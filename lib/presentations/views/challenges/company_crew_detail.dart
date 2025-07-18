import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/platform/controllers/company_crew_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/share_appbar.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class CompanyCrewDetail extends StatelessWidget {
  const CompanyCrewDetail({super.key});

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  List<Widget> renderMyCrewLeaderboardList(CompanyCrewController controller) {
    return controller.myCrewList.asMap().entries.map((item) {
      return CompanyCrewRankingItem(item.key, item.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController challengesDetailController =
        Get.isRegistered<ChallengesDetailController>()
            ? Get.find<ChallengesDetailController>()
            : Get.put(ChallengesDetailController());
    CompanyCrewController controller = Get.isRegistered<CompanyCrewController>()
        ? Get.find<CompanyCrewController>()
        : Get.put(CompanyCrewController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: preferredSize, // here the desired height
          child: ShareAppbar(
            titleText: 'my_crew'.tr(),
            isBeta: false,
            isLockButton: false,
          )),
      backgroundColor: AppColorData.regular().colorBgPrimary,
      body: Obx(
        () {
          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0.sp),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.sp),
                            color: AppColorData.regular().colorBgPrimary,
                            border: Border.all(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                offset: Offset(0, 3),
                                blurRadius: 0,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: popupBgColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.sp),
                                      topRight: Radius.circular(15.sp)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 28.0.sp),
                                    child: Column(
                                      children: [
                                        StyledText(
                                          controller.myCrewInfo['crewName'],
                                          fontSize: 18,
                                          fontWeight: 500,
                                          lineHeight: 25,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 12.0.sp),
                                          child: CircleAvatar(
                                            radius: 34.sp,
                                            backgroundColor: Colors.transparent,
                                            foregroundImage: (controller
                                                                .myCrewInfo[
                                                            'crewIconImageUrl'] ==
                                                        null ||
                                                    controller.myCrewInfo[
                                                            'crewIconImageUrl'] ==
                                                        '')
                                                ? Image.asset(
                                                    'assets/images/ic_launcher.png',
                                                    width: 68.sp,
                                                  ).image
                                                : controller.myCrewInfo[
                                                            'crewIconImageUrl']
                                                        .contains('.svg')
                                                    ? sp.Svg(
                                                        controller.myCrewInfo[
                                                            'crewIconImageUrl'],
                                                        source: sp.SvgSource
                                                            .network) as ImageProvider
                                                    : CachedNetworkImageProvider(
                                                        controller.myCrewInfo[
                                                            'crewIconImageUrl'],
                                                        headers:
                                                            imageNetworkHeader,
                                                      ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColorData.regular().colorBgPrimary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.sp),
                                      bottomRight: Radius.circular(15.sp)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 21.0.sp,
                                            horizontal: 10.sp),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            StyledText(
                                              'cumulative_average_distance'
                                                  .tr(),
                                              fontSize: 14,
                                              fontWeight: 500,
                                              lineHeight: 14,
                                              letterSpacing: -.5,
                                            ),
                                            FittedBox(
                                              child: StyledText(
                                                '${formatDecimalPlaces(controller.myCrewInfo['distance'] / 1000, 3, isAutoDecimal: true)} km',
                                                fontSize: 24,
                                                fontWeight: 600,
                                                lineHeight: 33.6,
                                                letterSpacing: -.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 42.sp,
                                      width: 1,
                                      child: VerticalDivider(
                                        color: AppColorData.regular()
                                            .colorBorderSecondary,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            StyledText(
                                              'crew_ranking'.tr(),
                                              fontSize: 14,
                                              fontWeight: 500,
                                              lineHeight: 14,
                                              letterSpacing: -.5,
                                            ),
                                            StyledText(
                                              controller.myCrewInfo[
                                                          'distance'] >
                                                      0
                                                  ? 'crew_rank'.tr(args: [
                                                      controller
                                                          .myCrewInfo['rank']
                                                    ])
                                                  : '-',
                                              fontSize: 24,
                                              fontWeight: 600,
                                              lineHeight: 33.6,
                                              letterSpacing: -.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16.0.sp,
                              right: 16.sp,
                              top: 15.sp,
                              bottom: 8.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyledText(
                                'crew_members'.tr(),
                                fontSize: 16,
                                fontWeight: 500,
                                color:
                                    AppColorData.regular().colorTextSecondary,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 7.0.sp),
                                    child: iconPeople,
                                  ),
                                  StyledText(
                                    'crew_member_count'.tr(args: [
                                      controller.myCrewList.length.toString()
                                    ]),
                                    fontSize: 14,
                                    lineHeight: 16,
                                    fontWeight: 500,
                                    letterSpacing: -.5,
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0.sp),
                                    child: StyledText(
                                      '/',
                                      fontSize: 14,
                                      lineHeight: 16,
                                      fontWeight: 500,
                                      color: AppColorData.regular()
                                          .colorTextSecondary,
                                    ),
                                  ),
                                  StyledText(
                                    'max_crew_members'.tr(args: [
                                      controller.myCrewInfo['maxMemberCount']
                                          .toString()
                                    ]),
                                    fontSize: 14,
                                    lineHeight: 16,
                                    fontWeight: 500,
                                    letterSpacing: -.5,
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ...renderMyCrewLeaderboardList(controller),
                        // ...renderMyCrewLeaderboardList(controller),
                        // ...renderMyCrewLeaderboardList(controller),
                        // ...renderMyCrewLeaderboardList(controller),
                      ]),
                      if (controller.myCrewList.length < 2)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 42.0.sp, horizontal: 16.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              iconCompanyChallengeShare,
                              Padding(
                                padding: EdgeInsets.only(top: 42.0.sp),
                                child: StyledText(
                                  'share_my_crew'.tr(),
                                  fontWeight: 500,
                                  fontSize: 20,
                                  lineHeight: 28,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.sp),
                                child: StyledText(
                                  'walk_together_get_rewards'.tr(),
                                  fontWeight: 500,
                                  fontSize: 16,
                                  lineHeight: 22.4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 34.0.sp),
                                child: InkWell(
                                  onTap: () {
                                    challengesDetailController.shareChallenge(
                                        challengeType:
                                            ChallengeType.companyCrew,
                                        shareSource: ShareSource.shareAppbar);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StyledText(
                                        'share_link'.tr(),
                                        fontSize: 14,
                                        fontWeight: 500,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0.sp),
                                        child: iconArrowRightTriangle,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                top: null,
                left: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorData.regular().colorBgPrimary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16.0.sp,
                        top: 12.0.sp,
                        right: 12.0.sp,
                        bottom: 25.0.sp),
                    child: GazagoButton(
                      onTap: () {
                        Get.toNamed(Routes.webView, arguments: {
                          'linkUrl':
                              '${F.leaderboardUrl}/company/challenge/${controller.challengeId}/${controller.userId}'
                        });
                      },
                      buttonText: 'view_crew_ranking'.tr(),
                      buttonColor: skyBlueColor,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CompanyCrewRankingItem extends StatelessWidget {
  final int index;
  final item;

  const CompanyCrewRankingItem(
    this.index,
    this.item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: index == 0
              ? AppColorData.regular().colorBgSecondary
              : AppColorData.regular().colorBgPrimary,
          border: Border(
            bottom: BorderSide(
              color: index == 0
                  ? AppColorData.regular().colorBgPrimary
                  : AppColorData.regular().colorBgSecondary,
              width: 1,
            ),
          ),
        ),
        height: index == 0 ? 92.sp : 68.sp,
        child: InkWell(
          // onTap: isMyCrew ? () => Get.find<ChallengesDetailController>().moveToMyCrew() : null,
          child: Padding(
            padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.0.sp),
                          child: Container(
                            width: 50.sp,
                            height: 50.sp,
                            decoration: index == 0
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50.0.sp)),
                                    border: Border.all(
                                      color: skyBlueColor,
                                      width: 1.5.sp,
                                    ),
                                  )
                                : null,
                            child: Center(
                              child: CircleAvatar(
                                radius: 19.sp,
                                backgroundColor: Colors.black,
                                foregroundImage: (item['profileImageUrl'] ==
                                            null ||
                                        item['profileImageUrl'] == '')
                                    ? Image.asset(
                                        'assets/images/ic_launcher.png',
                                        width: 38.sp,
                                      ).image
                                    : item['profileImageUrl'].contains('.svg')
                                        ? sp.Svg(item['profileImageUrl'],
                                                source: sp.SvgSource.network)
                                            as ImageProvider
                                        : CachedNetworkImageProvider(
                                            item['profileImageUrl'],
                                            headers: imageNetworkHeader,
                                          ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      StyledText(
                                        item['nickname'],
                                        fontWeight: 500,
                                        fontSize: 16,
                                        lineHeight: 20,
                                        letterSpacing: -.5,
                                        overflowEllipsis: true,
                                      ),
                                    ],
                                  ),
                                ),
                                // StyledText(
                                //   'crew_leader_nickname'.tr('${item.crewFounderNickName!.split('@')[0]}'),
                                //   color: deepGrayColor,
                                //   fontWeight: 500,
                                //   fontSize: 12,
                                //   lineHeight: 16,
                                //   letterSpacing: 0,
                                //   overflowEllipsis: true,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: StyledText(
                    '${formatDecimalPlaces(double.parse(item['rewardDistance'].toString()) / 1000, 3, isAutoDecimal: true)} km',
                    textAlign: TextAlign.right,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: 600,
                    letterSpacing: -.5,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
