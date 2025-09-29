import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/configs/unified_gps_config.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/services/activity_gps_service.dart';

import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/activity_active_main_button_section.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/activity_active_mini_map_section.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:lottie/lottie.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ActivityActive extends StatelessWidget {
  const ActivityActive({super.key});

  List<Widget> renderGauge(ExerciseType exerciseType, Color color) {
    List<Widget> gaugeList = List.empty(growable: true);
    
    // Get dynamic valid range indices based on config
    int validBarsStart = 3; // Start of valid range
    int validBarsEnd = 22;  // End of valid range (based on 14km/h max)
    
    for (int i = 0; i < 35; i++) {
      Widget? gauge;
      if (i >= validBarsStart && i <= validBarsEnd) {
        // Valid range bars - highlighted
        gauge = Container(
          width: 3.sp,
          height: 24.sp,
          color: color,
        );
      } else {
        // Invalid range bars - dimmed
        gauge = Container(
          width: 3.sp,
          height: 20.sp,
          color: AppColorData.regular().colorBgInteractivePrimaryDisabled,
        );
      }

      gaugeList.add(gauge);
    }
    return gaugeList;
  }

  double calculateGaugePosition(BoxConstraints constraints, double speed, ExerciseType exerciseType) {
    try {
      // Get dynamic speed range from config
      final maxValidSpeed = UnifiedGPSConfig.maxValidSpeed;
      final minValidSpeed = UnifiedGPSConfig.getMinValidSpeed(exerciseType.name);
      
      // Safety check for config values
      if (maxValidSpeed <= 0 || minValidSpeed < 0 || minValidSpeed >= maxValidSpeed) {
        // Fallback to safe values
        return _calculateFallbackGaugePosition(constraints, speed, exerciseType);
      }
    
    double barWidth = 3.0;
    int totalBars = 35;
    int validBarsStart = 3; // 3rd bar (0-indexed, actually 4th bar)
    int validBarsEnd = 22; // 21st bar (0-indexed, actually 22nd bar)
    
    // Calculate space between bars
    double spaceLeft = constraints.maxWidth - (totalBars * barWidth);
    double spacesBetweenBars = spaceLeft / (totalBars - 1);

    // If speed exceeds max valid speed, show beyond valid range  
    if (speed >= maxValidSpeed) {
      // Calculate position beyond valid range up to gauge end
      double excessSpeed = speed - maxValidSpeed;
      double maxExcessSpeed = 50.0; // Max speed we want to display on gauge
      double excessRange = (totalBars - 1 - validBarsEnd).toDouble();
      
      if (excessSpeed >= maxExcessSpeed - maxValidSpeed) {
        // At absolute end of gauge
        return ((totalBars - 1) * (barWidth + spacesBetweenBars)) + (barWidth / 2);
      } else {
        // Proportional position beyond valid range
        double excessRatio = excessSpeed / (maxExcessSpeed - maxValidSpeed);
        int excessBarStep = (validBarsEnd + (excessRatio * excessRange)).round();
        return (excessBarStep * (barWidth + spacesBetweenBars)) + (barWidth / 2);
      }
    }
    
    // Clamp speed to valid range for normal calculation
    speed = speed.clamp(minValidSpeed, maxValidSpeed);

    // Map speed to valid bar range
    double validBarRange = (validBarsEnd - validBarsStart).toDouble();
    double validSpeedRange = maxValidSpeed - minValidSpeed;
    double normalizedSpeed = (speed - minValidSpeed) / validSpeedRange;
    int barStep = (validBarsStart + normalizedSpeed * validBarRange).round();

      // Calculate bar position
      double position = (barStep * (barWidth + spacesBetweenBars)) + (barWidth / 2);

      return position;
    } catch (e) {
      // Fallback calculation if config access fails
      return _calculateFallbackGaugePosition(constraints, speed, exerciseType);
    }
  }
  
  double _calculateFallbackGaugePosition(BoxConstraints constraints, double speed, ExerciseType exerciseType) {
    // Fallback calculation with hardcoded safe values
    double barWidth = 3.0;
    int totalBars = 35;
    int validBarsStart = 3;
    int validBarsEnd = 22;
    double maxValidSpeed = 14.0; // Safe fallback
    double minValidSpeed = exerciseType == ExerciseType.hiking ? 0.7 : 1.0; // Safe fallback
    
    double spaceLeft = constraints.maxWidth - (totalBars * barWidth);
    double spacesBetweenBars = spaceLeft / (totalBars - 1);
    
    // If speed exceeds max valid speed, show beyond valid range
    if (speed >= maxValidSpeed) {
      double excessSpeed = speed - maxValidSpeed;
      double maxExcessSpeed = 50.0;
      double excessRange = (totalBars - 1 - validBarsEnd).toDouble();
      
      if (excessSpeed >= maxExcessSpeed - maxValidSpeed) {
        return ((totalBars - 1) * (barWidth + spacesBetweenBars)) + (barWidth / 2);
      } else {
        double excessRatio = excessSpeed / (maxExcessSpeed - maxValidSpeed);
        int excessBarStep = (validBarsEnd + (excessRatio * excessRange)).round();
        return (excessBarStep * (barWidth + spacesBetweenBars)) + (barWidth / 2);
      }
    }
    
    speed = speed.clamp(minValidSpeed, maxValidSpeed);
    
    double validBarRange = (validBarsEnd - validBarsStart).toDouble();
    double validSpeedRange = maxValidSpeed - minValidSpeed;
    double normalizedSpeed = (speed - minValidSpeed) / validSpeedRange;
    int barStep = (validBarsStart + normalizedSpeed * validBarRange).round();
    
    return (barStep * (barWidth + spacesBetweenBars)) + (barWidth / 2);
  }

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.sp),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              height: 36.sp,
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
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                      return Container(
                                        width: (stat.currentStat > 20
                                            ? constraints.maxWidth /
                                                (100 / stat.currentStat)
                                            : stat.currentStat < 2
                                                ? 0
                                                : 40.sp),
                                        decoration: BoxDecoration(
                                          color: stat.currentStat <= 30
                                              ? AppColorData.regular()
                                                  .colorBgWarning
                                              : stat.type == 'STAMINA'
                                                  ? AppColorData.regular()
                                                      .colorPointYellowgreen
                                                  : AppColorData.regular()
                                                      .colorPointPurple,
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
                                  padding: EdgeInsets.only(
                                      left: 17.0.sp, right: 5.sp),
                                  child: iconStamina,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0.sp, right: 3.sp),
                                  child: iconShoes,
                                ),
                          Text(
                            stat.name,
                            style: AppTextStyleData.regular()
                                .koBodySemiboldMd
                                .copyWith(
                                    height: 1.1,
                                    color: stat.currentStat <= 30
                                        ? AppColorData.regular()
                                            .colorTextPrimary
                                        : AppColorData.regular()
                                            .colorTextInverse),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: Text(
                              stat.currentStat.toString(),
                              style: AppTextStyleData.regular()
                                  .enBodySemiboldMd
                                  .copyWith(
                                      height: 1.1,
                                      color: stat.currentStat <= 30
                                          ? AppColorData.regular()
                                              .colorTextPrimary
                                          : AppColorData.regular()
                                              .colorTextInverse),
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
                                      width: 1.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.sp),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 1),
                                        blurRadius: 0,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 17.sp,
                                    backgroundColor: AppColorData.regular()
                                        .colorPointYellowgreen,
                                    child: IconButton(
                                      icon: iconRepairPlus,
                                      splashRadius: 17.sp,
                                      onPressed: () => controller
                                              .loaderController.isLoading.value
                                          ? null
                                          : controller.onClickRepairStat(
                                              stat, context),
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: gaugeGrayColor,
                                    border: Border.all(
                                      width: 1.sp,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.sp),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 1),
                                        blurRadius: 0,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 17.sp,
                                    backgroundColor:
                                        AppColorData.regular().colorPointPurple,
                                    child: IconButton(
                                      icon: iconRepairPlus,
                                      splashRadius: 17.sp,
                                      onPressed: () => controller
                                              .loaderController.isLoading.value
                                          ? null
                                          : controller.onClickRepairStat(
                                              stat, context),
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
      ..scene(
              begin: const Duration(seconds: 0),
              duration: const Duration(seconds: 2))
          .tween('opacity', Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOut)
          .thenFor(duration: const Duration(seconds: 5))
          .thenTween('opacity', Tween<double>(begin: 1, end: 0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);

    return DefaultContainer(
      backgroundColor: AppColorData.regular().colorBgPrimary,
      onBackButtonTap: () {
        controller.initLuckAnimation();
        if (globalController.internetConnection.value) {
          Get.back();
        } else {
          Get.offNamed(Routes.home);
        }
      },
      trailingChild: Padding(
        padding: EdgeInsets.only(right: 5.0.sp),
        child: Obx(() {
          return controller.gpsAccuracySensitive.value > 30
              ? InkWell(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => showNotGpsSensor(),
                  child: iconGpsFail)
              : Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: StyledText(
                        'GPS',
                        fontSize: 14,
                        fontWeight: 500,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 2.sp,
                            height: 4.sp,
                            color: controller.gpsAccuracySensitive.value <= 30
                                ? AppColorData.regular().colorBgSuccess
                                : AppColorData.regular().colorBgTertiary,
                          ),
                          Container(
                            width: 2.sp,
                            height: 7.sp,
                            color: controller.gpsAccuracySensitive.value < 15
                                ? AppColorData.regular().colorBgSuccess
                                : AppColorData.regular().colorBgTertiary,
                          ),
                          Container(
                            width: 2.sp,
                            height: 10.sp,
                            color: controller.gpsAccuracySensitive.value < 5
                                ? AppColorData.regular().colorBgSuccess
                                : AppColorData.regular().colorBgTertiary,
                          )
                        ],
                      ),
                    )
                  ],
                );
        }),
      ),
      titleWidget: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 6.sp,
              height: 6.sp,
              margin: EdgeInsets.only(right: 8.sp),
              decoration: BoxDecoration(
                color: controller.exerciseSteps.value < 1
                    ? Colors.white
                    : controller.exerciseStateTextColor.value,
                borderRadius: BorderRadius.circular(6.sp),
              ),
            ),
            controller.exerciseSteps.value < 1
                ? StyledText(
                    'analyzing_exercise'.tr(),
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                  )
                : StyledText(
                    ((controller.selectedExerciseType.value ==
                                            ExerciseType.hiking
                                        ? controller.avgSpeed.value < 0.7
                                        : controller.avgSpeed.value < 1) ||
                                    controller.avgSpeed.value > 40) &&
                                controller.exerciseState.value ==
                                    ExerciseState.ongoing ||
                            controller.stoppedExercising.value
                        ? 'exercise_state_no_reward'
                            .tr(args: [controller.exerciseState.value.label])
                        : controller.exerciseState.value.label,
                    fontSize: 18,
                    lineHeight: 18,
                    fontWeight: 500,
                    color: controller.exerciseStateTextColor.value,
                  ),
          ],
        );
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Obx(
                () => Visibility.maintain(
                  visible: controller.selectedCourse.value != null,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 3.sp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColorData.regular().colorBgBlack,
                        borderRadius: BorderRadius.circular(50.sp),
                      ),
                      child: Text(
                        '${controller.selectedCourse.value?.firstName} | ${controller.selectedCourse.value?.secondName}',
                        // 'sapaesan_easytechfin_trail'.tr(),
                        style: AppTextStyleData.regular()
                            .koBodyMediumLg
                            .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                                height: 1.4),
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColorData.regular()
                                                      .colorBgTransparcy80,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    AppDoubleData.regular()
                                                        .numberRadius4,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.sp,
                                                    vertical: 4.sp,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      iconActivityLuck,
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0.sp,
                                                                right: 5.0.sp),
                                                        child: Text(
                                                          'lucky_effect'.tr(),
                                                          style: AppTextStyleData
                                                                  .regular()
                                                              .koBodyMediumMd
                                                              .copyWith(
                                                                color: AppColorData
                                                                        .regular()
                                                                    .colorPointPink,
                                                                height: 1.2,
                                                              ),
                                                        ),
                                                      ),
                                                      if (controller.userState
                                                              .value.exercise !=
                                                          null)
                                                        Text(
                                                          '+${controller.userState.value.exercise!.luckApplyRewardGo} GO',
                                                          style: AppTextStyleData
                                                                  .regular()
                                                              .koBodyMediumMd
                                                              .copyWith(
                                                                color: AppColorData
                                                                        .regular()
                                                                    .colorTextPrimary,
                                                              ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.sp),
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
                              Obx(
                                () => Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/common/ico_token_go.svg',
                                      width: 36.sp,
                                      height: 36.sp,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 14.0.sp),
                                      child: AnimatedFlipCounter(
                                        value: controller
                                                    .userState.value.exercise !=
                                                null
                                            ? controller.userState.value
                                                .exercise!.rewardGo!
                                            : 0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        fractionDigits: 2,
                                        thousandSeparator: ',',
                                        textStyle: AppTextStyleData.regular()
                                            .numHeadingSemibold3xl
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorTextPrimary,
                                              height: 1.1,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0.sp),
                                      child: Text(
                                        'GO',
                                        style: AppTextStyleData.regular()
                                            .enHeadingMediumXl
                                            .copyWith(
                                              color: AppColorData.regular()
                                                  .colorTextTertiary,
                                              height: 1.1,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                ],
              ),
              Padding(
                  padding:
                      EdgeInsets.only(left: 38.0.sp, right: 38.sp, top: 20.sp),
                  child: Container(
                    // width: double.infinity.sp,
                    width: 300,
                    padding: EdgeInsets.symmetric(
                        vertical: 12.sp, horizontal: 24.sp),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50.sp),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Obx(() {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...renderGauge(
                                    controller.selectedExerciseType.value,
                                    controller.exerciseStateGaugeColor.value),
                              ],
                            ),
                            Positioned(
                              top: -28.sp,
                              left: calculateGaugePosition(constraints, () {
                                // Try to get speed from ActivityGPSService first, fallback to realTimeSpeed
                                try {
                                  final activityGPS =
                                      Get.find<ActivityGPSService>();
                                  return activityGPS.currentSpeed.value;
                                } catch (e) {
                                  return controller.realTimeSpeed.value;
                                }
                              }(), controller.selectedExerciseType.value),
                              child: Obx(() {
                                // Get display speed with same fallback logic
                                double displaySpeed = 0.0;
                                try {
                                  final activityGPS =
                                      Get.find<ActivityGPSService>();
                                  displaySpeed = activityGPS.currentSpeed.value;
                                } catch (e) {
                                  displaySpeed = controller.realTimeSpeed.value;
                                }

                                return GaugeCursor(
                                  color:
                                      controller.exerciseStateGaugeColor.value,
                                  speed: displaySpeed,
                                );
                              }),
                            ),
                            Positioned(
                              bottom: -30.sp,
                              left: ((constraints.maxWidth / 35) * 8).sp,
                              child: Row(
                                children: [
                                  Text(
                                    () {
                                      try {
                                        return '${UnifiedGPSConfig.getMinValidSpeed(controller.selectedExerciseType.value.name).toInt()}-${UnifiedGPSConfig.maxValidSpeed.toInt()}km/h';
                                      } catch (e) {
                                        // Fallback display
                                        return controller.selectedExerciseType.value == ExerciseType.hiking ? '1-14km/h' : '1-14km/h';
                                      }
                                    }(),
                                    style: AppTextStyleData.regular()
                                        .enBodySemiboldMd
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorTextTertiary,
                                          fontSize: 14.sp,
                                          height: 14 / 12,
                                          fontWeight: FontWeight.w500,
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
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: 37.sp,
              right: 37.sp,
              top: 20.sp,
              bottom: 10.sp,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12.sp,
              horizontal: 24.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50.sp),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Obx(() {
                return Stack(clipBehavior: Clip.none, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SizedBox(
                                width: 28.sp,
                                height: 28.sp,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/activity/ico_time.svg',
                                          width: 21.sp,
                                          height: 24.5.sp)
                                    ])),
                            Padding(
                              padding: EdgeInsets.only(top: 0.sp),
                              child: Text(
                                formatSeconds(controller.exerciseTime.value),
                                style: AppTextStyleData.regular()
                                    .enBodyMediumLg
                                    .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary,
                                      height: 1.5,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SizedBox(
                                width: 28.sp,
                                height: 28.sp,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/activity/ico_distance.svg',
                                          width: 22.8.sp,
                                          height: 20.6.sp)
                                    ])),
                            Padding(
                              padding: EdgeInsets.only(top: 0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    // Use valid distance from GPS manager for accurate distance calculation
                                    double displayDistance = 0.0;
                                    try {
                                      // Get valid distance from UnifiedGPSManager
                                      displayDistance = GPS.validDistanceKm;
                                    } catch (e) {
                                      // Fallback to totalDistance if GPS manager not available
                                      displayDistance =
                                          controller.totalDistance.value;
                                    }

                                    return Text(
                                      '${formatDecimalPlaces(displayDistance, 2)}km',
                                      style: AppTextStyleData.regular()
                                          .enBodyMediumLg
                                          .copyWith(
                                            color: AppColorData.regular()
                                                .colorTextPrimary,
                                            height: 1.5,
                                          ),
                                    );
                                  }),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 1.0.sp, top: 2.sp),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: IconButton(
                                          icon: iconActivityInfo,
                                          splashRadius: 15.sp,
                                          padding: EdgeInsets.zero,
                                          onPressed: () => Get.dialog(
                                            barrierColor:
                                                Colors.black.withOpacity(.8),
                                            Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25.0.sp),
                                                child: Center(
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                          40.sp,
                                                                      left:
                                                                          20.sp,
                                                                      right:
                                                                          20.sp,
                                                                      bottom: 32
                                                                          .sp),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        popupBgColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            AppDoubleData.regular().numberRadius20),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'valid_distance_guide'
                                                                            .tr(),
                                                                        style: AppTextStyleData.regular()
                                                                            .koHeadingSemiboldSm
                                                                            .copyWith(
                                                                              color: AppColorData.regular().colorTextPrimary,
                                                                              height: 1.4,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 8.sp),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                            Text(
                                                              () {
                                                                try {
                                                                  return 'valid_distance_criteria'.tr(args: [
                                                                    GPS.getMinValidSpeed(controller.selectedExerciseType.value.name).toString(),
                                                                    GPS.maxValidSpeed.toString()
                                                                  ]);
                                                                } catch (e) {
                                                                  // Fallback with hardcoded values
                                                                  final minSpeed = controller.selectedExerciseType.value == ExerciseType.hiking ? '0.7' : '1';
                                                                  return 'valid_distance_criteria'.tr(args: [minSpeed, '14']);
                                                                }
                                                              }(),
                                                                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                                                                    color: AppColorData.regular().colorTextPrimary,
                                                                                    height: 1.4,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right:
                                                                      16.8.sp,
                                                                  top: 16.8.sp,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () =>
                                                                        Get.back(),
                                                                    child:
                                                                        iconCloseWhite,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SizedBox(
                                width: 28.sp,
                                height: 28.sp,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/activity/ico_step.svg',
                                        width: 21.4.sp,
                                        height: 23.7.sp),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 0.sp),
                              child: Text(
                                controller.exerciseSteps.value.toString(),
                                style: AppTextStyleData.regular()
                                    .enBodyMediumLg
                                    .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary,
                                      height: 1.5,
                                    ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ]);
              });
            }),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 18.4.sp,
              right: 13.6.sp,
            ),
            child: Obx(() {
              return Column(
                children: [
                  ...renderStatList(controller, context),
                ],
              );
            }),
          ),
          Visibility(
            visible: (controller.selectedExerciseType.value !=
                ExerciseType.treasureHunting),
            child: const Spacer(),
          ),
          Obx(() {
            return Column(
              children: [
                if (controller.userState.value.exercise != null &&
                    controller.userState.value.exercise!.crewBuffLevel! !=
                        'NONE')
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.sp,
                      bottom: 30.sp,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sp, horizontal: 14.sp),
                      decoration: BoxDecoration(
                        color: speedBlackColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: StyledText(
                        'crew_buff_applied'.tr(args: [
                          controller.userState.value.exercise!.crewBuffLevel!
                              .replaceAll('LEVEL_', 'Lv')
                        ]),
                        fontSize: 16,
                        fontWeight: 500,
                        lineHeight: 16,
                        color: lightGrayColor,
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 14),
          if (controller.selectedExerciseType.value ==
              ExerciseType.treasureHunting)
            const ActivityActiveMiniMapSection(),
          const SizedBox(height: 14),
          const ActivityActiveMainButtonSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class GaugeCursor extends StatelessWidget {
  final Color color;
  final double speed;

  const GaugeCursor({super.key, required this.color, required this.speed});

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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: color),
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
            child: Padding(
              padding: EdgeInsets.only(left: 1.0.sp),
              child: Row(
                children: [
                  Text(
                    formatDecimalPlaces(speed >= 0 ? speed : 0, 1),
                    style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                          color: color,
                          height: 1.1,
                          letterSpacing: -.1,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.sp),
                    child: Text(
                      'km/h',
                      style:
                          AppTextStyleData.regular().enBodySemiboldSm.copyWith(
                                color: color,
                                height: 1.2,
                                letterSpacing: -.1,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
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
