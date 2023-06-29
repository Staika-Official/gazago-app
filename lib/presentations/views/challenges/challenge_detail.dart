import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/challenges/challenge_info.dart';
import 'package:gaza_go/presentations/views/challenges/leaderboard.dart';
import 'package:get/get.dart';
import 'package:intrinsic_dimension/intrinsic_dimension.dart';
import 'package:skeletons/skeletons.dart';

import '../../components/mini_bottom_sheet.dart';

class ChallengeDetail extends StatelessWidget {
  const ChallengeDetail({Key? key}) : super(key: key);

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
        return Stack(
          children: [
            if (controller.challengeDetails.value.title != null)
              IntrinsicDimension(
                listener: (context, width, height, startOffset) {
                  print(height);
                  print(context.height);
                  print(width);
                  print(startOffset);

                  controller.backgroundBoxSize.value = height + kTextTabBarHeight + 26;
                },
                builder: (_, __, ___, ____) {
                  return Container(
                    color: subBg01Color,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 220.sp,
                          child: Image.asset("assets/images/challenges/@temp_img_big.png", fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15.0.sp, bottom: 10.0.sp),
                                child: Container(
                                  child: StyledText(
                                    controller.challengeDetails.value.title!,
                                    fontSize: 20,
                                    lineHeight: 25,
                                    fontWeight: 500,
                                    letterSpacing: -.1,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  StyledText(
                                    '2023/02/01 - 2023/02/01',
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
                                  StyledText(
                                    '오픈예정',
                                    color: lightGreenColor,
                                    fontWeight: 500,
                                    fontSize: 12,
                                    lineHeight: 14,
                                    letterSpacing: -.1,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
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
                                                fontWeight: 500,
                                                lineHeight: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    StyledText(
                                      ' · ',
                                      color: const Color(0xffd9d9d9),
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
                                          child: StyledText(
                                            '80명 / 100명',
                                            color: lightGrayColor,
                                            fontWeight: 500,
                                            fontSize: 12,
                                            lineHeight: 13,
                                            letterSpacing: -.1,
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
                      ],
                    ),
                  );
                },
              ),
            NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  Obx(() {
                    return SliverAppBar(
                      // onStretchTrigger: () => controller.getSize(),
                      // collapsedHeight: 0.0,
                      backgroundColor: subBg01Color,
                      titleSpacing: 0,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      floating: true,
                      pinned: true,
                      expandedHeight: controller.backgroundBoxSize.value,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        expandedTitleScale: 1,
                        titlePadding: EdgeInsets.zero,
                        title: Container(
                          decoration: BoxDecoration(
                            color: subBg01Color,
                            border: Border(
                              top: BorderSide(
                                // POINT
                                color: const Color(0xFF2E3038),
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                // POINT
                                color: const Color(0xFF2E3038),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: controller.tabController,
                            padding: EdgeInsets.symmetric(horizontal: 6.sp),
                            indicator: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                color: skyBlueColor,
                                width: 2,
                              )),
                            ),
                            indicatorPadding: EdgeInsets.only(left: 33.sp, right: 33.sp),
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFFA5A5A5),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              height: 20.sp / 16.sp,
                              letterSpacing: 0.5,
                            ),
                            tabs: [
                              Tab(
                                height: 50.sp,
                                text: '챌린지 안내',
                              ),
                              Tab(
                                height: 50.sp,
                                text: '리더보드',
                              ),
                            ],
                          ),
                        ),
                        background: Container(
                          key: controller.backgroundKey,
                          color: subBg01Color,
                          child: controller.backgroundBoxSize.value > 0
                              ? Column(
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
                                          // if (controller.challengeDetails.value.challengeActivationType != null)
                                          //   Positioned(
                                          //     top: 12.sp,
                                          //     left: 15.sp,
                                          //     child: Container(
                                          //       decoration: BoxDecoration(
                                          //         color: subBg01Color,
                                          //         borderRadius: BorderRadius.all(
                                          //           Radius.circular(6.sp),
                                          //         ),
                                          //       ),
                                          //       child: Padding(
                                          //         padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
                                          //         child: StyledText(
                                          //           controller.challengeDetails.value.challengeActivationType == 'ITEM' ? '아이템 장착형' : '참가비 납부형',
                                          //           fontWeight: 600,
                                          //           fontSize: 12,
                                          //           lineHeight: 14,
                                          //           letterSpacing: -.1,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      ),
                                    ),
                                    // CachedNetworkImage(
                                    //   imageUrl: controller.challengeDetails.value.imageUrl!,
                                    //   fit: BoxFit.cover,
                                    //   placeholder: (context, url) => const Center(child: SizedBox.square(dimension: 40, child: CircularProgressIndicator())),
                                    //   errorWidget: (context, url, error) => Image.asset("assets/images/challenges/@temp_img.png", fit: BoxFit.cover),
                                    // )
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
                                                  padding: EdgeInsets.only(top: 18.0),
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
                                                      StyledText(
                                                        ' · ',
                                                        color: const Color(0xffd9d9d9),
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
                                                                        '${formatDecimalPlaces(controller.challengeDetails.value.soldQuantity!.toDouble(), 0) ?? 0}명 /',
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
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                    );
                  })
                ];
              },
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.tabController,
                children: const [
                  ChallengeInfo(),
                  ChallengeLeaderboard(),
                ],
              ),
            ),
            if (controller.challengeTabIndex.value == 0)
              // if (controller.challengeDetails.value.challengeUserState != null)
              //   Positioned.fill(
              //     top: null,
              //     left: 0,
              //     bottom: 0,
              //     child: renderParticipateInChallenge(controller.challengeDetails.value.challengeUserState!),
              //   ),

              // Positioned.fill(
              //   top: null,
              //   left: 0,
              //   bottom: 0,
              //   child: renderParticipateInChallenge(controller.challengeDetails.value.challengeState!),
              // )
              if (controller.challengeDetails.value.challengeState != null)
                Positioned.fill(
                  top: null,
                  left: 0,
                  bottom: 0,
                  child: renderParticipateInChallenge(),
                )
          ],
        );
      }),
    );
  }
}
