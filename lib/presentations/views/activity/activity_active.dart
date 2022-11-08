import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/presentations/components/circular_button.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/activity/activity_map.dart';
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
          color: const Color(0xff585858),
        );
      }

      gaugeList.add(gauge);
    }
    return gaugeList;
  }

  double calculateGaugePosition(BoxConstraints constraints, double speed) {
    double spaceLeft = constraints.maxWidth - (60 * 3);
    double spacesBetweenBars = spaceLeft / 59;
    int barStep = (speed > 15 ? 15 : speed / 0.25).floor();

    if (barStep < 2) {
      return 0.5;
    } else {
      return (3 + spacesBetweenBars) * (barStep - 1) + 0.5;
    }
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
              height: 42,
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
                                            Radius.circular(42),
                                          ),
                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? LayoutBuilder(builder: (context, constraints) {
                                              return Container(
                                                width: stat.currentStat > 20
                                                    ? constraints.maxWidth / (100 / stat.currentStat)
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
                                                    Radius.circular(42),
                                                  ),
                                                ),
                                              );
                                            })
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
                                        ),
                                      ),
                                      stat.currentStat > 1.0
                                          ? LayoutBuilder(builder: (context, constraints) {
                                              return Container(
                                                width: stat.currentStat > 20
                                                    ? constraints.maxWidth / (100 / stat.currentStat)
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
                                                ),
                                              );
                                            })
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
                            fontWeight: 800,
                            fontSize: 15,
                            lineHeight: 15,
                            color: stat.currentStat < 20 ? Colors.white : Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: StyledText(
                              stat.currentStat.toString(),
                              fontWeight: 800,
                              fontSize: 14,
                              lineHeight: 15,
                              color: stat.currentStat < 20 ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          stat.type == 'STAMINA'
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF606167),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(42),
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
                                    radius: 19,
                                    backgroundColor: const Color(0xFFCDFF41),
                                    child: IconButton(
                                      icon: iconPlus,
                                      splashRadius: 19,
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
                                    radius: 19,
                                    backgroundColor: const Color(0xFFB85DFF),
                                    child: IconButton(
                                      icon: iconPlus,
                                      splashRadius: 15,
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

    return DefaultContainer(
      onBackButtonTap: () {
        Get.offNamed(Routes.home);
      },
      titleWidget: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: controller.exerciseStateColor.value,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            StyledText(
              (controller.realTimeSpeed.value < 1 || controller.realTimeSpeed.value > 6) && controller.exerciseState.value == ExerciseState.ongoing
                  ? controller.exerciseState.value.label + ' (보상 불가)'
                  : controller.exerciseState.value.label,
              fontSize: 18,
              lineHeight: 18,
              fontWeight: 500,
              color: controller.exerciseStateColor.value,
            )
          ],
        );
      }),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(() {
            return Container(
              child: controller.selectedChallenge.value.id != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xff1b1b1b),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: StyledText(
                        '${controller.selectedChallenge.value.firstName} | ${controller.selectedChallenge.value.secondName}',
                        fontSize: 14,
                        fontWeight: 500,
                        color: const Color(0xff8a8a8a),
                      ),
                    )
                  : Container(),
            );
          }),
          // TODO. qa후 삭제 필요.
          // StyledText(
          //     '현재 위치의 gps정확도: ${formatDecimalPlaces(controller.currentLocation.value.accuracy, 2)}m [속도: ${formatDecimalPlaces(convertMStoKMH(controller.currentLocation.value.speed), 2)}km/h]'),
          // if (controller.exerciseData.isNotEmpty) StyledText('저장된 운동데이터 배열에서 마지막 데이터의 속도: ${formatDecimalPlaces(controller.exerciseData.last.speed!, 2)}km/h'),
          // StyledText('평균 속도: ${formatDecimalPlaces(controller.avgSpeed.value, 2)}km/h'),
          // StyledText('평균 속도: ${formatDecimalPlaces(controller.realTimeSpeed.value, 2)}km/h'),
          // StyledText('성공적인 업데이트 요청 (시작/종료 제외): ${controller.updateCount.value.toString()}회'),
          // StyledText('마지막 업데이트 시간: ${controller.lastUpdateTime.value != '' ? formatDate(controller.lastUpdateTime.value) : '??'}'),
          // StyledText('걷기 상태: ${controller.pedestrianStatus.value}'),
          // TODO. qa후 삭제 필요 end.
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20),
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
                    child: AnimatedFlipCounter(
                      value: controller.userState.value.exercise != null ? controller.userState.value.exercise!.rewardGo! : 0,
                      duration: const Duration(milliseconds: 500),
                      fractionDigits: 2,
                      thousandSeparator: ',',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 50,
                        height: 1,
                        fontFamily: 'Monserrat',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 3.0),
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
            );
          }),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xff1F2129),
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
                            ...renderGauge(controller.exerciseStateColor.value),
                          ],
                        ),
                        Positioned(
                          top: -26,
                          left: calculateGaugePosition(constraints, controller.realTimeSpeed.value),
                          child: GaugeCursor(
                            color: controller.exerciseStateColor.value,
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
                                padding: EdgeInsets.only(left: 3),
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
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 60,
              bottom: 25,
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
                              '${formatDecimalPlaces(controller.totalDistance.value, 2)}km',
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
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Obx(() {
              return Column(
                children: [
                  ...renderStatList(controller, context),
                ],
              );
            }),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, bottom: 100),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularButton(
                        radius: 50,
                        color: Colors.white,
                        onTap: () => controller.showExerciseMap(const ActivityMap()),
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_map.svg',
                        ),
                      ),
                      [ExerciseState.ongoing].any((state) => controller.exerciseState.value == state)
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTapDown: (tapDownDetail) => controller.onTapDownStop(tapDownDetail, controller.selectedChallenge.value),
                                  onTapUp: (tapUpDetail) => controller.onTapUpStop(tapUpDetail),
                                  child: Stack(
                                    children: [
                                      const CircularButton(
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
                                          padding: const EdgeInsets.all(5),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 6,
                                            color: const Color(0xff0ee6f3),
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
                                    color: const Color(0xffFF2222),
                                    onTap: () => controller.pauseExercise(),
                                    child: const Icon(Icons.pause, color: Colors.white, size: 35),
                                  ),
                                )
                              ],
                            )
                          : CircularButton(
                              radius: 90,
                              color: const Color(0xffFF2222),
                              onTap: () {
                                if (controller.exerciseState.value == ExerciseState.paused) {
                                  controller.continueExercise();
                                } else {
                                  controller.startExercise(controller.selectedExerciseType.value, controller.selectedChallenge.value);
                                }
                              },
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 35),
                            ),
                      CircularButton(
                        radius: 50,
                        color: Colors.white,
                        onTap: () {
                          Get.toNamed(Routes.equippedItems);
                        },
                        child: SvgPicture.asset(
                          'assets/images/activity/ico_item.svg',
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
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
