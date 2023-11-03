import 'dart:async';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/challenge_join_model.dart';
import 'package:gaza_go/platform/models/challenge_landing_model.dart';
import 'package:gaza_go/platform/models/challenge_notification_group_model.dart';
import 'package:gaza_go/platform/models/challenge_ranker_model.dart';
import 'package:gaza_go/platform/models/challenge_reward_model.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';
import 'package:gaza_go/platform/models/crew_icon_model.dart';
import 'package:gaza_go/platform/models/crew_member_model.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/join_challenge_response_model.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/services/crew_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/challenge_detail_notification.dart';
import 'package:gaza_go/presentations/components/product_list_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengesDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  ChallengesController challengesController = Get.isRegistered<ChallengesController>() ? Get.find<ChallengesController>() : Get.put(ChallengesController());
  WalletMasterController walletMasterController = Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>() : Get.put(WalletMasterController());
  LoaderController loaderController = Get.put(LoaderController());
  final GlobalKey webViewKey = GlobalKey();
  Rx<DateTime?> today = Rx(DateTime.now());
  RxString fromDate = RxString('');
  RxString toDate = RxString('');
  RxInt dDay = RxInt(0);
  RxInt inDays = RxInt(0);

  late TabController tabController;
  final GlobalKey backgroundKey = GlobalKey();

  final RxDouble backgroundBoxSize = RxDouble(0.0);

  ScrollController challengeDetailScrollController = ScrollController();
  RxBool isHeightCalculated = RxBool(false);
  RxInt challengeTabIndex = RxInt(0);
  RxInt challengeId = RxInt(0);
  final Rx<NewChallengeDetailModel> challengeDetails = Rx(NewChallengeDetailModel());
  Rxn<ChallengeRankerModel> myRank = Rxn();
  Rx<ChallengeRewardModel> challengeRewardPool = Rx(ChallengeRewardModel());
  RxList<ChallengeRankerModel> challengeRankingList = RxList.empty();
  final RxBool dataGetLoading = RxBool(false);
  ScrollController leaderboardScrollController = ScrollController();
  final TextEditingController codeTextController = TextEditingController(text: '');
  final RxString participationCode = RxString('');
  final FocusNode focusNode = FocusNode();
  final RxString errorMessage = RxString('');
  final RxBool hideCourses = RxBool(false);
  final RxBool isDisableButton = RxBool(false);
  final RxBool isLoading = RxBool(false);

  final RxBool isShortTokenBalance = RxBool(false);

  int page = 0;
  int size = 100;
  bool hasMore = true;
  bool loadingLeaderboard = false;

  RxList<CrewModel> crewList = RxList.empty();
  RxList<CrewIconModel> crewMarkIcons = RxList.empty();
  RxInt selectedMarkIconId = RxInt(0);
  TextEditingController crewNameController = TextEditingController();
  RxString crewName = RxString('');
  Rxn shareTemplate = Rxn();
  RxBool get isAbleToJoinCrew {
    return RxBool([
          'READY',
          'IN_PROGRESS',
        ].any((state) => state == challengeDetails.value.challengeState) &&
        [
          'REGISTER_AVAILABLE',
          'JOIN_AVAILABLE',
        ].any((state) => state == challengeDetails.value.challengeUserState));
  }

  RxBool get isAbleToCreateCrew {
    return RxBool([
          'READY',
        ].any((state) => state == challengeDetails.value.challengeState) &&
        [
          'REGISTER_AVAILABLE',
        ].any((state) => state == challengeDetails.value.challengeUserState));
  }

  Rxn<Map<String, dynamic>> get myCrew {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    int ranking = 0;
    CrewModel? myCrew;
    crewList.forEachIndexedWhile((int crewIndex, CrewModel crew) {
      crew.crewMemberList!.forEachIndexedWhile((int memberIndex, CrewMemberModel member) {
        if (member.userId.toString() == userId) {
          ranking = crewIndex + 1;
          myCrew = crew;
        }

        return member.userId.toString() != userId;
      });

      return myCrew == null;
    });

    return myCrew == null ? Rxn() : Rxn({'ranking': ranking, 'crew': myCrew});
  }

  @override
  void onInit() async {
    focusNode.addListener(_onFocusChange);
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 1) {}
      });
    tabController.addListener(_tabController);
    if (await Get.arguments != null) {
      challengeId.value = await Get.arguments['id'];
      hideCourses.value = await Get.arguments['hideCourses'] ?? false;
    } else {
      challengeId.value = int.parse(Get.parameters['id']!);
      hideCourses.value = false;
    }
    await getChallengeDetail();
    if (challengeDetails.value.challengeType == 'CREW') {
      await getCrewList();
      if (challengeDetails.value.challengeState == 'CLOSED' && myCrew.value != null) {
        crewChallengeCloseAlert(this);
      }
    } else {
      getChallengeLeaderboard();
      getChallengeLeaderboardMyRanking();
    }

    leaderboardScrollController.addListener(() {
      loadDataOnScroll();
    });
    await getFirebaseShareTemplate();
    // Todo 크루버프 백엔드 배포할 때 다시 복구 해야함
    // await BoardService.getChallengeNotifications(
    //   challengeId.value,
    //   successCallback: (ChallengeNotificationGroupModel? data) {
    //     if (data != null) {
    //       showChallengeNotification(this, data);
    //     }
    //   },
    // );

    super.onInit();
  }

  @override
  void onClose() {
    challengesController.getChallengesList();
    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.removeListener(_onFocusChange);
    focusNode.unfocus();
    focusNode.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${focusNode.hasFocus.toString()}");
  }

  Future<void> refreshController() async {
    getChallengeDetail();
  }

  void _tabController() {
    challengeTabIndex.value = tabController.index;
  }

  void showMoveToShopItem() {
    moveBuyChallengeItemPageAlert(this, challengeDetails.value.itemTradeStoreId!);
  }

  void fetchEquipItem(int itemId) async {
    // 첫 챌린지 참여 이벤트
    bool adjustFirstJoinedChallengeEvent = HiveStore.load(key: HiveKey.adjustFirstJoinedChallengeEvent.name) ?? false;
    if (!adjustFirstJoinedChallengeEvent) {
      Adjust.trackEvent(AdjustEvent('kvq7g5'));
      HiveStore.save(key: HiveKey.adjustFirstJoinedChallengeEvent.name, value: true);
    }

    await ItemService.fetchEquippedItem(
      itemId,
      successCallback: (InventoryItemModel item) {
        showToastPopup('아이템이 장착되었습니다.');
        getChallengeDetail();
      },
    );
  }

  Future<void> getChallengeDetail() async {
    isLoading.value = true;
    await ActivityService.getChallengeDetails(challengeId.value, successCallback: (NewChallengeDetailModel data) {
      challengeDetails.value = data;
      fromDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.fromDate!));
      toDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.toDate!));
      inDays.value = DateTime.parse(data.toDate!).difference(DateTime.parse(data.fromDate!)).inDays;
    });
    isLoading.value = false;
  }

  Future<void> getChallengeLeaderboard() async {
    if (!loadingLeaderboard) {
      loadingLeaderboard = true;
      await ActivityService.getChallengeLeaderboard(challengeId.value, page, size, successCallback: (List<ChallengeRankerModel> data) {
        if (data.length < size) {
          hasMore = false;
        }

        data.asMap().forEach((index, ranker) {
          ranker.rank = (index + 1) + (page * size);
        });

        challengeRankingList.addAll(data);
        loadingLeaderboard = false;
      });
    }
  }

  Future<void> getChallengeLeaderboardMyRanking() async {
    await ActivityService.getChallengeLeaderboardMyRanking(challengeId.value, successCallback: (ChallengeRankerModel? data) {
      myRank.value = data;
    });
  }

  Future<void> getCrewList() async {
    DatabaseReference crewChallengeLeaderboardRef = FirebaseDatabase.instance.ref('crewChallengeLeaderboard/${challengeId.value}');

    await crewChallengeLeaderboardRef.get().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        await updateCrewData(snapshot);
      } else {
        crewList.clear();
      }
    }).onError((error, stackTrace) {
      print(error);

    });

    crewChallengeLeaderboardRef.onValue.listen((DatabaseEvent event) async {
      await updateCrewData(event.snapshot);
    });
  }

  Future<void> updateCrewData(DataSnapshot snapshot) async {
    if (snapshot.value == null) return;
    crewList.clear();
    Map crewListMap = snapshot.value as Map;
    crewListMap.forEach((key, crew) {
      crew['isLimited'] = false;
      List<CrewMemberModel> members = List.empty(growable: true);
      Map membersMap = crew['crewMemberMap'] as Map;

      membersMap.forEach((key, member) {
        members.add(CrewMemberModel.fromJson(jsonDecode(jsonEncode(member))));
      });

      members.sort((a, b) => b.blockQuantity!.compareTo(a.blockQuantity!));

      crew['crewMemberList'] = members;
      if (members.length == 20 && crew['crewRecruitStatus'] != 'CLOSE') {
        FirebaseDatabase.instance.ref('crewChallengeLeaderboard/${challengeId.value}/$key/crewRecruitStatus').set('CLOSE');
      }

      CrewModel crewModel = CrewModel.fromJson(jsonDecode(jsonEncode(crew)));
      crewList.add(crewModel);
    });

    if ([
      'REGISTER_AVAILABLE',
      'REGISTER_READY',
      'JOIN_AVAILABLE',
    ].any((challengeUserState) => challengeUserState == challengeDetails.value.challengeUserState)) {
      crewList.sort((a, b) {
        bool isSameMemberCount = b.crewMemberList!.length.compareTo(a.crewMemberList!.length) == 0;
        if (isSameMemberCount) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        }
        return b.crewMemberList!.length.compareTo(a.crewMemberList!.length);
      });
    } else {
      crewList.sort((a, b) {
        bool isSameBlockCount = b.blockQuantity!.compareTo(a.blockQuantity!) == 0;
        if (isSameBlockCount) {
          bool isSameMemberCount = b.crewMemberList!.length.compareTo(a.crewMemberList!.length) == 0;
          if (isSameMemberCount) {
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
          }
          return b.crewMemberList!.length.compareTo(a.crewMemberList!.length);
        }
        return b.blockQuantity!.compareTo(a.blockQuantity!);
      });
    }
  }

  void getSize() {
    if (backgroundKey.currentContext != null) {
      backgroundBoxSize.value = backgroundKey.currentContext!.size!.height;
    }
  }

  void moveToExternalBrowser(linkUrl) async {
    Uri url = Uri.parse(linkUrl!);
    if (await canLaunchUrl(url)) {
      await ActivityService.fetchChallengeAllianceLinkRecord(challengeId.value, linkUrl);

      showModalWebview(Get.context, title: challengeDetails.value.title, linkUrl: linkUrl);
      // Get.toNamed(Routes.inAppModalWebView, arguments: {'linkUrl': linkUrl, 'title': title});
      // await launchUrl(
      //   url,
      //   mode: LaunchMode.inAppWebView,
      //   webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
      // );
    }
  }

  void setCode(String code) {
    participationCode.value = code;
  }

  void closeParticipateInCodeAlert() {
    Get.back();
    initCodeTextField();
  }

  void initCodeTextField() {
    participationCode.value = '';
    codeTextController.text = '';
    errorMessage.value = '';
  }

  Future<void> showCreateCrewForm() async {
    if (await handleCheckUserVerified()) {
      await CrewService.getCrewMarkIcons(successCallback: (List<CrewIconModel> icons) {
        crewMarkIcons.clear();
        selectedMarkIconId.value = icons.first.id;
        crewMarkIcons.addAll(icons);
      }, errorCallback: () {
        showToastPopup('크루 마크를 불러오지 못했습니다.');
      });
      crewName.value = '';
      crewNameController.text = '';
      crewCreatePopup(this);
    } else {
      showChallengeNeedVerificationAlert();
    }
  }

  void handleCreateCrewType(String createCrewType) async {
    if (crewName.value == '') {
      showToastPopup('크루명을 입력해주세요');
      return;
    }

    RegExp pattern = RegExp(r'^[가-힣a-zA-Z0-9\s]{2,10}$');
    if (!pattern.hasMatch(crewName.value)) {
      showToastPopup('2~10글자로 작성해주세요.\n특수문자는 사용 불가능합니다.');
      return;
    }

    if (createCrewType == 'TIK') {
      if (Get.find<WalletMasterController>().tik.value.amount! < 3000) {
        shortTikCreateCrewAlert();
        return;
      }
      Get.back();
      requestCreateCrew('TIK');
    } else {
      shareCrewChallengeKakaoLinkDialog(this);
    }
  }

  void requestCreateCrew(String createCrewType) {
    CrewCreateFormModel formData;
    if (createCrewType == 'TIK') {
      formData = CrewCreateFormModel(
        challengeId: challengeId.value,
        crewCreateType: 'TIK',
        crewIconId: selectedMarkIconId.value,
        name: crewName.value,
        price: 3000,
      );
    } else {
      formData = CrewCreateFormModel(
        challengeId: challengeId.value,
        crewCreateType: 'INVITE',
        crewIconId: selectedMarkIconId.value,
        name: crewName.value,
      );
    }

    CrewService.createCrew(
      formData,
      successCallback: (int crewId) async {
        await getChallengeDetail();
        Get.until((route) => Get.isDialogOpen == false && Get.isBottomSheetOpen == false);
        await Future.delayed(const Duration(seconds: 1));
        crewCreateCompleteAlert(this);
      },
      errorCallback: (ErrorResponseDataModel error) {
        if (error.errorCode == 'ALREADY_JOINED_CHALLENGE') {
          showChallengeAlreadyJoinedAlert();
        } else {
          showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
        }
      },
    );
  }

  void selectCrewMark(CrewIconModel crewMarkIcon) {
    selectedMarkIconId.value = crewMarkIcon.id;
  }

  void updateCrewName(String name) {
    crewName.value = name;
  }

  void exploreCrews() {
    tabController.index = 1;
  }

  Future<void> shareChallenge({required ChallengeType challengeType, required ShareSource shareSource, String? crewName}) async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;

    String uriPrefix = F.isDev ? "https://gazagostage.page.link" : "https://gazago.page.link";
    String packageName = F.isDev ? "kr.co.eztechfin.gazaGo.dev" : "kr.co.eztechfin.gazaGo";

    DynamicLinkParameters? dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://gazago.io?route=${Routes.challengeDetail.replaceAll(':id', challengeId.value.toString())}"),
      uriPrefix: uriPrefix,
      androidParameters: AndroidParameters(packageName: packageName),
      iosParameters: IOSParameters(bundleId: packageName),
    );

    if (challengeType == ChallengeType.crew) {
      if (![ShareSource.shareAppbar, ShareSource.createCrew].any((source) => shareSource == source)) {
        dynamicLinkParams = DynamicLinkParameters(
          link: Uri.parse("https://gazago.io?route=${Routes.challengeDetail.replaceAll(':id', challengeId.value.toString())}&inviteId=$userId"),
          uriPrefix: uriPrefix,
          androidParameters: AndroidParameters(packageName: packageName),
          iosParameters: IOSParameters(bundleId: packageName),
        );
      }
    }

    final ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams!);

    FeedTemplate? kakaoFeedTemplate;
    String shareTarget = shareSource == ShareSource.crewDetail ? 'inviteCode' : 'basic';
    if (shareTemplate.value != null) {
      kakaoFeedTemplate = FeedTemplate(
        content: Content(
          imageUrl: Uri.parse(shareTemplate.value![shareTarget]['imageUrl']),
          imageHeight: 400,
          imageWidth: 400,
          title: shareTemplate.value[shareTarget]['title'],
          description: shareTemplate.value[shareTarget]['description'],
          link: Link(
            webUrl: dynamicLink.shortUrl,
            mobileWebUrl: dynamicLink.shortUrl,
          ),
        ),
        buttonTitle: shareTemplate.value[shareTarget]['buttonTitle'],
      );
    } else {
      showToastPopup('공유하기 템플릿 설정 미적용');
    }

    // if (challengeType == ChallengeType.crew) {
    //   kakaoFeedTemplate = generateFeedTemplate(dynamicLink.shortUrl, challengeType: challengeType, shareSource: shareSource, crewName: crewName);
    // } else {
    //   if (shareTemplate.value != null) {
    //     kakaoFeedTemplate = FeedTemplate(
    //       content: Content(
    //         imageUrl: Uri.parse(shareTemplate.value!.basic.imageUrl),
    //         imageHeight: 400,
    //         imageWidth: 400,
    //         title: shareTemplate.value!.basic.title,
    //         description: shareTemplate.value!.basic.description,
    //         link: Link(
    //           webUrl: dynamicLink.shortUrl,
    //           mobileWebUrl: dynamicLink.shortUrl,
    //         ),
    //       ),
    //       buttonTitle: shareTemplate.value!.basic.buttonTitle,
    //     );
    //   }
    // }

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: kakaoFeedTemplate!, serverCallbackArgs: {
          'userId': userId,
          'challengeId': '${challengeId.value}',
        });
        await ShareClient.instance.launchKakaoTalk(uri);
      } catch (error) {
        showToastPopup('공유 실패');
      }
    } else {
      // try {
      //   Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: defaultText);
      //   await launchBrowserTab(shareUrl, popupOpen: true);
      //   Future.delayed(const Duration(seconds: 2));
      //   askSharedCompleteDialog(this);
      // } catch (error) {
      //   showToastPopup('공유 실패');
      // }
      showToastPopup('카카오톡을 설치해주세요');
    }
  }

  Future<void> getFirebaseShareTemplate() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection("challengeShareTemplate").doc(challengeDetails.value.id.toString()).get();

      shareTemplate.value = docSnapshot.data();
    } catch (e) {
      shareTemplate.value = null;
    }
  }

  Future<void> validateKakaoShareResult({required ChallengeType challengeType, required ShareSource shareSource}) async {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    DatabaseReference kakaoShareStatus = FirebaseDatabase.instance.ref('kakaoSharedMessageRecord/${challengeId.value}/$userId');

    kakaoShareStatus.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value as Map;

        if (data['chat_TYPE'] == 'MemoChat') {
          unableShareMyselfDialog(this, challengeType: challengeType, shareSource: shareSource);
        } else {
          if (challengeDetails.value.challengeActivationType == 'CREW') {
            requestCreateCrew('INVITE');
          } else {
            // 납부형 챌린지 참여하기
            onFetchJoinChallenge(isFree: true);
          }
        }
      } else {
        unableSharedHistoryDialog(this, challengeType: challengeType, shareSource: shareSource);
      }
    }).onError((error, stackTrace) {
      unableSharedHistoryDialog(this, challengeType: challengeType, shareSource: shareSource);
    });
  }

  Future<void> handleCrewJoin(CrewModel crew) async {
    if (isAbleToJoinCrew.value) {
      if (await handleCheckUserVerified()) {
        if (crew.crewRecruitStatus == "OPEN" && crew.crewRelayStatus == "ONGOING") {
          crewJoinInfoAlert(crew);
        } else {
          showToastPopup('모집이 제한된 크루입니다.');
        }
      } else {
        showChallengeNeedVerificationAlert();
      }
    } else {
      showToastPopup('모집인원이 마감된 크루입니다.');
    }
  }

  void requestJoinCrew(CrewModel crew) {
    CrewService.joinCrew(challengeId.value, crew.id!, successCallback: () async {
      await getChallengeDetail();
      await Future.delayed(const Duration(seconds: 1));
      crewJoinCompleteAlert(myCrew.value!['crew']);
    }, errorCallback: (ErrorResponseDataModel error) async {
      if (error.errorCode == 'CREW_RECRUIT_CLOSED') {
        await getCrewList();
        showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
      } else if (error.errorCode == 'ALREADY_JOINED_CHALLENGE') {
        showChallengeAlreadyJoinedAlert();
      } else {
        showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
      }
    });
  }

  void moveToMyCrew() {
    if (myCrew.value != null && crewList.isNotEmpty) {
      Get.toNamed(Routes.crewDetail);
    } else {
      showToastPopup('내 크루를 찾을 수 없습니다. 잠시후 시도해주세요');
      getCrewList();
    }
  }

  void loadDataOnScroll() {
    double scrollBottom = leaderboardScrollController.positions.last.maxScrollExtent;
    double scrollPosition = leaderboardScrollController.positions.last.pixels;

    if (tabController.index == 1 && scrollPosition == scrollBottom) {
      if (hasMore) {
        page = page + 1;
        getChallengeLeaderboard();
      }
    }
  }

  void requestJoinChallenge(Function callback) async {
    isDisableButton.value = true;
    if (await handleCheckUserVerified()) {
      callback();
    } else {
      showChallengeNeedVerificationAlert();
    }
    isDisableButton.value = false;
  }

  Future<void> onFetchJoinChallenge({bool isFree = false}) async {
    ChallengeJoinModel params = ChallengeJoinModel(challengeActivationType: challengeDetails.value.challengeActivationType!);
    if (challengeDetails.value.challengeActivationType! == 'PAYMENT') {
      params.entryFee = isFree ? 0 : challengeDetails.value.entryFee;
      Get.back();
    }
    if (challengeDetails.value.challengeActivationType! == 'ITEM') {
      params.itemId = challengeDetails.value.item!.id;
    }
    if (challengeDetails.value.challengeActivationType! == 'CODE') {
      if (participationCode.value == '') {
        showToastPopup('참여코드를 입력해주세요.');
        return;
      }
      params.code = participationCode.value;
    }
    await ActivityService.fetchJoinChallenge(challengeId.value, params, successCallback: (JoinChallengeResponseModel landingInfo) {
      walletMasterController.getSpendingWalletBalances();
      if (challengeDetails.value.challengeActivationType! != 'ITEM') {
        getChallengeDetail();
      }
      initLeaderboard();
      getChallengeLeaderboard();
      getChallengeLeaderboardMyRanking();
      showToastPopup('챌린지 참가가 완료되었습니다.');

      // 광고가 있다면 띄워주기
      if (landingInfo.challengeLanding != null) {
        showChallengeLandingPopup(this, landingInfo.challengeLanding!);
      }
      if (challengeDetails.value.challengeActivationType! == 'CODE') {
        initCodeTextField();
      }
    }, errorCallback: (ErrorResponseDataModel error) {
      if (challengeDetails.value.challengeActivationType! == 'CODE') {
        errorMessage.value = error.errorMessage!;
      } else {
        print(error.errorMessage);
        // showToastPopup(error.errorMessage!);
      }
    });
  }

  void initLeaderboard() {
    page = 0;
    hasMore = true;
    challengeRankingList.value = RxList.empty();
  }

  // void sendParticipateInCode() async {
  //   if (participationCode.value != '') {
  //     ChallengeJoinModel params = ChallengeJoinModel(
  //       challengeActivationType: challengeDetails.value.challengeActivationType!,
  //       code: participationCode.value,
  //     );
  //     await ActivityService.fetchJoinChallenge(challengeId.value, params, successCallback: (bool isSuccess) {
  //       if (isSuccess) {
  //         Get.back();
  //         showToastPopup('챌린지 참가가 완료되었습니다.');
  //         initCodeTextField();
  //         getChallengeDetail();
  //         getChallengeLeaderboard();
  //         getChallengeLeaderboardMyRanking();
  //       }
  //     }, errorCallback: (String? message) {
  //       errorMessage.value = message!;
  //     });
  //   } else {
  //     showToastPopup('참여코드를 입력해주세요.');
  //   }
  // }

  void onJoinPayChallenge() {
    if (double.parse(walletMasterController.tik.value.uiAmountString!) < challengeDetails.value.entryFee!) {
      isShortTokenBalance.value = true;
    } else {
      isShortTokenBalance.value = false;
    }
    joinChallengePopup(this);
  }

  void moveToChargeTik() {
    HiveStore.save(key: HiveKey.enteredRoute.name, value: Get.currentRoute);
    showProductList();
  }

  void onClickChallengeLandingPage(ChallengeLandingModel landingInfo) async {
    switch (landingInfo.openType) {
      case 'IN_APP':
        if (!Get.currentRoute.contains('home')) {
          Get.until((route) => Get.currentRoute == Routes.home);
        }
        switch (landingInfo.linkUrl) {
          case 'CHALLENGES':
            Get.find<HomeMenuController>().selectMenu(0);
            // Get.toNamed(Routes.challengeDetail.replaceAll(':id', item.referenceId.toString()));
            break;
          // case 'COURSE_CHALLENGES':
          //   Get.find<HomeMenuController>().selectMenu(2);
          //   checkBlockUser(item);
          //   break;
          case 'ARCHIVE':
            Get.find<HomeMenuController>().selectMenu(4);
            if (Get.isRegistered<LeaderboardController>()) {
              Get.find<LeaderboardController>().tabController.animateTo(1);
            } else {
              LeaderboardController leaderboardController = Get.put(LeaderboardController());
              leaderboardController.tabController.animateTo(1);
            }

            break;
          case 'ITEM':
            Get.find<HomeMenuController>().selectMenu(1);
            break;
          case 'SHOP':
            Get.find<HomeMenuController>().selectMenu(3);
            break;
          case 'RANKING':
            Get.find<HomeMenuController>().selectMenu(4);
            if (Get.isRegistered<LeaderboardController>()) {
              Get.find<LeaderboardController>().tabController.animateTo(0);
            } else {
              LeaderboardController leaderboardController = Get.put(LeaderboardController());
              leaderboardController.tabController.animateTo(0);
            }
            break;

          case 'WALLET':
            Get.toNamed(Routes.wallet);
            break;
          case 'NOTICE':
            // Get.toNamed(Routes.noticeList);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/c5103042de5d4e3a9a61c1101508ffed'});
            break;
          case 'FAQ':
            // Get.toNamed(Routes.preferenceBoard);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/FAQ-2f6b0ec4d6134fd398cd7a832bfa6cd3'});
            break;
        }
        break;
      case 'INTERNAL_WEB_VIEW':
        showModalWebview(Get.context, title: landingInfo.title!, linkUrl: landingInfo.linkUrl!);
        break;
      case 'EXTERNAL_BROWSER':
        Uri url = Uri.parse(landingInfo.linkUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }
}
