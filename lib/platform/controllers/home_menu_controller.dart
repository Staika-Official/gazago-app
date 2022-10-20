import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/presentations/components/main_appbar.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/views/activity/index.dart';
import 'package:gaza_go/presentations/views/archive/index.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:get/get.dart';

class HomeMenuController extends GetxController {
  final RxInt selectedIndex = RxInt(0);
  final RxList<int> visitedTabs = RxList.empty();

  final List<PreferredSizeWidget> appbarList = [
    MainAppbar(),
    SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    ActivityHome(),
    ArchiveHome(),
    InventoryHome(),
    // ShopHome(),
    LeaderboardHome(),
  ];

  PreferredSizeWidget get appbar {
    return selectedIndex.value == 0 ? appbarList.first : appbarList.last;
  }

  bool isBackButton() {
    return Get.currentRoute == Routes.syntheticBadge;
  }

  void selectMenu(int index) {
    int prevTabIndex = selectedIndex.value;
    selectedIndex.value = index;

    if (visitedTabs.any((tabIndex) => tabIndex == index) && prevTabIndex != index) {
      switch (index) {
        case 0:
          ActivityController activityController = Get.find();
          activityController.refreshController();
          break;
        case 1:
          ArchiveController archiveController = Get.find();
          archiveController.refreshController();
          break;
        case 2:
          InventoryController inventoryController = Get.find();
          inventoryController.refreshController();
          break;
        case 3:
          LeaderboardController leaderboardController = Get.find();
          leaderboardController.refreshController();
          break;
      }
    } else {
      visitedTabs.add(index);
    }
  }
}
