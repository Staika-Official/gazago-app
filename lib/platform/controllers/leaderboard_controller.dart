import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/events.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/models/user_reward_statistics_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:get_event_bus/get_event_bus.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class LeaderboardController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  HomeMenuController homeMenuController = Get.isRegistered<HomeMenuController>() ? Get.find<HomeMenuController>() : Get.put(HomeMenuController());
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
  RxBool isLoadingMore = RxBool(false);
  RxMap<String, List<UserRewardStatisticsModel>> userMonthlyRewardMap = RxMap();
  final StreamController<RxMap> streamController = StreamController.broadcast();

  RxList<UserRewardStatisticsModel> dailyRewardList = RxList.empty();
  // RxList get dailyRewardList => _dailyRewardList;
  RxDouble todayTikAmount = RxDouble(0.0);

  RxDouble totalStikRewarded = RxDouble(0.0);
  RxDouble totalTikRewarded = RxDouble(0);
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
      return RxString('실시간 랭킹');
    }
    return RxString('랭킹');
  }

  RxInt page = RxInt(0);
  RxInt size = RxInt(100);

  @override
  void onInit() {
    initController();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0)
      ..addListener(() {
        if (tabController.indexIsChanging && tabController.index == 0) {
          Get.bus.fire(SetBottomNavStateEvent(false));
        }
      });

    Get.bus.on<RefreshLeaderboardControllerEvent>((event) {
      refreshController();
    });

    Get.bus.on<SetLeaderboardTabMenuEvent>((tabEvent) {
      tabController.animateTo(tabEvent.index);
    });
    super.onInit();
  }

  @override
  void onClose() {
    leaderboardScrollController.removeListener(() {
      // loadDataOnScroll();
      toggleBottomNav(leaderboardScrollController);
    });
    super.onClose();
  }

  Future<void> initController() async {
    _fetchMyRank();
    _fetchTodayTik();
    _fetchRankerList(true);
    streamController.add(userMonthlyRewardMap);
    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
    leaderboardScrollController.addListener(() {
      loadDataOnScroll();
      toggleBottomNav(leaderboardScrollController);
    });
  }

  Future<void> refreshController() async {
    selectedDate.value = DateTime.now();
    _fetchMyRank();
    _fetchTodayTik();
    _fetchRankerList(true);
    streamController.add(userMonthlyRewardMap);
    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
  }

  Future<void> _fetchRankerList(bool reset) async {
    if (reset) {
      page.value = 0;
      rankings.clear();
      hasMore.value = true;
      dataGetLoading.value = true;
    }

    isLoadingMore.value = true;
    await DashboardService.getDailyRankingList(
      formattedDate.value,
      page.value,
      size.value,
      successCallback: (List<RankerModel> rankingList) {
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
        isLoadingMore.value = false;
      },
    );
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

  void calendarSelectedChanged(selectDay) {
    selectedDate.value = selectDay;
    _fetchMyRank();
    _fetchRankerList(true);

    Get.bus.fire(SetBottomNavStateEvent(false));
  }

  void calendarChanged(focusedDay) {
    focusDay.value = focusedDay;
    String month = DateFormat('yyyy-MM-dd').format(focusedDay);
    getCalendarStatistics(month);
  }

  void getCalendarStatistics(month) async {
    streamController.add(RxMap());
    await DashboardService.getUserRewardStatistics(
      month,
      successCallback: (data) {
        totalTikRewarded.value = data.totalTik;
        totalStikRewarded.value = data.totalStik;

        for (var item in data.rewards) {
          userMonthlyRewardMap[item.date!] = [item];
        }

        streamController.add(userMonthlyRewardMap);
      },
    );
  }

  void getCalendarStatisticsToday() {
    String month = DateFormat('yyyy-MM-dd').format(today.value!);
    getCalendarStatistics(month);
  }

  List<UserRewardStatisticsModel> findCalendarStatisticsData(date) {
    String day = DateFormat('yyyy-MM-dd').format(date);
    if (userMonthlyRewardMap[day] != null) {
      return userMonthlyRewardMap[day]!;
    }
    return [];
  }

  void loadDataOnScroll() {
    double scrollBottom = leaderboardScrollController.positions.last.maxScrollExtent;
    double scrollPosition = leaderboardScrollController.positions.last.pixels;

    if (scrollPosition == scrollBottom) {
      if (hasMore.value && !isLoadingMore.value) {
        page.value = page.value + 1;
        _fetchRankerList(false);
      }
    }
  }
}
