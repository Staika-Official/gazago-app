import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivitySelect extends StatelessWidget {
  const ActivitySelect({Key? key}) : super(key: key);

  List<Widget> renderChallengeTypes(ActivityController controller) {
    return controller.challengeList.isNotEmpty
        ? controller.challengeList
            .map(
              (challenge) => Padding(
                padding: EdgeInsets.only(top: 16.0.sp),
                child: Ink(
                  width: 302.sp,
                  height: 121.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: popupBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Obx(() {
                    return InkWell(
                      onTap: controller.doableCourses.isNotEmpty && controller.doableCourses.any((course) => course.challengeId == challenge.id)
                          ? () {
                              Get.back();
                              controller.moveToCourseSelection(
                                course: controller.doableCourses.firstWhere((course) => course.challengeId == challenge.id),
                                challenge: challenge,
                              );
                            }
                          : () {
                              controller.moveToChallengeDetail(challenge, false);
                            },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(72),
                              child: challenge.thumbnailImageUrl.contains('.svg')
                                  ? SvgPicture.network(
                                      challenge.thumbnailImageUrl,
                                      fit: BoxFit.fitHeight,
                                      width: 72.sp,
                                      height: 72.sp,
                                      placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                                      headers: imageNetworkHeader,
                                    )
                                  : CachedNetworkImage(
                                      fit: BoxFit.fitHeight,
                                      width: 72.sp,
                                      height: 72.sp,
                                      imageUrl: challenge.thumbnailImageUrl,
                                      placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                                      httpHeaders: imageNetworkHeader,
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 22.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.sp),
                                      color: const Color(0xff0E2627),
                                    ),
                                    child: StyledText(
                                      challenge.challengeType == 'COURSE' ? '코스형 챌린지' : '챌린지',
                                      color: const Color(0xff0EE6F3),
                                      fontSize: 10,
                                      fontWeight: 600,
                                      lineHeight: 10,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9),
                                    child: StyledText(
                                      challenge.simpleTitle,
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: 600,
                                      lineHeight: 19,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: StyledText(
                                      challenge.subTitle,
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: 600,
                                      lineHeight: 11,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13),
                                    child: StyledText(
                                      '${formatDateUntilDay(challenge.fromDate)} ~ ${formatDateUntilDay(challenge.toDate)}',
                                      color: deepGrayColor,
                                      fontSize: 10,
                                      fontWeight: 500,
                                      lineHeight: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
            .toList()
        : [];
  }

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
                '어떤 운동을 할까요?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 24.sp / 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Ink(
              width: 302.sp,
              height: 121.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xff2EFF75),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: InkWell(
                onTap: () => !controller.isButtonDisabled.value ? controller.selectExerciseType(ExerciseType.walking) : null,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 24.sp),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(74),
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_activity_type_walking.svg',
                          width: 74.sp,
                          height: 74.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 9.sp, vertical: 4.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.sp),
                                color: const Color(0xff0E2627),
                              ),
                              child: const StyledText(
                                '일반',
                                color: Color(0xff2EFF75),
                                fontSize: 10,
                                fontWeight: 600,
                                lineHeight: 10,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 9),
                              child: StyledText(
                                '걷기',
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: 600,
                                lineHeight: 19,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: StyledText(
                                '오늘도 건강하게 걸어보자고!',
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: 600,
                                lineHeight: 11,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.0.sp),
              child: const Divider(
                color: Color(0xff363841),
                thickness: 2,
                indent: 80,
                endIndent: 80,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 16.0.sp),
            //   child: Ink(
            //     width: 302.sp,
            //     height: 121.sp,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(14),
            //       color: popupBgColor,
            //       boxShadow: const [
            //         BoxShadow(
            //           color: Color.fromRGBO(0, 0, 0, 0.25),
            //           offset: Offset(0, 0),
            //           blurRadius: 4,
            //           spreadRadius: 4,
            //         )
            //       ],
            //     ),
            //     child: InkWell(
            //       onTap: controller.doableChallenge.value != null
            //           ? () {
            //               Get.back();
            //               controller.moveToChallengeSelection();
            //             }
            //           : () {
            //               showNotChallangeAbleAlert(controller);
            //             },
            //       borderRadius: BorderRadius.circular(14),
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 26.sp, vertical: 24.sp),
            //         child: Row(
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(70),
            //               child: SvgPicture.asset(
            //                 'assets/images/activity/ico_activity_type_mountains.svg',
            //                 width: 70.sp,
            //                 height: 70.sp,
            //               ),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.only(left: 22.sp),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Container(
            //                     padding: EdgeInsets.symmetric(horizontal: 9.sp, vertical: 4.sp),
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(9.sp),
            //                       color: const Color(0xff0E2627),
            //                     ),
            //                     child: const StyledText(
            //                       '코스형 챌린지',
            //                       color: Color(0xff0EE6F3),
            //                       fontSize: 10,
            //                       fontWeight: 600,
            //                       lineHeight: 10,
            //                     ),
            //                   ),
            //                   const Padding(
            //                     padding: EdgeInsets.only(top: 9),
            //                     child: StyledText(
            //                       '100대 명산 챌린지',
            //                       color: Colors.white,
            //                       fontSize: 19,
            //                       fontWeight: 600,
            //                       lineHeight: 19,
            //                       letterSpacing: -0.3,
            //                     ),
            //                   ),
            //                   const Padding(
            //                     padding: EdgeInsets.only(top: 10),
            //                     child: StyledText(
            //                       '기념 뱃지 획득 도전!',
            //                       color: Colors.white,
            //                       fontSize: 11,
            //                       fontWeight: 600,
            //                       lineHeight: 11,
            //                       letterSpacing: 0.3,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            ...renderChallengeTypes(controller),
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
