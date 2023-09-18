import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/notice_popup_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  MovieTween challengeMovie = MovieTween()
    ..scene(begin: const Duration(seconds: 1), duration: const Duration(milliseconds: 300))
        .tween('opacity', Tween<double>(begin: 0, end: 1), curve: Curves.easeOut)
        .thenFor(duration: const Duration(seconds: 1))
        .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  Widget bottomNavigationBar(HomeMenuController controller) {
    return Container(
      key: controller.bottomNavKey,
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == 2
            ? const Color(0xFF252529)
            : controller.selectedIndex.value == 1 || controller.selectedIndex.value == 3
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              return CustomAnimationBuilder<Movie>(
                control: controller.newChallengeControl.value,
                tween: challengeMovie,
                duration: challengeMovie.duration,
                builder: (context, value, _) {
                  if (controller.hasNewChallenge.value == true) {
                    return Positioned(
                      top: -60.sp,
                      left: 10.sp,
                      child: Opacity(
                        opacity: value.get('opacity'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: StyledText(
                                '새로운 챌린지가 오픈했어요',
                                color: skyBlueColor,
                                fontSize: 14,
                                fontWeight: 600,
                                lineHeight: 14,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Positioned(
                              bottom: -5,
                              left: 20,
                              child: Transform.rotate(
                                angle: 180 / pi,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            }),
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.sp), topRight: Radius.circular(15.sp)),
              child: NavigationBar(
                elevation: 0,
                backgroundColor: popupBgColor,
                onDestinationSelected: (index) => controller.selectMenu(index),
                selectedIndex: controller.selectedIndex.value,
                destinations: [
                  Obx(() {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NavigationDestination(
                          icon: iconMenuChallenges,
                          selectedIcon: iconMenuChallengesActive,
                          label: '챌린지',
                        ),
                        if (controller.hasNewChallenge.value == true)
                          Positioned(
                            top: 17.sp,
                            right: 17.sp,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xffFF1414),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                      ],
                    );
                  }),
                  NavigationDestination(
                    icon: iconMenuItems,
                    selectedIcon: iconMenuItemsActive,
                    label: '내 장비',
                  ),
                  NavigationDestination(
                    icon: iconMenuHome,
                    selectedIcon: iconMenuHomeActive,
                    label: '홈',
                  ),
                  NavigationDestination(
                    icon: iconMenuShop,
                    selectedIcon: iconMenuShopActive,
                    label: '상점',
                  ),
                  NavigationDestination(
                    icon: iconMenuRanking,
                    selectedIcon: iconMenuRankingActive,
                    label: '랭킹',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NoticePopupController());
    Get.put(DailyBenefitController());
    HomeMenuController controller = Get.put(HomeMenuController());

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
          // extendBody: true,
          backgroundColor: subBg01Color,
          appBar: controller.appbar,
          body: controller.mainViewWidgetList.elementAt(controller.selectedIndex.value),
          bottomNavigationBar: controller.selectedIndex.value == 2
              ? bottomNavigationBar(
                  controller,
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.hideBottomNav.value ? 0 : controller.bottomNavHeight.value,
                  child: Wrap(
                    children: [
                      bottomNavigationBar(
                        controller,
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
