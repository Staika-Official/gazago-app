import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivitySelect extends StatelessWidget {
  const ActivitySelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 42.sp),
              child: Text(
                '어떤 활동을 하시나요?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  height: 24.sp / 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 1.sp,
                      top: 7.sp,
                      child: Container(
                        width: 155.sp,
                        height: 215.sp,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                      ),
                    ),
                    Container(
                      width: 155.sp,
                      height: 215.sp,
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.black,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.25),
                            offset: const Offset(0, 0),
                            blurRadius: 4.sp,
                            spreadRadius: 4.sp,
                          )
                        ],
                        borderRadius: BorderRadius.circular(14.sp),
                      ),
                      child: InkWell(
                        // onTap: () => controller.selectExerciseType(ExerciseType.famous),
                        onTap: controller.doableChallenges.isNotEmpty
                            ? () {
                                Get.back();
                                controller
                                    .moveToChallengeSelection('startFamousAd');
                              }
                            : () {
                                Get.back();
                                controller.moveToChallengeMap();
                              },
                        borderRadius: BorderRadius.circular(14.sp),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 32.sp, left: 10.sp, right: 10.sp),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/activity/ico_mountain_100.svg',
                                width: 88.sp,
                                height: 88.sp,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25.sp),
                                child: const FittedBox(
                                  alignment: Alignment.topCenter,
                                  child: StyledText(
                                    '100대 명산 챌린지',
                                    fontSize: 18,
                                    fontWeight: 600,
                                    lineHeight: 25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.sp),
                                child: StyledText(
                                  '뱃지 획득 가능',
                                  fontWeight: 600,
                                  fontSize: 12,
                                  color: Color(0xFFFFFFFF).withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.sp),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 1.sp,
                        top: 7.sp,
                        child: Container(
                          width: 155.sp,
                          height: 215.sp,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                        ),
                      ),
                      Container(
                        width: 155.sp,
                        height: 215.sp,
                        decoration: BoxDecoration(
                          color: popupBgColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 4,
                            )
                          ],
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                        child: InkWell(
                          onTap: () =>
                              controller.selectExerciseType(ExerciseType.dulle),
                          borderRadius: BorderRadius.circular(14.sp),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 32.sp, left: 10.sp, right: 10.sp),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/activity/ico_doole.svg',
                                  width: 88.sp,
                                  height: 88.sp,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 28.sp),
                                  child: const FittedBox(
                                    alignment: Alignment.topCenter,
                                    child: StyledText(
                                      '둘레길 챌린지',
                                      fontWeight: 600,
                                      fontSize: 18,
                                      lineHeight: 22,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12.sp),
                                  child: StyledText(
                                    '뱃지 획득 가능',
                                    fontWeight: 600,
                                    fontSize: 12,
                                    color: Color(0xFFFFFFFF).withOpacity(.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 1.sp,
                        top: 7.sp,
                        child: Container(
                          width: 155.sp,
                          height: 215.sp,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                        ),
                      ),
                      Container(
                        width: 155.sp,
                        height: 215.sp,
                        decoration: BoxDecoration(
                          color: popupBgColor,
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.black,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.25),
                              offset: const Offset(0, 0),
                              blurRadius: 4.sp,
                              spreadRadius: 4.sp,
                            )
                          ],
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                        // foregroundDecoration: BoxDecoration(
                        //   color: controller.doableChallenges.isNotEmpty ? Colors.transparent : const Color.fromRGBO(0, 0, 0, 0.6),
                        // ),
                        child: InkWell(
                          onTap: () => controller
                              .selectExerciseType(ExerciseType.hiking),
                          borderRadius: BorderRadius.circular(14.sp),
                          child: Padding(
                            padding: EdgeInsets.only(top: 32.sp),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/activity/ico_hiking.svg',
                                  width: 88.sp,
                                  height: 88.sp,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30.sp),
                                  child: Text(
                                    '등산',
                                    style: TextStyle(
                                      color: const Color(0xff54F5FF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28.sp,
                                      height: 16.sp / 28.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 14.sp),
                                  child: Text(
                                    '동네 산 올라가요!',
                                    style: TextStyle(
                                      color: const Color(0xff54F5FF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      height: 16.sp / 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.sp),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 1.sp,
                          top: 7.sp,
                          child: Container(
                            width: 155.sp,
                            height: 215.sp,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(14.sp),
                            ),
                          ),
                        ),
                        Container(
                          width: 155.sp,
                          height: 215.sp,
                          decoration: BoxDecoration(
                            color: popupBgColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                spreadRadius: 4,
                              )
                            ],
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          child: InkWell(
                            onTap: () => controller
                                .selectExerciseType(ExerciseType.walking),
                            borderRadius: BorderRadius.circular(14.sp),
                            child: Padding(
                              padding: EdgeInsets.only(top: 32.sp),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/activity/ico_walking.svg',
                                    width: 88.sp,
                                    height: 88.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.sp),
                                    child: Text(
                                      '걷기',
                                      style: TextStyle(
                                        color: const Color(0xff4FFF4B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28.sp,
                                        height: 16.sp / 28.sp,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 14.sp),
                                    child: Text(
                                      '실외 YES 실내 NO',
                                      style: TextStyle(
                                        color: const Color(0xff4FFF4B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        height: 16.sp / 12.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.sp),
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(113.sp),
                child: Container(
                  width: 57.sp,
                  height: 57.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xff18191F),
                    border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.white),
                    borderRadius: BorderRadius.circular(113.sp),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/activity/ico_close_select.svg',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
