import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/debugging_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class LaboratoryDetectChallengeCourse extends StatelessWidget {
  const LaboratoryDetectChallengeCourse({super.key});

  List<Widget> renderCourseList(ActivityController controller) {
    return controller.nearByCourses.map((item) {
      return Padding(
        padding: EdgeInsets.only(top: 8.0.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(100.sp),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 1),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(
                    '${item.firstName.toString()} - ${item.secondName.toString()}'),
                StyledText(
                    '${item.startLat.toString()}, ${item.startLon.toString()}'),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find<ActivityController>();

    return DefaultContainer(
        titleText: 'gps_challenge_course'.tr(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: double.infinity,
                      height: 420.sp,
                      color: Colors.grey,
                      child: GoogleMap(
                        markers: Set.of(controller.drawingMarkers),
                        polylines: Set.of(controller.drawingPolylines),
                        polygons: Set.of(controller.drawingPolygons),
                        circles: Set.of(controller.drawingCircles),
                        tiltGesturesEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              controller.currentLocation.value.latitude,
                              controller.currentLocation.value.longitude),
                          zoom: 14,
                          tilt: 1,
                        ),
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        onMapCreated: (mapController) {
                          // mapController.setLocationTrackingMode(
                          //     NLocationTrackingMode.follow);
                          controller.googleMapController = mapController;
                          if (controller.nearByCourses.value != null) {
                            List overlays = [];
                            controller.nearByCourses.value.forEach((item) {
                              overlays.addAll(renderCircleOverlays(item));
                              overlays.addAll(renderMarkers(item));
                            });
                            print(overlays);

                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              controller.addOverlayAll({...overlays});
                            });
                          }
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('nearest_challenge'.tr()),
                        StyledText(
                            '${controller.nearChallengeLocation.value!.firstName.toString()} - ${controller.nearChallengeLocation.value!.secondName.toString()}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('nearest_challenge_location'.tr()),
                        StyledText(
                            '${controller.nearChallengeLocation.value!.startLat.toString()} - ${controller.nearChallengeLocation.value!.startLon.toString()}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('distance_to_nearest_challenge'.tr()),
                        StyledText(
                            '${formatDecimalPlaces(controller.betweenDistance.value, 0)} m'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('my_location'.tr()),
                        StyledText(
                            '${controller.currentLocation.value.latitude.toString()} - ${controller.currentLocation.value.longitude.toString()}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('speed : '),
                        StyledText(
                            '${formatDecimalPlaces(controller.gpsSpeed.value, 0)} km/h'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: Row(
                      children: [
                        StyledText('Detect Delay : '),
                        StyledText('detection_delay'
                            .tr(args: [controller.detectDelay.toString()])),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: StyledText('nearby_challenge_list'.tr()),
                  ),
                  Column(
                    children: [...renderCourseList(controller)],
                  )
                ],
              );
            }),
          ),
        ));
  }
}
