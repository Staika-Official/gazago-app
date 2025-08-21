import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class ActivityMap extends StatefulWidget {
  const ActivityMap({super.key});

  @override
  State<ActivityMap> createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  ActivityController controller = Get.find();

  @override
  void dispose() {
    controller.challengeMapControllers.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          return GoogleMap(
            markers: Set.of(controller.drawingMarkers),
            polylines: Set.of(controller.drawingPolylines),
            polygons: Set.of(controller.drawingPolygons),
            circles: Set.of(controller.drawingCircles),
            myLocationEnabled: true,
            padding: EdgeInsets.only(top: 100.sp),
            minMaxZoomPreference: const MinMaxZoomPreference(8, 20),
            mapType: MapType.normal,
            indoorViewEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value.latitude,
                  controller.currentLocation.value.longitude),
              zoom: 17,
            ),
            zoomGesturesEnabled: controller.isLockMap.isFalse,
            tiltGesturesEnabled: controller.isLockMap.isFalse,
            rotateGesturesEnabled: controller.isLockMap.isFalse,
            scrollGesturesEnabled: controller.isLockMap.isFalse,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (mapController) {
              // mapController
              //     .setLocationTrackingMode(NLocationTrackingMode.follow);
              controller.challengeMapControllers.add(mapController);
              controller.addOverlayAll(
                {
                  if (controller.selectedCourse.value != null)
                    ...renderCircleOverlays(controller.selectedCourse.value),
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
          );
        }),
        Positioned(
          top: 0,
          left: 20.sp,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 46.sp,
                height: 46.sp,
                margin: EdgeInsets.only(top: 20.sp),
                decoration: BoxDecoration(
                    color: popupBgColor,
                    border: Border.all(
                        width: 2.sp,
                        style: BorderStyle.solid,
                        color: Colors.black),
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
          ),
        ),
      ],
    );
  }
}
