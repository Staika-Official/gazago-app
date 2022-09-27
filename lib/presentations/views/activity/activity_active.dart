import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class ActivityActive extends StatelessWidget {
  const ActivityActive({Key? key}) : super(key: key);

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
                    CircleOverlay(
                      radius: 20,
                      overlayId: 'challengeStartId',
                      center: LatLng(
                        37.5819,
                        126.8871,
                      ),
                      color: Colors.transparent,
                      outlineColor: Colors.blue[100],
                      outlineWidth: 3,
                    ),
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
                  Text('speed ' + controller.speed.value.toString()),
                  Text('altitude ' + controller.altitude.value.toString()),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
