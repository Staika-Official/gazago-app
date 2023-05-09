import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController with GetTickerProviderStateMixin {
  ScrollController challengesScrollController = ScrollController();
  // ScrollController itemScrollController = ScrollController(keepScrollOffset: false);
  final RxList challengeItemsList = RxList.empty();
  final List<Map<String, String>> sortingList = [
    {'title': '전체', 'value': 'id,DESC'},
    {'title': '참여가능', 'value': 'price,DESC'},
    {'title': '참여 중', 'value': 'price,ASC'},
    {'title': '종료', 'value': 'price,ASC'}
  ];

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
  final List<Map<String, dynamic>> challengeList = [
    {
      'title': '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
      'openDate': '2023/02/01',
      'closeDate': '2023/02/28',
      'activityTypes': ['걷기', '100대 명산'],
      'challengeTypes': 'ITEM',
      'maxPeople': 100,
      'participatePeople': 80,
      'status': 'READY',
      'imageUrl': '',
      'userStatus': '참가중'
    },
    {
      'title': '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
      'openDate': '2023/02/01',
      'closeDate': '2023/02/28',
      'activityTypes': ['걷기', '100대 명산'],
      'challengeTypes': 'ITEM',
      'maxPeople': 100,
      'participatePeople': 80,
      'status': 'READY',
      'imageUrl': '',
      'userStatus': '참가중'
    },
    {
      'title': '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
      'openDate': '2023/02/01',
      'closeDate': '2023/02/28',
      'activityTypes': ['걷기', '100대 명산'],
      'challengeTypes': 'ITEM',
      'maxPeople': 100,
      'participatePeople': 80,
      'status': 'READY',
      'imageUrl': '',
      'userStatus': '참가중'
    },
    {
      'title': '[2월] 챌린저 트레킹슈즈 신고 매일 걷기',
      'openDate': '2023/02/01',
      'closeDate': '2023/02/28',
      'activityTypes': ['걷기', '100대 명산'],
      'challengeTypes': 'ITEM',
      'maxPeople': 100,
      'participatePeople': 80,
      'status': 'READY',
      'imageUrl': '',
      'userStatus': '참가중'
    },
  ];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
