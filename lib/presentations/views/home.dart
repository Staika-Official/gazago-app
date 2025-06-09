import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/collection_controller.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:simple_animations/simple_animations.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<Widget> renderNavigation(HomeMenuController controller) {
    List navigation = [
      {
        'icon': iconMenuChallenges,
        'selectedIcon': iconMenuChallengesActive,
        'label': 'challenge'.tr(),
      },
      {
        'icon': iconMenuItems,
        'selectedIcon': iconMenuItemsActive,
        'label': 'my_equipment'.tr(),
      },
      {
        'icon': iconMenuHome,
        'selectedIcon': iconMenuHomeActive,
        'label': 'home'.tr(),
      },
      {
        'icon': iconMenuShop,
        'selectedIcon': iconMenuShopActive,
        'label': 'shop'.tr(),
      },
      {
        'icon': iconMenuRanking,
        'selectedIcon': iconMenuRankingActive,
        'label': 'ranking'.tr(),
      }
    ];
    return navigation
        .asMap()
        .entries
        .map(
          (item) => Expanded(
            child: InkWell(
              onTap: () {
                controller.selectMenu(item.key);
              },
              child: Container(
                key: ValueKey(item.key),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: Center(
                            child: controller.selectedIndex.value == item.key
                                ? item.value['selectedIcon']
                                : item.value['icon'],
                          ),
                        ),
                        if (controller.hasNewChallenge.value == true &&
                            item.key == 0)
                          Positioned(
                            top: 0,
                            right: -2,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item.value['label'],
                        style: AppTextStyleData.regular()
                            .koCaptionSemiboldMd
                            .copyWith(
                              color: controller.selectedIndex.value == item.key
                                  ? AppColorData.regular().colorTextBrand
                                  : Colors.white,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  MovieTween challengeMovie = MovieTween()
    ..scene(
            begin: const Duration(seconds: 1),
            duration: const Duration(milliseconds: 300))
        .tween('opacity', Tween<double>(begin: 0, end: 1),
            curve: Curves.easeOut)
        .thenFor(duration: const Duration(seconds: 1))
        .thenTween('opacity', Tween<double>(begin: 1, end: 0),
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  Widget bottomNavigationBar(HomeMenuController controller) {
    return Container(
      key: controller.bottomNavKey,
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == 2
            ? AppColorData.regular().colorBgPrimary
            : controller.selectedIndex.value == 1
                ? AppColorData.regular().colorBgTertiary
                : AppColorData.regular().colorBgPrimary,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorData.regular().colorBgTertiary,
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
                  if (controller.hasNewChallenge.value != true) {
                    return Positioned(
                      top: -60.sp,
                      left: 10.sp,
                      child: Opacity(
                        opacity: value.get('opacity'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: StyledText(
                                'new_challenge_opened'.tr(),
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
                                  decoration: const BoxDecoration(
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.sp),
                topRight: Radius.circular(15.sp),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.sp, bottom: 28.sp),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ...renderNavigation(controller),
                    ],
                  ),
                ),
              ),
              // child: NavigationBar(
              //   elevation: 0,
              //   backgroundColor: AppColorData.regular().colorBgTertiary,
              //   onDestinationSelected: (index) => controller.selectMenu(index),
              //   selectedIndex: controller.selectedIndex.value,
              //   destinations: [
              //     Obx(() {
              //       return Stack(
              //         clipBehavior: Clip.none,
              //         children: [
              //           NavigationDestination(
              //             icon: iconMenuChallenges,
              //             selectedIcon: iconMenuChallengesActive,
              //             label: 'challenge'.tr(),
              //           ),
              //           if (controller.hasNewChallenge.value == true)
              //             Positioned(
              //               top: 17.sp,
              //               right: 22.sp,
              //               child: Container(
              //                 width: 8,
              //                 height: 8,
              //                 decoration: BoxDecoration(
              //                   color: const Color(0xffFF1414),
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //             )
              //         ],
              //       );
              //     }),
              //
              //     NavigationDestination(
              //       icon: iconMenuItems,
              //       selectedIcon: iconMenuItemsActive,
              //       label: 'my_equipment'.tr(),
              //     ),
              //     NavigationDestination(
              //       icon: iconMenuHome,
              //       selectedIcon: iconMenuHomeActive,
              //       label: 'home'.tr(),
              //     ),
              //     NavigationDestination(
              //       icon: iconMenuShop,
              //       selectedIcon: iconMenuShopActive,
              //       label: 'shop'.tr(),
              //     ),
              //     NavigationDestination(
              //       icon: iconMenuRanking,
              //       selectedIcon: iconMenuRankingActive,
              //       label: 'ranking'.tr(),
              //     )
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DailyBenefitController());
    Get.put(CollectionController());
    HomeMenuController controller = Get.put(HomeMenuController());

    return PopScope(
      canPop: false,
      onPopInvoked: (bool canPop) async {
        showAlert(
          title: 'notification'.tr(),
          contentText: 'unsaved_exercise_data'.tr(),
          actions: [
            Expanded(
              child: GazagoButton(
                onTap: () => Get.back(),
                buttonText: 'no'.tr(),
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
                buttonText: 'yes_1'.tr(),
                buttonColor: skyBlueColor,
              ),
            ),
          ],
        );
      },
      child: Obx(() {
        return Scaffold(
          // extendBody: true,
          backgroundColor: subBg01Color,
          appBar: controller.appbar,
          body: controller.mainViewWidgetList
              .elementAt(controller.selectedIndex.value),
          bottomNavigationBar: controller.selectedIndex.value == 2
              ? bottomNavigationBar(
                  controller,
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.hideBottomNav.value
                      ? 0
                      : controller.bottomNavHeight.value,
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
