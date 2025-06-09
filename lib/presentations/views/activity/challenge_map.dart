import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class ChallengeMap extends StatelessWidget {
  const ChallengeMap({super.key});

  List<Circle> renderStartPoint(ActivityController controller) {
    List<Circle> centerCircles = controller.allCoursesList
        .map(
          (challenge) => Circle(
            circleId: CircleId('ChallengeStartCenter${challenge.id!}'),
            center: LatLng(challenge.startLat!, challenge.startLon!),
            radius: 30,
            fillColor: skyBlueColor,
          ),
        )
        .toList();

    return [...centerCircles];
  }

  List<Circle> renderEndPoint(ActivityController controller) {
    List<Circle> centerCircles = controller.allCoursesList
        .map(
          (challenge) => Circle(
            circleId: CircleId('ChallengeEndCenter${challenge.id!}'),
            center: LatLng(challenge.endLat!, challenge.endLon!),
            radius: 30.sp,
            fillColor: Colors.red,
          ),
        )
        .toList();

    return [...centerCircles];
  }

  Widget _renderChallengePoint(
      ActivityController controller, ChallengeHierarchyModel challenge) {
    return ListTileTheme(
      // dense: true,
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.all(0),
        title: Text(
          challenge.name,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        collapsedIconColor: lightGrayColor,
        iconColor: skyBlueColor,
        tilePadding:
            EdgeInsets.only(left: 20.sp, right: 20.sp, top: 0, bottom: 0),
        //children: challenge.course.map(course => _renderCourse(controller, course)).toList(),
        children: challenge.course.map((course) {
          return _renderCourseList(controller, course);
        }).toList(),
      ),
    );
  }

  Widget _renderCourseList(
      ActivityController controller, ChallengeCourseModel course) {
    return Builder(builder: (context) {
      return Obx(() {
        return ListTile(
            onTap: () {
              controller.showPathPointMarkers(course);
            },
            dense: MediaQuery.of(context).size.width < 320,
            visualDensity: VisualDensity(
                vertical: MediaQuery.of(context).size.width < 320 ? -3 : 0),
            subtitle: StyledText(
              controller.getCourseRouteString(course),
              // 'start_end_points_2'.tr('${course.startPointName}', '${course.endPointName}'),
              color: (controller.challengeSelectedIndex.value == course.id)
                  ? skyBlueColor
                  : deepGrayColor,
              fontSize: 14,
              lineHeight: 14,
              fontWeight: 500,
            ),
            minLeadingWidth: 10,
            leading: Padding(
              padding: EdgeInsets.only(left: 30.sp, top: 5),
              child: (controller.challengeSelectedIndex.value == course.id)
                  ? iconChallengeCheckOn
                  : iconChallengeCheckOff,
            ),
            contentPadding: EdgeInsets.only(right: 20.sp),
            // title: Text(
            //   course.secondName!,
            //   style: TextStyle(color: (controller.challengeSelectedIndex == course.id) ? skyBlueColor : Colors.white),
            // ),

            title: StyledText(course.secondName!,
                fontSize: 17,
                color: (controller.challengeSelectedIndex.value == course.id)
                    ? skyBlueColor
                    : Colors.white));
      });
    });
  }

  Widget _renderChallenges(ActivityController controller) {
    List<ChallengeHierarchyModel> challenges =
        controller.hierarchyChallengesList;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0.0),
      itemCount: challenges.length,
      itemBuilder: (BuildContext context, int index) =>
          _renderChallengePoint(controller, challenges[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Scaffold(
      body: ExpandableBottomSheet(
        //use the key to get access to expand(), contract() and expansionStatus
        key: key,

        //optional; default: Duration(milliseconds: 250)
        //The durations of the animations.
        animationDurationExtend: const Duration(milliseconds: 500),
        animationDurationContract: const Duration(milliseconds: 250),

        //optional; default: Curves.ease
        //The curves of the animations.
        animationCurveExpand: Curves.ease,
        animationCurveContract: Curves.ease,

        //optional
        //The content extend will be at least this height. If the content
        //height is smaller than the persistentContentHeight it will be
        //animated on a height change.
        //You can use it for example if you have no header.
        persistentContentHeight: 120,

        //required
        //This is the widget which will be overlapped by the bottom sheet.
        background: Obx(() {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Obx(
                () => GoogleMap(
                  markers: Set.of(controller.drawingMarkers),
                  polylines: Set.of(controller.drawingPolylines),
                  polygons: Set.of(controller.drawingPolygons),
                  circles: Set.of(controller.drawingCircles),
                  tiltGesturesEnabled: true,
                  padding: const EdgeInsets.only(bottom: 100),
                  mapType: MapType.normal,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  initialCameraPosition:
                      controller.currentLocation.value.latitude > 0
                          ? CameraPosition(
                              target: LatLng(
                                  controller.currentLocation.value.latitude,
                                  controller.currentLocation.value.longitude),
                              zoom: 14,
                            )
                          : const CameraPosition(
                              target: LatLng(37.5665, 126.978),
                              zoom: 14,
                            ),
                  onMapCreated: (mapController) {
                    controller.challengeMapController = mapController;
                    controller.onChallengeMapCreated();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      controller.addOverlayAll(
                        {
                          ...controller.challengeMarkers,
                          ...controller.selectedChallengeMarkers
                        },
                      );
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 68.sp),
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10.sp, bottom: 10.sp, right: 20.sp, left: 20.sp),
                  decoration: BoxDecoration(
                    color: popupBgColor,
                    borderRadius: BorderRadius.circular(14.sp),
                    border: Border.all(color: Colors.black, width: 2.sp),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: StyledText(
                    'challenge_course'.tr(),
                    fontSize: 16,
                    fontWeight: 500,
                    lineHeight: 22,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 66.sp,
                left: 20.sp,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: iconChallengeScreenBack,
                ),
              ),
            ],
          );
        }),

        //optional
        //This widget is sticking above the content and will never be contracted.
        persistentHeader: Container(
          padding: EdgeInsets.only(bottom: 5.sp),
          height: 30,
          decoration: BoxDecoration(
              color: const Color(0xFF4A4D57),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.sp),
                  topRight: Radius.circular(15.sp))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 40.sp,
                  child: Divider(
                    color: skyBlueColor,
                    thickness: 3.sp,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 40.sp,
                  child: Divider(
                    height: 1.sp,
                    color: skyBlueColor,
                    thickness: 3.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        //required
        //This is the content of the bottom sheet which will be extendable by dragging.
        expandableContent: Container(
          height: MediaQuery.of(context).size.height - 200,
          color: popupBgColor,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[_renderChallenges(controller)],
            ),
          ),
        ),

        // optional
        // This will enable tap to toggle option on header.
        enableToggle: true,
      ),
    );
  }
}
