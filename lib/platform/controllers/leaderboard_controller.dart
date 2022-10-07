import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:gaza_go/platform/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaderboardController extends GetxController {
  RxList<RankerModel> rankerList = RxList.empty();
  Rx<DateTime?> selectedDate = Rx(DateTime.now());
  RxString get formattedDate {
    return RxString(DateFormat('yyyy-MM-dd').format(selectedDate.value!.toLocal()).toString());
  }

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  Future<void> initController() async {
    getRankerList();
  }

  void getRankerList() async {
    rankerList.value = await DashboardService.getDailyRankingList(formattedDate.value);
  }

  //TODO. 콜백 가능한 방법 찾아서 적용할 것 => https://pub.dev/packages/syncfusion_flutter_datepicker 참고해볼만한 것으로 생각됨.
  void showCalendar(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(2022, 9, 1), lastDate: DateTime.now(), initialDate: selectedDate.value!);
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      getRankerList();
    }
  }
}
