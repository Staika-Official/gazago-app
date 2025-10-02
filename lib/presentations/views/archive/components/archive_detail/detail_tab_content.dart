import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/segmented_polyline_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailTabContent extends StatefulWidget {
  const DetailTabContent({super.key});

  @override
  State<DetailTabContent> createState() => _DetailTabContentState();
}

class _DetailTabContentState extends State<DetailTabContent>
    with AutomaticKeepAliveClientMixin {
  final ArchiveController controller = Get.find<ArchiveController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 22.0.sp, horizontal: 16.0.sp),
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
                        style:
                            AppTextStyleData.regular().koBodyMediumLg.copyWith(
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
                      '${formatDecimalPlaces(convertMetersToKm(controller.selectedItem.value.rewardDistance!), 3, isAutoDecimal: true)} km',
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                            color: AppColorData.regular()
                                .colorTextInteractivePrimary,
                          ),
                    ),
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
                        style:
                            AppTextStyleData.regular().koBodyMediumLg.copyWith(
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
          padding: EdgeInsets.all(16.sp).copyWith(top: 0),
          child: SizedBox(
            height: 220.sp,
            child: controller.selectedItem.value.isTwoMonthAgo == false
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
                            if (controller.selectedItem.value.challengeCourse !=
                                null)
                              ...renderCircleOverlays(controller
                                  .selectedItem.value.challengeCourse),
                            if (controller.selectedItem.value.challengeCourse !=
                                null)
                              ...renderMarkers(
                                  controller.selectedItem.value.challengeCourse)
                          },
                        );

                        // Add segmented polylines for archive detail instead of continuous red line
                        _addSegmentedPolylinesForArchive(mapController);
                      },
                    );
                  })
                : ColoredBox(
                    color: Colors.black.withOpacity(.8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          iconNoneMap,
                          SizedBox(height: 20.sp),
                          Text(
                            'exercise_log_limit'.tr(),
                            textAlign: TextAlign.center,
                            style: AppTextStyleData.regular()
                                .koBodyMediumLg
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        _buildRowInfo(
          title: 'received_go'.tr(),
          firstPostFix:
              formatDecimalPlaces(controller.selectedItem.value.rewardGo!, 2),
          secondPostFix: ' GO',
        ),
        _buildRowInfo(
          title: 'activity_reward'.tr(),
          firstPostFix: formatDecimalPlaces(
              controller.selectedItem.value.rewardGoExerciseSum!, 2),
          secondPostFix: ' GO',
        ),
        // _buildRowInfo(
        //   title: 'ad_reward'.tr(),
        //   firstPostFix: formatDecimalPlaces(
        //       controller.selectedItem.value.rewardGoAdSum!, 2),
        //   secondPostFix: ' GO',
        // ),
        _buildRowInfo(
          title: 'lucky_effect_2'.tr(),
          firstPostFix:
              '${controller.selectedItem.value.luckOccurredCount ?? 0}',
          secondPostFix: 'times'.tr(),
        ),
        _buildRowInfo(
          title: 'stamina_used'.tr(),
          secondPostFix: controller.selectedItem.value.spendStamina.toString(),
        ),
        _buildRowInfo(
          title: 'durability_used'.tr(),
          secondPostFix:
              controller.selectedItem.value.spendDurability.toString(),
        ),
        if (controller.selectedItem.value.challengeActivationType == "COURSE")
          _buildRowInfo(
            title: 'badges_obtained'.tr(),
            secondPostFix: controller.selectedItem.value.badgeIssueId != null
                ? controller.selectedItem.value.badgeName!
                : 'challenge_failed'.tr(),
          ),
        _buildDivider(),
        if (controller.selectedItem.value.challengeActivationType == "COURSE")
          _buildRowInfo(
            title: 'start_point_1'.tr(),
            secondPostFix: controller.selectedItem.value.startPointName!,
          ),
        _buildRowInfo(
          title: 'start_time'.tr(),
          secondPostFix:
              formatHipenDate(controller.selectedItem.value.startedDate!),
        ),
        if (controller.selectedItem.value.challengeActivationType == "COURSE")
          _buildRowInfo(
            title: 'end_point_1'.tr(),
            secondPostFix: controller.selectedItem.value.endPointName!,
          ),
        if (controller.selectedItem.value.endedDate != null)
          _buildRowInfo(
            title: 'end_time'.tr(),
            secondPostFix:
                formatHipenDate(controller.selectedItem.value.endedDate!),
          ),
        _buildDivider(),
        if (controller.selectedItem.value.speed != null)
          _buildRowInfo(
            title: 'average_speed'.tr(),
            secondPostFix:
                '${controller.selectedItem.value.speed!.toString()} km/h',
          ),
        if (controller.selectedItem.value.altitude != null)
          _buildRowInfo(
            title: 'max_altitude'.tr(),
            secondPostFix:
                '${controller.selectedItem.value.altitude!.toString()} m',
          ),
        SizedBox(height: 50.sp),
      ],
    );
  }

  /// Add segmented polylines for archive detail map
  void _addSegmentedPolylinesForArchive(GoogleMapController mapController) {
    if (controller.locations.length < 2) {
      // Fallback to default location if no locations
      controller.addOverlay(const Polyline(
        polylineId: PolylineId('archive_fallback'),
        width: 4,
        color: Colors.blue,
        points: [LatLng(37.5551, 126.9933), LatLng(37.5551, 126.9933)],
      ));
      return;
    }

    // Clear any existing polylines
    SegmentedPolylineHelper.clearSegmentedPolylines(
      controller.drawingPolylines.toList(),
      'archive',
      debugMode: true,
    );

    // Remove cleared polylines from controller
    controller.drawingPolylines.removeWhere((polyline) =>
        polyline.polylineId.value.startsWith('archive') ||
        polyline.polylineId.value.contains('segment') ||
        polyline.polylineId.value == 'detail_path');

    // Create segmented polylines from archive locations
    List<Polyline> segmentedPolylines =
        SegmentedPolylineHelper.renderSegmentedPolylines(
      coordinates: controller.locations,
      polylineIdPrefix: 'archive_segment',
      color: Colors.blue, // Blue color instead of red
      width: 4,
      debugMode: true,
    );

    // Add segmented polylines to map
    for (Polyline polyline in segmentedPolylines) {
      controller.addOverlay(polyline);
    }
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0.sp, horizontal: 16.0.sp),
      child: const Divider(
        height: 2,
        thickness: 2.0,
        color: Color(0xFF2C2C35),
      ),
    );
  }

  Widget _buildRowInfo({
    required String title,
    String? firstPostFix,
    String? secondPostFix,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0.sp,
        horizontal: 16.0.sp,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                  color: AppColorData.regular().colorTextPrimary,
                ),
          ),
          const Spacer(),
          Row(
            children: [
              if (firstPostFix != null)
                Text(
                  firstPostFix,
                  style: AppTextStyleData.regular().koBodySemiboldXl.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                      ),
                ),
              if (secondPostFix != null)
                Text(
                  secondPostFix,
                  style: AppTextStyleData.regular().enBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextTertiary,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
