import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

class ChallengeCourseDetail extends StatelessWidget {
  const ChallengeCourseDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.put(ChallengesDetailController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SecondaryAppbar(
        isShowBackButton: true,
        isShowPreferencesButton: false,
      ),
      backgroundColor: subBg01Color,
      body: Obx(() {
        return SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 220.sp,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (controller.challengeDetails.value.imageUrl != null)
                          controller.challengeDetails.value.imageUrl!.contains('.svg')
                              ? SvgPicture.network(
                                  fit: BoxFit.fill,
                                  controller.challengeDetails.value.imageUrl!,
                                  placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                  headers: imageNetworkHeader,
                                )
                              : CachedNetworkImage(
                                  imageUrl: controller.challengeDetails.value.imageUrl!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                  errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                  httpHeaders: imageNetworkHeader,
                                ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0.sp),
                    child: controller.challengeDetails.value.title == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 28,
                                  width: 88,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0.sp),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 20,
                                    minLength: MediaQuery.of(context).size.width / 2,
                                    maxLength: MediaQuery.of(context).size.width,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 14,
                                    minLength: MediaQuery.of(context).size.width / 4,
                                    maxLength: MediaQuery.of(context).size.width / 2,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0.sp),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                    height: 14,
                                    minLength: MediaQuery.of(context).size.width / 4,
                                    maxLength: MediaQuery.of(context).size.width / 2,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.challengeDetails.value.subTitle != null || controller.challengeDetails.value.subTitle == '')
                                Padding(
                                  padding: EdgeInsets.only(top: 4.sp, bottom: 10.0.sp),
                                  child: StyledText(
                                    controller.challengeDetails.value.subTitle!,
                                    fontSize: 14,
                                    lineHeight: 14,
                                    fontWeight: 500,
                                    letterSpacing: -.1,
                                    color: lightGrayColor,
                                  ),
                                ),
                              if (controller.challengeDetails.value.title != null)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0.sp),
                                  child: StyledText(
                                    controller.challengeDetails.value.title!,
                                    fontSize: 20,
                                    lineHeight: 25,
                                    fontWeight: 500,
                                    letterSpacing: -.1,
                                  ),
                                ),
                              Row(
                                children: [
                                  StyledText(
                                    '${formatDateUntilTime(controller.challengeDetails.value.fromDate)} - ${formatDateUntilTime(controller.challengeDetails.value.toDate)}',
                                    color: lightGrayColor,
                                    fontWeight: 500,
                                    fontSize: 12,
                                    lineHeight: 14,
                                    letterSpacing: -.1,
                                  ),
                                  StyledText(
                                    ' · ',
                                    color: lightGrayColor,
                                    fontWeight: 500,
                                    fontSize: 12,
                                    lineHeight: 14,
                                    letterSpacing: -.1,
                                  ),
                                  if (controller.challengeDetails.value.challengeState != null)
                                    StyledText(
                                      controller.getChallengeStatus(controller.challengeDetails.value.challengeState!),
                                      color: controller.challengeDetails.value.challengeState == 'READY'
                                          ? lightGreenColor
                                          : controller.challengeDetails.value.challengeState == 'IN_PROGRESS'
                                              ? skyBlueColor
                                              : lightGrayColor,
                                      fontWeight: 500,
                                      fontSize: 12,
                                      lineHeight: 14,
                                      letterSpacing: -.1,
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Row(
                                  children: [
                                    if (controller.challengeDetails.value.exerciseTypes != null)
                                      Row(
                                        children: [
                                          ...controller.challengeDetails.value.exerciseTypes!.map(
                                            (type) => Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 1.sp, color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.sp),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 8.sp),
                                                child: StyledText(
                                                  controller.getChallengeExerciseType(type),
                                                  color: subBg01Color,
                                                  fontSize: 10,
                                                  fontWeight: 600,
                                                  lineHeight: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    const StyledText(
                                      ' · ',
                                      color: Color(0xffd9d9d9),
                                      fontWeight: 500,
                                      fontSize: 16,
                                      lineHeight: 18,
                                      letterSpacing: -.1,
                                    ),
                                    Row(
                                      children: [
                                        iconPeople,
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0.sp),
                                          child: Row(
                                            children: [
                                              controller.challengeDetails.value.challengeState == 'READY'
                                                  ? StyledText(
                                                      '모집인원',
                                                      color: lightGrayColor,
                                                      fontWeight: 500,
                                                      fontSize: 12,
                                                      lineHeight: 13,
                                                      letterSpacing: -.1,
                                                    )
                                                  : StyledText(
                                                      '${formatDecimalPlaces((controller.challengeDetails.value.soldQuantity ?? 0).toDouble(), 0)}명 /',
                                                      color: lightGrayColor,
                                                      fontWeight: 500,
                                                      fontSize: 12,
                                                      lineHeight: 13,
                                                      letterSpacing: -.1,
                                                    ),
                                              StyledText(
                                                ' ${formatDecimalPlaces(controller.challengeDetails.value.quantity!.toDouble(), 0)}명',
                                                color: lightGrayColor,
                                                fontWeight: 500,
                                                fontSize: 12,
                                                lineHeight: 13,
                                                letterSpacing: -.1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  const Divider(
                    color: Color(0xFF2E3038),
                    height: 1,
                    thickness: 1,
                  ),
                  Container(
                    color: subBg01Color,
                    padding: EdgeInsets.only(bottom: 180.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 20.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (controller.challengeDetails.value.introduce != null)
                                Html(
                                  shrinkWrap: true,
                                  data: controller.challengeDetails.value.introduce!,
                                  style: {
                                    "*": Style(
                                      lineHeight: LineHeight.percent(130),
                                    ),
                                    "p": Style(
                                      margin: Margins.zero,
                                      color: Colors.white,
                                      lineHeight: LineHeight.percent(130),
                                    ),
                                  },
                                ),
                              if (controller.challengeDetails.value.badges != null && controller.challengeDetails.value.badges!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 45.0.sp),
                                      child: const StyledText(
                                        '챌린지 달성 뱃지',
                                        fontWeight: 500,
                                        fontSize: 18,
                                        lineHeight: 20,
                                        letterSpacing: -.1,
                                      ),
                                    ),
                                    ...controller.challengeDetails.value.badges!.map(
                                      (badge) => Padding(
                                        padding: EdgeInsets.only(top: 16.0.sp),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2E3038),
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF2E3038),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12.sp),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 11.sp, horizontal: 10.sp),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: subBg01Color,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(12.sp),
                                                    ),
                                                  ),
                                                  width: 107.sp,
                                                  height: 87.sp,
                                                  child: controller.challengeDetails.value.badge!.imageUrl != null
                                                      ? controller.challengeDetails.value.badge!.imageUrl!.contains('.svg')
                                                          ? SvgPicture.network(
                                                              fit: BoxFit.contain,
                                                              badge.imageUrl!,
                                                              placeholderBuilder: (BuildContext context) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                              headers: imageNetworkHeader,
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl: badge.imageUrl!,
                                                              fit: BoxFit.fitHeight,
                                                              placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                              errorWidget: (context, url, error) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                                              httpHeaders: imageNetworkHeader,
                                                            )
                                                      : const SizedBox(),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 17.0.sp),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      StyledText(
                                                        badge.name!,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: 500,
                                                        fontSize: 16,
                                                        lineHeight: 22,
                                                        letterSpacing: -.1,
                                                      ),
                                                      if (badge.description != null)
                                                        Padding(
                                                            padding: EdgeInsets.only(top: 9.0.sp),
                                                            child: StyledText(
                                                              badge.description!,
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: 600,
                                                              fontSize: 22,
                                                              lineHeight: 22,
                                                              letterSpacing: -.1,
                                                            )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0.sp),
                          child: const Divider(
                            color: Color(0xFF26272F),
                            height: 3,
                            thickness: 2,
                          ),
                        ),
                        if (controller.challengeDetails.value.description != null)
                          Padding(
                            padding: EdgeInsets.only(top: 30.0.sp, left: 20.sp, right: 20.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const StyledText(
                                  '이용안내',
                                  fontWeight: 500,
                                  fontSize: 18,
                                  lineHeight: 20,
                                  letterSpacing: -.1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 14.0),
                                  child: Html(
                                    shrinkWrap: true,
                                    data: controller.challengeDetails.value.description!,
                                    style: {
                                      "*": Style(
                                        lineHeight: LineHeight.percent(130),
                                      ),
                                      "p": Style(
                                        margin: Margins.zero,
                                        color: Colors.white,
                                        lineHeight: LineHeight.percent(130),
                                      ),
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!controller.hideCourses.value)
                    Container(
                      decoration: BoxDecoration(
                        color: popupBgColor,
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.sp),
                          topRight: Radius.circular(25.sp),
                        ),
                      ),
                      width: double.infinity,
                      // height: 50,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0.sp, vertical: 20.sp),
                            child: Flex(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: skyBlueColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                        height: 24.sp / 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${controller.challengeDetails.value.title}\n',
                                          style: TextStyle(
                                            color: lightGrayColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '코스를 미리 확인하세요',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0.sp),
                                  child: InkWell(
                                    onTap: () {
                                      Get.find<ActivityController>().moveToChallengeMap(controller.challengeDetails.value.id!);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: popupBgColor,
                                          border: Border.all(
                                            width: 2,
                                            style: BorderStyle.solid,
                                            color: skyBlueColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25.sp),
                                          ),
                                          boxShadow: [
                                            BoxShadow(offset: Offset(0.sp, 3.sp), color: Colors.black),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 13.0.sp, horizontal: 40.sp),
                                          child: StyledText(
                                            '코스 보기',
                                            fontWeight: 500,
                                            fontSize: 18,
                                            lineHeight: 18,
                                            letterSpacing: -.1,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: subBg01Color,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0.sp, bottom: Platform.isAndroid ? 10.0.sp : 24.sp),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                ShaderMask(
                                  shaderCallback: (size) => LinearGradient(
                                    colors: [const Color(0XFF0EE6F3), skyBlueColor],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(
                                    Rect.fromLTWH(0, 0, size.width, 16),
                                  ),
                                  child: const StyledText(
                                    '챌린지 기간',
                                    fontSize: 14,
                                    lineHeight: 20,
                                    fontWeight: 600,
                                  ),
                                ),
                                ShaderMask(
                                  blendMode: BlendMode.modulate,
                                  shaderCallback: (size) => LinearGradient(
                                    colors: [const Color(0XFF0EE6F3), skyBlueColor],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(
                                    Rect.fromLTWH(0, 0, size.width, 16),
                                  ),
                                  child: Text(
                                    '${formatDateUntilTime(controller.challengeDetails.value.fromDate)} - ${formatDateUntilTime(controller.challengeDetails.value.toDate)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      height: (20 / 14).sp,
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
