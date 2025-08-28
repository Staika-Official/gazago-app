import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class ArchiveDetail extends StatelessWidget {
  const ArchiveDetail({super.key});

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.find();

    return DefaultContainer(
      titleText: 'exercise_record_detail'.tr(),
      trailingChild: InkWell(
        child: IconButton(
          onPressed: () =>
              controller.showConfirmDelete(controller.selectedItem.value.id!),
          icon: iconWasteBasket,
          splashRadius: 32.sp,
          constraints: BoxConstraints(
            minWidth: 32.sp,
          ),
        ),
      ),
      backgroundColor: AppColorData.regular().colorBgPrimary,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.sp),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            controller.getArchiveTypeImage(
                                controller.selectedItem.value),
                            if (controller.selectedItem.value.badgeIssueId !=
                                null)
                              controller.selectedItem.value.badgeImageUrl!
                                      .contains('.svg')
                                  ? Positioned(
                                      right: 0,
                                      bottom: 2,
                                      child: SvgPicture.network(
                                        width: 20.sp,
                                        height: 20.sp,
                                        fit: BoxFit.contain,
                                        controller
                                            .selectedItem.value.badgeImageUrl!,
                                        headers: imageNetworkHeader,
                                      ),
                                    )
                                  : Positioned(
                                      right: 0,
                                      bottom: 2,
                                      child: CachedNetworkImage(
                                        width: 20.sp,
                                        height: 20.sp,
                                        imageUrl: controller
                                            .selectedItem.value.badgeImageUrl!,
                                        fit: BoxFit.fitHeight,
                                        httpHeaders: imageNetworkHeader,
                                      ),
                                    ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          formatDateUntilDay(
                              controller.selectedItem.value.startedDate),
                          style: AppTextStyleData.regular()
                              .koBodySemiboldLg
                              .copyWith(
                                color:
                                    AppColorData.regular().colorTextSecondary,
                              )),
                      controller.selectedItem.value.secondName != null
                          ? Text(controller.selectedItem.value.secondName!,
                              style: AppTextStyleData.regular()
                                  .koBodyMediumMd
                                  .copyWith(
                                    color: AppColorData.regular()
                                        .colorTextSecondary,
                                  ))
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 4.sp, left: 16.0.sp, right: 16.0.sp),
              child: Divider(
                height: 2,
                thickness: 2.0,
                color: AppColorData.regular().colorBorderSecondary,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 22.0.sp, horizontal: 16.0.sp),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: iconArchiveClockDetail,
                        ),
                        Text(formatSeconds(controller.selectedItem.value.time!),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color: AppColorData.regular()
                                      .colorTextInteractivePrimary,
                                ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: iconArchiveDistanceDetail,
                        ),
                        Text(
                            '${formatDecimalPlaces(convertMetersToKm(controller.selectedItem.value.distance ?? controller.selectedItem.value.rewardDistance ?? 0), 3, isAutoDecimal: true)} km',
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color: AppColorData.regular()
                                      .colorTextInteractivePrimary,
                                )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: iconArchiveStepsDetail,
                        ),
                        Text('${controller.selectedItem.value.steps}',
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color: AppColorData.regular()
                                      .colorTextInteractivePrimary,
                                )),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.sp, right: 16.0.sp, top: 0.0.sp, bottom: 15.0.sp),
              child: Container(
                  width: double.infinity,
                  height: 220.sp,
                  color: Colors.grey,
                  child: controller.selectedItem.value.isTwoMonthAgo != null &&
                          !controller.selectedItem.value.isTwoMonthAgo!
                      ? Obx(() {
                          return GoogleMap(
                            markers: Set.of(controller.drawingMarkers),
                            polylines: Set.of(controller.drawingPolylines),
                            polygons: Set.of(controller.drawingPolygons),
                            circles: Set.of(controller.drawingCircles),
                            mapType: MapType.normal,
                            tiltGesturesEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: controller.locations.isNotEmpty
                                  ? controller.locations.first
                                  : const LatLng(37.5525, 126.9883),
                              zoom: 10,
                            ),
                            gestureRecognizers: <Factory<
                                OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },
                            onMapCreated: (mapController) {
                              controller.recordMapCreated(
                                  mapController, controller.locations);

                              controller.addOverlayAll(
                                {
                                  if (controller
                                          .selectedItem.value.challengeCourse !=
                                      null)
                                    ...renderCircleOverlays(controller
                                        .selectedItem.value.challengeCourse),
                                  if (controller
                                          .selectedItem.value.challengeCourse !=
                                      null)
                                    ...renderMarkers(controller
                                        .selectedItem.value.challengeCourse)
                                },
                              );

                              controller.addOverlay(Polyline(
                                polylineId: const PolylineId('detail path'),
                                width: 4,
                                color: Colors.red,
                                points: controller.locations.length > 1
                                    ? controller.locations
                                    : [
                                        const LatLng(37.5551, 126.9933),
                                        const LatLng(37.5551, 126.9933)
                                      ],
                                // outlineColor: Colors.white,
                              ));
                            },
                          );
                        })
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              iconNoneMap,
                              Padding(
                                padding: EdgeInsets.only(top: 20.0.sp),
                                child: Text('exercise_log_limit'.tr(),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyleData.regular()
                                        .koBodyMediumLg
                                        .copyWith(
                                          color: AppColorData.regular()
                                              .colorTextSecondary,
                                        )),
                              ),
                            ],
                          ),
                        )),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('received_go'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                          formatDecimalPlaces(
                              controller.selectedItem.value.rewardGo!, 2),
                          style: AppTextStyleData.regular()
                              .koBodySemiboldXl
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              )),
                      Text(' GO',
                          style: AppTextStyleData.regular()
                              .enBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextTertiary,
                              )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('activity_reward'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                          formatDecimalPlaces(
                              controller
                                  .selectedItem.value.rewardGoExerciseSum!,
                              2),
                          style: AppTextStyleData.regular()
                              .koBodySemiboldXl
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              )),
                      Text(' GO',
                          style: AppTextStyleData.regular()
                              .enBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextTertiary,
                              )),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
            //   child: Row(
            //     children: [
            //       const StyledText(
            //         'ad_reward'.tr(),
            //         fontWeight: 600,
            //         fontSize: 16,
            //       ),
            //       const Spacer(),
            //       Row(
            //         children: [
            //           StyledText(
            //             formatDecimalPlaces(controller.selectedItem.value.rewardGoAdSum!, 2),
            //             fontWeight: 500,
            //             fontSize: 16,
            //           ),
            //           const StyledText(
            //             ' GO',
            //             fontWeight: 500,
            //             fontSize: 16,
            //             color: Color(0xFF7D7D84),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('lucky_effect_2'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                          '${controller.selectedItem.value.luckOccurredCount ?? 0}',
                          style: AppTextStyleData.regular()
                              .koBodySemiboldXl
                              .copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              )),
                      Text('times'.tr(),
                          style: AppTextStyleData.regular()
                              .enBodyMediumLg
                              .copyWith(
                                color: AppColorData.regular().colorTextTertiary,
                              )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('stamina_used'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Text(controller.selectedItem.value.spendStamina.toString(),
                      style: AppTextStyleData.regular().enBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextTertiary,
                          )),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('durability_used'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Text(controller.selectedItem.value.spendDurability.toString(),
                      style: AppTextStyleData.regular().enBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextTertiary,
                          )),
                ],
              ),
            ),
            controller.selectedItem.value.challengeActivationType == "COURSE"
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('badges_obtained'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(
                            controller.selectedItem.value.badgeIssueId != null
                                ? controller.selectedItem.value.badgeName!
                                : 'challenge_failed'.tr(),
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 16.0.sp),
              child: const Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            controller.selectedItem.value.challengeActivationType == "COURSE"
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('start_point_1'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(controller.selectedItem.value.startPointName!,
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp),
              child: Row(
                children: [
                  Text('start_time'.tr(),
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          )),
                  const Spacer(),
                  Text(
                      formatHipenDate(
                          controller.selectedItem.value.startedDate!),
                      style: AppTextStyleData.regular().enBodyMediumLg.copyWith(
                            color: AppColorData.regular().colorTextTertiary,
                          )),
                ],
              ),
            ),
            // startPointName
            controller.selectedItem.value.challengeActivationType == "COURSE"
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('end_point_1'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(controller.selectedItem.value.endPointName!,
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            controller.selectedItem.value.endedDate != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('end_time'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(
                            formatHipenDate(
                                controller.selectedItem.value.endedDate!),
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 16.0.sp),
              child: const Divider(
                height: 2,
                thickness: 2.0,
                color: Color(0xFF2C2C35),
              ),
            ),
            controller.selectedItem.value.speed != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('average_speed'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(
                            '${controller.selectedItem.value.speed!.toString()} km/h',
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            controller.selectedItem.value.altitude != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0.sp, horizontal: 16.0.sp),
                    child: Row(
                      children: [
                        Text('max_altitude'.tr(),
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextPrimary,
                                )),
                        const Spacer(),
                        Text(
                            '${controller.selectedItem.value.altitude!.toString()} m',
                            style: AppTextStyleData.regular()
                                .enBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextTertiary,
                                )),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 50.sp,
            )
          ],
        ),
      ),
    );
  }
}
