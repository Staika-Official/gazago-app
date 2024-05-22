import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivitySelect extends StatelessWidget {
  const ActivitySelect({super.key});

  List<Widget> renderChallengeTypes(ActivityController controller) {
    return controller.challengeList
        .map(
          (challenge) => Padding(
            padding: EdgeInsets.only(top: 10.0.sp),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: double.infinity,
                minWidth: 280.sp,
                minHeight: 118.sp,
              ),
              child: Ink(
                width: 302.sp,
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
                    onTap: controller.doableCourses.isNotEmpty &&
                            controller.doableCourses.any((course) => course.challengeId == challenge.id) &&
                            DateTime.now().isAfter(DateTime.parse(challenge.fromDate))
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
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 22.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 9.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.sp),
                                      color: const Color(0xff0E2627),
                                    ),
                                    child: StyledText(
                                      challenge.challengeType == 'COURSE' ? '코스형 챌린지' : '챌린지',
                                      color: skyBlueColor,
                                      fontSize: 10,
                                      fontWeight: 600,
                                      lineHeight: 10,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: StyledText(
                                        challenge.simpleTitle,
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: 600,
                                        lineHeight: 19,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: StyledText(
                                      challenge.subTitle.replaceAll('\\n', '\n'),
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: 600,
                                      lineHeight: 11,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  if (challenge.limitedPeriod)
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
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Material(
      color: Colors.transparent,
      child: Obx(() {
        return Stack(
          children: [
            Align(
              // challengeList가 2개 이상이고, 미래에셋 광고 있을때 20.sp, 없을때 topCenter
              alignment: controller.challengeList.length > 1 && controller.promotionAdsList.isNotEmpty && controller.promotionAdsList[0].imageUrl != null ? Alignment.topCenter : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.sp),
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
                      height: 118.sp,
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
                        onTap: () => controller.selectExerciseType(ExerciseType.walking),
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
                      padding: EdgeInsets.only(top: 10.0.sp),
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
                    Obx(() {
                      return Material(
                        color: Colors.transparent,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                            maxHeight: 280,
                          ),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: controller.isFetchingCourseList.value
                                ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 50.0.sp),
                                    child: const Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator())),
                                  )
                                : controller.challengeList.isNotEmpty
                                    ? Column(
                                        children: [
                                          ...renderChallengeTypes(controller),
                                        ],
                                      )
                                    : Container(),
                          ),
                        ),
                      );
                    }),

                    SizedBox(
                      width: 302.sp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff28292F),
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
                                onTap: () => Get.toNamed(Routes.fairPlayView),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
                                  child: const StyledText(
                                    '경고 & 퇴장 카드 규정',
                                    color: lightGrayColor,
                                    fontSize: 14,
                                    fontWeight: 600,
                                    lineHeight: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.sp),
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
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.promotionAdsList.isNotEmpty && controller.promotionAdsList[0].subImageUrl != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 20.0.sp),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                      onTap: () => controller.moveToWebView(controller.promotionAdsList[0]),
                      child: CachedNetworkImage(
                        imageUrl: controller.promotionAdsList[0].subImageUrl!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                        httpHeaders: imageNetworkHeader,
                      )),
                ),
              ),
          ],
        );
      }),
    );
  }
}
