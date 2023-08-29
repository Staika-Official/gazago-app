import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/crew_detail_controller.dart';
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
    return controller.crewLeaderboardList.map((item) {
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
                          foregroundImage: (item.iconImageUrl == null || item.iconImageUrl == '')
                              ? Image.asset(
                                  'assets/images/ic_launcher.png',
                                  width: 30.sp,
                                ).image
                              : NetworkImage(
                                  item.iconImageUrl!,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.sp),
                        child: StyledText(
                          item.name!,
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
              '${item.blockQuantity} 블럭 | ${item.invitationCount} 초대',
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
    CrewDetailController controller = Get.put(CrewDetailController());

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 14),
                  child: CircleAvatar(
                    radius: 22.sp,
                    backgroundColor: deepGrayColor,
                    foregroundImage: (controller.selectedCrew.value!.iconImageUrl == null || controller.selectedCrew.value!.iconImageUrl == '')
                        ? Image.asset(
                            'assets/images/ic_launcher.png',
                            width: 30.sp,
                          ).image
                        : NetworkImage(
                            controller.selectedCrew.value!.iconImageUrl!,
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
                    controller.selectedCrew.value!.name!,
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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StyledText(
                                '데일리 크루블록',
                                fontSize: 14,
                                fontWeight: 500,
                                lineHeight: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: StyledText(
                                  '완료',
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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StyledText(
                                '크루초대',
                                fontSize: 14,
                                fontWeight: 500,
                                lineHeight: 14,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: StyledText(
                                  '0',
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
                    onPressed: () => null,
                    child: RichText(
                      text: const TextSpan(
                        text: '크루 초대하면 ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '2블럭추가!',
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
                  StyledText(
                    '오늘 크루가 쌓은 블럭',
                    fontSize: 14,
                    fontWeight: 500,
                    lineHeight: 22,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: StyledText(
                      '35개',
                      fontSize: 26,
                      fontWeight: 500,
                      lineHeight: 26,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StyledText(
                      '총 124개',
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
                          children: [...renderBlocksCollected(35)],
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
                          text: const TextSpan(
                            text: '3',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: Colors.white,
                            ),
                            children: [
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
                          text: const TextSpan(
                            text: '12',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: Colors.white,
                            ),
                            children: [
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
            ...renderCrewList(controller),
          ],
        ),
      ),
    );
  }
}
