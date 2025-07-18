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

class ActivityMap extends StatelessWidget {
  const ActivityMap({super.key});

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

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
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value.latitude,
                  controller.currentLocation.value.longitude),
              zoom: 17,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (mapController) {
              controller.challengeMapController = mapController;
              // mapController
              //     .setLocationTrackingMode(NLocationTrackingMode.follow);
              controller.addOverlayAll(
                {
                  if (controller.selectedCourse.value != null)
                    ...renderCircleOverlays(controller.selectedCourse.value),
                  if (controller.selectedCourse.value != null)
                    ...renderMarkers(controller.selectedCourse.value),
                },
              );
              print('map_ready'.tr());

              if (controller.coordinates.length >= 10) {
                print('entered_here'.tr());
                controller.addOverlay(Polyline(
                  polylineId: PolylineId('path'),
                  width: 3,
                  color: Colors.red,
                  points: controller.coordinates,
                  // outlineColor: Colors.white,
                ));
              }
            },
            // onCameraChange: (position, isGesture) {
            //   // controller.challengeMapController.clearOverlays();
            //   print('camera_moving'.tr());
            //   if(controller.coordinates.length >= 10) {
            //     controller.challengeMapController.addOverlay( NPathOverlay(
            //       id: 'path',
            //       width: 3,
            //       color: Colors.red,
            //       coords: controller.coordinates,
            //       // outlineColor: Colors.white,
            //     ));
            //   }
            // },
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
