import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/presentations/components/main_appbar.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/views/activity/index.dart';
import 'package:gaza_go/presentations/views/archive/index.dart';
import 'package:gaza_go/presentations/views/inventory/index.dart';
import 'package:gaza_go/presentations/views/leaderboard/index.dart';
import 'package:gaza_go/presentations/views/shop/index.dart';
import 'package:get/get.dart';

class HomeMenuController extends GetxController {
  final RxInt selectedIndex = RxInt(2);

  final List<PreferredSizeWidget> appbarList = [
    MainAppbar(),
    SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    ArchiveHome(),
    InventoryHome(),
    // InventoryItemDetail(),
    // InventoryBadgeDetail(),
    ActivityHome(),
    ShopHome(),
    LeaderboardHome(),
  ];

  PreferredSizeWidget get appbar {
    return selectedIndex.value == 2 ? appbarList.first : appbarList.last;
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
  }

  Future<void> checkLoginStatus() async {
    int statusCode = await UaaService.checkLoginStatus();
    if (statusCode != 200) Get.offAll(Routes.login);
  }
}
