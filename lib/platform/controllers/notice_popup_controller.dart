import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/promotion_mixin.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/models/notice_popup_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/board_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/mirae/alert_ui_list.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/promotion_ad_model.dart';

class NoticePopupController extends GetxController with PromotionMixin {
  GlobalController globalController = Get.find();
  ActivityController activityController = Get.find();

  RxList<NoticePopupModel> noticePopupList = RxList.empty();
  RxList<NoticePopupModel> noticeMainPopupList = RxList.empty();
  final RxInt _current = 0.obs;
  late final int pageSize;
  RxList<double> ops = [1.0, 0.0, 0.0].obs;
  RxList<double> offsets = [0.0, 0.0, 0.0].obs;
  RxBool hasNewNotice = RxBool(false);
  GlobalKey webViewKey = GlobalKey();

  @override
  void onInit() async {
    await initController();
    super.onInit();
  }

  setValue(double op) {
    if (op > 0 && op < 1) {
      ops[0] = 1 - op;
      ops[1] = op;
    } else if (op > 1 && op < 2) {
      ops[1] = 2 - op;
      ops[2] = -1 + op;
    }

    if (op == 0.0) {
      ops[0] = 1;
      ops[1] = ops[2] = 0;
    } else if (op == 1.0) {
      ops[1] = 1;
      ops[0] = ops[2] = 0;
    } else if (op == 2.0) {
      ops[2] = 1;
      ops[0] = ops[1] = 0;
    }
  }

  RxInt get current => _current;

  setCurrent(int index) {
    _current.value = index;
  }

  Future<void> initController() async {
    await getPromotionAdsList();
    await getNoticePopupList();
    await getMainNoticePopupList();
    showMainPopup();
  }

  Future<void> getMainNoticePopupList() async {
    await BoardService.getMainNoticePopupList(
      successCallback: (List<NoticePopupModel> records) {
        records.removeWhere((element) => element.type == 'INSPECTION');
        if(promotionAdsList.isNotEmpty){
          for (PromotionAdModel promotion in promotionAdsList) {
            NoticePopupModel promotionAd = NoticePopupModel(
              imageUrlKo: promotion.imageUrl,
              label: promotion.label,
              openType: promotion.openType,
              linkUrl: promotion.linkUrl,
              listOrder: promotion.listOrder,
              isAdsBanner: true,
            );
            noticeMainPopupList.add(promotionAd);
          }
        }
        noticeMainPopupList.addAll(records);
        noticeMainPopupList.sort((a, b) => a.listOrder!.compareTo(b.listOrder!));
      },
    );
  }

  Future<void> getNoticePopupList() async {
    await BoardService.getNoticePopupList(
      successCallback: (List<NoticePopupModel> records) {
        records.removeWhere((element) => element.type == 'INSPECTION');
        noticePopupList.addAll(records);
        List<int>? noticePopupListIds = HiveStore.load(key: HiveKey.noticePopupListIds.name);
        if (noticePopupListIds != null && noticePopupListIds.isNotEmpty) {
          for (NoticePopupModel notice in noticePopupList) {
            if (!noticePopupListIds.contains(notice.id!)) {
              hasNewNotice.value = true;
              break;
            }
          }
        } else if (noticePopupListIds == null && noticePopupList.isNotEmpty) {
          hasNewNotice.value = true;
        }
      },
    );
  }


  void moveToWebView(NoticePopupModel item) async {
    // 메인팝업 클릭 이벤트
    Adjust.trackEvent(AdjustEvent('hed7a4'));
    String? userId = HiveStore.loadString(key: HiveKey.userId.name);
    // 미래에셋 광고 클릭 이벤트
    if(item.isAdsBanner != null && item.isAdsBanner!){
      Adjust.trackEvent(AdjustEvent('qljdfk'));
      bool bannerAdClick = HiveStore.load(key: HiveKey.bannerAdClick.name) ?? false;
      if(!bannerAdClick){
        Adjust.trackEvent(AdjustEvent('ytqi48'));
        HiveStore.save(key: HiveKey.bannerAdClick.name, value: true);
      }
    }


    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    switch (item.openType) {
      case 'IN_APP':
        if (!Get.currentRoute.contains('home')) {
          Get.until((route) => Get.currentRoute == Routes.home);
        }
        switch (item.linkUrl) {
          case 'CHALLENGES':
            Get.find<HomeMenuController>().selectMenu(0);
            Get.toNamed(Routes.challengeDetail.replaceAll(':id', item.referenceId.toString()));
            break;
          case 'COMPANY_CHALLENGES':




            String? userId = HiveStore.loadString(key: HiveKey.userId.name);
            DatabaseReference userDiInfoRef = FirebaseDatabase.instance.ref('crewChallengeLeaderboard/${item.referenceId}');
            Query query = userDiInfoRef.child(userId!);
            query.get().then((DataSnapshot snapshot) async {
              print('snapshot : ${snapshot.value}');
              if (snapshot.value != null) {
                // Get.find<HomeMenuController>().selectMenu(0);
                Get.toNamed(Routes.companyChallengeDetail.replaceAll(':id', item.referenceId.toString()));

              } else {
                await ActivityService.getChallengeDetails(item.referenceId!, successCallback: (NewChallengeDetailModel data) async {
                  if(data.challengeUserState == null){
                    miraeAssetAlert(int.parse(item.referenceId.toString()), null);
                  } else {
                    miraeAssetAlert(int.parse(item.referenceId.toString()), data.challengeUserState!);
                  }

                });

              }
            }).catchError((error) {
              // 오류 처리
              print('데이터를 가져오는 중 오류가 발생했습니다: $error');
            });

            break;
          case 'COURSE_CHALLENGES':
            checkBlockUser(item);
            break;
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
        // Get.toNamed(Routes.webView, arguments: {'id': item.id, 'linkUrl': item.linkUrl});
        showModalWebview(this, Get.context, title: item.label!, linkUrl: item.linkUrl!);
        break;
      case 'EXTERNAL_BROWSER':
        Uri url = Uri.parse(item.linkUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }

  void checkBlockUser(item) async {
    bool hasSeenFairPlayAlert = HiveStore.load(key: HiveKey.hasSeenFairPlayAlert.name) ?? false;
    if (!hasSeenFairPlayAlert) {
      HiveStore.save(key: HiveKey.hasSeenFairPlayAlert.name, value: true);
      await showFairPlayAlert();
    }

    if (activityController.userState.value.state!.locked != null && activityController.userState.value.state!.locked! == true) {
      showLockedUserAlert();
    } else {
      Get.toNamed(Routes.challengeCourseDetail, arguments: {'id': item.referenceId}, preventDuplicates: false);
    }
  }

  Future<bool> checkPopupExpired() async {
    DateTime? date = await HiveStore.load(key: HiveKey.closePopupDate.name);

    if (date != null) {
      DateTime viewableTime = date.add(const Duration(hours: 24));
      DateTime now = DateTime.now();

      if (viewableTime.isBefore(now) && noticeMainPopupList.isNotEmpty) {
        return true;
      }
      return false;
    } else {
      if (noticeMainPopupList.isNotEmpty) {
        return true;
      }
      return false;
    }
  }

  void showMainPopup() async {
    bool isShowPopup = await checkPopupExpired();
    if (isShowPopup) {
      setCurrent(0);
      showMainPopupAlert(this);
    }
  }

  void onSavePopupCloseDate() {
    DateTime now = DateTime.now();
    HiveStore.save(key: HiveKey.closePopupDate.name, value: now);
    Get.back();
  }

  void moveToNotificationsListPage() {
    Adjust.trackEvent(AdjustEvent('fl5g4k'));
    List<int> noticePopupListIds = noticePopupList.map((element) => element.id!).toSet().toList();
    HiveStore.save(key: HiveKey.noticePopupListIds.name, value: noticePopupListIds);
    hasNewNotice.value = false;
    Get.toNamed(Routes.notifications);
  }
}
