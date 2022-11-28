import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget bottomNavigationBar(HomeMenuController controller) {
    return Container(
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == 0
            ? Color(0xFF1C1D23)
            : controller.selectedIndex.value == 2
                ? popupBgColor
                : subBg01Color,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.sp,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.sp),
            topRight: Radius.circular(16.sp),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.sp), topRight: Radius.circular(15.sp)),
          child: NavigationBar(
            elevation: 0,
            backgroundColor: popupBgColor,
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
          contentText: '운동 중인 기록은 저장되지 않습니다.\ngazaGO를 종료 하시겠습니까?',
          actions: [
            Expanded(
              child: GazagoButton(
                onTap: () => Get.back(),
                buttonText: '아니요',
                textColor: Colors.white,
                buttonColor: popupBgColor,
              ),
            ),
            SizedBox(
              width: 9.sp,
            ),
            Expanded(
              child: GazagoButton(
                onTap: () {
                  SystemNavigator.pop();
                },
                buttonText: '예',
                buttonColor: skyBlueColor,
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
          backgroundColor: subBg01Color,
          appBar: controller.appbar,
          body: controller.mainViewWidgetList.elementAt(controller.selectedIndex.value),
          bottomNavigationBar: bottomNavigationBar(
            controller,
          ),
        );
      }),
    );
  }
}
