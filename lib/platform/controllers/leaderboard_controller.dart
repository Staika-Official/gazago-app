import 'package:flutter/material.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  RxList<RankerModel> rankerList = RxList.empty();

  @override
  void onInit() {
    getRankerList();
    super.onInit();
  }

  void getRankerList() {
    rankerList.value = [
      RankerModel(nickname: '하이루', profileImageUrl: 'https://placeimg.com/20/20/any', rewardGo: 5600, rewardTik: 200, date: '2022-09-09'),
      RankerModel(nickname: '하이루2', profileImageUrl: 'https://placeimg.com/20/20/any', rewardGo: 3000, rewardTik: 120, date: '2022-09-09'),
      RankerModel(nickname: '하이루3', profileImageUrl: 'https://placeimg.com/20/20/any', rewardGo: 2400, rewardTik: 30, date: '2022-09-09'),
      RankerModel(nickname: '하이루4', profileImageUrl: 'https://placeimg.com/20/20/any', rewardGo: 1100, rewardTik: 1, date: '2022-09-09'),
    ];
  }

  //TODO. 콜백 가능한 방법 찾아서 적용할 것 => https://pub.dev/packages/syncfusion_flutter_datepicker 참고해볼만한 것으로 생각됨.
  void showCalendar(BuildContext context) {
    showDatePicker(context: context, firstDate: DateTime(2022, 9, 1), lastDate: DateTime.now(), initialDate: DateTime.now());
  }
}
