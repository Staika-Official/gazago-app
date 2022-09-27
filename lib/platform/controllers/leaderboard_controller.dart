import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  RxList<RankerModel> rankerList = RxList.empty();
  RxString selectedDate = RxString('2022-09-21');

  @override
  void onInit() {
    getRankerList();
    super.onInit();
  }

  void getRankerList() async {
    rankerList.value = await DashboardService.getDailyRankingList(selectedDate.value);
  }

  //TODO. 콜백 가능한 방법 찾아서 적용할 것 => https://pub.dev/packages/syncfusion_flutter_datepicker 참고해볼만한 것으로 생각됨.
  void showCalendar(BuildContext context) {
    showDatePicker(context: context, firstDate: DateTime(2022, 9, 1), lastDate: DateTime.now(), initialDate: DateTime.now());
  }
}
