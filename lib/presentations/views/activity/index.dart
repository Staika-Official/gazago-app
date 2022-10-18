import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ActivityHome extends StatelessWidget {
  ActivityHome({Key? key}) : super(key: key);

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
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 0),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
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

  List<Widget> renderActivitySumList(ActivityController controller) {
    return controller.activitySumList
        .map(
          (activitySum) => Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 2.0, bottom: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF363841),
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF000000),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(2, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                color: const Color(0xFF363841),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: Color(0xFF1D1D21),
                        child: activitySum['icon'],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: StyledText(
                          activitySum['title'],
                          fontSize: 13,
                          color: Color(0xFF7A7A7A),
                          fontWeight: 600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            StyledText(
                              activitySum['content'],
                              fontSize: 20,
                              fontWeight: 700,
                            ),
                            StyledText(
                              activitySum['unit'],
                              fontSize: 13,
                              fontWeight: 500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ActivityController controller = Get.find();

    final slideController = PageController(viewportFraction: 1, keepPage: true);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_activity_road.png'),
          alignment: Alignment(100, 1.5),
        ),
      ),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                    margin: const EdgeInsets.symmetric(vertical: 25),
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
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          iconActivityTokenGo,
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StyledText(
                                  'Today',
                                  fontFamily: 'Montserrat',
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
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontWeight: 600,
                                        fontSize: 30,
                                        lineHeight: 34,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2.0, right: 5.0),
                                        child: StyledText(
                                          'GO',
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontWeight: 500,
                                          fontSize: 18,
                                          lineHeight: 26,
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
              Obx(() {
                return Column(
                  children: [
                    ...renderStatList(controller, context),
                  ],
                );
              }),
              // TODO. 추후 나의 운동 스토리의 위치가 확정되면 아래 주석처리 된 소스를 이동하도록 한다.
              // Padding(
              //   padding: const EdgeInsets.only(top: 40.0),
              //   child: StyledText(
              //     '나의 운동 스토리',
              //     color: Color(0xFF8A8A8A),
              //     fontSize: 18,
              //     fontWeight: 600,
              //   ),
              // ),
              // Obx(() {
              //   return Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.only(top: 14.0),
              //         child: SizedBox(
              //           height: 134,
              //           child: PageView.builder(
              //             controller: slideController,
              //             itemCount: renderActivitySumList(controller).length ~/ 2,
              //             itemBuilder: (_, index) {
              //               if (index == 0) {
              //                 return Row(
              //                   children: [
              //                     Expanded(child: renderActivitySumList(controller)[index]),
              //                     Expanded(child: renderActivitySumList(controller)[index + 1]),
              //                   ],
              //                 );
              //               } else {
              //                 return Row(
              //                   children: [
              //                     Expanded(child: renderActivitySumList(controller)[index + 1]),
              //                     Expanded(child: renderActivitySumList(controller)[index + 2]),
              //                   ],
              //                 );
              //               }
              //             },
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 10.0),
              //         child: SmoothPageIndicator(
              //           controller: slideController,
              //           count: renderActivitySumList(controller).length ~/ 2,
              //           effect: const ExpandingDotsEffect(
              //             dotHeight: 5, dotWidth: 5, activeDotColor: Color(0xFFA6A9B4), dotColor: Color(0xFF666870),
              //             // strokeWidth: 5,
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              // }),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Stack(
                  children: [
                    Center(
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EE6F3),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(150),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 4),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                onPressed: [ExerciseState.ongoing, ExerciseState.paused, ExerciseState.ready].any((state) => controller.exerciseState.value == state)
                                    ? () => controller.requestExerciseInitialization()
                                    : () => Get.snackbar('시작 불가', '지속적으로 문제가 발생한다면 앱을 재시작해주세요', colorText: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(150),
                                ),
                                color: const Color(0xFF0EE6F3),
                                height: 150,
                                minWidth: 150,
                                child: StyledText(
                                  [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 'Continue' : 'GO',
                                  fontWeight: 800,
                                  fontFamily: 'Montserrat',
                                  fontSize: [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 18 : 34,
                                  lineHeight: [ExerciseState.ongoing, ExerciseState.paused].any((state) => controller.exerciseState.value == state) ? 18 : 34,
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            /* ElevatedButton(
                              onPressed: () => { controller.onClickTestNoti() },
                              child: Text('확인'),
                            ),*/
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
