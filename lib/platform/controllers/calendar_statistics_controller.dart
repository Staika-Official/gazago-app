import 'dart:async';

import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// TODO. 삭제 예정
class CalendarStatisticsController extends GetxController {
  RxList<UserRewardStatisticsModel> userMonthlyRewardList = RxList.empty();
  CalendarFormat calendarFormat = CalendarFormat.month;
  Rx<DateTime?> today = Rx(DateTime.now());
  Rx<DateTime?> firstDay = Rx(DateTime.utc(2022, 1, 1));
  Rx<DateTime?> lastDay = Rx(DateTime.utc(2050, 12, 31));
  RxMap<String, List<UserRewardStatisticsModel>> userMonthlyRewardMap = RxMap();
  Rx<double> totalTik = Rx(0.0);
  Rx<double> totalStik = Rx(0.0);

  StreamController<RxMap> streamController = StreamController();

  RxInt size = RxInt(20);

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  void calendarChanged(focusedDay) {
    today.value = focusedDay;
    String month = DateFormat('yyyy-MM-dd').format(focusedDay);
    getCalendarStatistics(month);
  }

  Future<void> initController() async {
    streamController.add(userMonthlyRewardMap);
    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
  }

  void getCalendarStatistics(month) async {
    print('asdasdasdasdasds');
    await DashboardService.getUserRewardStatistics(
      month,
      successCallback: (list) {
        totalTik.value = 0;
        print(list);

        for (var item in list) {
          userMonthlyRewardMap[item.date!] = [item];
          totalTik.value += item.tik;
          totalStik.value += item.stik;
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
