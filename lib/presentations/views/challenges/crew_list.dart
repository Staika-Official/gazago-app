import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/challenges_detail_controller.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class CrewList extends StatelessWidget {
  const CrewList({super.key});

  List<Widget> renderCrewList(ChallengesDetailController controller) {
    return controller.crewList.asMap().entries.map((item) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          color: subBg01Color,
          height: 64.sp,
          child: InkWell(
            onTap: () => controller.handleCrewJoin(item.value),
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
                          (item.value.iconImageUrl != null)
                              ? SizedBox(
                                  width: 44.0.sp,
                                  height: 44.0.sp,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          radius: 22.sp,
                                          backgroundColor: deepGrayColor,
                                          foregroundImage: (item
                                                          .value.iconImageUrl ==
                                                      null ||
                                                  item.value.iconImageUrl == '')
                                              ? Image.asset(
                                                  'assets/images/ic_launcher.png',
                                                ).image
                                              : item.value.iconImageUrl!
                                                      .contains('.svg')
                                                  ? sp
                                                          .Svg(
                                                              item.value
                                                                  .iconImageUrl!,
                                                              source: sp
                                                                  .SvgSource
                                                                  .network)
                                                      as ImageProvider
                                                  : CachedNetworkImageProvider(
                                                      item.value.iconImageUrl!,
                                                      headers:
                                                          imageNetworkHeader,
                                                    ),
                                        ),
                                      ),
                                      if (item.value.crewBuffLevel != 'NONE')
                                        Center(
                                          child: SizedBox(
                                            width: 44.sp,
                                            height: 44.sp,
                                            child: Image.asset(
                                              'assets/images/challenges/crewListBuff_${item.value.crewBuffLevel}.png',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 22.sp,
                                  backgroundColor: Colors.white,
                                ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (item.value.crewRecruitStatus ==
                                          'CLOSE')
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.sp),
                                          child: iconCircleLock,
                                        ),
                                      StyledText(
                                        item.value.name!,
                                        fontWeight: 500,
                                        fontSize: 16,
                                        lineHeight: 20,
                                        letterSpacing: 0,
                                        overflowEllipsis: true,
                                      ),
                                    ],
                                  ),
                                  StyledText(
                                    'crew_leader_nickname_alt'.tr(args: [
                                      item.value.crewFounderNickName!
                                          .split('@')[0]
                                    ]),
                                    color: deepGrayColor,
                                    fontWeight: 500,
                                    fontSize: 12,
                                    lineHeight: 16,
                                    letterSpacing: 0,
                                    overflowEllipsis: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: subBg01Color,
                      border: Border.all(
                        color: item.value.crewRecruitStatus == 'CLOSE'
                            ? deepGrayColor
                            : skyBlueColor,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0.sp, horizontal: 14.0.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconPeople,
                          Padding(
                            padding: EdgeInsets.only(left: 4.0.sp),
                            child: StyledText(
                              item.value.crewMemberList != null
                                  ? item.value.crewMemberList!.length.toString()
                                  : '0',
                              textAlign: TextAlign.right,
                              color: item.value.crewRecruitStatus == 'CLOSE'
                                  ? deepGrayColor
                                  : Colors.white,
                              fontSize: 14,
                              lineHeight: 16,
                              fontWeight: 500,
                              letterSpacing: -.1,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ChallengesDetailController controller =
        Get.isRegistered<ChallengesDetailController>()
            ? Get.find<ChallengesDetailController>()
            : Get.put(ChallengesDetailController());

    return SingleChildScrollView(
      child: Obx(() {
        return Container(
            color: subBg01Color,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: controller.dataGetLoading.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: skyBlueColor)),
                            )
                          : controller.crewList.isEmpty
                              ? SizedBox(
                                  height: 500,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        iconEmpty,
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.sp),
                                          child: StyledText(
                                            'no_crew'.tr(),
                                            color: const Color(0xff7b7b7b),
                                            fontSize: 16,
                                            lineHeight: 10,
                                            fontWeight: 500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 10.0.sp),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [...renderCrewList(controller)],
                                  ),
                                ),
                    )
                  ],
                ),
              ),
            )
            // height: MediaQuery.of(context).size.height,

            );
      }),
    );
  }
}
