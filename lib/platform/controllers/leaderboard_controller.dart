import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/daily_reward_model.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
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
  RxList<DailyRewardModel> dailyRewardList = RxList(
    [
      DailyRewardModel(
        id: 1,
        rewardedDate: DateTime(2023, 2, 6),
        stikAmount: 100,
        tikAmount: 500000,
      ),
      DailyRewardModel(
        id: 2,
        rewardedDate: DateTime(2023, 2, 7),
        stikAmount: 20,
        tikAmount: 1000000,
      ),
      DailyRewardModel(
        id: 3,
        rewardedDate: DateTime(2023, 2, 10),
        stikAmount: 300,
        tikAmount: 10000,
      ),
    ],
  );
  RxInt todayTikAmount = RxInt(59456);

  RxDouble totalStikRewarded = RxDouble(19.9293184);
  RxInt totalTikRewarded = RxInt(4839679456);
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
    _fetchRankerList(true);
  }

  Future<void> refreshController() async {
    selectedDate.value = DateTime.now();
    _fetchMyRank();
    _fetchRankerList(true);
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

  void calendarSelectedChanged(selectedDay) {
    selectedDate.value = selectedDay;
    _fetchMyRank();
    _fetchRankerList(true);
  }
}
