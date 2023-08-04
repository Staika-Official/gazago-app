import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';

class ActivityMap extends StatelessWidget {
  const ActivityMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Stack(
      children: [
        Obx(() {
          return NaverMap(
            nightModeEnable: true,
            mapType: MapType.Basic,
            activeLayers: const [MapLayer.LAYER_GROUP_MOUNTAIN],
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value.latitude, controller.currentLocation.value.longitude),
              zoom: 15,
            ),
            initLocationTrackingMode: LocationTrackingMode.Follow,
            circles: [
              if (controller.selectedCourse.value != null) ...renderCircleOverlays(controller.selectedCourse.value),
            ],
            markers: [
              if (controller.selectedCourse.value != null) ...renderMarkers(controller.selectedCourse.value),
            ],
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
                  color: popupBgColor,
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
        ),
      ],
    );
  }
}
