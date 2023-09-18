import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/new_challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController with GetTickerProviderStateMixin, ChallengeMixin {
  ScrollController challengesScrollController = ScrollController();

  final RxList<NewChallengeModel> challengeList = RxList.empty();
  final List<Map<String, String>> sortingList = [
    {'title': '전체', 'value': 'id,DESC'},
    {'title': '참여가능', 'value': 'price,DESC'},
    {'title': '참여 중', 'value': 'price,ASC'},
    {'title': '종료', 'value': 'price,ASC'}
  ];
  Rx<DateTime?> today = Rx(DateTime.now());
  final List<Map<String, String>> exerciseTypeFilterList = [
    {'title': '걷기', 'value': 'WALKING'},
    {'title': '오르기', 'value': 'HIKING'},
  ];
  RxList selectedStatus = RxList.empty(growable: true);
  RxList filteredStatus = RxList.empty(growable: true);

  RxBool isSelectAllItems = RxBool(true);
  RxBool isFilteredItems = RxBool(false);
  RxBool dataGetLoading = RxBool(false);

  Rx isSelectedSortValue = Rx({'title': '전체', 'value': 'id,DESC'});
  RxString isSelectedSortString = RxString('전체');

  @override
  void onInit() async {
    await getChallengesList();
    super.onInit();
  }

  Future<void> refreshController() async {
    challengeList.value = RxList.empty();
    await getChallengesList();
  }

  Future<void> getChallengesList() async {
    dataGetLoading.value = true;
    challengeList.clear();
    await ActivityService.getNewChallenges(successCallback: (List<NewChallengeModel> data) {
      challengeList.addAll(data);
      List<int> challengeListIds = challengeList.map((element) => element.id).toSet().toList();
      HiveStore.save(key: HiveKey.challengeListIds.name, value: challengeListIds);
      dataGetLoading.value = false;
    }, errorCallback: () {
      dataGetLoading.value = false;
    });
  }

  void moveToDetail(id) {
    Get.toNamed(Routes.challengeDetail.replaceAll(':id', id.toString()));
  }

  void showChallengesSortingPopup() {
    challengesSortListAlert(this);
  }

  void showChallengesFilterPopup() {
    challengesFilterListAlert(this);
  }

  void onClickSortingMenu(checkedData) {
    isSelectedSortValue.value = checkedData;
  }

  void closeSortingMenu() {
    isSelectedSortValue.value = sortingList[0];
    Get.back();
  }

  void onClickConfirmSortValue(confirmData) {
    isSelectedSortString.value = confirmData['title'];
    // getShopItemsList();
    Get.back();
  }

  void onClickConfirmFilterValue() {
    // getShopItemsList();
    Get.back();
  }

  void closeItemFilterPopup() {
    List newFilteredStatus = [...filteredStatus];

    if (isFilteredItems.value) {
      selectedStatus.value = newFilteredStatus;

      isSelectAllItems.value = false;
    } else {
      initItemsFilter();
    }

    Get.back();
  }

  void initItemsFilter() {
    selectedStatus.value = [];
    isSelectAllItems.value = true;
  }

  void onSelectCategory(category) {
    isSelectAllItems.value = false;
    if (selectedStatus.any((element) => element == category)) {
      selectedStatus.removeWhere((item) => item == category);
    } else {
      selectedStatus.add(category);
    }

    if (selectedStatus.isEmpty) isSelectAllItems.value = true;
  }

  void onSelectAllItems() {
    initItemsFilter();
    isSelectAllItems.value = true;
  }
}
