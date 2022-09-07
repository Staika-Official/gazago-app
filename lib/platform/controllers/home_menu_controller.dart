import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/presentations/views/activity/index.dart';
import 'package:step_go/presentations/views/archive/index.dart';
import 'package:step_go/presentations/views/inventory/index.dart';
import 'package:step_go/presentations/views/leaderboard/index.dart';
import 'package:step_go/presentations/views/shop/index.dart';

class HomeMenuController extends GetxController {
  final List<AppBar> appbarList = [
    AppBar(
      title: Text('main'),
    ),
    AppBar(
      title: Text('secondary'),
    ),
  ];

  final List<Widget> mainViewWidgetList = [
    ArchiveHome(),
    InventoryHome(),
    ActivityHome(),
    ShopHome(),
    LeaderboardHome(),
  ];

  AppBar get appbar {
    return selectedIndex.value == 2 ? appbarList.first : appbarList.last;
  }

  final RxInt selectedIndex = RxInt(2);

  void selectMenu(int index) {
    selectedIndex.value = index;
  }
}
