import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActivityHome extends StatelessWidget {
  const ActivityHome({Key? key}) : super(key: key);

  List<Widget> renderStatList(ActivityController controller) {
    return controller.statList.map((stat) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
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
                              ? LinearPercentIndicator(
                                  progressColor: const Color(0xFFCDFF41),
                                  backgroundColor: Color(0xFF606167),
                                  lineHeight: 34,
                                  animation: true,
                                  percent: stat.currentStat / 100,
                                  barRadius: const Radius.circular(50),
                                  padding: const EdgeInsets.all(0),
                                )
                              : LinearPercentIndicator(
                                  progressColor: const Color(0xFFB85DFF),
                                  backgroundColor: Color(0xFF606167),
                                  lineHeight: 34,
                                  percent: stat.currentStat / 100,
                                  barRadius: const Radius.circular(50),
                                  padding: const EdgeInsets.all(0),
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
                        children: [
                          StyledText(
                            stat.name,
                            fontWeight: 600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: StyledText(
                              stat.currentStat.toString(),
                              fontWeight: 600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          StyledText('100'),
                          stat.type == 'STAMINA'
                              ? IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.add_circle),
                                  color: Color(0xFFCDFF41),
                                  onPressed: () => {controller.onClickRepairStat(stat)},
                                )
                              : IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.add_circle),
                                  color: Color(0xFFB85DFF),
                                  onPressed: () => {controller.onClickRepairStat(stat)},
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

  List<Widget> renderActivitySumList(ActivityController controller) {
    return controller.activitySumList
        .map(
          (activitySum) => Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activitySum['title']),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(activitySum['content']),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    WalletMasterController walletMasterController = Get.find();
    ActivityController controller = Get.put(ActivityController(walletMasterController));

    controller.initController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                '가자고와 함께 \n등산하고 뱃지를 받아보자고-!',
                color: const Color(0xFF0EE6F3),
                fontWeight: 700,
                fontSize: 24,
                lineHeight: 32,
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EE6F3),
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconActivityTokenGo,
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText(
                              'Today',
                              color: Colors.black,
                              fontWeight: 500,
                              fontSize: 13,
                              lineHeight: 13,
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  StyledText(
                                    '${controller.userState.value.state != null ? controller.userState.value.state!.dailyGoReward.toString() : 0}',
                                    color: Colors.black,
                                    fontWeight: 600,
                                    fontSize: 30,
                                    lineHeight: 34,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: StyledText(
                                      'GO',
                                      color: Colors.black,
                                      fontWeight: 500,
                                      fontSize: 18,
                                      lineHeight: 20,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          return Column(
            children: [
              ...renderStatList(controller),
            ],
          );
        }),
        Obx(() {
          return GridView.count(
            childAspectRatio: 1 / .4,
            shrinkWrap: true,
            primary: false,
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: [
              ...renderActivitySumList(controller),
            ],
          );
        }),
        Expanded(
          child: Stack(
            children: [
              Center(
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: MaterialButton(
                                onPressed: null,
                                onLongPress: () => controller.endExercise(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                color: Colors.blue,
                                height: 100,
                                minWidth: 100,
                                child: Text('Stop'),
                              ),
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: [ExerciseState.ongoing, ExerciseState.paused, ExerciseState.ready].any((state) => controller.exerciseState.value == state)
                            ? () => controller.requestExerciseInitialization()
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        color: Colors.blue,
                        height: 100,
                        minWidth: 100,
                        child: Text([ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 'Continue' : 'Go'),
                      ),
                    ],
                  );
                }),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: () => null,
                  child: const Icon(Icons.terrain),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
