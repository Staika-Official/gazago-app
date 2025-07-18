import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class CrewInfo extends StatelessWidget {
  const CrewInfo({super.key});

  List<Widget> renderBuffStats(String buffLevel) {
    int level = int.parse(buffLevel.substring(buffLevel.length - 1));
    return [
      if (level > 2) ...[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
          child: SizedBox(
            width: 70,
            child: Column(
              children: [
                const StyledText(
                  '30',
                  fontSize: 24,
                  lineHeight: 26,
                  color: skyBlueColor,
                  fontWeight: 500,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconShopReward,
                      Padding(
                        padding: EdgeInsets.only(left: 4.0.sp),
                        child: StyledText(
                          'go_accumulation'.tr(),
                          color: skyBlueColor,
                          fontSize: 12,
                          lineHeight: 14,
                          fontWeight: 500,
                          letterSpacing: -.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      if (level > 1) ...[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
          child: SizedBox(
            width: 70,
            child: Column(
              children: [
                StyledText(
                  '30',
                  fontSize: 24,
                  lineHeight: 26,
                  fontWeight: 500,
                  color: AppColorData.regular().colorPointPurple,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      iconShopDurabilityLightPng,
                      Padding(
                        padding: EdgeInsets.only(left: 4.0.sp),
                        child: StyledText(
                          'durability_resistance'.tr(),
                          color: AppColorData.regular().colorPointPurple,
                          fontSize: 12,
                          lineHeight: 12,
                          letterSpacing: -.1,
                          fontWeight: 600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
          child: SizedBox(
            width: 70,
            child: Column(
              children: [
                const StyledText(
                  '30',
                  fontSize: 24,
                  lineHeight: 26,
                  fontWeight: 500,
                  color: lightGreenColor,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      iconShopStamina,
                      Padding(
                        padding: EdgeInsets.only(left: 4.0.sp),
                        child: StyledText(
                          'stamina_resistance'.tr(),
                          color: lightGreenColor,
                          fontSize: 12,
                          lineHeight: 12,
                          letterSpacing: -.1,
                          fontWeight: 600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
        child: SizedBox(
          width: 70,
          child: Column(
            children: [
              StyledText(
                '30',
                fontSize: 24,
                lineHeight: 26,
                fontWeight: 500,
                color: pinkColor,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconShopLuck,
                    Padding(
                      padding: EdgeInsets.only(left: 4.0.sp),
                      child: StyledText(
                        'luck'.tr(),
                        color: pinkColor,
                        fontSize: 12,
                        lineHeight: 12,
                        letterSpacing: -.1,
                        fontWeight: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> renderBlocksCollected(int count) {
    List<Widget> blocks = List.empty(growable: true);
    for (int i = 0; i < count; i++) {
      blocks.add(
        Flexible(
          fit: FlexFit.loose,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 13,
            ),
            child: Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: skyBlueColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      );
      if (i != count - 1) {
        blocks.add(
          const SizedBox(
            width: 2,
          ),
        );
      }
    }
    return blocks;
  }

  List<Widget> renderCrewList(CrewDetailController controller) {
    return controller.crewList.map((member) {
      return Container(
        color: subBg01Color,
        height: 64.sp,
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
                    SizedBox(
                      width: 52.0.sp,
                      height: 52.0.sp,
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 22.sp,
                              backgroundColor: deepGrayColor,
                              foregroundImage: (member.imageUrl == null ||
                                      member.imageUrl == '')
                                  ? Image.asset(
                                      'assets/images/ic_launcher.png',
                                      width: 30.sp,
                                    ).image
                                  : NetworkImage(
                                      member.imageUrl!,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.sp),
                        child: StyledText(
                          member.nickname!.split('@')[0],
                          fontWeight: 500,
                          fontSize: 20,
                          lineHeight: 20,
                          letterSpacing: 0,
                          overflowEllipsis: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StyledText(
              'blocks_and_invites'.tr(args: [
                member.blockQuantity.toString(),
                member.inviteCount.toString(),
              ]),
              fontSize: 12,
              fontWeight: 500,
              color: deepGrayColor,
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    CrewDetailController controller = Get.find<CrewDetailController>();

    return SingleChildScrollView(
      child: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 19),
                    child: Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 33.sp,
                            backgroundColor: deepGrayColor,
                            foregroundImage: (controller
                                            .selectedCrew.value.iconImageUrl ==
                                        null ||
                                    controller
                                            .selectedCrew.value.iconImageUrl ==
                                        '')
                                ? Image.asset(
                                    'assets/images/ic_launcher.png',
                                    width: 30.sp,
                                  ).image
                                : controller.selectedCrew.value.iconImageUrl!
                                        .contains('.svg')
                                    ? sp.Svg(
                                        controller
                                            .selectedCrew.value.iconImageUrl!,
                                        source: sp
                                            .SvgSource.network) as ImageProvider
                                    : CachedNetworkImageProvider(
                                        controller
                                            .selectedCrew.value.iconImageUrl!,
                                        headers: imageNetworkHeader,
                                      ),
                          ),
                        ),
                        if (controller.selectedCrew.value.crewBuffLevel !=
                            'NONE')
                          Center(
                            child: SizedBox(
                              width: 66.sp,
                              height: 66.sp,
                              child: Image.asset(
                                'assets/images/challenges/crewListBuff_${controller.selectedCrew.value.crewBuffLevel}.png',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  StyledText(
                    controller.selectedCrew.value.name!,
                    fontSize: 26,
                    lineHeight: 26,
                    fontWeight: 500,
                  ),
                  if (controller.selectedCrew.value.crewBuffLevel !=
                      'NONE') ...[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 28.sp, left: 20.sp, right: 20.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...renderBuffStats(
                              controller.selectedCrew.value.crewBuffLevel!),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18.sp),
                      padding: EdgeInsets.only(
                        top: 10.sp,
                        left: 14.sp,
                        right: 14.sp,
                        bottom: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: StyledText(
                        'crew_buff_level'.tr(args: [
                          controller.selectedCrew.value.crewBuffLevel!
                              .replaceAll('LEVEL_', 'Lv')
                        ]),
                        fontSize: 14,
                        fontWeight: 500,
                        lineHeight: 14,
                        color: lightGrayColor,
                      ),
                    )
                  ],
                  Container(
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.only(top: 25, left: 18.sp, right: 18.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StyledText(
                                  'crew_ranking_1'.tr(),
                                  fontSize: 14,
                                  fontWeight: 500,
                                  lineHeight: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: StyledText(
                                    'crew_rank_1'.tr(args: [
                                      controller.crewRanking.value.toString()
                                    ]),
                                    fontSize: 16,
                                    fontWeight: 500,
                                    lineHeight: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          width: .5,
                          child: VerticalDivider(
                            color: Colors.white.withOpacity(0.5),
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
                                  'total_crew_blocks'.tr(),
                                  fontSize: 14,
                                  fontWeight: 500,
                                  lineHeight: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: StyledText(
                                    'accumulated_crew_blocks'.tr(args: [
                                      controller.accumulatedCrewBlock.value
                                          .toString()
                                    ]),
                                    fontSize: 16,
                                    fontWeight: 500,
                                    lineHeight: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          width: .5,
                          child: VerticalDivider(
                            color: Colors.white.withOpacity(0.5),
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
                                  'invite_crew_members'.tr(),
                                  fontSize: 14,
                                  fontWeight: 500,
                                  lineHeight: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: StyledText(
                                    '${controller.accumulatedCrewInvite.value}',
                                    fontSize: 16,
                                    fontWeight: 500,
                                    lineHeight: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (controller.selectedCrew.value.crewRelayStatus! ==
                      'ONGOING')
                    Container(
                      margin: EdgeInsets.only(
                        top: 12,
                        left: 18.sp,
                        right: 18.sp,
                      ),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () => showCrewInviteInfoAlert(controller),
                        child: RichText(
                          text: TextSpan(
                            text: 'invite_crew_members_get_blocks'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'get_2_blocks'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 8,
                margin: const EdgeInsets.only(top: 24),
                color: const Color(0xff2E3038),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 23, left: 20.sp, right: 20.sp, bottom: 18.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          'todays_crew_blocks'.tr(),
                          fontSize: 14,
                          fontWeight: 500,
                          lineHeight: 22,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Ink(
                            width: 24,
                            height: 24,
                            child: InkWell(
                              onTap: () => controller.refreshController(),
                              borderRadius: BorderRadius.circular(24),
                              child: iconRefresh,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: StyledText(
                        'daily_block_count'.tr(args: [
                          controller.dailyBlockCount.value.toString()
                        ]),
                        fontSize: 26,
                        fontWeight: 500,
                        lineHeight: 26,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 18, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: skyBlueColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              ...renderBlocksCollected(
                                  controller.dailyBlockCount.value)
                            ],
                          );
                        },
                      ),
                    ),
                    if (controller.dailyBlockCount.value == 0)
                      StyledText(
                        'minimum_block_for_relay'.tr(),
                        fontSize: 14,
                        fontWeight: 600,
                        fontFamily: 'Monserrat',
                        lineHeight: 16,
                        color: skyBlueColor,
                      ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 8,
                color: const Color(0xff2E3038),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18.sp,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 9),
                  decoration: BoxDecoration(
                    color: popupBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: StyledText(
                            'walk_2km_daily'.tr(),
                            fontSize: 16,
                            fontWeight: 500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: iconStackedBlocks,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5, left: 18.sp, right: 18.sp, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledText(
                        'crew_members'.tr(),
                        fontSize: 18,
                        fontWeight: 500,
                        lineHeight: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      StyledText(
                        'crew_member_count_1'.tr(args: [
                          controller.selectedCrew.value.crewMemberList!.length
                              .toString()
                        ]),
                        fontSize: 18,
                        fontWeight: 500,
                        lineHeight: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
              ...renderCrewList(controller),
            ],
          );
        }),
      ),
    );
  }
}
