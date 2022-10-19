import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
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
          onPressed: () => controller.deleteItem(controller.selectedItem.value.id!),
          icon: iconWasteBasket,
          constraints: const BoxConstraints(
            minWidth: 20,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1D1D26),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 21,
                              child: controller.selectedItem.value.type == ExerciseType.hiking.name.toUpperCase() ? iconArchiveHiking : iconArchiveWalking,
                            ),
                            if (controller.selectedItem.value.badgeIssueId != null)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset('assets/images/archive/ico_badge.png', width: 15, height: 20),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.selectedItem.value.challengeTitle != null
                          ? StyledText(
                              controller.selectedItem.value.challengeTitle!,
                              fontSize: 18,
                              lineHeight: 20,
                              fontWeight: 500,
                              color: const Color(0xFF949494),
                            )
                          : Container(),
                      StyledText(
                        formatDate(controller.selectedItem.value.startedDate),
                        fontSize: 14,
                        lineHeight: 20,
                        fontWeight: 500,
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
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.2, bottom: 3),
                          child: iconArchiveClock,
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
                          padding: const EdgeInsets.only(right: 5.2, bottom: 5),
                          child: iconArchiveDistance,
                        ),
                        StyledText(
                          '${convertMetersToKm(controller.selectedItem.value.distance!)} km',
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
                          padding: const EdgeInsets.only(right: 5.2, bottom: 3),
                          child: iconArchiveSteps,
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
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 15.0),
              child: Container(
                width: double.infinity,
                height: 220,
                color: Colors.grey,
                child: NaverMap(
                  nightModeEnable: true,
                  tiltGestureEnable: false,
                  mapType: MapType.Navi,
                  initialCameraPosition: CameraPosition(
                    target: controller.locations.length > 1 ? controller.locations.first : LatLng(37.5525, 126.9883),
                  ),
                  pathOverlays: {
                    PathOverlay(
                      PathOverlayId('detail path'),
                      controller.locations.length > 1 ? controller.locations : [LatLng(37.5551, 126.9933), LatLng(37.5551, 126.9933)],
                      width: 3,
                      color: Colors.red,
                      outlineColor: Colors.white,
                    )
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: [
                  StyledText(
                    '획득 GO',
                    fontWeight: 600,
                    fontSize: 16,
                  ),
                  const Spacer(),
                  StyledText(
                    '${controller.selectedItem.value.rewardGo.toString()} GO',
                    fontWeight: 500,
                    fontSize: 16,
                    color: const Color(0xFF7D7D84),
                  ),
                ],
              ),
            ),
            controller.selectedItem.value.badgeName != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
                          '획득 뱃지',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.badgeName!,
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: [
                  StyledText(
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
            controller.selectedItem.value.endedDate != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            controller.selectedItem.value.speed != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
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
            controller.selectedItem.value.spendStamina != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
                          '소비 체력',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.spendStamina!.toString(),
                          fontWeight: 500,
                          fontSize: 16,
                          color: const Color(0xFF7D7D84),
                        ),
                      ],
                    ),
                  )
                : Container(),
            controller.selectedItem.value.spendDurability != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        StyledText(
                          '소비 내구도',
                          fontWeight: 600,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        StyledText(
                          controller.selectedItem.value.spendDurability!.toString(),
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
