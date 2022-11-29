import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ArchiveDetail extends StatelessWidget {
  const ArchiveDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.find();

    return DefaultContainer(
      titleText: '${formatDateUntilDay(controller.selectedItem.value.startedDate)} 기록',
      trailingChild: InkWell(
        child: IconButton(
          onPressed: () => controller.showConfirmDelete(controller.selectedItem.value.id!),
          icon: iconWasteBasket,
          constraints: BoxConstraints(
            minWidth: 20.sp,
          ),
        ),
      ),
      backgroundColor: subBg01Color,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 20.0.sp),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15.0.sp),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 21.sp,
                              backgroundColor: Colors.transparent,
                              foregroundImage: controller.selectedItem.value.type == ExerciseType.hiking.name.toUpperCase()
                                  ? const Svg('assets/images/archive/ico_archive_hiking.svg')
                                  : const Svg('assets/images/archive/ico_archive_walking.svg'),
                            ),
                            if (controller.selectedItem.value.badgeIssueId != null)
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: Image.network(controller.selectedItem.value.badgeImageUrl!, width: 20.sp, height: 20.sp),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.selectedItem.value.secondName != null
                          ? StyledText(
                              controller.selectedItem.value.secondName!,
                              fontSize: 18,
                              lineHeight: 20,
                              fontWeight: 500,
                              color: const Color(0xFF949494),
                            )
                          : Container(),
                      StyledText(
                        formatDateUntilDay(controller.selectedItem.value.startedDate),
                        fontSize: controller.selectedItem.value.secondName != null ? 14 : 18,
                        lineHeight: 20,
                        fontWeight: 500,
                        color: controller.selectedItem.value.secondName != null ? Colors.white : const Color(0xFF949494),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2.0,
              color: Color(0xFF2C2C35),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.sp, horizontal: 20.0.sp),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.2.sp, bottom: 3.sp),
                          child: iconArchiveClockDetail,
                        ),
                        StyledText(
                          formatSeconds(controller.selectedItem.value.time!),
                          fontSize: 16,
                          lineHeight: 20,
                          fontWeight: 600,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.2.sp, bottom: 5.sp),
                          child: iconArchiveDistanceDetail,
                        ),
                        StyledText(
                          '${formatDecimalPlaces(convertMetersToKm(controller.selectedItem.value.distance!), 2)} km',
                          fontSize: 16,
                          lineHeight: 20,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5.2.sp, bottom: 3.sp),
                          child: iconArchiveStepsDetail,
                        ),
                        StyledText(
                          '${controller.selectedItem.value.steps}',
                          fontSize: 16,
                          lineHeight: 20,
                          fontWeight: 600,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0.sp, right: 20.0.sp, top: 0.0.sp, bottom: 15.0.sp),
              child: Container(
                width: double.infinity,
                height: 220.sp,
                color: Colors.grey,
                child: NaverMap(
                  nightModeEnable: true,
                  forceGesture: true,
                  tiltGestureEnable: false,
                  mapType: MapType.Basic,
                  activeLayers: const [MapLayer.LAYER_GROUP_MOUNTAIN],
                  onMapCreated: (mapController) => controller.recordMapCreated(mapController, controller.locations),
                  initialCameraPosition: CameraPosition(
                    target: controller.locations.length > 1 ? controller.locations.first : const LatLng(37.5525, 126.9883),
                  ),
                  pathOverlays: {
                    PathOverlay(
                      PathOverlayId('detail path'),
                      controller.locations.length > 1 ? controller.locations : [const LatLng(37.5551, 126.9933), const LatLng(37.5551, 126.9933)],
                      width: 3,
                      color: Colors.red,
                      // outlineColor: Colors.white,
                    )
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: Row(
                children: [
                  const StyledText(
                    '획득 GO',
                    fontWeight: 600,
                    fontSize: 16,
                  ),
                  const Spacer(),
                  StyledText(
                    '${formatDecimalPlaces(controller.selectedItem.value.rewardGo!, 2)} GO',
                    fontWeight: 500,
                    fontSize: 16,
                    color: const Color(0xFF7D7D84),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: Row(
                children: [
                  const StyledText(
                    '소비 체력',
                    fontWeight: 600,
                    fontSize: 16,
                  ),
                  const Spacer(),
                  StyledText(
                    controller.selectedItem.value.spendStamina.toString(),
                    fontWeight: 500,
                    fontSize: 16,
                    color: const Color(0xFF7D7D84),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: Row(
                children: [
                  const StyledText(
                    '소비 내구도',
                    fontWeight: 600,
                    fontSize: 16,
                  ),
                  const Spacer(),
                  StyledText(
                    controller.selectedItem.value.spendDurability.toString(),
                    fontWeight: 500,
                    fontSize: 16,
                    color: const Color(0xFF7D7D84),
                  ),
                ],
              ),
            ),
            controller.selectedItem.value.challengeId != null && controller.selectedItem.value.badgeName != null && controller.selectedItem.value.type == "HIKING"
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '획득 뱃지',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.badgeIssueId != null ? controller.selectedItem.value.badgeName! : '챌린지 실패',
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: const Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            controller.selectedItem.value.startPointName != null && controller.selectedItem.value.type == "HIKING"
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '시작점',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.startPointName!,
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: Row(
                children: [
                  const StyledText(
                    '시작 시간',
                    fontWeight: 600,
                    fontSize: 16,
                  ),
                  const Spacer(),
                  StyledText(
                    formatDate(controller.selectedItem.value.startedDate!),
                    fontWeight: 500,
                    fontSize: 16,
                    color: const Color(0xFF7D7D84),
                  ),
                ],
              ),
            ),
            // startPointName
            controller.selectedItem.value.endPointName != null && controller.selectedItem.value.type == "HIKING"
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '종료점',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.endPointName!,
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            controller.selectedItem.value.endedDate != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '종료 시간',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          formatDate(controller.selectedItem.value.endedDate!),
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
              child: const Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            controller.selectedItem.value.speed != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '평균 속도',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          '${controller.selectedItem.value.speed!.toString()} km/h',
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            controller.selectedItem.value.altitude != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
                    child: Row(
                      children: [
                        const StyledText(
                          '최고 고도',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          '${controller.selectedItem.value.altitude!.toString()} m',
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
