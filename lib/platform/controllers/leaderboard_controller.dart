import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

  RxString get formattedDate {
    return RxString(DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()).toString());
  }
  RxString get leaderboardDate {
    return RxString(DateFormat('yyyy.MM.dd').format(selectedDate.value!.toLocal()).toString());
  }
  RxInt size = RxInt(100);

  final PagingController<int, RankerModel> pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 10);

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> initController() async {
    _fetchMyRank();

    pagingController.addPageRequestListener((pageKey) {
      _fetchRankerList(pageKey);
    });
  }

  Future<void> refreshController() async {
    selectedDate.value = DateTime.now();
    _fetchMyRank();
    pagingController.itemList = [];
    _fetchRankerList(0);
  }

  Future<void> _fetchRankerList(int page) async {
    print('_fetchPage page: ${page} size: ${size.value}');
    try {
      List<RankerModel> rankingList = await DashboardService.getDailyRankingList(formattedDate.value, page, size.value);
      rankingList.asMap().forEach((index, ranker) {
        ranker.rank = (index + 1) + (page * size.value);
      });

      final isLastPage = rankingList.length < size.value;
      if (isLastPage) {
        pagingController.appendLastPage(rankingList);
      } else {
        final newPage = page + 1;
        pagingController.appendPage(rankingList, newPage);
      }
    } catch (error) {
      print(error);
      pagingController.error = error;
    }
  }

  void _fetchMyRank() {
    DashboardService.getDailyRankingMyRank(formattedDate.value).then((data) {
      myRank.value = data;
      print(myRank.value?.profileImageUrl);
    });
  }

  void showCalendar(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(2022, 9, 1), lastDate: DateTime.now(), initialDate: selectedDate.value!);
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      _fetchMyRank();
    }
  }

  goPageCalendarStatistics() {
    Get.toNamed(Routes.calendarStatistics);
  }

  void calendarSelectedChanged(selectedDay) {
    selectedDate.value = selectedDay;
    refreshController();
  }
}
