import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class ActivityChallenges extends StatelessWidget {
  const ActivityChallenges({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    // List<CircleOverlay> centerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStartCenter' + challenge.id!.toString(),
    //         center: LatLng(challenge.startLat!, challenge.startLon!),
    //         radius: 9,
    //         color: Color(0xff0EE6F3),
    //       ),
    //     )
    //     .toList();
    //
    // List<CircleOverlay> outerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStart' + challenge.id!.toString(),
    //         center: LatLng(challenge.startLat!, challenge.startLon!),
    //         radius: challenge.startRadius!,
    //         color: Color.fromRGBO(14, 230, 243, 0.3),
    //       ),
    //     )
    //     .toList();
    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeStartCenter' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: 9,
      color: Color(0xff0EE6F3),
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeStart' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.startLat!, controller.selectedChallenge.value.startLon!),
      radius: controller.selectedChallenge.value.startRadius!,
      color: Color.fromRGBO(14, 230, 243, 0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<CircleOverlay> renderEndPoint(ActivityController controller) {
    // List<CircleOverlay> centerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeEndCenter' + challenge.id!.toString(),
    //         center: LatLng(challenge.endLat!, challenge.endLon!),
    //         radius: 9,
    //         color: Colors.red,
    //       ),
    //     )
    //     .toList();
    //
    // List<CircleOverlay> outerCircles = controller.doableChallenges
    //     .map(
    //       (challenge) => CircleOverlay(
    //         overlayId: 'ChallengeStart' + challenge.id!.toString(),
    //         center: LatLng(challenge.endLat!, challenge.endLon!),
    //         radius: challenge.startRadius!,
    //         color: Colors.red[100],
    //       ),
    //     )
    //     .toList();
    //
    // return [...outerCircles, ...centerCircles];

    CircleOverlay centerCircle = CircleOverlay(
      overlayId: 'ChallengeEndCenter' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: 9,
      color: Colors.red,
    );

    CircleOverlay outerCircle = CircleOverlay(
      overlayId: 'ChallengeEnd' + controller.selectedChallenge.value.id!.toString(),
      center: LatLng(controller.selectedChallenge.value.endLat!, controller.selectedChallenge.value.endLon!),
      radius: controller.selectedChallenge.value.endRadius!,
      color: Colors.red[300]?.withOpacity(0.3),
    );

    return [centerCircle, outerCircle];
  }

  List<Widget> renderChallengeList(ActivityController controller) {
    return controller.doableChallenges.map((challenge) {
      bool isSelected = challenge.id == controller.selectedChallenge.value.id;
      return Padding(
        padding: const EdgeInsets.only(top: 23),
        child: InkWell(
          onTap: () => controller.selectChallenge(challenge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  isSelected ? 'assets/images/activity/ico_challenge_checked.svg' : 'assets/images/activity/ico_challenge_unchecked.svg',
                  width: 16,
                  height: 11,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Text(
                    '${challenge.startPointName!} - ${challenge.endPointName!}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 18 / 18,
                      color: isSelected ? Color(0xff0EE6F3) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return DefaultContainer(
      child: Obx(() {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - (controller.doableChallenges.length * 80) - (MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).viewInsets.top),
                width: MediaQuery.of(context).size.width,
                child: NaverMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.currentLocation.value.latitude ?? 0, controller.currentLocation.value.longitude ?? 0),
                    zoom: 14,
                  ),
                  circles: [
                    if (controller.selectedChallenge.value.id != null) ...renderStartPoint(controller),
                    if (controller.selectedChallenge.value.id != null) ...renderEndPoint(controller),
                  ],
                  mapType: MapType.Navi,
                  nightModeEnable: true,
                  tiltGestureEnable: false,
                  onMapCreated: controller.onChallengeMapCreated,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff363841),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        bottom: 15,
                      ),
                      child: Text(
                        '등산 시작점을 선택해주세요',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 18 / 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ...renderChallengeList(controller),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 36,
                        left: 30,
                        right: 30,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (controller.selectedChallenge.value.id != null) {
                            controller.selectExerciseType(ExerciseType.hiking);
                          } else {
                            if (!Get.isSnackbarOpen) {
                              Get.snackbar('챌린지 미선택', '시작할 챌린지를 선택해주세요', colorText: Colors.white);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xff0EE6F3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 0,
                                spreadRadius: 0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          child: Text(
                            '시작하기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 16 / 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
