import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/main_appbar.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/views/activity/index.dart';
import 'package:gaza_go/presentations/views/archive/index.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:gaza_go/presentations/views/shop/index.dart';
import 'package:get/get.dart';

class HomeMenuController extends SuperController {
  final RxInt selectedIndex = RxInt(2);
  final RxInt prevIndex = RxInt(0);
  final RxList<int> visitedTabs = RxList.empty();

  final List<PreferredSizeWidget> appbarList = [
    const MainAppbar(),
    const SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    const ArchiveHome(),
    const InventoryHome(),
    const ActivityHome(),
    const ShopHome(),
    const LeaderboardHome(),
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
  void onReady() {
    handleRewardNotification();
    super.onReady();
  }

  void handleRewardNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data['notificationKey'] == 'DAILY_REWARD_COMPLETED') {
        Get.toNamed(Routes.wallet);
      }
    }
  }

  bool isBackButton() {
    return Get.currentRoute == Routes.shopItemDetail;
  }

  void selectMenu(int index) {
    prevIndex.value = selectedIndex.value;
    selectedIndex.value = index;

    if (visitedTabs.any((tabIndex) => tabIndex == index) && prevIndex.value != index) {
      switch (index) {
        case 0:
          if (Get.isRegistered<ArchiveController>()) Get.find<ArchiveController>().refreshController();
          break;
        case 1:
          if (Get.isRegistered<InventoryController>()) Get.find<InventoryController>().refreshController();
          break;
        case 2:
          if (Get.isRegistered<ActivityController>()) Get.find<ActivityController>().refreshController();
          break;
        case 3:
          if (Get.isRegistered<ShopController>()) Get.find<ShopController>().refreshController();
          break;
        case 4:
          if (Get.isRegistered<LeaderboardController>()) Get.find<LeaderboardController>().refreshController();
          break;
      }
    } else {
      visitedTabs.add(index);
    }
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
  void onResumed() {
    if (HiveStore.load(key: HiveKey.needRouteToGoWallet.name) != null && HiveStore.load(key: HiveKey.needRouteToGoWallet.name)) {
      HiveStore.deleteKey(key: HiveKey.needRouteToGoWallet.name);
      Get.toNamed(Routes.wallet);
    }
  }
}
