import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/activity/activity_map.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ActivityActive extends StatelessWidget {
  const ActivityActive({Key? key}) : super(key: key);

  List<Widget> renderGauge(ExerciseType exerciseType, Color color) {
    List<Widget> gaugeList = List.empty(growable: true);
    for (int i = 0; i < 75; i++) {
      //15km / 0.20 = 75
      Widget? gauge;
      if (i > (exerciseType == ExerciseType.hiking ? 1 : 3) && i < 35) {
        // hiking? 0.6 : 1 ~ 7km
        gauge = Container(
          width: 3.sp,
          height: 21.sp,
          color: color,
        );
      } else {
        gauge = Container(
          width: 3.sp,
          height: 18.sp,
          color: speedGrayColor,
        );
      }

      gaugeList.add(gauge);
    }
    return gaugeList;
  }

  double calculateGaugePosition(BoxConstraints constraints, double speed) {
    double spaceLeft = constraints.maxWidth - (75 * 3); //75 = bar 개수, 3= bar width
    double spacesBetweenBars = spaceLeft / 74;
    int barStep = ((speed > 15 ? 15 : speed) / 0.20).floor();

    if (barStep < 2) {
      return 0.5; //0.5 = gauge cursor width / 2
    } else {
      return (3 + spacesBetweenBars) * (barStep - 1) + 0.5;
    }
  }

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.0.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 42.sp,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                            child: SizedBox(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: gaugeGrayColor,
                                  border: Border.all(
                                    width: 2.sp,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(42.sp),
                                  ),
                                ),
                              ),
                              stat.currentStat > 1.0
                                  ? LayoutBuilder(builder: (context, constraints) {
                                      return Container(
                                        width: (stat.currentStat > 20
                                            ? constraints.maxWidth / (100 / stat.currentStat)
                                            : stat.currentStat < 2
                                                ? 0
                                                : 34),
                                        decoration: BoxDecoration(
                                          color: stat.currentStat < 30
                                              ? textRedColor
                                              : stat.type == 'STAMINA'
                                                  ? lightGreenColor
                                                  : purpleColor,
                                          border: Border.all(
                                            width: 2.sp,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.sp),
                                          ),
                                        ),
                                      );
                                    })
                                  : Container(),
                            ],
                          ),
                        )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          stat.type == 'STAMINA'
                              ? Padding(
                                  padding: EdgeInsets.only(left: 13.0.sp, right: 10.sp),
                                  child: iconStamina,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 12.0.sp, right: 7.sp),
                                  child: iconShoes,
                                ),
                          StyledText(
                            stat.name,
                            fontFamily: 'Montserrat',
                            fontWeight: 800,
                            fontSize: 15,
                            lineHeight: 18,
                            letterSpacing: -.1,
                            color: stat.currentStat <= 30 ? Colors.white : Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.sp),
                            child: StyledText(
                              stat.currentStat.toString(),
                              fontWeight: 800,
                              fontSize: 14,
                              lineHeight: 15,
                              color: stat.currentStat <= 30 ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          stat.type == 'STAMINA'
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(42.sp),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 2),
                                        blurRadius: 4.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 19.sp,
                                    backgroundColor: lightGreenColor,
                                    child: IconButton(
                                      icon: iconPlus,
                                      splashRadius: 19.sp,
                                      onPressed: () => controller.loaderController.isLoading.value ? null : controller.onClickRepairStat(stat, context),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 2.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.sp),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 2),
                                        blurRadius: 4.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 19.sp,
                                    backgroundColor: purpleColor,
                                    child: IconButton(
                                      icon: iconPlus,
                                      splashRadius: 15.sp,
                                      onPressed: () => controller.loaderController.isLoading.value ? null : controller.onClickRepairStat(stat, context),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController globalController = Get.find();
    ActivityController controller = Get.find();

    final luckMovie = MovieTween()
      ..scene(begin: const Duration(seconds: 0), duration: const Duration(seconds: 2))
          .tween('opacity', Tween<double>(begin: 0, end: 1), curve: Curves.easeOut)
          .thenFor(duration: const Duration(seconds: 5))
          .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

    return DefaultContainer(
      backgroundColor: subBg02Color,
      onBackButtonTap: () {
        controller.initLuckAnimation();
        if (globalController.internetConnection.value) {
          Get.back();
        } else {
          Get.offNamed(Routes.home);
        }
      },
      titleWidget: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.sp,
              height: 6.sp,
              margin: EdgeInsets.only(right: 8.sp),
              decoration: BoxDecoration(
                color: controller.exerciseSteps.value < 1 ? Colors.white : controller.exerciseStateTextColor.value,
                borderRadius: BorderRadius.circular(6.sp),
              ),
            ),
            controller.exerciseSteps.value < 1
                ? const StyledText(
                    '운동 분석중',
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                  )
                : StyledText(
                    ((controller.selectedExerciseType.value == ExerciseType.hiking ? controller.avgSpeed.value < 0.7 : controller.avgSpeed.value < 1) || controller.avgSpeed.value > 7) &&
                                controller.exerciseState.value == ExerciseState.ongoing ||
                            controller.stoppedExercising.value
                        ? '${controller.exerciseState.value.label} (보상 불가)'
                        : controller.exerciseState.value.label,
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                    color: controller.exerciseStateTextColor.value,
                  )
          ],
        );
      }),
      child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Obx(() {
                    return Container(
                      child: controller.selectedCourse.value != null
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 7.sp),
                              decoration: BoxDecoration(
                                color: const Color(0xff1b1b1b),
                                borderRadius: BorderRadius.circular(50.sp),
                              ),
                              child: StyledText(
                                '${controller.selectedCourse.value!.firstName} | ${controller.selectedCourse.value!.secondName}',
                                fontSize: 14,
                                fontWeight: 500,
                                color: deepGrayColor,
                              ),
                            )
                          : Container(),
                    );
                  }),
                  Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.0.sp, bottom: 20.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Stack(
                              children: [
                                if (controller.isShowLuckAnimation.value)
                                  CustomAnimationBuilder<Movie>(
                                      control: controller.luckLoadControl.value,
                                      tween: luckMovie,
                                      duration: luckMovie.duration,
                                      onCompleted: () {
                                        controller.initLuckAnimation();
                                      },
                                      builder: (context, value, _) {
                                        return Obx(() {
                                          return Opacity(
                                            opacity: value.get('opacity'),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 14.sp, right: 14.sp, top: 10.sp, bottom: 10.0.sp),
                                                    child: Row(
                                                      children: [
                                                        iconStatLuck,
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 5.0.sp, right: 5.0.sp),
                                                          child: StyledText(
                                                            '행운효과',
                                                            color: pinkColor,
                                                            fontSize: 14,
                                                            fontWeight: 500,
                                                            letterSpacing: -.1,
                                                          ),
                                                        ),
                                                        if (controller.userState.value.exercise != null)
                                                          StyledText(
                                                            '+${controller.userState.value.exercise!.luckApplyRewardGo}',
                                                            fontSize: 14,
                                                            fontWeight: 700,
                                                            letterSpacing: -.1,
                                                          ),
                                                        const StyledText(
                                                          ' GO',
                                                          fontSize: 14,
                                                          fontWeight: 700,
                                                          letterSpacing: -.1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 25.0.sp),
                                                  child: ClipPath(
                                                    clipper: CustomShapeClipper(),
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Container(
                                                      width: 10.0.sp,
                                                      height: 7.0.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                      }),
                                Obx(() {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 43.0.sp, left: 12.sp, right: 12.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/common/ico_token_go.svg',
                                          width: 36.sp,
                                          height: 36.sp,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 14.0.sp),
                                          child: AnimatedFlipCounter(
                                            value: controller.userState.value.exercise != null ? controller.userState.value.exercise!.rewardGo! : 0,
                                            duration: const Duration(milliseconds: 500),
                                            fractionDigits: 2,
                                            thousandSeparator: ',',
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 50.sp,
                                              height: 1,
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3.0.sp),
                                          child: StyledText(
                                            'GO',
                                            fontWeight: 500,
                                            fontSize: 35,
                                            lineHeight: 35,
                                            fontFamily: 'Montserrat',
                                            color: deepGrayColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    if (controller.isShowLuckAnimation.value)
                      Positioned(
                        left: 0.sp,
                        top: 0,
                        child: Lottie.asset(
                          'assets/lottie/activity_luck.json',
                          width: 250,
                          height: 150,
                          repeat: false,
                          frameRate: FrameRate.max,
                        ),
                      ),
                  ]),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 10.sp),
                      child: Container(
                        width: double.infinity.sp,
                        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 24.sp),
                        decoration: BoxDecoration(
                          color: speedBlackColor,
                          borderRadius: BorderRadius.circular(50.sp),
                        ),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Obx(() {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ...renderGauge(controller.selectedExerciseType.value, controller.exerciseStateGaugeColor.value),
                                  ],
                                ),
                                Positioned(
                                  top: -26.sp,
                                  left: calculateGaugePosition(constraints, controller.realTimeSpeed.value),
                                  child: GaugeCursor(
                                    color: controller.exerciseStateGaugeColor.value,
                                    speed: controller.realTimeSpeed.value,
                                  ),
                                ),
                                Positioned(
                                  bottom: -30.sp,
                                  left: ((constraints.maxWidth / 60) * 8).sp,
                                  child: Row(
                                    children: [
                                      StyledText(
                                        '${controller.selectedExerciseType.value == ExerciseType.hiking ? '0.7' : '1'}-7',
                                        color: deepGrayColor,
                                        fontSize: 14,
                                        lineHeight: 12,
                                        fontWeight: 700,
                                        fontFamily: 'Montserrat',
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3.sp),
                                        child: StyledText(
                                          'km/h',
                                          color: deepGrayColor,
                                          fontSize: 12,
                                          lineHeight: 12,
                                          fontWeight: 500,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                        }),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.sp,
                      right: 30.sp,
                      top: 60.sp,
                      bottom: 25.sp,
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // InkWell(
                            //     onTap: () {
                            //       controller.showLuckAnimation();
                            //     },
                            //     child: StyledText('눌ㄹ러라')),
                            SizedBox(
                              width: constraints.maxWidth / 3,
                              child: Column(
                                children: [
                                  SvgPicture.asset('assets/images/activity/ico_time.svg'),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.sp),
                                    child: StyledText(
                                      formatSeconds(controller.exerciseTime.value),
                                      fontWeight: 600,
                                      fontSize: 16,
                                      lineHeight: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth / 3,
                              child: Column(
                                children: [
                                  SvgPicture.asset('assets/images/activity/ico_distance.svg'),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.sp),
                                    child: StyledText(
                                      '${formatDecimalPlaces(controller.totalDistance.value, 2)}km',
                                      fontWeight: 600,
                                      fontSize: 16,
                                      lineHeight: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth / 3,
                              child: Column(
                                children: [
                                  SvgPicture.asset('assets/images/activity/ico_step.svg'),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.sp),
                                    child: StyledText(
                                      controller.exerciseSteps.value.toString(),
                                      fontWeight: 600,
                                      fontSize: 16,
                                      lineHeight: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.sp,
                      right: 30.sp,
                    ),
                    child: Obx(() {
                      return Column(
                        children: [
                          ...renderStatList(controller, context),
                        ],
                      );
                    }),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(left: 35.sp, right: 35.sp, bottom: 100.sp),
                        child: Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircularButton(
                                radius: 50,
                                color: Colors.white,
                                onTap: () => controller.showExerciseMap(const ActivityMap()),
                                child: SvgPicture.asset(
                                  'assets/images/activity/ico_map.svg',
                                ),
                              ),
                              [ExerciseState.ongoing].any((state) => controller.exerciseState.value == state)
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail, controller.selectedCourse.value, controller: controller),
                                          onTapUp: (tapUpDetail) => controller.onTapUpStop(tapUpDetail),
                                          child: Stack(
                                            children: [
                                              CircularButton(
                                                radius: 78.sp,
                                                color: Colors.white,
                                                child: Icon(Icons.stop, color: Colors.black, size: 35.sp),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                  width: 78.sp,
                                                  height: 78.sp,
                                                  padding: EdgeInsets.all(5.sp),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 6.sp,
                                                    color: skyBlueColor,
                                                    value: controller.stopProgress.value,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 11.sp),
                                          child: CircularButton(
                                            radius: 78.sp,
                                            color: const Color(0xffFF2222),
                                            onTap: () => controller.pauseExercise(),
                                            child: Icon(Icons.pause, color: Colors.white, size: 35.sp),
                                          ),
                                        )
                                      ],
                                    )
                                  : CircularButton(
                                      radius: 90.sp,
                                      color: const Color(0xffFF2222),
                                      onTap: () {
                                        if (controller.exerciseState.value == ExerciseState.paused) {
                                          controller.exerciseUpdateThr.throttle(() => controller.continueExercise());
                                        } else {
                                          controller.exerciseStartThr.throttle(() => controller.startExercise(controller.selectedExerciseType.value, controller.selectedCourse.value));
                                        }
                                      },
                                      child: Icon(Icons.play_arrow, color: Colors.white, size: 35.sp),
                                    ),
                              CircularButton(
                                radius: 50,
                                color: Colors.white,
                                onTap: () {
                                  Get.toNamed(Routes.equippedItems);
                                },
                                child: SvgPicture.asset(
                                  'assets/images/activity/ico_item.svg',
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class GaugeCursor extends StatelessWidget {
  final Color color;
  final double speed;

  const GaugeCursor({Key? key, required this.color, required this.speed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: -5,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Container(
              width: 2,
              height: 12,
              color: color,
            ),
          ),
          Positioned(
            top: 0,
            left: speed > 13 ? -80 : 10,
            child: Row(
              children: [
                StyledText(
                  formatDecimalPlaces(speed >= 0 ? speed : 0, 1),
                  color: color,
                  fontSize: 14,
                  lineHeight: 12,
                  fontWeight: 700,
                  fontFamily: 'Montserrat',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: StyledText(
                    'km/h',
                    color: color,
                    fontSize: 12,
                    lineHeight: 12,
                    fontWeight: 500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
