import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/presentations/components/main_appbar.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/views/activity/index.dart';
import 'package:gaza_go/presentations/views/archive/index.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:get/get.dart';

class HomeMenuController extends GetxController {
  final RxInt selectedIndex = RxInt(0);

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

  @override
  void onInit() async {
    await checkLoginStatus();
    super.onInit();
  }

  bool isBackButton() {
    return Get.currentRoute == Routes.syntheticBadge;
  }

  void selectMenu(int index) {
    selectedIndex.value = index;
    ActivityController activityController = Get.find();
    ArchiveController archiveController = Get.find();
    InventoryController inventoryController = Get.find();
    LeaderboardController leaderboardController = Get.find();

    switch (index) {
      case 0:
        activityController.initController();
        break;
      case 1:
        archiveController.initController();
        break;
      case 2:
        inventoryController.initController();
        break;
      case 3:
        leaderboardController.initController();
        break;
    }
  }

  Future<void> checkLoginStatus() async {
    int statusCode = await UaaService.checkLoginStatus();
    if (statusCode != 200) Get.offAllNamed(Routes.login);
  }
}
