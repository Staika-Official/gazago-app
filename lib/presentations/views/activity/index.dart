import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class ActivityHome extends StatelessWidget {
  const ActivityHome({Key? key}) : super(key: key);

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
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0, 0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
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
                                                  color: stat.currentStat < 30 ? textRedColor : lightGreenColor,
                                                  border: Border.all(
                                                    width: 2.sp,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.5),
                                                      offset: const Offset(1, 0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
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
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(1, 0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
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
                                                  color: stat.currentStat <= 30 ? textRedColor : purpleColor,
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.5),
                                                      offset: const Offset(1, 0),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
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
                            color: stat.currentStat <= 30 ? Colors.white : Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.sp),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0.sp),
                                child: StyledText(
                                  formatDecimalPlaces(stat.currentStat, 2),
                                  fontWeight: 800,
                                  fontSize: 15,
                                  lineHeight: 15,
                                  color: stat.currentStat <= 30 ? Colors.white : Colors.black,
                                ),
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
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
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
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
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

    var challengeMovie = MovieTween()
      ..scene(begin: const Duration(seconds: 1), duration: const Duration(seconds: 2))
          .thenTween('width', Tween<double>(begin: 70.sp, end: 250.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('opacity', Tween<double>(begin: 0, end: 1), curve: Curves.easeOut)
          .thenFor(duration: const Duration(seconds: 3))
          .thenTween('opacity', Tween<double>(begin: 1, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .tween('width', Tween<double>(begin: 250.sp, end: 70.sp), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 0, end: 10.sp), duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
          .thenTween('bottom', Tween<double>(begin: 10.sp, end: 0), duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [-0.06, 1],
              colors: [
                mainBg01Color,
                mainBg02Color,
              ],
            ),
            image: const DecorationImage(
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
                          StyledText(
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
                            Center(
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
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Obx(() {
                                  return CustomAnimationBuilder<Movie>(
                                    control: controller.challengeLoadControl.value,
                                    tween: challengeMovie,
                                    duration: challengeMovie.duration,
                                    builder: (context, value, _) {
                                      return InkWell(
                                        onTap: () => Get.toNamed(Routes.dailyBenefits),
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
                                                    const Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          left: 20,
                                                        ),
                                                        child: StyledText(
                                                          'GO를 누르고 걷고,\n일일 혜택도 받아보세요',
                                                          fontSize: 16,
                                                          lineHeight: 20,
                                                          fontWeight: 600,
                                                          color: Colors.black,
                                                          softWrap: false,
                                                          overflowEllipsis: true,
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
                                    },
                                  );
                                })),
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
