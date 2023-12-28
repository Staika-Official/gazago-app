import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/calendar_statistics_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

//TODO. 삭제 예정
class CalendarStatistics extends StatelessWidget {
  const CalendarStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalendarStatisticsController controller = Get.put(CalendarStatisticsController());

    return Scaffold(

      appBar: AppBar(
        title: const StyledText(
          "TIK 획득 내역",
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: subBg01Color,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.chevron_left, size: 30.sp, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        color: subBg01Color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.w500),
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        leftChevronPadding: EdgeInsets.only(left: 60.sp),
                        rightChevronPadding: EdgeInsets.only(right: 60.sp),
                      ),
                      calendarFormat: controller.calendarFormat,
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            UserRewardStatisticsModel reward = events.first as UserRewardStatisticsModel;
                            return StyledText(
                              '+${formatDecimalPlaces(reward.tik!.toDouble(), 1)}',
                              color: tikColor,
                            );
                          }
                          return null;
                        },
                      ),
                      eventLoader: (day) {
                        return controller.findCalendarStatisticsData(day);
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                            color: skyBlueColor, shape: BoxShape.circle, border: Border.all(width: 14.sp, style: BorderStyle.solid, color: subBg01Color, strokeAlign: BorderSide.strokeAlignCenter)),
                        todayTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0.sp,
                        ),
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle: const TextStyle(color: Colors.white),
                      ),
                      onPageChanged: (focusedDay) {
                        controller.calendarChanged(focusedDay);
                      },
                    );
                  });
                }),
            Obx(() {
              return Container(
                height: 49.0.sp,
                margin: EdgeInsets.only(top: 0.sp, left: 30.sp, right: 31.sp, bottom:20.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3038),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF2E3038),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(600.sp),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const StyledText(
                      'Total',
                      color: Colors.white,
                      fontWeight: 500,
                      fontSize: 18,
                      lineHeight: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.sp, right: 5.sp),
                      child: iconCalendarStatisticsTokenTik,
                    ),
                    StyledText(
                      '${formatDecimalPlaces(controller.totalTik.value, 0)} TIK',
                      color: tikColor,
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
