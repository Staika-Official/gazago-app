import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/models/ranker_model.dart';

class LeaderboardController extends GetxController {
  RxList<RankerModel> rankerList = RxList.empty();

  @override
  void onInit() {
    getRankerList();
    super.onInit();
  }

  void getRankerList() {
    rankerList.value = [
      RankerModel(place: '1', nickname: '하이루', profileImageUrl: 'https://placeimg.com/20/20/any', goBalance: 5600, tikBalance: 200),
      RankerModel(place: '2', nickname: '하이루2', profileImageUrl: 'https://placeimg.com/20/20/any', goBalance: 3000, tikBalance: 120),
      RankerModel(place: '3', nickname: '하이루3', profileImageUrl: 'https://placeimg.com/20/20/any', goBalance: 2400, tikBalance: 30),
      RankerModel(place: '4', nickname: '하이루4', profileImageUrl: 'https://placeimg.com/20/20/any', goBalance: 1100, tikBalance: 1),
    ];
  }

  //TODO. 콜백 가능한 방법 찾아서 적용할 것 => https://pub.dev/packages/syncfusion_flutter_datepicker 참고해볼만한 것으로 생각됨.
  void showCalendar(BuildContext context) {
    showDatePicker(context: context, firstDate: DateTime(2022, 9, 1), lastDate: DateTime.now(), initialDate: DateTime.now());
  }
}
