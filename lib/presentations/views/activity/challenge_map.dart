import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChallengeMap extends StatelessWidget {
  const ChallengeMap({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    List<CircleOverlay> centerCircles = controller.allChallengesList
        .map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeStartCenter' + challenge.id!.toString(),
            center: LatLng(challenge.startLat!, challenge.startLon!),
            radius: 30,
            color: Color(0xff0EE6F3),
          ),
        )
        .toList();

    List<CircleOverlay> outerCircles = controller.allChallengesList.map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeStart' + challenge.id!.toString(),
            center: LatLng(challenge.startLat!, challenge.startLon!),
            radius: challenge.startRadius!,
            color: Color.fromRGBO(14, 230, 243, 0.3),
          ),
        )
        .toList();

    return [...centerCircles];
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    List<CircleOverlay> centerCircles = controller.allChallengesList
        .map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeEndCenter' + challenge.id!.toString(),
            center: LatLng(challenge.endLat!, challenge.endLon!),
            radius: 30,
            color: Colors.red,
          ),
        )
        .toList();

    List<CircleOverlay> outerCircles = controller.allChallengesList
        .map(
          (challenge) => CircleOverlay(
            overlayId: 'ChallengeStart' + challenge.id!.toString(),
            center: LatLng(challenge.endLat!, challenge.endLon!),
            radius: challenge.startRadius!,
            color: Colors.red[100],
          ),
        )
        .toList();

    return [...centerCircles];
  }

  List<Marker> renderMarker(ActivityController controller) {
    List<Marker> markers = controller.allChallengesList
        .map(
          (challenge) => Marker(
              markerId: challenge.id!.toString(),
              position: LatLng(challenge.startLat!, challenge.startLon!),
              captionText: challenge.startPointName,
              captionColor: Colors.indigo,

              // captionTextSize: 12.0,
              // alpha: 0.8,
              captionOffset: 5,
              // //icon: image,
              // anchor: AnchorPoint(0.5, 1),
              width: 20,
              height: 20,
              // infoWindow: '인포 윈도우',
              onMarkerTab: (Marker? marker, Map<String, int?> iconSiz) {
                print('111111');
                controller.showEndPointMarker(challenge);
              }
      ),
    )
        .toList();
    return [...markers];
  }

  Widget _renderChallengePoint(ChallengeHierarchyModel challenge) {
    return ExpansionTile(
      //leading: Icon(list.icon!),
      title: Text(
        challenge.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      children: challenge.course.map(_renderCourse).toList(),
    );
  }

  Widget _renderCourse(ChallengeModel course) {
    return Builder(
        builder: (context) {
          return ListTile(
              onTap:() => {},
              leading: SizedBox(),
              title: Text(course.startPointName!, style: TextStyle(color: Colors.white),)
          );
        }
    );;
  }

  Widget _renderChallenges(ActivityController controller) {
    List<ChallengeHierarchyModel> challenges = controller.hierarchyChallengesList;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: challenges.length,
      itemBuilder: (BuildContext context, int index) =>
          _renderChallengePoint(challenges[index]),
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
        animationDurationExtend: Duration(milliseconds: 500),
        animationDurationContract: Duration(milliseconds: 250),

        //optional; default: Curves.ease
        //The curves of the animations.
        animationCurveExpand: Curves.ease,
        animationCurveContract: Curves.ease,

        //optional
        //The content extend will be at least this height. If the content
        //height is smaller than the persistentContentHeight it will be
        //animated on a height change.
        //You can use it for example if you have no header.
        //persistentContentHeight: 150,

        //required
        //This is the widget which will be overlapped by the bottom sheet.
        background: Container(
          child: Obx(() {
            print('체인지 #############');
            return Stack(
              children: [
                NaverMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.currentLocation.value.latitude ?? 0, controller.currentLocation.value.longitude ?? 0),
                    zoom: 14,
                  ),
                  markers: controller.challengeMarkers.value,
                  //markers: [...renderMarker(controller)],
                  mapType: MapType.Navi,
                  nightModeEnable: true,
                  tiltGestureEnable: false,
                  onMapCreated: controller.onChallengeMapCreated,
                ),
                Positioned(
                  top: 50,
                  left: 15,
                  child: StyledText('뒤로', color: Colors.white,)
                )              ],
            );
          }),
        ),

        //optional
        //This widget is sticking above the content and will never be contracted.
        persistentHeader: Container(
          color: Colors.orange,
          height: 20,
          child: const Center(
            child: SizedBox(
              width: 50,
              child: Divider(
                thickness: 5,
              ),
            ),
          ),
        ),

        //required
        //This is the content of the bottom sheet which will be extendable by dragging.
        expandableContent: Container(
          height: MediaQuery.of(context).size.height - 200,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _renderChallenges(controller)
              ],
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