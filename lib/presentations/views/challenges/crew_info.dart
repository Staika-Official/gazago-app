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
import 'package:get/get.dart';

class CrewInfo extends StatelessWidget {
  const CrewInfo({Key? key}) : super(key: key);

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
              margin: EdgeInsets.only(left: i != 0 ? 2 : 0),
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
                      child: Center(
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor: deepGrayColor,
                          foregroundImage: (member.imageUrl == null || member.imageUrl == '')
                              ? Image.asset(
                                  'assets/images/ic_launcher.png',
                                  width: 30.sp,
                                ).image
                              : NetworkImage(
                                  member.imageUrl!,
                                ),
                        ),
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
              '${member.blockQuantity} 블럭 | ${member.inviteCount} 초대',
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
                    padding: const EdgeInsets.only(top: 30, bottom: 14),
                    child: CircleAvatar(
                      radius: 22.sp,
                      backgroundColor: deepGrayColor,
                      foregroundImage: (controller.selectedCrew.value.iconImageUrl == null || controller.selectedCrew.value.iconImageUrl == '')
                          ? Image.asset(
                              'assets/images/ic_launcher.png',
                              width: 30.sp,
                            ).image
                          : controller.selectedCrew.value.iconImageUrl!.contains('.svg')
                              ? sp.Svg(controller.selectedCrew.value.iconImageUrl!, source: sp.SvgSource.network) as ImageProvider
                              : CachedNetworkImageProvider(
                                  controller.selectedCrew.value.iconImageUrl!,
                                  headers: imageNetworkHeader,
                                ),
                    ),
                  ),
                  StyledText(
                    '크루 명',
                    fontSize: 14,
                    fontWeight: 500,
                    lineHeight: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: StyledText(
                      controller.selectedCrew.value.name!,
                      fontSize: 26,
                      lineHeight: 26,
                      fontWeight: 500,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: popupBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.only(top: 37, left: 18.sp, right: 18.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const StyledText(
                                  '데일리 크루블럭',
                                  fontSize: 14,
                                  fontWeight: 500,
                                  lineHeight: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: StyledText(
                                    controller.dailyBlockCount.value == 0 ? '미완료' : '완료',
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
                                const StyledText(
                                  '크루초대',
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
                  Container(
                    margin: EdgeInsets.only(
                      top: 12,
                      left: 18.sp,
                      right: 18.sp,
                      bottom: 24,
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
                        text: const TextSpan(
                          text: '크루원 초대하고, ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '2블럭 받기',
                              style: TextStyle(fontWeight: FontWeight.w800),
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
                color: const Color(0xff2E3038),
              ),
              Padding(
                padding: EdgeInsets.only(top: 23, left: 20.sp, right: 20.sp, bottom: 32.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyledText(
                          '오늘 크루가 쌓은 블럭',
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
                        '${controller.dailyBlockCount.value}개',
                        fontSize: 26,
                        fontWeight: 500,
                        lineHeight: 26,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: StyledText(
                        '총 ${controller.accumulatedCrewBlock.value}개',
                        fontSize: 14,
                        fontWeight: 500,
                        lineHeight: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 7, bottom: 10),
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
                            children: [...renderBlocksCollected(controller.accumulatedCrewBlock.value)],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const StyledText(
                            '현재',
                            fontSize: 18,
                            fontWeight: 500,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${controller.crewRanking.value}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1,
                                color: Colors.white,
                              ),
                              children: const [
                                TextSpan(
                                  text: '등',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const StyledText(
                            '크루원 수',
                            fontSize: 18,
                            fontWeight: 500,
                          ),
                          RichText(
                            text: TextSpan(
                              text: controller.selectedCrew.value.crewMemberList!.length.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1,
                                color: Colors.white,
                              ),
                              children: const [
                                TextSpan(
                                  text: '명',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                      const Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: StyledText(
                            '하루에 2km씩 걷고 1블럭씩 채워보세요',
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
                  padding: EdgeInsets.only(top: 5, left: 18.sp, bottom: 10),
                  child: StyledText(
                    '크루원',
                    fontSize: 18,
                    fontWeight: 500,
                    lineHeight: 18,
                    color: Colors.white.withOpacity(0.8),
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
