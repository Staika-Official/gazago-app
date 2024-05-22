import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/daily_benefit_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ActivityHome extends StatelessWidget {
  const ActivityHome({super.key});

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.0.sp,
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
              height: 42.sp,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: stat.type == 'STAMINA'
                              ? SizedBox(
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
                                            Radius.circular(100.sp),
                                          ),

                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? LayoutBuilder(builder: (context, constraints) {
                                              return Container(
                                                width: stat.currentStat > 20
                                                    ? constraints.maxWidth / (100 / stat.currentStat)
                                                    : stat.currentStat < 2
                                                        ? 0
                                                        : 34,
                                                decoration: BoxDecoration(
                                                  color: stat.currentStat <= 30 ? AppColorData.regular().colorBgWarning : AppColorData.regular().colorPointYellowgreen,
                                                  border: Border.all(
                                                    width: 2.sp,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.black.withOpacity(0.5),
                                                  //     offset: const Offset(1, 0),
                                                  //     blurRadius: 0.0,
                                                  //     spreadRadius: 0.0,
                                                  //   ),
                                                  // ],

                                                ),
                                              );
                                            })
                                          : Container(),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: gaugeGrayColor,
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(42.sp),
                                          ),
                                          // boxShadow: const [
                                          //   BoxShadow(
                                          //     color: Colors.black,
                                          //     offset: Offset(1, 0),
                                          //     blurRadius: 0.0,
                                          //     spreadRadius: 0.0,
                                          //   ),
                                          // ],

                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? LayoutBuilder(builder: (context, constraints) {
                                              return Container(
                                                width: stat.currentStat > 20
                                                    ? constraints.maxWidth / (100 / stat.currentStat)
                                                    : stat.currentStat < 2
                                                        ? 0
                                                        : 34,
                                                decoration: BoxDecoration(
                                                  color: stat.currentStat <= 30 ? AppColorData.regular().colorBgWarning : AppColorData.regular().colorPointPurple,
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.black.withOpacity(0.5),
                                                  //     offset: const Offset(1, 0),
                                                  //     blurRadius: 4.0,
                                                  //     spreadRadius: 0.0,
                                                  //   ),
                                                  // ],
                                                ),
                                              );
                                            })
                                          : Container(),
                                    ],
                                  ),
                                ),
                        ),
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
                                  padding: EdgeInsets.only(left: 17.0.sp, right: 5.sp),
                                  child: iconStamina,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 15.0.sp, right: 3.sp),
                                  child: iconShoes,
                                ),
                          Text(
                            stat.name,
                            style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                                height: 1,
                                color: stat.currentStat <= 30 ? AppColorData.regular().colorTextPrimary : AppColorData.regular().colorTextInverse
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0.sp),
                            child: Text(
                              formatDecimalPlaces(stat.currentStat, 2),
                              style: AppTextStyleData.regular().enBodySemiboldMd.copyWith(
                                  height: 1,
                                  color: stat.currentStat <= 30 ? AppColorData.regular().colorTextPrimary : AppColorData.regular().colorTextInverse
                              ),
                            ),
                          )
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
                                    radius: 18.sp,
                                    backgroundColor:  AppColorData.regular().colorPointYellowgreen,
                                    child: IconButton(
                                      icon: iconRepairPlus,
                                      onPressed: () => {controller.onClickRepairStat(stat, context)},
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
                                        offset: Offset(0, 1),
                                        blurRadius: 0,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 18.sp,
                                    backgroundColor: AppColorData.regular().colorPointPurple,
                                    child: IconButton(
                                      icon: iconRepairPlus,
                                      onPressed: () => {controller.onClickRepairStat(stat, context)},
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
    ActivityController controller = Get.find();
    DailyBenefitController dailyBenefitController = Get.isRegistered<DailyBenefitController>() ? Get.find<DailyBenefitController>() : Get.put(DailyBenefitController());
    var challengeMovie = MovieTween()
      ..scene(begin: const Duration(seconds: 1), duration: const Duration(seconds: 2))
          .thenTween('width', Tween<double>(begin: 70.sp, end: 250.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('opacity', Tween<double>(begin: 0, end: 1), curve: Curves.easeOut)
          .thenFor(duration: const Duration(seconds: 5))
          .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('width', Tween<double>(begin: 250.sp, end: 70.sp), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 0, end: 10.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 10.sp, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [-0.06, 1],
              colors: [
                mainBg01Color,
                mainBg02Color,
              ],
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_activity_road.png'),
              alignment: Alignment(100, 1.5),
            ),
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 15.sp),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StyledText(
                            '가자고와 함께 \n등산하고 뱃지를 받아보자고-!',
                            color: skyBlueColor,
                            fontWeight: 700,
                            fontSize: 24,
                            lineHeight: 32,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(25)),
                            decoration: BoxDecoration(
                              color: skyBlueColor,
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  spreadRadius: 0,
                                  blurRadius: 0,
                                  offset: Offset(0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15), horizontal: ScreenUtil().setHeight(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  iconActivityTokenGo,
                                  Padding(
                                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const StyledText(
                                          'Today',
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontWeight: 500,
                                          fontSize: 13,
                                          lineHeight: 15,
                                        ),
                                        Obx(() {
                                          return Row(
                                            children: [
                                              StyledText(
                                                controller.userState.value.state != null ? formatDecimalPlaces(controller.userState.value.state!.dailyGoReward!, 2) : formatDecimalPlaces(0, 2),
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                                fontWeight: 600,
                                                fontSize: 30,
                                                lineHeight: 34,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 2.0.sp, right: 5.0.sp),
                                                child: const StyledText(
                                                  'GO',
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: 500,
                                                  fontSize: 18,
                                                  lineHeight: 26,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        return Column(
                          children: [
                            ...renderStatList(controller, context),
                          ],
                        );
                      }),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Center(
                                child: Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: skyBlueColor,
                                          border: Border.all(width: 10.sp, color: const Color(0xFF4A4D57)),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(150),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(2, 4),
                                              blurRadius: 0.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3.sp,
                                              color: Colors.black,
                                            ),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(150),
                                            ),
                                          ),
                                          child: MaterialButton(
                                            onPressed: controller.disableActivityButton.value
                                                ? null
                                                : [ExerciseState.ongoing, ExerciseState.paused, ExerciseState.ready].any((state) => controller.exerciseState.value == state)
                                                    ? () => controller.requestExerciseInitialization()
                                                    : () => showToastPopup('지속적으로 문제가 발생한다면 앱을 재시작해주세요'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(150),
                                            ),
                                            color: skyBlueColor,
                                            height: 150.sp,
                                            minWidth: 150.sp,
                                            child: controller.disableActivityButton.value
                                                ? StyledText(
                                                    'Loading..',
                                                    fontWeight: 800,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 23.sp,
                                                    lineHeight: 23.sp,
                                                    color: Colors.black,
                                                    letterSpacing: 0.5,
                                                  )
                                                : StyledText(
                                                    [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 'Continue' : 'GO',
                                                    fontWeight: 800,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 23.sp : 50.sp,
                                                    lineHeight: [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 23.sp : 50.sp,
                                                    color: Colors.black,
                                                    letterSpacing: 0.5,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            Obx(() {
                              if (dailyBenefitController.dailyBenefitList.value != null) {
                                return Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CustomAnimationBuilder<Movie>(
                                    control: controller.challengeLoadControl.value,
                                    tween: challengeMovie,
                                    duration: challengeMovie.duration,
                                    builder: (context, value, _) {
                                      return Obx(() {
                                        return InkWell(
                                          onTap: () async {
                                            await dailyBenefitController.refreshController();
                                            Adjust.trackEvent(AdjustEvent('h199wc'));
                                            Get.toNamed(Routes.dailyBenefits);
                                          },
                                          child: Container(
                                            width: value.get('width'),
                                            height: 70.sp,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 2),
                                              borderRadius: BorderRadius.circular(40.sp),
                                              color: skyBlueColor,
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              fit: StackFit.expand,
                                              children: [
                                                Opacity(
                                                  opacity: value.get('opacity'),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      // InkWell(
                                                      //   onTap: () {
                                                      //     controller.challengeLoadControl.value = Control.stop;
                                                      //     challengeMovie = MovieTween()
                                                      //       ..scene(begin: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 200))
                                                      //           .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
                                                      //           .tween('width', Tween<double>(begin: 250.sp, end: 70.sp), curve: Curves.easeOut)
                                                      //           .thenTween('bottom', Tween<double>(begin: 0, end: 10.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
                                                      //           .thenTween('bottom', Tween<double>(begin: 10.sp, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                                                      //   },
                                                      //   child: Padding(
                                                      //     padding: const EdgeInsets.only(
                                                      //       left: 20,
                                                      //       top: 16,
                                                      //     ),
                                                      //     child: iconCloseChallenge,
                                                      //   ),
                                                      // ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                            left: 20,
                                                            right: 70,
                                                          ),
                                                          child: StyledText(
                                                            dailyBenefitController.dailyBenefitList.value != null
                                                                ? dailyBenefitController.dailyBenefitList.value!.label.replaceAll('과 ', '과\n')
                                                                : 'GO를 누르고 걷고,\n일일 혜택도 받아보세요',
                                                            fontSize: 17,
                                                            lineHeight: 20,
                                                            fontWeight: 600,
                                                            color: Colors.black,
                                                            softWrap: true,
                                                            overflowEllipsis: false,
                                                            letterSpacing: -0.2,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 5,
                                                  right: 8,
                                                  child: iconPresentBox,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
