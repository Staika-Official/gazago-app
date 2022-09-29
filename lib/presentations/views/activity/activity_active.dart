import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class ActivityActive extends StatelessWidget {
  const ActivityActive({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    return controller.challengeList
        .map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeStart' + challenge.id!.toString(),
            center: LatLng(challenge.startLat!, challenge.startLon!),
            radius: challenge.startRadius!,
            color: Colors.transparent,
            outlineColor: Colors.blue[300],
            outlineWidth: 3,
          ),
        )
        .toList();
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    return controller.challengeList
        .map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeEnd' + challenge.id!.toString(),
            center: LatLng(challenge.endLat!, challenge.endLon!),
            // radius: challenge.endRadius!,
            radius: 10,
            color: Colors.transparent,
            outlineColor: Colors.red[300],
            outlineWidth: 3,
          ),
        )
        .toList();
  }

  List<Marker> renderStartMarker(ActivityController controller) {
    return controller.challengeList
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

    return DefaultContainer(
      onBackButtonTap: () {
        Get.offNamed(Routes.home);
      },
      child: Center(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: NaverMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.currentLocation.value.latitude ?? 0, controller.currentLocation.value.longitude ?? 0),
                    zoom: 10,
                  ),
                  initLocationTrackingMode: LocationTrackingMode.Follow,
                  mapType: MapType.Basic,
                  circles: [
                    ...renderStartPoint(controller),
                    ...renderEndPoint(controller),
                  ],
                  markers: [
                    ...renderStartMarker(controller),
                    ...renderEndMarker(controller),
                  ],
                  pathOverlays: (controller.coordinates.length < 10)
                      ? null
                      : {
                          PathOverlay(
                            PathOverlayId('path'),
                            controller.coordinates,
                            width: 3,
                            color: Colors.red,
                            outlineColor: Colors.white,
                          )
                        },
                  locationButtonEnable: true,
                  onCameraChange: controller.onCameraChange,
                  onCameraIdle: controller.onCameraIdle,
                  onMapCreated: (NaverMapController mapController) => controller.onMapCreated(mapController, controller.mapCompleter),
                  onMapTap: controller.onMapTap,
                  onMapLongTap: controller.onMapLongTap,
                  onMapDoubleTap: controller.onMapDoubleTap,
                  onMapTwoFingerTap: controller.onMapTwoFingerTap,
                  onSymbolTap: controller.onSymbolTap,
                  indoorEnable: true,
                  maxZoom: 17,
                  minZoom: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('latitude ' + controller.currentLocation.value.latitude.toString()),
                  Text('longitude ' + controller.currentLocation.value.longitude.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('step ' + controller.steps.value.toString()),
                  Text('status ' + controller.pedestrianStatus.value),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('speed ' + controller.realTimeSpeed.value.toString()),
                  Text('avgSpeed ' + controller.avgSpeed.value.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('time ' + controller.time.value.toString()),
                  Text('distance ' + controller.totalDistance.value.toString()),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
