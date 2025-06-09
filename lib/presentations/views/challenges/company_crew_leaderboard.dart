import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/flavors.dart';
import 'package:gaza_go/platform/controllers/company_crew_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class CompanyCrewLeaderboard extends StatelessWidget {
  const CompanyCrewLeaderboard({super.key});

  List<Widget> renderCrewLeaderboardList(CompanyCrewController controller) {
    final limitedList = controller.crewRankingList.take(10).toList();
    return limitedList.asMap().entries.map((item) {
      return CompanyCrewRankingItem(item.key, item.value);
    }).toList();
  }

  List<Widget> renderCrewManagerLeaderboardList(
      CompanyCrewController controller) {
    return controller.crewManagerList.asMap().entries.map((item) {
      return CompanyCrewRankingItem(item.key, item.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    CompanyCrewController controller = Get.isRegistered<CompanyCrewController>()
        ? Get.find<CompanyCrewController>()
        : Get.put(CompanyCrewController());

    return Obx(() {
      return Container(
        color: AppColorData.regular().colorBgPrimary,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 25.sp, left: 20.sp, right: 20.sp, bottom: 18.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText(
                      'realtime_top_10'.tr(),
                      color: Colors.white,
                      fontSize: 16,
                      lineHeight: 16,
                      fontWeight: 600,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.sp),
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.webView, arguments: {
                          'linkUrl':
                              '${F.leaderboardUrl}/company/challenge/${controller.challengeId}/${controller.userId}'
                        }),
                        child: Row(
                          children: [
                            StyledText(
                              'show_more'.tr(),
                              color: lightGrayColor,
                              fontSize: 14,
                              lineHeight: 16,
                              fontWeight: 600,
                              letterSpacing: -.1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.0.sp),
                              child: iconArrowRightTriangle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.crewManagerList.isNotEmpty)
                CompanyCrewRankingItem(
                  controller.crewManagerList[0]['rank'] - 1,
                  controller.crewManagerList[0],
                  isManager: true,
                  isMyCrew: controller.crewManagerList[0]['crewId'] ==
                      controller.myCrewId,
                ),
              if (controller.myCrewInfo.isNotEmpty &&
                  !controller.myCrewInfo['listFixed'])
                CompanyCrewRankingItem(
                    controller.myCrewInfo['rank'] - 1, controller.myCrewInfo,
                    isMyCrew: true),
              ...renderCrewLeaderboardList(controller),
            ],
          ),
        ),
      );
    });
  }
}

class CompanyCrewRankingItem extends StatelessWidget {
  final int index;
  final item;
  final bool isMyCrew;
  final bool isManager;

  const CompanyCrewRankingItem(
    this.index,
    this.item, {
    this.isMyCrew = false,
    this.isManager = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isMyCrew || isManager
              ? AppColorData.regular().colorBgSecondary
              : AppColorData.regular().colorBgPrimary,
          border: Border(
            bottom: BorderSide(
              color: isMyCrew || isManager
                  ? AppColorData.regular().colorBgPrimary
                  : AppColorData.regular().colorBgSecondary,
              width: 1,
            ),
          ),
        ),
        height: isMyCrew || isManager ? 92.sp : 64.sp,
        child: InkWell(
          // onTap: isMyCrew ? () => Get.find<ChallengesDetailController>().moveToMyCrew() : null,
          child: Padding(
            padding: EdgeInsets.only(left: 18.sp, right: 20.sp),
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
                        ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: 50, minWidth: 40),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                isMyCrew || isManager
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 5.0.sp),
                                        child: iconMyRankArrow,
                                      )
                                    : Container(),
                                StyledText(
                                  item['distance'] > 0
                                      ? (index + 1).toString()
                                      : '-',
                                  fontWeight: 600,
                                  fontSize: 16,
                                  color: isMyCrew || isManager
                                      ? AppColorData.regular().colorTextBrand
                                      : Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0.sp),
                          child: isMyCrew
                              ? Container(
                                  width: 50.sp,
                                  height: 50.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50.0.sp)),
                                    border: Border.all(
                                      color: skyBlueColor,
                                      width: 1.5.sp,
                                    ),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 20.sp,
                                      backgroundColor: Colors.black,
                                      foregroundImage: (item[
                                                      'crewIconImageUrl'] ==
                                                  null ||
                                              item['crewIconImageUrl'] == '')
                                          ? Image.asset(
                                              'assets/images/ic_launcher.png',
                                              width: 40.sp,
                                            ).image
                                          : item['crewIconImageUrl']
                                                  .contains('.svg')
                                              ? sp.Svg(item['crewIconImageUrl'],
                                                  source: sp.SvgSource
                                                      .network) as ImageProvider
                                              : CachedNetworkImageProvider(
                                                  item['crewIconImageUrl'],
                                                  headers: imageNetworkHeader,
                                                ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 20.sp,
                                  backgroundColor: Colors.black,
                                  foregroundImage: (item['crewIconImageUrl'] ==
                                              null ||
                                          item['crewIconImageUrl'] == '')
                                      ? Image.asset(
                                          'assets/images/ic_launcher.png',
                                          width: 40.sp,
                                        ).image
                                      : item['crewIconImageUrl']
                                              .contains('.svg')
                                          ? sp.Svg(item['crewIconImageUrl'],
                                                  source: sp.SvgSource.network)
                                              as ImageProvider
                                          : CachedNetworkImageProvider(
                                              item['crewIconImageUrl'],
                                              headers: imageNetworkHeader,
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
                                        item['crewName'],
                                        fontWeight: 500,
                                        fontSize: 16,
                                        lineHeight: 20,
                                        letterSpacing: 0,
                                        overflowEllipsis: true,
                                      ),
                                      if (isManager)
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 5.0.sp),
                                          child: iconChallengeManager,
                                        )
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
                    '${formatDecimalPlaces(item['distance'] / 1000, 3, isAutoDecimal: true)} km',
                    textAlign: TextAlign.right,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: 700,
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
