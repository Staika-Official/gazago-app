import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityActiveMiniMapSection extends StatefulWidget {
  const ActivityActiveMiniMapSection({super.key});

  @override
  State<ActivityActiveMiniMapSection> createState() =>
      _ActivityActiveMiniMapSectionState();
}

class _ActivityActiveMiniMapSectionState
    extends State<ActivityActiveMiniMapSection> {
  final controller = Get.find<ActivityController>();

  @override
  void dispose() {
    controller.challengeMapControllers.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 3,
                  color: Colors.black,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                  () => GoogleMap(
                    markers: Set.of(controller.drawingMarkers),
                    polylines: Set.of(controller.drawingPolylines),
                    polygons: Set.of(controller.drawingPolygons),
                    circles: Set.of(controller.drawingCircles),
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    minMaxZoomPreference: const MinMaxZoomPreference(8, 20),
                    mapType: MapType.normal,
                    indoorViewEnabled: true,
                    myLocationButtonEnabled: false,
                    buildingsEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.currentLocation.value?.latitude ?? 0.0,
                        controller.currentLocation.value?.longitude ?? 0.0,
                      ),
                      zoom: 17,
                    ),
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    onMapCreated: (mapController) {
                      controller.challengeMapControllers.add(mapController);
                      // mapController
                      //     .setLocationTrackingMode(NLocationTrackingMode.follow);
                      controller.addOverlayAll(
                        {
                          if (controller.selectedCourse.value != null)
                            ...renderCircleOverlays(
                                controller.selectedCourse.value),
                          if (controller.selectedCourse.value != null)
                            ...renderMarkers(controller.selectedCourse.value),
                        },
                      );

                      if (controller.coordinates.length >= 10) {
                        controller.addOverlay(Polyline(
                          polylineId: const PolylineId('path'),
                          width: 3,
                          color: Colors.red,
                          points: controller.coordinates,
                          // outlineColor: Colors.white,
                        ));
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  controller.isLockMap.value = false;
                  controller.showExerciseMap();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2626).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: iconZoomOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
