import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget bottomNavigationBar(HomeMenuController controller) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: NavigationBar(
          backgroundColor: const Color(0xFF363841),
          onDestinationSelected: (index) => controller.selectMenu(index),
          selectedIndex: controller.selectedIndex.value,
          destinations: [
            NavigationDestination(
              icon: iconMenuHome,
              selectedIcon: iconMenuHomeActive,
              label: '홈',
            ),
            NavigationDestination(
              icon: iconMenuArchive,
              selectedIcon: iconMenuArchiveActive,
              label: '기록',
            ),
            NavigationDestination(
              icon: iconMenuItems,
              selectedIcon: iconMenuItemsActive,
              label: '내 장비',
            ),
            // NavigationDestination(
            //   icon: Icon(
            //     Icons.storefront,
            //   ),
            //   label: '상점',
            // ),
            NavigationDestination(
              icon: iconMenuRanking,
              selectedIcon: iconMenuRankingActive,
              label: '랭킹',
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeMenuController controller = Get.put(HomeMenuController());

    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFF1D1D26),
        appBar: controller.appbar,
        body: controller.mainViewWidgetList.elementAt(controller.selectedIndex.value),
        bottomNavigationBar: controller.selectedIndex != 2 ? bottomNavigationBar(controller) : null,
      );
    });
  }
}
