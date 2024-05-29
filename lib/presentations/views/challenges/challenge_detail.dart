import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/beta_tag.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/mini_bottom_sheet.dart';
import 'package:gaza_go/presentations/components/secondary_appbar.dart';
import 'package:gaza_go/presentations/components/share_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/challenges/challenge_info.dart';
import 'package:gaza_go/presentations/views/challenges/crew_leaderboard.dart';
import 'package:gaza_go/presentations/views/challenges/leaderboard.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:intrinsic_dimension/intrinsic_dimension.dart';
import 'package:skeletonizer/skeletonizer.dart';


import 'crew_list.dart';

class ChallengeDetail extends StatelessWidget {
  const ChallengeDetail({super.key});
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller = Get.put(ChallengesDetailController());

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: preferredSize, // here the desired height
            child: controller.challengeDetails.value.challengeType == 'CREW'
                ? const ShareAppbar(
                    isBeta: false,
                  )
                : const SecondaryAppbar(
                    isShowBackButton: true,
                    isShowPreferencesButton: false,
                  )),
        backgroundColor: AppColorData.regular().colorBgPrimary,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              if (controller.challengeDetails.value.title != null)
                IntrinsicDimension(
                  listener: (context, width, height, startOffset) {
                    controller.backgroundBoxSize.value = height + kTextTabBarHeight + 30;
                  },
                  builder: (_, __, ___, ____) {
                    return Container(
                      color: subBg01Color,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 220.sp,
                            child: Image.asset("assets/images/challenges/@temp_img_big.png", fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller.challengeDetails.value.subTitle != null || controller.challengeDetails.value.subTitle == '')
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.sp, bottom: 10.0.sp),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: StyledText(
                                            controller.challengeDetails.value.subTitle!,
                                            fontSize: 14,
                                            lineHeight: 16,
                                            fontWeight: 500,
                                            letterSpacing: -.1,
                                            color: lightGrayColor,
                                            maxLines: 1,
                                            overflowEllipsis: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0.sp, bottom: 10.0.sp),
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
                                    controller.challengeDetails.value.challengeType == 'CREW'
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 10.0.sp),
                                            child: const Column(
                                              children: [
                                                StyledText(
                                                  '2023/02/01 - 2023/02/01',
                                                  color: lightGrayColor,
                                                  fontWeight: 500,
                                                  fontSize: 12,
                                                  lineHeight: 14,
                                                  letterSpacing: -.1,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8.0),
                                                  child: StyledText(
                                                    '2023/02/01 - 2023/02/01',
                                                    color: lightGrayColor,
                                                    fontWeight: 500,
                                                    fontSize: 12,
                                                    lineHeight: 14,
                                                    letterSpacing: -.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const StyledText(
                                            '2023/02/01 - 2023/02/01',
                                            color: lightGrayColor,
                                            fontWeight: 500,
                                            fontSize: 12,
                                            lineHeight: 14,
                                            letterSpacing: -.1,
                                          ),
                                    const StyledText(
                                      ' · ',
                                      color: lightGrayColor,
                                      fontWeight: 500,
                                      fontSize: 12,
                                      lineHeight: 14,
                                      letterSpacing: -.1,
                                    ),
                                    const StyledText(
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
                                  padding: const EdgeInsets.only(top: 10.0),
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
                                            child: const StyledText(
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
                controller: controller.leaderboardScrollController,
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
                            decoration: const BoxDecoration(
                              color: subBg01Color,
                              border: Border(
                                top: BorderSide(
                                  // POINT
                                  color: Color(0xFF2E3038),
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  // POINT
                                  color: Color(0xFF2E3038),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: TabBar(
                              controller: controller.tabController,
                              padding: EdgeInsets.symmetric(horizontal: 6.sp),
                              indicator: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  color: skyBlueColor,
                                  width: 2,
                                )),
                              ),
                              indicatorPadding: EdgeInsets.zero,
                              dividerColor : Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
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
                                  text: controller.challengeDetails.value.challengeType == 'CREW'
                                      ? !controller.isAbleToJoinCrew.value && !controller.isAbleToJoinCrew.value
                                          ? '크루 랭킹'
                                          : '크루 탐색'
                                      : '리더보드',
                                ),
                              ],
                            ),
                          ),
                          background: Container(
                            // key: controller.backgroundKey,
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
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(20.0.sp),
                                        child: Skeletonizer(
                                          enabled: controller.challengeDetails.value.title == null,
                                          textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.2),
                                          effect:  ShimmerEffect(baseColor: Colors.white, highlightColor: AppColorData.regular().colorTextTertiary, duration: Duration(seconds:2)),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (controller.challengeDetails.value.subTitle != null || controller.challengeDetails.value.subTitle == '')
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 4.sp, bottom: 10.0.sp),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: StyledText(
                                                            controller.challengeDetails.value.subTitle!,
                                                            fontSize: 14,
                                                            lineHeight: 16,
                                                            fontWeight: 500,
                                                            letterSpacing: -.1,
                                                            color: lightGrayColor,
                                                            maxLines: 1,
                                                            overflowEllipsis: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (controller.challengeDetails.value.title != null)
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 10.0.sp),
                                                    child: RichText(
                                                      maxLines: 2,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: controller.challengeDetails.value.title!,
                                                            style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: -.1,
                                                              height: 25 / 20,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          if (controller.challengeDetails.value.challengeType == 'CREW')
                                                            const WidgetSpan(
                                                              child: BetaTag(),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                controller.challengeDetails.value.challengeType == 'CREW'
                                                    ? Padding(
                                                        padding: EdgeInsets.only(top: 10.0.sp),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(right: 20.0.sp),
                                                                  child: const StyledText(
                                                                    '개설 기간',
                                                                    fontSize: 14,
                                                                    fontWeight: 500,
                                                                    lineHeight: 14,
                                                                  ),
                                                                ),
                                                                StyledText(
                                                                  '${calculateDuration(controller.challengeDetails.value.reservedDate, controller.challengeDetails.value.fromDate)}일간',
                                                                  fontSize: 14,
                                                                  fontWeight: 500,
                                                                  lineHeight: 14,
                                                                  color: lightGrayColor,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 5.0.sp),
                                                                  child: StyledText(
                                                                    '${formatDateMonthUntilTime(controller.challengeDetails.value.reservedDate)} - ${formatDateMonthUntilTime(controller.challengeDetails.value.fromDate)}',
                                                                    color: deepGrayColor,
                                                                    fontWeight: 500,
                                                                    fontSize: 14,
                                                                    lineHeight: 14,
                                                                    letterSpacing: -.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 9.0.sp),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(right: 20.0.sp),
                                                                    child: const StyledText(
                                                                      '활동 기간',
                                                                      fontSize: 14,
                                                                      fontWeight: 500,
                                                                      lineHeight: 14,
                                                                    ),
                                                                  ),
                                                                  StyledText(
                                                                    '${calculateDuration(controller.challengeDetails.value.fromDate, controller.challengeDetails.value.toDate)}일간',
                                                                    fontSize: 14,
                                                                    fontWeight: 500,
                                                                    lineHeight: 14,
                                                                    color: lightGrayColor,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 5.0.sp),
                                                                    child: StyledText(
                                                                      '${formatDateMonthUntilTime(controller.challengeDetails.value.fromDate)} - ${formatDateMonthUntilTime(controller.challengeDetails.value.toDate)}',
                                                                      color: deepGrayColor,
                                                                      fontWeight: 500,
                                                                      fontSize: 14,
                                                                      lineHeight: 14,
                                                                      letterSpacing: -.1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          StyledText(
                                                            '${formatDateUntilTime(controller.challengeDetails.value.fromDate)} - ${formatDateUntilTime(controller.challengeDetails.value.toDate)}',
                                                            color: lightGrayColor,
                                                            fontWeight: 500,
                                                            fontSize: 12,
                                                            lineHeight: 14,
                                                            letterSpacing: -.1,
                                                          ),
                                                          const StyledText(
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
                                                          controller.challengeDetails.value.challengeType == 'CREW'
                                                              ? Padding(
                                                                  padding: EdgeInsets.only(left: 5.0.sp),
                                                                  child: const Row(
                                                                    children: [
                                                                      StyledText(
                                                                        '크루제한 20명',
                                                                        color: lightGrayColor,
                                                                        fontWeight: 500,
                                                                        fontSize: 12,
                                                                        lineHeight: 13,
                                                                        letterSpacing: -.1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets.only(left: 5.0.sp),
                                                                  child: Row(
                                                                    children: [
                                                                      controller.challengeDetails.value.challengeState == 'READY'
                                                                          ? const StyledText(
                                                                              '모집인원',
                                                                              color: lightGrayColor,
                                                                              fontWeight: 500,
                                                                              fontSize: 12,
                                                                              lineHeight: 13,
                                                                              letterSpacing: -.1,
                                                                            )
                                                                          : StyledText(
                                                                              '${formatDecimalPlaces((controller.challengeDetails.value.soldQuantity ?? 0).toDouble(), 0)}명',
                                                                              color: lightGrayColor,
                                                                              fontWeight: 500,
                                                                              fontSize: 12,
                                                                              lineHeight: 13,
                                                                              letterSpacing: -.1,
                                                                            ),
                                                                      StyledText(
                                                                        controller.challengeDetails.value.quantity! >= 0
                                                                            ? '${controller.challengeDetails.value.challengeState! == 'READY' ? '' : ' /'}  ${formatDecimalPlaces(controller.challengeDetails.value.quantity!.toDouble(), 0)}명'
                                                                            : controller.getUnlimitedParticipationStatus(controller.challengeDetails.value.challengeState!),
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
                  children: [
                    const ChallengeInfo(),
                    controller.challengeDetails.value.challengeType == 'CREW'
                        ? !controller.isAbleToJoinCrew.value && !controller.isAbleToJoinCrew.value
                            ? const CrewLeaderboard()
                            : const CrewList()
                        : const ChallengeLeaderboard(),
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
                if (controller.challengeDetails.value.challengeState != null && controller.challengeDetails.value.challengeType != 'CREW')
                  Positioned.fill(
                    top: null,
                    left: 0,
                    bottom: 0,
                    child: renderParticipateInChallenge(),
                  )
                else if (controller.challengeDetails.value.challengeState == 'CLOSED' && controller.challengeDetails.value.challengeType == 'CREW')
                  Positioned.fill(
                    top: null,
                    left: 0,
                    bottom: 0,
                    child: renderParticipateInChallenge(),
                  )
                else
                  Positioned.fill(
                    top: null,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      height: 150.sp,
                      padding: EdgeInsets.only(
                        top: 68.sp,
                        bottom: 27.sp,
                        left: 18.sp,
                        right: 18.sp,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.4],
                          colors: [
                            subBg01Color.withOpacity(0),
                            subBg01Color,
                            // Colors.red,
                            // Colors.blueAccent
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          if (controller.isAbleToCreateCrew.value) ...[
                            Expanded(
                              child: GazagoButton(
                                onTap: () => controller.showCreateCrewForm(),
                                buttonText: '크루 개설',
                                buttonColor: popupBgColor,
                                borderColor: skyBlueColor,
                                textColor: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10.sp,
                            ),
                          ],
                          controller.isAbleToJoinCrew.value
                              ? Expanded(
                                  child: GazagoButton(
                                    onTap: () => controller.exploreCrews(),
                                    buttonText: controller.isAbleToJoinCrew.value && !controller.isAbleToCreateCrew.value ? '크루 탐색하기' : '크루 탐색',
                                    buttonColor: controller.isAbleToCreateCrew.value ? skyBlueColor : popupBgColor,
                                    borderColor: controller.isAbleToCreateCrew.value ? Colors.black : skyBlueColor,
                                    textColor: controller.isAbleToCreateCrew.value ? Colors.black : Colors.white,
                                  ),
                                )
                              : (controller.myCrew.value != null)
                                  ? Expanded(
                                      child: GazagoButton(
                                        onTap: () => controller.moveToMyCrew(),
                                        buttonText: '나의 크루 보기',
                                      ),
                                    )
                                  : const SizedBox(),
                        ],
                      ),
                    ),
                  )
            ],
          );
        }),
      );
    });
  }
}
