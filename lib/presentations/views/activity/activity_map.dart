import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class ActivityMap extends StatelessWidget {
  const ActivityMap({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeStartCenter${controller.selectedCourse.value.id!}',
      center: LatLng(controller.selectedCourse.value.startLat!, controller.selectedCourse.value.startLon!),
      radius: 9,
      color: skyBlueColor,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeStart${controller.selectedCourse.value.id!}',
      center: LatLng(controller.selectedCourse.value.startLat!, controller.selectedCourse.value.startLon!),
      radius: controller.selectedCourse.value.startRadius!,
      color: const Color.fromRGBO(14, 230, 243, 0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeEndCenter${controller.selectedCourse.value.id!}',
      center: LatLng(controller.selectedCourse.value.endLat!, controller.selectedCourse.value.endLon!),
      radius: 9,
      color: Colors.red,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeEnd${controller.selectedCourse.value.id!}',
      center: LatLng(controller.selectedCourse.value.endLat!, controller.selectedCourse.value.endLon!),
      radius: controller.selectedCourse.value.endRadius!,
      color: Colors.red[300]?.withOpacity(0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<Marker> renderMakers(ActivityController controller) {
    ChallengeCourseModel course = controller.selectedCourse.value;

    Marker startMaker = Marker(
      markerId: course.id!.toString(),
      position: LatLng(course.startLat!, course.startLon!),
      captionText: '시작: ${course.startPointName}',
      captionColor: skyBlueColor,
      captionHaloColor: Colors.black,
      captionTextSize: 16.0.sp,
      subCaptionTextSize: 14.sp,
      subCaptionText: course.secondName,
      subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
      subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
      captionOffset: 5,
      icon: controller.startMarker,
      width: 20,
      height: 20,
    );

    Marker endMaker = Marker(
      markerId: 'end_${course.id!.toString()}',
      position: LatLng(course.endLat!, course.endLon!),
      captionText: '도착: ${course.endPointName}',
      captionColor: const Color(0xFFFF6F75),
      captionHaloColor: Colors.black,
      captionTextSize: 16.0.sp,
      captionOffset: 5,
      subCaptionText: course.secondName,
      subCaptionTextSize: 14.sp,
      subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
      subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
      icon: controller.endMarker,
      width: 20,
      height: 20,
    );

    List<Marker> checkpointMarker() {
      if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
        return course.checkpoints!
            .map((checkpoint) => Marker(
                  markerId: 'checkpoint_${checkpoint.id!.toString()}',
                  position: LatLng(checkpoint.lat!, checkpoint.lon!),
                  captionText: checkpoint.name,
                  captionColor: skyBlueColor,
                  captionHaloColor: Colors.black,
                  captionTextSize: 12.0.sp,
                  captionOffset: 5,
                  // subCaptionText: course.secondName,
                  // subCaptionTextSize: 14.sp,
                  // subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
                  // subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
                  icon: controller.checkpointMarker,
                  width: 30,
                  height: 30,
                ))
            .toList();
      } else {
        return [];
      }
    }

    return [startMaker, endMaker, ...checkpointMarker()];
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Stack(
      children: [
        Obx(() {
          return NaverMap(
            nightModeEnable: true,
            mapType: MapType.Basic,
            activeLayers: const [MapLayer.LAYER_GROUP_MOUNTAIN],
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value.latitude, controller.currentLocation.value.longitude),
              zoom: 15,
            ),
            initLocationTrackingMode: LocationTrackingMode.Follow,
            circles: [
              if (controller.selectedCourse.value.id != null) ...renderStartPoint(controller),
              if (controller.selectedCourse.value.id != null) ...renderEndPoint(controller),
            ],
            markers: [if (controller.selectedCourse.value.id != null) ...renderMakers(controller)],
            pathOverlays: (controller.coordinates.length < 10)
                ? null
                : {
                    PathOverlay(
                      PathOverlayId('path'),
                      controller.coordinates,
                      width: 3,
                      color: Colors.red,
                      // outlineColor: Colors.white,
                    )
                  },
            locationButtonEnable: true,
            maxZoom: 20,
            minZoom: 8,
            tiltGestureEnable: false,
          );
        }),
        Positioned(
          top: 20.sp,
          left: 20.sp,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 46.sp,
              height: 46.sp,
              decoration: BoxDecoration(
                  color: popupBgColor,
                  border: Border.all(width: 2.sp, style: BorderStyle.solid, color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2.sp, 4.sp),
                      color: Colors.black,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(14.sp)),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        )
      ],
    );
  }
}
