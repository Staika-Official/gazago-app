import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/checkpoint_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

List<Circle> renderCircleOverlays(ChallengeCourseModel? course) {
  if (course != null) {
    Circle startCenterCircle = Circle(
      circleId: CircleId('ChallengeStartCenter${course.id!}'),
      center: LatLng(course.startLat!, course.startLon!),
      radius: 9,
      fillColor: skyBlueColor,
    );

    Circle startOuterCircle = Circle(
      circleId: CircleId('ChallengeStart${course.id!}'),
      center: LatLng(course.startLat!, course.startLon!),
      radius: course.startRadius!,
      fillColor: const Color.fromRGBO(14, 230, 243, 0.3),
    );

    Circle endCenterCircle = Circle(
      circleId: CircleId('ChallengeEndCenter${course.id!}'),
      center: LatLng(course.endLat!, course.endLon!),
      radius: 9,
      fillColor: Colors.red,
    );

    Circle endOuterCircle = Circle(
      circleId: CircleId('ChallengeEnd${course.id!}'),
      center: LatLng(course.endLat!, course.endLon!),
      radius: course.endRadius!,
      fillColor: Colors.red[300]!.withOpacity(0.3),
    );

    List<Circle> renderCheckpoints() {
      if (course.checkpoints != null) {
        return course.checkpoints!
            .map((checkpoint) => Circle(
                  circleId: CircleId('checkpoint${checkpoint.id!}'),
                  center: LatLng(checkpoint.lat!, checkpoint.lon!),
                  radius: checkpoint.radius!,
                  fillColor: const Color.fromRGBO(14, 230, 243, 0.3),
                ))
            .toList();
      } else {
        return List.empty();
      }
    }

    return [
      startCenterCircle,
      startOuterCircle,
      endCenterCircle,
      endOuterCircle,
      ...renderCheckpoints()
    ];
  } else {
    return List.empty();
  }
}

List<Marker> renderMarkers(ChallengeCourseModel? course) {
  ActivityController controller = Get.find<ActivityController>();
  if (course != null) {
    Marker startMaker = getCustomMarker(
        id: course.id.toString(),
        markerType: "START",
        course: course,
        markerIcon: controller.startMarker);

    Marker endMaker = getCustomMarker(
        id: course.id.toString(),
        markerType: "END",
        course: course,
        markerIcon: controller.endMarker);

    List<Marker> checkpointMarker() {
      if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
        List<Marker> list = List.empty(growable: true);
        course.checkpoints!.asMap().forEach((index, checkpoint) {
          list.add(getCheckpointMarker(
              checkpoint, controller.checkpointMarkers[index]?.icon));
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

Marker getCustomMarker(
    {required String id,
    required String markerType,
    required ChallengeCourseModel course,
    BitmapDescriptor? markerIcon,
    Function(Marker?, Map<String, int?>)? onMarkerTab}) {
  switch (markerType) {
    case 'START':
      return Marker(
        markerId: MarkerId(id),
        position: LatLng(course.startLat!, course.startLon!),
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
      );
    case 'END':
      return Marker(
        markerId: MarkerId('end_${id}'),
        position: LatLng(course.endLat!, course.endLon!),
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
      );
    default:
      return Marker(
        markerId: MarkerId(id),
        position: LatLng(course.startLat!, course.startLon!),
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
      );
  }
}

Marker getCheckpointMarker(
    CheckpointModel checkpoint, BitmapDescriptor? markerIcon) {
  return Marker(
    markerId: MarkerId('checkpoint_${checkpoint.id!.toString()}'),
    position: LatLng(checkpoint.lat!, checkpoint.lon!),
    icon: markerIcon ?? BitmapDescriptor.defaultMarker,
  );
}
