import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/checkpoint_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

List<CircleOverlay> renderCircleOverlays(ChallengeCourseModel? course) {
  if (course != null) {
    CircleOverlay startCenterCircle = CircleOverlay(
      overlayId: 'ChallengeStartCenter${course.id!}',
      center: LatLng(course.startLat!, course.startLon!),
      radius: 9,
      color: skyBlueColor,
    );

    CircleOverlay startOuterCircle = CircleOverlay(
      overlayId: 'ChallengeStart${course.id!}',
      center: LatLng(course.startLat!, course.startLon!),
      radius: course.startRadius!,
      color: const Color.fromRGBO(14, 230, 243, 0.3),
    );

    CircleOverlay endCenterCircle = CircleOverlay(
      overlayId: 'ChallengeEndCenter${course.id!}',
      center: LatLng(course.endLat!, course.endLon!),
      radius: 9,
      color: Colors.red,
    );

    CircleOverlay endOuterCircle = CircleOverlay(
      overlayId: 'ChallengeEnd${course.id!}',
      center: LatLng(course.endLat!, course.endLon!),
      radius: course.endRadius!,
      color: Colors.red[300]?.withOpacity(0.3),
    );

    List<CircleOverlay> renderCheckpoints() {
      if (course.checkpoints != null) {
        return course.checkpoints!
            .map((checkpoint) => CircleOverlay(
                  overlayId: 'checkpoint${checkpoint.id!}',
                  center: LatLng(checkpoint.lat!, checkpoint.lon!),
                  radius: checkpoint.radius!,
                  color: const Color.fromRGBO(14, 230, 243, 0.3),
                ))
            .toList();
      } else {
        return List.empty();
      }
    }

    return [startCenterCircle, startOuterCircle, endCenterCircle, endOuterCircle, ...renderCheckpoints()];
  } else {
    return List.empty();
  }
}

List<Marker> renderMarkers(ChallengeCourseModel? course) {
  ActivityController controller = Get.find<ActivityController>();
  if (course != null) {
    Marker startMaker = getCustomMarker(markerType: "START", course: course, markerIcon: controller.startMarker);

    Marker endMaker = getCustomMarker(markerType: "END", course: course, markerIcon: controller.startMarker);
    ;

    List<Marker> checkpointMarker() {
      if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
        return course.checkpoints!
            .map(
              (checkpoint) => getCheckpointMarker(checkpoint, controller.checkpointMarker),
            )
            .toList();
      } else {
        return [];
      }
    }

    return [startMaker, endMaker, ...checkpointMarker()];
  } else {
    return List.empty();
  }
}

Marker getCustomMarker({required String markerType, required ChallengeCourseModel course, OverlayImage? markerIcon, Function(Marker?, Map<String, int?>)? onMarkerTab}) {
  Marker startMarker = Marker(
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
    icon: markerIcon,
    width: 20,
    height: 20,
    onMarkerTab: onMarkerTab,
  );

  Marker endMarker = Marker(
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
    icon: markerIcon,
    width: 20,
    height: 20,
  );

  switch (markerType) {
    case 'START':
      return startMarker;
    case 'END':
      return endMarker;
    default:
      return startMarker;
  }
}

Marker getCheckpointMarker(CheckpointModel checkpoint, OverlayImage? markerIcon) {
  return Marker(
    markerId: 'checkpoint_${checkpoint.id!.toString()}',
    position: LatLng(checkpoint.lat!, checkpoint.lon!),
    captionText: checkpoint.name,
    captionColor: skyBlueColor,
    captionHaloColor: Colors.black,
    captionTextSize: 12.0.sp,
    captionOffset: 5,
    icon: markerIcon,
    width: 19,
    height: 17,
  );
}
