import 'dart:async';

import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStatisticsController extends GetxController {
  RxList<UserRewardStatisticsModel> userMonthlyRewardList = RxList.empty();
  CalendarFormat calendarFormat = CalendarFormat.month;
  Rx<DateTime?> today = Rx(DateTime.now());
  Rx<DateTime?> firstDay = Rx(DateTime.utc(2022, 1, 1));
  Rx<DateTime?> lastDay = Rx(DateTime.utc(2050, 12, 31));
  RxMap<String, List<UserRewardStatisticsModel>> userMonthlyRewardMap = RxMap();
  Rx<double> total = Rx(0.0);

  StreamController<RxMap> streamController = StreamController();

  RxInt size = RxInt(20);

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  void calendarChanged(focusedDay) {
    today.value = focusedDay;
    String month = DateFormat('yyyy-MM').format(focusedDay);
    getCalendarStatistics(month);
  }

  Future<void> initController() async {
    streamController.add(userMonthlyRewardMap);
    String month = DateFormat('yyyy-MM').format(today.value!);
    getCalendarStatistics(month);
  }

  void getCalendarStatistics(month) async {
    await DashboardService.getUserRewardStatistics(
      'monthly',
      month,
      successCallback: (list) {
        total.value = 0;
        for (var item in list) {
          userMonthlyRewardMap[item.date!] = [item];
          total.value += item.tik;
        }
        streamController.add(userMonthlyRewardMap);
      },
    );
  }

  List<UserRewardStatisticsModel> findCalendarStatisticsData(date) {
    String day = DateFormat('yyyy-MM-dd').format(date);
    if (userMonthlyRewardMap[day] != null) {
      return userMonthlyRewardMap[day]!;
    }
    return [];
  }
}
