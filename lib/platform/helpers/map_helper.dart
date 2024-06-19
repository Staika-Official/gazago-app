import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/checkpoint_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

List<NCircleOverlay> renderCircleOverlays(ChallengeCourseModel? course) {
  if (course != null) {
    NCircleOverlay startCenterCircle = NCircleOverlay(
      id: 'ChallengeStartCenter${course.id!}',
      center: NLatLng(course.startLat!, course.startLon!),
      radius: 9,
      color: skyBlueColor,
    );

    NCircleOverlay startOuterCircle = NCircleOverlay(
      id: 'ChallengeStart${course.id!}',
      center: NLatLng(course.startLat!, course.startLon!),
      radius: course.startRadius!,
      color: const Color.fromRGBO(14, 230, 243, 0.3),
    );

    NCircleOverlay endCenterCircle = NCircleOverlay(
      id: 'ChallengeEndCenter${course.id!}',
      center: NLatLng(course.endLat!, course.endLon!),
      radius: 9,
      color: Colors.red,
    );

    NCircleOverlay endOuterCircle = NCircleOverlay(
      id: 'ChallengeEnd${course.id!}',
      center: NLatLng(course.endLat!, course.endLon!),
      radius: course.endRadius!,
      color: Colors.red[300]!.withOpacity(0.3),
    );

    List<NCircleOverlay> renderCheckpoints() {
      if (course.checkpoints != null) {
        return course.checkpoints!
            .map((checkpoint) => NCircleOverlay(
                  id: 'checkpoint${checkpoint.id!}',
                  center: NLatLng(checkpoint.lat!, checkpoint.lon!),
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

List<NMarker> renderMarkers(ChallengeCourseModel? course) {
  ActivityController controller = Get.find<ActivityController>();
  if (course != null) {
    NMarker startMaker = getCustomMarker(markerType: "START", course: course, markerIcon: controller.startMarker);

    NMarker endMaker = getCustomMarker(markerType: "END", course: course, markerIcon: controller.startMarker);

    List<NMarker> checkpointMarker() {
      if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
        List<NMarker> list = List.empty(growable: true);
        course.checkpoints!.asMap().forEach((index, checkpoint) {
          list.add(getCheckpointMarker(checkpoint, controller.checkpointMarkers[index]));
        });
        return list;
      } else {
        return [];
      }
    }

    return [startMaker, endMaker, ...checkpointMarker()];
  } else {
    return List.empty();
  }
}

NMarker getCustomMarker({required String markerType, required ChallengeCourseModel course, NOverlayImage? markerIcon, Function(NMarker?, Map<String, int?>)? onMarkerTab}) {
  NMarker startMarker = NMarker(
    id: course.id!.toString(),
    position: NLatLng(course.startLat!, course.startLon!),
    caption: NOverlayCaption(
      text: '시작: ${course.startPointName}',
      color: skyBlueColor,
      haloColor: Colors.black,
      textSize: 16.0.sp,
    ),


    // subCaptionTextSize: 14.sp,
    // subCaptionText: course.secondName,
    // subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
    // subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
    captionOffset: 5,
    icon: markerIcon,
    size: const Size(20,20),

    // Todo: 여기서 마커 클릭 이벤트 처리
    // onMarkerTab: onMarkerTab,
  );

  NMarker endMarker = NMarker(
    id: 'end_${course.id!.toString()}',
    position: NLatLng(course.endLat!, course.endLon!),
    caption: NOverlayCaption(
      text: '도착: ${course.endPointName}',
      color: const Color(0xFFFF6F75),
      haloColor: Colors.black,
      textSize: 16.0.sp,
    ),

    captionOffset: 5,
    // subCaptionText: course.secondName,
    // subCaptionTextSize: 14.sp,
    // subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
    // subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
    icon: markerIcon,
    size: const Size(20,20),
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

NMarker getCheckpointMarker(CheckpointModel checkpoint, NOverlayImage? markerIcon) {
  return NMarker(
    id: 'checkpoint_${checkpoint.id!.toString()}',
    position: NLatLng(checkpoint.lat!, checkpoint.lon!),
    // captionText: checkpoint.name,
    // captionColor: skyBlueColor,
    caption: NOverlayCaption(
      haloColor: Colors.black,
      textSize: 12.0.sp, text: '',
    ),
    captionOffset: 5,
    icon: markerIcon,
    size: const Size(43,54),
  );
}
