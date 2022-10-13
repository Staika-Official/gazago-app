import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/calendar_statistics_controller.dart';
import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStatistics extends StatelessWidget {
  const CalendarStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalendarStatisticsController controller = Get.put(CalendarStatisticsController());


    return Scaffold(
      appBar: AppBar(
        title: Text("TIK 획득 내역"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D1D26),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.chevron_left, size: 30,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF1D1D26),
        child: Column(
          children: [
            StreamBuilder<RxMap>(
              stream: controller.streamController.stream,
              builder: (context, snapshot) {
                return Obx(() {
                  return TableCalendar(
                    locale: 'ko-KR',
                    firstDay: controller.firstDay.value!,
                    lastDay: controller.lastDay.value!,
                    focusedDay: controller.today.value!,
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white,),
                      leftChevronPadding: EdgeInsets.only(left: 60, top: 10, bottom: 10),
                      rightChevronPadding: EdgeInsets.only(right: 60, top: 10, bottom: 10),
                    ),
                    calendarFormat: controller.calendarFormat,
                    calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            UserRewardStatisticsModel reward = events.first as UserRewardStatisticsModel;
                            return StyledText(reward.tik.toString(), color: Colors.red,);
                          }
                          return null;
                        }
                    ),
                    eventLoader: (day) {
                      return controller.findCalendarStatisticsData(day);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: const Color(0xFF0EE6F3),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 14,
                              style: BorderStyle.solid,
                              color: const Color(0xFF1D1D26),
                              strokeAlign: StrokeAlign.center
                          )
                      ),
                      todayTextStyle:  const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      defaultTextStyle: const TextStyle(
                          color: Colors.white
                      ),
                      weekendTextStyle: const TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPageChanged: (focusedDay) {
                      controller.calendarChanged(focusedDay);
                    },
                  );
                });
              }
            ),
            Obx(() {
              return Container(
                height: 49.0,
                margin: const EdgeInsets.only(top: 38, left: 77, right: 76),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3038),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF2E3038),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(600),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText(
                      'Total',
                      color: Colors.white,
                      fontWeight: 500,
                      fontSize: 18,
                      lineHeight: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 5),
                      child: iconCalendarStatisticsTokenTik,
                    ),
                    StyledText(
                      '${controller.total.value.toString()} TIK',
                      color: const Color(0xFFFF8FB4),
                      fontWeight: 600,
                      fontSize: 18,
                      lineHeight: 20,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
