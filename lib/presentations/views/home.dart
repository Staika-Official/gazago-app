import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
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
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return WillPopScope(
      onWillPop: () async {
        showAlert(
          title: '알림',
          contentText: '앱을 종료하시겠습니까?',
          actions: [
            Expanded(
              child: GazagoButton(
                onTap: () => Get.back(),
                buttonText: '아니요',
                textColor: Colors.white,
                buttonColor: const Color(0xFF363841),
              ),
            ),
            const SizedBox(
              width: 9,
            ),
            Expanded(
              child: GazagoButton(
                onTap: () {
                  SystemNavigator.pop();
                },
                buttonText: '예',
                buttonColor: const Color(0xFF0EE6F3),
              ),
            ),
          ],
        );
        // maypop : pop 할께 있으면 pop을 하고, 아니면, app 을 종료 시키는것
        // pop 할께 있으면 true 인데, true 이면 app 이 종료가 되기 때문에 false 로 바꿔 줘야 되기 때문에 await 앞에 ! 을 넣어 줌
        return !await navigatorKey.currentState!.maybePop();
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color(0xFF1D1D26),
          appBar: controller.appbar,
          body: controller.mainViewWidgetList.elementAt(controller.selectedIndex.value),
          bottomNavigationBar: bottomNavigationBar(controller),
        );
      }),
    );
  }
}
