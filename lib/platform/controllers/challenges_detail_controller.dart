import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/challenge_ranker_model.dart';
import 'package:gaza_go/platform/models/challenge_reward_model.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';
import 'package:gaza_go/platform/models/crew_icon_model.dart';
import 'package:gaza_go/platform/models/crew_member_model.dart';
import 'package:gaza_go/platform/models/crew_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/crew_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengesDetailController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  ChallengesController challengesController = Get.isRegistered<ChallengesController>() ? Get.find<ChallengesController>() : Get.put(ChallengesController());
  LoaderController loaderController = Get.put(LoaderController());
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
  int page = 0;
  int size = 100;
  bool hasMore = true;
  bool loadingLeaderboard = false;

  RxList<CrewModel> crewList = RxList.empty();
  RxList<CrewIconModel> crewMarkIcons = RxList.empty();
  RxInt selectedMarkIconId = RxInt(0);
  TextEditingController crewNameController = TextEditingController();
  RxString crewName = RxString('');
  RxBool get isAbleToJoinCrew {
    return RxBool([
          'READY',
          'IN_PROGRESS',
        ].any((state) => state == challengeDetails.value.challengeState) &&
        [
          'REGISTER_AVAILABLE',
          'REGISTER_READY',
          'JOIN_AVAILABLE',
        ].any((state) => state == challengeDetails.value.challengeUserState));
  }

  RxBool get isAbleToCreateCrew {
    return RxBool([
          'READY',
        ].any((state) => state == challengeDetails.value.challengeState) &&
        [
          'REGISTER_AVAILABLE',
          'REGISTER_READY',
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
      getCrewList();
    } else {
      getChallengeLeaderboard();
      getChallengeLeaderboardMyRanking();
    }

    leaderboardScrollController.addListener(() {
      loadDataOnScroll();
    });

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
    await ActivityService.getChallengeDetails(challengeId.value, successCallback: (NewChallengeDetailModel data) {
      challengeDetails.value = data;

      fromDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.fromDate!));
      toDate.value = DateFormat('M.d (EEE)', 'ko').format(DateTime.parse(data.toDate!));
      inDays.value = DateTime.parse(data.toDate!).difference(DateTime.parse(data.fromDate!)).inDays;
    });
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

    crewChallengeLeaderboardRef.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        updateCrewData(snapshot);
      } else {
        crewList.clear();
      }
    }).onError((error, stackTrace) {
      print(error);
    });

    crewChallengeLeaderboardRef.onValue.listen((DatabaseEvent event) {
      updateCrewData(event.snapshot);
    });
  }

  void updateCrewData(DataSnapshot snapshot) {
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

      CrewModel crewModel = CrewModel.fromJson(jsonDecode(jsonEncode(crew)));
      crewList.add(crewModel);
    });
    crewList.sort((a, b) => b.blockQuantity!.compareTo(a.blockQuantity!));
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
      await launchUrl(url, mode: LaunchMode.externalApplication);
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

  void sendParticipateInCode() async {
    if (participationCode.value != '') {
      await ActivityService.sendParticipateInCode(challengeId.value, participationCode.value, successCallback: (bool isSuccess) {
        if (isSuccess) {
          Get.back();
          showToastPopup('인증이 완료되었습니다.');
          initCodeTextField();
          getChallengeDetail();
          getChallengeLeaderboard();
          getChallengeLeaderboardMyRanking();
        }
      }, errorCallback: (String? message) {
        errorMessage.value = message!;
      });
    } else {
      showToastPopup('참여코드를 입력해주세요.');
    }
  }

  Future<void> showCreateCrewForm() async {
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
        showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
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

  Future<void> shareCrewChallenge() async {
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://gazago.io?route=${Routes.challengeDetail.replaceAll(':id', challengeId.value.toString())}&inviteId=$userId"),
      uriPrefix: F.isDev ? "https://gazagostage.page.link" : "https://gazago.page.link",
      androidParameters: AndroidParameters(packageName: F.isDev ? "kr.co.eztechfin.gazaGo.dev" : "kr.co.eztechfin.gazaGo"),
      iosParameters: IOSParameters(bundleId: F.isDev ? "kr.co.eztechfin.gazaGo.dev" : "kr.co.eztechfin.gazaGo"),
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    final TextTemplate defaultText = TextTemplate(
      text: '함께 가자고!!!',
      link: Link(
        webUrl: dynamicLink.shortUrl,
        mobileWebUrl: dynamicLink.shortUrl,
      ),
    );

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: defaultText, serverCallbackArgs: {
          'userId': '${HiveStore.loadString(key: HiveKey.userId.name)}',
          'challengeId': '${challengeId.value}',
        });
        await ShareClient.instance.launchKakaoTalk(uri);
        Future.delayed(const Duration(seconds: 2));
        askSharedCompleteDialog(this);
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

  Future<void> validateKakaoShareResult() async {
    String userId = HiveStore.loadString(key: HiveKey.userId.name)!;
    DatabaseReference kakaoShareStatus = FirebaseDatabase.instance.ref('kakaoSharedMessageRecord/${challengeId.value}/$userId');

    kakaoShareStatus.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value as Map;

        if (data['chat_TYPE'] == 'MemoChat') {
          unableShareMyselfDialog(this);
        } else {
          requestCreateCrew('INVITE');
        }
      } else {
        unableSharedHistoryDialog(this);
      }
    }).onError((error, stackTrace) {
      unableSharedHistoryDialog(this);
    });
  }

  void handleCrewJoin(CrewModel crew) {
    if (crew.crewRecruitStatus == "OPEN" && crew.crewRelayStatus == "ONGOING") {
      crewJoinInfoAlert(crew);
    } else if (crew.crewRelayStatus != "ONGOING") {
      showToastPopup('비활성화된 크루입니다.');
    } else {
      showToastPopup('모집이 제한된 크루입니다.');
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
      }
      showToastPopup(error.errorMessage!.replaceAll('\\n', '\n'));
    });
  }

  void moveToCrewDetail(CrewModel crew) {
    int ranking = 0;
    crewList.forEachIndexedWhile((index, CrewModel item) {
      if (item.id == crew.id!) {
        ranking = index + 1;
      }
      return item.id != crew.id!;
    });
    Get.toNamed(Routes.crewDetail, arguments: {'ranking': ranking, 'crew': crew});
  }

  void moveToMyCrew() {
    Get.toNamed(Routes.crewDetail, arguments: {'ranking': myCrew.value!['ranking'], 'crew': myCrew.value!['crew']});
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
}
