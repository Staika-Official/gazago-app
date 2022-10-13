import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivityActive extends StatelessWidget {
  const ActivityActive({Key? key}) : super(key: key);

  List<Widget> renderGauge(Color color) {
    List<Widget> gaugeList = List.empty(growable: true);
    for (int i = 0; i < 60; i++) {
      //15km / 0.25 = 60
      Widget? gauge;
      if (i > 2 && i < 24) {
        // 1 ~ 6km
        gauge = Container(
          width: 3,
          height: 21,
          color: color,
        );
      } else {
        gauge = Container(
          width: 3,
          height: 18,
          color: Color(0xff585858),
        );
      }

      gaugeList.add(gauge);
    }
    return gaugeList;
  }

  double calculateGaugePosition(BoxConstraints constraints, double speed) {
    double spaceLeft = constraints.maxWidth - (60 * 3);
    double spacesBetweenBars = spaceLeft / 59;
    int barStep = (speed / 0.25).floor();

    if (barStep < 2) {
      return 0.5;
    } else {
      return (3 + spacesBetweenBars) * (barStep - 1) + 0.5;
    }
  }

  Color getGaugeColor(double speed) {
    return speed >= 1 && speed <= 6 ? Color(0xff76FFFB) : Color(0xffFF2222);
  }

  List<Widget> renderStatList(ActivityController controller, context) {
    return controller.statList.map((stat) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 34,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: stat.type == 'STAMINA'
                              ? SizedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF606167),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(1, 0),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? Container(
                                              width: stat.currentStat > 20
                                                  ? MediaQuery.of(context).size.width / (100 / stat.currentStat)
                                                  : stat.currentStat < 2
                                                      ? 0
                                                      : 34,
                                              decoration: BoxDecoration(
                                                color: stat.currentStat < 20 ? const Color(0xFFFF2525) : const Color(0xFFCDFF41),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.black,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    offset: Offset(1, 0),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF606167),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(1, 0),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? Container(
                                              width: stat.currentStat > 20
                                                  ? MediaQuery.of(context).size.width / (100 / stat.currentStat)
                                                  : stat.currentStat < 2
                                                      ? 0
                                                      : 34,
                                              decoration: BoxDecoration(
                                                color: stat.currentStat < 20 ? const Color(0xFFFF2525) : const Color(0xFFB85DFF),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.black,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    offset: Offset(1, 0),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          stat.type == 'STAMINA'
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 13.0, right: 10),
                                  child: iconStamina,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 7),
                                  child: iconShoes,
                                ),
                          StyledText(
                            stat.name,
                            fontFamily: 'Montserrat',
                            fontWeight: 600,
                            fontSize: 14,
                            lineHeight: 14,
                            color: stat.currentStat < 20 ? Colors.white : Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: StyledText(
                              stat.currentStat.toString(),
                              fontWeight: 600,
                              fontSize: 13,
                              lineHeight: 14,
                              color: stat.currentStat < 20 ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: StyledText(
                              '100',
                              color: const Color(0xFF494A51),
                              fontSize: 14,
                              fontWeight: 600,
                            ),
                          ),
                          stat.type == 'STAMINA'
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF606167),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 2),
                                        blurRadius: 4.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: const Color(0xFFCDFF41),
                                    child: IconButton(
                                      icon: iconPlus,
                                      onPressed: () => {controller.onClickRepairStat(stat)},
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF606167),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 2),
                                        blurRadius: 4.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Color(0xFFB85DFF),
                                    child: IconButton(
                                      icon: iconPlus,
                                      onPressed: () => {controller.onClickRepairStat(stat)},
                                    ),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    return Obx(() {
      return DefaultContainer(
        backgroundColor: Color(0xff2A2B33),
        onBackButtonTap: () {
          Get.offNamed(Routes.home);
        },
        titleText: controller.exerciseState.value.label,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/common/ico_token_go.svg',
                    width: 36,
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: StyledText(
                      '+${(controller.userState.value.exercise != null ? controller.userState.value.exercise!.rewardGo : 0).toString()}',
                      fontWeight: 600,
                      fontSize: 50,
                      lineHeight: 50,
                      fontFamily: 'Monserrat',
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: StyledText(
                      'GO',
                      fontWeight: 500,
                      fontSize: 35,
                      lineHeight: 35,
                      fontFamily: 'Monserrat',
                      color: Color(0xff8a8a8a),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Color(0xff1F2129),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Obx(() {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...renderGauge(getGaugeColor(controller.realTimeSpeed.value)),
                            ],
                          ),
                          Positioned(
                            top: -26,
                            left: calculateGaugePosition(constraints, controller.realTimeSpeed.value),
                            child: GaugeCursor(
                              color: getGaugeColor(controller.realTimeSpeed.value),
                              speed: controller.realTimeSpeed.value,
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: (constraints.maxWidth / 60) * 8,
                            child: Row(
                              children: const [
                                StyledText(
                                  '1-6',
                                  color: Color(0xff8a8a8a),
                                  fontSize: 14,
                                  lineHeight: 12,
                                  fontWeight: 700,
                                  fontFamily: 'Monserrat',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: StyledText(
                                    'km/h',
                                    color: Color(0xff8a8a8a),
                                    fontSize: 12,
                                    lineHeight: 12,
                                    fontWeight: 500,
                                    fontFamily: 'Monserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
                  }),
                )),
            Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 30,
                bottom: 20,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SvgPicture.asset('assets/images/activity/ico_time.svg'),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: StyledText(
                                formatSeconds(controller.exerciseTime.value),
                                fontWeight: 600,
                                fontSize: 16,
                                lineHeight: 16,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SvgPicture.asset('assets/images/activity/ico_distance.svg'),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: StyledText(
                                formatDecimalPlaces(controller.totalDistance.value, 2) + 'km',
                                fontWeight: 600,
                                fontSize: 16,
                                lineHeight: 16,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth / 3,
                        child: Column(
                          children: [
                            SvgPicture.asset('assets/images/activity/ico_step.svg'),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: StyledText(
                                controller.exerciseSteps.value.toString(),
                                fontWeight: 600,
                                fontSize: 16,
                                lineHeight: 16,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                });
              }),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
              ),
              child: Column(
                children: [
                  ...renderStatList(controller, context),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, bottom: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularButton(
                        radius: 50,
                        color: Colors.white,
                        onTap: () => controller.showExerciseMap(ActivityMap()),
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_map.svg',
                        ),
                      ),
                      [ExerciseState.ongoing].any((state) => controller.exerciseState.value == state)
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail),
                                  onTapUp: (tapUpDetail) => controller.onTapUpStop(tapUpDetail),
                                  child: Stack(
                                    children: [
                                      CircularButton(
                                        radius: 78,
                                        color: Colors.white,
                                        child: Icon(Icons.stop, color: Colors.black, size: 35),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 78,
                                          height: 78,
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 6,
                                            color: Color(0xff0ee6f3),
                                            value: controller.stopProgress.value,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 11),
                                  child: CircularButton(
                                    radius: 78,
                                    color: Color(0xffFF2222),
                                    onTap: () => controller.pauseExercise(),
                                    child: Icon(Icons.pause, color: Colors.white, size: 35),
                                  ),
                                )
                              ],
                            )
                          : CircularButton(
                              radius: 90,
                              color: Color(0xffFF2222),
                              onTap: () {
                                if (controller.exerciseState.value == ExerciseState.paused) {
                                  controller.continueExercise();
                                } else {
                                  controller.startExercise(controller.selectedExerciseType.value, controller.selectedChallenge.value);
                                }
                              },
                              child: Icon(Icons.play_arrow, color: Colors.white, size: 35),
                            ),
                      CircularButton(
                        radius: 50,
                        color: Colors.white,
                        onTap: () {
                          Get.snackbar('[기능 구현 필요]', '구현 예정인 기능입니다.', colorText: Colors.white);
                        },
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_item.svg',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         '평균속도: ' + formatDecimalPlaces(controller.avgSpeed.value, 1) + 'km/h',
            //         style: TextStyle(fontSize: 16),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}

class GaugeCursor extends StatelessWidget {
  final Color color;
  final double speed;

  const GaugeCursor({Key? key, required this.color, required this.speed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: -5,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Container(
              width: 2,
              height: 12,
              color: color,
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: Row(
              children: [
                StyledText(
                  formatDecimalPlaces(speed, 1),
                  color: color,
                  fontSize: 14,
                  lineHeight: 12,
                  fontWeight: 700,
                  fontFamily: 'Monserrat',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: StyledText(
                    'km/h',
                    color: color,
                    fontSize: 12,
                    lineHeight: 12,
                    fontWeight: 500,
                    fontFamily: 'Monserrat',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ActivityMap extends StatelessWidget {
  const ActivityMap({Key? key}) : super(key: key);

  List<CircleOverlay> renderStartPoint(ActivityController controller) {
    return controller.challengeList
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
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
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
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
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
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
        .where((challenge) => challenge.id == controller.userState.value.exercise?.challengeId)
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

    return Stack(
      children: [
        NaverMap(
          nightModeEnable: true,
          mapType: MapType.Navi,
          initialCameraPosition: CameraPosition(
            target: LatLng(controller.currentLocation.value.latitude ?? 0, controller.currentLocation.value.longitude ?? 0),
            zoom: 15,
          ),
          initLocationTrackingMode: LocationTrackingMode.Follow,
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
          maxZoom: 20,
          minZoom: 8,
          tiltGestureEnable: false,
        ),
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: Color(0xff363841),
                  border: Border.all(width: 2, style: BorderStyle.solid, color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 4),
                      color: Colors.black,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(14)),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }
}
