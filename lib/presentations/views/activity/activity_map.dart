import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:get/get.dart';

class ActivityMap extends StatelessWidget {
  const ActivityMap({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeStartCenter' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: 9,
      color: Color(0xff0EE6F3),
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeStart' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: controller.selectedChallenge.value.startRadius!,
      color: Color.fromRGBO(14, 230, 243, 0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeEndCenter' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: 9,
      color: Colors.red,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeEnd' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: controller.selectedChallenge.value.endRadius!,
      color: Colors.red[300]?.withOpacity(0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<Marker> renderStartMarker(ActivityController controller) {
    return controller.challengeList
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
        .map(
          (challenge) => Marker(
            markerId: 'StartMarker' + challenge.id!.toString(),
            position: LatLng(challenge.startLat!, challenge.startLon!),
            captionText: challenge.firstName! + ' 시작점',
            // icon: controller.startMarkerImage.value,
            // width: 10,
            // height: 10,
          ),
        )
        .toList();
  }

  List<Marker> renderEndMarker(ActivityController controller) {
    return controller.challengeList
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
        .map(
          (challenge) => Marker(
            markerId: 'FinishMarker' + challenge.id!.toString(),
            position: LatLng(challenge.endLat!, challenge.endLon!),
            captionText: challenge.firstName! + ' 도착점',
            // icon: controller.finishMarkerImage.value,
            // width: 10,
            // height: 10,
          ),
        )
        .toList();
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
            activeLayers: [MapLayer.LAYER_GROUP_MOUNTAIN],
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value.latitude, controller.currentLocation.value.longitude),
              zoom: 15,
            ),
            initLocationTrackingMode: LocationTrackingMode.Follow,
            circles: [
              if (controller.selectedChallenge.value.id != null) ...renderStartPoint(controller),
              if (controller.selectedChallenge.value.id != null) ...renderEndPoint(controller),
            ],
            // markers: [
            //   ...renderStartMarker(controller),
            //   ...renderEndMarker(controller),
            // ],
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
                  color: Color(0xff363841),
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
