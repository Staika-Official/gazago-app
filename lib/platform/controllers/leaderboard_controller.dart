import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class LeaderboardController extends GetxController {
  Rx<DateTime?> selectedDate = Rx(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  Rx<DateTime?> today = Rx(DateTime.now());
  Rx<DateTime?> focusDay = Rx(DateTime.now());
  Rx<DateTime?> firstDay = Rx(DateTime.utc(2022, 1, 1));
  Rx<DateTime?> lastDay = Rx(DateTime.utc(2050, 12, 31));
  Rx<RankerModel?> myRank = Rxn<RankerModel>();
  RxList<RankerModel> rankings = RxList.empty();
  RxBool hasMore = RxBool(true);
  RxBool dataGetLoading = RxBool(false);
  RxMap<String, List<UserRewardStatisticsModel>> userMonthlyRewardMap = RxMap();
  StreamController<RxList> streamController = StreamController.broadcast();
  RxList<UserRewardStatisticsModel> dailyRewardList = RxList.empty();
  // RxList get dailyRewardList => _dailyRewardList;
  RxDouble todayTikAmount = RxDouble(0.0);

  RxDouble totalStikRewarded = RxDouble(19.9293184);
  RxDouble totalTikRewarded = RxDouble(4839679456);
  ScrollController leaderboardScrollController = ScrollController();

  RxString get formattedDate {
    return RxString(DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()).toString());
  }

  RxString get leaderboardDate {
    if (DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()) == DateFormat('yyyy-MM-dd').format(today.value!.toLocal())) {
      return RxString('TODAY');
    }
    return RxString(DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()).toString());
  }

  RxString get checkRewardDate {
    if (DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()) == DateFormat('yyyy-MM-dd').format(today.value!.toLocal())) {
      return RxString('실시간 예측 리워드');
    }
    return RxString('확정 리워드');
  }

  RxInt page = RxInt(0);
  RxInt size = RxInt(100);

  @override
  void onInit() {
    initController();
    leaderboardScrollController.addListener(() {
      double scrollBottom = leaderboardScrollController.positions.last.maxScrollExtent;
      double scrollPosition = leaderboardScrollController.positions.last.pixels;

      if (scrollPosition == scrollBottom) {
        if (hasMore.value) {
          page.value = page.value + 1;
          _fetchRankerList(false);
        }
      }
    });
    super.onInit();
  }

  Future<void> initController() async {
    _fetchMyRank();
    _fetchTodayTik();
    _fetchRankerList(true);

    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
    streamController.add(dailyRewardList);
  }

  Future<void> refreshController() async {
    selectedDate.value = DateTime.now();
    _fetchMyRank();
    _fetchRankerList(true);
    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
    streamController.add(dailyRewardList);
  }

  Future<void> _fetchRankerList(bool reset) async {
    if (reset) {
      page.value = 0;
      rankings.clear();
      hasMore.value = true;
      dataGetLoading.value = true;
    }
    await DashboardService.getDailyRankingList(formattedDate.value, page.value, size.value, successCallback: (List<RankerModel> rankingList) {
      if (rankingList.length < size.value) {
        hasMore.value = false;
      }

      rankingList.asMap().forEach((index, ranker) {
        ranker.rank = (index + 1) + (page.value * size.value);
      });
      rankings.addAll(rankingList);
      if (reset) {
        dataGetLoading.value = false;
      }
      rankings.refresh();
    });
  }

  void _fetchMyRank() {
    DashboardService.getDailyRankingMyRank(
      formattedDate.value,
      successCallback: (data) {
        myRank.value = data;
      },
    );
  }

  void _fetchTodayTik() {
    DashboardService.getTodayRewardTik(
      formattedDate.value,
      successCallback: (data) {
        todayTikAmount.value = data.rewardTik;
      },
    );
  }

  void calendarSelectedChanged(selectedDay) {
    selectedDate.value = selectedDay;
    _fetchMyRank();
    _fetchRankerList(true);
  }

  void calendarChanged(focusedDay) {
    today.value = focusedDay;
    String month = DateFormat('yyyy-MM-dd').format(focusedDay);
    getCalendarStatistics(month);
  }

  Future<void> getCalendarStatistics(month) async {
    print('aaaaaaaaaaaaaaaaaaaaaaaa');

    await DashboardService.getUserRewardStatistics(
      month,
      successCallback: (data) {
        totalTikRewarded.value = data.totalTik;
        totalStikRewarded.value = data.totalStik;

        print(data);
        dailyRewardList.clear();
        // _dailyRewardList.addAll(data.rewards);
        // print(data.rewards);
        // List<UserRewardStatisticsModel> newRewards = data.rewards;
        dailyRewardList.value = data.rewards;
        // dailyRewardList.addAll(data.rewards);

        // dailyRewardList.refresh();
        // for (var item in data.rewards) {
        //   // print(UserRewardStatisticsModel.fromJson(item));
        //   dailyRewardList.add(item);
        // }
        // dailyRewardList.add(data.rewards);
        // dailyRewardList.assignAll(data.rewards);
        // dailyRewardList.refresh();
        // streamController.add(dailyRewardList);
        // for (var item in data.rewards) {
        //   userMonthlyRewardMap[item.date!] = [item];
        // }
        // print(dailyRewardList);
        streamController.add(dailyRewardList);
        update();
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
