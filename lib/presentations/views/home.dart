import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/home_menu_controller.dart';
import 'package:step_go/presentations/components/main_appbar.dart';
import 'package:step_go/presentations/components/secondary_appbar.dart';
import 'package:step_go/presentations/views/activity/index.dart';
import 'package:step_go/presentations/views/archive/index.dart';
import 'package:step_go/presentations/views/inventory/index.dart';
import 'package:step_go/presentations/views/leaderboard/index.dart';
import 'package:step_go/presentations/views/shop/index.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final List<PreferredSizeWidget> appbarList = [
    MainAppbar(),
    SecondaryAppbar(),
  ];

  final List<Widget> mainViewWidgetList = [
    ArchiveHome(),
    InventoryHome(),
    ActivityHome(),
    ShopHome(),
    LeaderboardHome(),
  ];

  @override
  Widget build(BuildContext context) {
    HomeMenuController controller = Get.put(HomeMenuController());

    return Obx(() {
      return Scaffold(
        appBar: controller.getAppbar(appbarList),
        body: mainViewWidgetList.elementAt(controller.selectedIndex.value),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) => controller.selectMenu(index),
          selectedIndex: controller.selectedIndex.value,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.assignment,
              ),
              label: '기록',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.inventory,
              ),
              label: '아이템',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.home,
              ),
              label: '홈',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.storefront,
              ),
              label: '상점',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.star,
              ),
              label: '리더보드',
            )
          ],
        ),
      );
    });
  }
}
