import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/models/new_challenge_model.dart';
import 'package:gaza_go/platform/models/push_message_challenge_success_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/main_appbar.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/views/activity/index.dart';
import 'package:gaza_go/presentations/views/challenges/index.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:gaza_go/presentations/views/shop/index.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:simple_animations/simple_animations.dart';

class HomeMenuController extends SuperController {
  final RxInt selectedIndex = RxInt(2);
  final RxInt prevIndex = RxInt(0);
  final RxList<int> visitedTabs = RxList.empty();
  GlobalKey bottomNavKey = GlobalKey();
  final RxnDouble bottomNavHeight = RxnDouble();
  final RxBool hideBottomNav = RxBool(false);
  final RxBool hasNewChallenge = RxBool(false);
  final Rx<Control> newChallengeControl = Rx(Control.play);
  final RxInt eventListener = RxInt(0);

  final List<PreferredSizeWidget> appbarList = [
    const MainAppbar(),
    const SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    const ChallengesHome(),
    const InventoryHome(),
    const ActivityHome(),
    const ShopHome(),
    const RankingHome(),
  ];

  PreferredSizeWidget? get appbar {
    switch (selectedIndex.value) {
      case 2:
        return appbarList.first;
      default:
        return appbarList.last;
    }
  }

  @override
  void onInit() async {

    super.onInit();
  }

  @override
  void onReady() async {
    Get.isRegistered<ActivityController>() ? Get.find<ActivityController>().initializeExercise() : Get.put(ActivityController()).initializeExercise();
    await checkUpdates();
    bottomNavHeight.value = bottomNavKey.currentContext != null ? bottomNavKey.currentContext!.size!.height : 0;
    checkItemsDb();
    handlePendingDynamicLink();
    checkForNewChallenges();
    await checkUserCI();
    await handleCheckGetSpendingWallet();
    handleAppNotification();
    super.onReady();
  }

  Future<void> handleCheckGetSpendingWallet() async {
    bool isNotLoadWallet = await HiveStore.load(key: HiveKey.isFailureGetSpendingWallet.name) ?? false;
    print('isNotLoadWallet : $isNotLoadWallet');
    if (isNotLoadWallet) {
      showRefetchGetSpendingWalletAlert();
    }
  }

  void handleAppNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    print('initialMessage : $initialMessage');
    if (initialMessage != null) {
      if (initialMessage.data['notificationKey'] == 'DAILY_REWARD_COMPLETED') {
        // Get.find<WalletMasterController>().moveToWallet();
        print('DAILY_REWARD_COMPLETED : handleAppNotification');
        Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>().moveToWallet() : Get.put(WalletMasterController()).moveToWallet();
      }
      if (initialMessage.data['notificationKey'] == 'MY_ITEM') {
        Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>().selectMenu(1) : Get.put(HomeMenuController()).selectMenu(1);
      }
      // 챌린지 보상 푸쉬 알림
      if (initialMessage.data['notificationKey'] == 'CHALLENGE_REWARD_BADGE_ISSUED') {
        PushMessageChallengeSuccessModel data = PushMessageChallengeSuccessModel.fromJson(initialMessage.data);
        // showLocalNotification(
        //   notificationType: NotificationType.badge,
        //   title: '챌린지 뱃지 발급!',
        //   message: '${data.challengeTitle} 달성. 새로운 뱃지 확인하러 가자GO~~',
        //   payload: 'NAV-INVENTORY_BADGE',
        // );
        showChallengeBadgeAcquisitionAlert(data);
      }

      // if (initialMessage.data['notificationKey'] == 'FORCE_LOGOUT') {
      //   if (HiveStore.load(key: HiveKey.hasForcedLogout.name) != null && HiveStore.load(key: HiveKey.hasForcedLogout.name)) {
      //     HiveStore.deleteKey(key: HiveKey.hasForcedLogout.name);
      //   } else {
      //     HiveStore.save(key: HiveKey.hasForcedLogout.name, value: true); //getInitialMessage가 중복처리되어서 처리 여부를 구분하기 위해 필요
      //     await showForceLogoutAlert();
      //     forceLogout();
      //   }
      // }
    }
  }

  void selectMenu(int index) {
    prevIndex.value = selectedIndex.value;
    selectedIndex.value = index;
    if (index == 0 && hasNewChallenge.value) {
      hasNewChallenge.value = false;
    }
    if (index != 1 && Get.isRegistered<InventoryHomeController>()) {
      Get.find<InventoryHomeController>().tabController.animateTo(0);
    }
    if (visitedTabs.any((tabIndex) => tabIndex == index) && prevIndex.value != index) {
      switch (index) {
        case 0:
          if (Get.isRegistered<ChallengesController>()) Get.find<ChallengesController>().refreshController();
          bool adjustFirstClickChallengeTabEvent = HiveStore.load(key: HiveKey.adjustFirstClickChallengeTabEvent.name) ?? false;
          if (!adjustFirstClickChallengeTabEvent) {
            Adjust.trackEvent(AdjustEvent('7uolhz'));
            HiveStore.save(key: HiveKey.adjustFirstClickChallengeTabEvent.name, value: true);
          }
          Adjust.trackEvent(AdjustEvent('kq18ho'));
          break;
        case 1:
          if (Get.isRegistered<InventoryController>()) Get.find<InventoryController>().refreshController();
          Adjust.trackEvent(AdjustEvent('tlnz8m'));
          break;
        case 2:
          if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().refreshController();
          break;
        case 3:
          if (Get.isRegistered<ShopController>()) Get.find<ShopController>().refreshController();
          Adjust.trackEvent(AdjustEvent('9z4t0n'));
          break;
        case 4:
          if (Get.isRegistered<ArchiveController>()) Get.find<ArchiveController>().refreshController();
          if (Get.isRegistered<LeaderboardController>()) Get.find<LeaderboardController>().refreshController();
          bool adjustFirstClickRankTabEvent = HiveStore.load(key: HiveKey.adjustFirstClickRankTabEvent.name) ?? false;
          if (!adjustFirstClickRankTabEvent) {
            Adjust.trackEvent(AdjustEvent('var9av'));
            HiveStore.save(key: HiveKey.adjustFirstClickRankTabEvent.name, value: true);
          }
          Adjust.trackEvent(AdjustEvent('f206px'));
          break;
      }
    } else {
      visitedTabs.add(index);
    }
  }

  String selectedMenuTitle() {
    switch (selectedIndex.value) {
      case 0:
        return '챌린지';
      case 1:
        return '내 장비';
      case 3:
        return '상점';
      case 4:
        return '랭킹';
    }
    return '홈';
  }

  Future<void> checkUpdates() async {
    AppUpdateInfo? appAndroidUpdateInfo;
    VersionStatus? appIOSUpdateInfo;

    Future<void> checkAppStores() async {
      if (Platform.isAndroid) {
        appAndroidUpdateInfo = await InAppUpdate.checkForUpdate().catchError((e) {
          showToastPopup(e.toString());
        });
      } else {
        appIOSUpdateInfo = await NewVersionPlus(
          iOSId: F.isDev ? 'kr.co.eztechfin.gazaGo.dev' : 'kr.co.eztechfin.gazaGo',
        ).getVersionStatus().catchError((e) {
          showToastPopup(e.toString());
          return null;
        });
      }
    }

    bool needForceUpgrade = await isForceUpdateTarget();
    if (needForceUpgrade) {
      await checkAppStores();
      if (Platform.isAndroid &&
          appAndroidUpdateInfo != null &&
          [UpdateAvailability.updateAvailable, UpdateAvailability.developerTriggeredUpdateInProgress].any((result) => result == appAndroidUpdateInfo?.updateAvailability)) {
        await InAppUpdate.performImmediateUpdate().then((result) async {
          if ([AppUpdateResult.userDeniedUpdate, AppUpdateResult.inAppUpdateFailed].any((resultStatus) => resultStatus == result)) {
            showForceUpdateApp();
          }
        }).catchError((e) {
          showToastPopup(e.toString());
        });
      } else {
        showForceUpdateApp();
      }
    } else {
      bool needRecommendedUpgrade = await isRecommendUpdateTarget();
      if (needRecommendedUpgrade) {
        await checkAppStores();
        if (Platform.isAndroid &&
            appAndroidUpdateInfo != null &&
            [UpdateAvailability.updateAvailable, UpdateAvailability.developerTriggeredUpdateInProgress].any((result) => result == appAndroidUpdateInfo?.updateAvailability)) {
          if (appAndroidUpdateInfo!.flexibleUpdateAllowed) {
            await InAppUpdate.startFlexibleUpdate().then((value) {
              if (value == AppUpdateResult.success) {
                showUpdateSnackbar();
              }
            }).catchError((e) {
              showToastPopup(e.toString());
            });
          } else if (appAndroidUpdateInfo!.installStatus == InstallStatus.downloaded) {
            showUpdateSnackbar();
          }
        } else {
          showRecommendUpdateApp();
        }
      }
    }
  }

  void checkItemsDb() {
    String userId = HiveStore.loadString(key: HiveKey.userId.name) ?? '';
    DatabaseReference expiredItemsRef = FirebaseDatabase.instance.ref('alert_expired_item/$userId');

    expiredItemsRef.get().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        List<dynamic> expiringItems = jsonDecode(snapshot.value as String);
        Map<dynamic, dynamic> expirationNotified = HiveStore.load(key: HiveKey.expirationNotificationState.name) ?? {};

        for (Map<dynamic, dynamic> item in expiringItems) {
          DateTime expiryUTCDateTime = DateTime.parse(item['expiredDate']).toUtc();
          DateTime now = DateTime.now().toUtc();

          if (expirationNotified.isEmpty || expirationNotified.isNotEmpty && expirationNotified[item['userItemId'].toString()] == null) {
            if (const Duration(hours: 48).compareTo(expiryUTCDateTime.difference(now)) == 1) {
              expirationNotified[item['userItemId'].toString()] = {'notified': true, 'expireDate': expiryUTCDateTime.toString()};
              showLocalNotification(
                notificationType: NotificationType.normal,
                title: '아이템 만료 알림',
                message: '${item['itemName']}가 48시간 이내에 회수될 예정입니다.',
                allowSeparatePush: true,
                separatePushId: item['userItemId'],
                payload: 'NAV-INVENTORY_ITEM',
              );
            }
          }
        }

        HiveStore.save(key: HiveKey.expirationNotificationState.name, value: expirationNotified);
      } else {
        HiveStore.save(key: HiveKey.expirationNotificationState.name, value: {});
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void checkForNewChallenges() async {
    await ActivityService.getNewChallenges(successCallback: (List<NewChallengeModel> challengeList) {
      List<int>? challengeListIds = HiveStore.load(key: HiveKey.challengeListIds.name);
      if (challengeListIds != null && challengeListIds.isNotEmpty) {
        for (NewChallengeModel challenge in challengeList) {
          if (!challengeListIds.contains(challenge.id)) {
            hasNewChallenge.value = true;
            break;
          }
        }
      } else if (challengeListIds == null && challengeList.isNotEmpty) {
        hasNewChallenge.value = true;
      }
    });
  }

  Future<void> checkUserCI() async {
    String userId = HiveStore.load(key: HiveKey.userId.name);
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    DatabaseReference userDiInfoRef = FirebaseDatabase.instance.ref('user_info/$userId/deviceId');

    userDiInfoRef.onValue.listen((DatabaseEvent event) async {
      eventListener.value = ++eventListener.value;
      print(event.snapshot.value);
      if (event.snapshot.value != deviceId && event.snapshot.value != null && eventListener.value == 1) {
        handleForceLogoutWithAlert();
      }
      eventListener.value = 0;
    });
  }

  Future<void> handleForceLogoutWithAlert() async {
    HiveStore.deleteKey(key: HiveKey.needToForceLogout.name);
    HiveStore.save(key: HiveKey.hasForcedLogout.name, value: true);

    await showForceLogoutAlert();
    forceLogout();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() async {
    handleAppNotification();
    print('111111111111111111111111111111111111111111');

    if (HiveStore.load(key: HiveKey.needRouteToGoWallet.name) != null && HiveStore.load(key: HiveKey.needRouteToGoWallet.name)) {
      print('2222222222222222222222222222222222');
      Get.isRegistered<WalletMasterController>() ? Get.find<WalletMasterController>().moveToWallet() : Get.put(WalletMasterController()).moveToWallet();
      HiveStore.deleteKey(key: HiveKey.needRouteToGoWallet.name);
    } else if (HiveStore.load(key: HiveKey.needToForceLogout.name) != null && HiveStore.load(key: HiveKey.needToForceLogout.name)) {
      handleForceLogoutWithAlert();
    } else if (HiveStore.load(key: HiveKey.needToForceStopExercise.name) != null && HiveStore.load(key: HiveKey.needToForceStopExercise.name)) {
      Get.find<ActivityController>().handleAlreadyFinishedExercise();
      HiveStore.deleteKey(key: HiveKey.needToForceStopExercise.name);
    }
  }



  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
