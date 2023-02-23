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
              padding: EdgeInsets.only(bottom: 22.sp),
              child: Text(
                '어떤 활동을 하시나요?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 24.sp / 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.0.sp),
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
                          width: 153.sp,
                          height: 186.sp,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                        ),
                      ),
                      Container(
                        width: 153.sp,
                        height: 186.sp,
                        decoration: BoxDecoration(
                          color: skyBlueColor,
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
                          onTap: () => controller.selectExerciseType(ExerciseType.hiking),
                          borderRadius: BorderRadius.circular(14.sp),
                          child: Padding(
                            padding: EdgeInsets.only(top: 32.sp),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/activity/ico_hiking.svg',
                                  width: 74.sp,
                                  height: 74.sp,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 18.sp),
                                  child: Text(
                                    '등산',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22.sp,
                                      height: 22.sp / 28.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.sp),
                                  child: Text(
                                    '동네 산 올라가요!',
                                    style: TextStyle(
                                      color: Colors.black,
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
                            width: 153.sp,
                            height: 186.sp,
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
                          width: 153.sp,
                          height: 186.sp,
                          decoration: BoxDecoration(
                            color: Color(0xFF2EFF75),
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
                            onTap: () => controller.selectExerciseType(ExerciseType.walking),
                            borderRadius: BorderRadius.circular(14.sp),
                            child: Padding(
                              padding: EdgeInsets.only(top: 32.sp),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/activity/ico_walking.svg',
                                    width: 74.sp,
                                    height: 74.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 18.sp),
                                    child: Text(
                                      '걷기',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22.sp,
                                        height: 22.sp / 28.sp,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 6.sp),
                                    child: Text(
                                      '실외 YES 실내 NO',
                                      style: TextStyle(
                                        color: Colors.black,
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
              padding: EdgeInsets.only(top: 22.0.sp),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: 321.sp,
                    height: 141.sp,
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(14.sp),
                    ),
                    child: InkWell(
                      // onTap: () => controller.selectExerciseType(ExerciseType.famous),
                      onTap: controller.doableChallenges.isNotEmpty
                          ? () {
                              Get.back();
                              controller.moveToChallengeSelection();
                            }
                          : () {
                              Get.back();
                              controller.moveToChallengeMap();
                            },
                      borderRadius: BorderRadius.circular(14.sp),
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.sp),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.0.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: skyBlueColor,
                                      borderRadius: BorderRadius.circular(14.sp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 10.sp),
                                      child: const StyledText(
                                        '챌린지',
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                        fontWeight: 600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.sp),
                                    child: StyledText(
                                      '100대 명산 챌린지',
                                      fontSize: 22,
                                      fontWeight: 600,
                                      lineHeight: 22,
                                      color: skyBlueColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.sp),
                                    child: StyledText(
                                      '뱃지 획득에 도전해보세요!',
                                      fontWeight: 600,
                                      fontSize: 10,
                                      color: Colors.white.withOpacity(.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 2.sp,
                              bottom: -10.sp,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 1.0),
                                child: SvgPicture.asset(
                                  'assets/images/activity/ico_challange_mountain.svg',
                                  width: 88.sp,
                                  height: 88.sp,
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
            Padding(
              padding: EdgeInsets.only(top: 80.sp),
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(113.sp),
                child: Container(
                  width: 57.sp,
                  height: 57.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xff18191F),
                    border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.white),
                    borderRadius: BorderRadius.circular(113.sp),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/activity/ico_close_select.svg',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
