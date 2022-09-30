import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
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
            radius: challenge.endRadius!,
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
              Flexible(
                flex: 3,
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
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '획득한 STEP ' + (controller.userState.value.exercise != null ? controller.userState.value.exercise!.rewardGo : 0).toString() + 'GO',
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '체력: ' + controller.userState.value.state!.stamina.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '내구도: ' + controller.userState.value.shoes!.durability.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '속도: ' + formatDecimalPlaces(controller.realTimeSpeed.value, 1) + 'km/h',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '평균속도: ' + formatDecimalPlaces(controller.avgSpeed.value, 1) + 'km/h',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '걸음수: ' + controller.exerciseSteps.value.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '운동시간: ' + formatSeconds(controller.exerciseTime.value),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '이동거리: ' + formatDecimalPlaces(controller.totalDistance.value, 2) + 'm',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
