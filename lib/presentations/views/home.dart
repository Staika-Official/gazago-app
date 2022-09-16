import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeMenuController controller = Get.put(HomeMenuController());

    return Obx(() {
      return Scaffold(
        appBar: controller.appbar,
        body: controller.mainViewWidgetList.elementAt(controller.selectedIndex.value),
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
