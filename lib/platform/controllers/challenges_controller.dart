import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/new_challenge_detail_model.dart';
import 'package:gaza_go/platform/models/new_challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/components/mirae/alert_ui_list.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class ChallengesController extends GetxController
    with GetTickerProviderStateMixin, MapMixin, ChallengeMixin {
  ScrollController challengesScrollController = ScrollController();

  final RxList<NewChallengeModel> challengeList = RxList.empty();
  final List<Map<String, String>> sortingList = [
    {'title': 'all'.tr(), 'value': 'id,DESC'},
    {'title': 'joinable'.tr(), 'value': 'price,DESC'},
    {'title': 'joining'.tr(), 'value': 'price,ASC'},
    {'title': 'finished'.tr(), 'value': 'price,ASC'}
  ];
  Rx<DateTime?> today = Rx(DateTime.now());
  final List<Map<String, String>> exerciseTypeFilterList = [
    {'title': 'walking'.tr(), 'value': 'WALKING'},
    {'title': 'climbing'.tr(), 'value': 'HIKING'},
  ];
  RxList selectedStatus = RxList.empty(growable: true);
  RxList filteredStatus = RxList.empty(growable: true);

  RxBool isSelectAllItems = RxBool(true);
  RxBool isFilteredItems = RxBool(false);
  RxBool dataGetLoading = RxBool(false);
  late StreamSubscription subscription;
  Rx isSelectedSortValue = Rx({'title': 'all'.tr(), 'value': 'id,DESC'});
  RxString isSelectedSortString = RxString('all'.tr());
  final TextEditingController codeTextController =
      TextEditingController(text: '');
  final RxString participationCode = RxString('');
  final FocusNode focusNode = FocusNode();
  final RxString errorMessage = RxString('');
  final RxString companyChallengeStatus = RxString('');
  @override
  void onInit() async {
    await getChallengesList();
    super.onInit();
  }

  Future<void> refreshController() async {
    await getChallengesList();
  }

  bool listsAreEqual(
      List<NewChallengeModel> list1, List<NewChallengeModel> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    Function deepEq = const DeepCollectionEquality().equals;
    for (int i = 0; i < list1.length; i++) {
      if (!deepEq(list1[i].toJson(), list2[i].toJson())) {
        return false;
      }
    }

    return true;
  }

  Future<void> getChallengesList() async {
    dataGetLoading.value = true;
    await ActivityService.getNewChallenges(
        successCallback: (List<NewChallengeModel> data) {
      List<int> newChallengeListIds =
          data.map((element) => element.id).toSet().toList();
      if (!listsAreEqual(challengeList, data)) {
        challengeList.clear();
        challengeList.addAll(data);
        HiveStore.save(
            key: HiveKey.challengeListIds.name, value: newChallengeListIds);
      }
      dataGetLoading.value = false;
    }, errorCallback: () {
      dataGetLoading.value = false;
    });
  }

  void moveToDetail(
      id, challengeType, challengeUserState, challengeState) async {
    if (challengeType == 'CREW_COMPANY') {
      String? userId = HiveStore.loadString(key: HiveKey.userId.name);

      // DatabaseReference userDiInfoRef = FirebaseDatabase.instance.ref('crewChallengeLeaderboard/$id/$userId');
      DatabaseReference userDiInfoRef =
          FirebaseDatabase.instance.ref('crewChallengeLeaderboard/$id');
      Query query = userDiInfoRef.child(userId!);

      await query.get().then((DataSnapshot snapshot) async {
        if (snapshot.value != null) {
          Get.toNamed(
              Routes.companyChallengeDetail.replaceAll(':id', id.toString()));
        } else {
          showMiraeAssetPopup(id);
        }
      }).catchError((error) {
        // 오류 처리
      });
    } else {
      Get.toNamed(Routes.challengeDetail.replaceAll(':id', id.toString()));
    }
  }

  bool checkUserIdExistence(data, String userId) {
    return data.keys.contains(userId);
  }

  void onJoinCompanyChallenge(challengeId) {}

  Future<void> getChallengeDetail(challengeId) async {
    await ActivityService.getChallengeDetails(challengeId,
        successCallback: (NewChallengeDetailModel data) async {
      String? userId = HiveStore.loadString(key: HiveKey.userId.name);
      DatabaseReference userDiInfoRef = FirebaseDatabase.instance
          .ref('crewChallengeLeaderboard/$challengeId');
      Query query = userDiInfoRef.child(userId!);
      query.get().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          // if(Get.isDialogOpen == true){
          //   Get.back();
          // }
          Get.find<HomeMenuController>().selectMenu(0);
          Get.toNamed(Routes.companyChallengeDetail
              .replaceAll(':id', challengeId.toString()));
        } else {
          if (data.challengeState == 'READY') {
            if (data.challengeUserState == 'REGISTER_READY') {
              notOpenCompanyChallenge();
            } else {
              participateInMiraeChallengeByCodeAlert(challengeId);
            }
          } else if (data.challengeState == 'IN_PROGRESS') {
            if (data.challengeUserState == 'JOIN_CLOSED') {
              closedCompanyChallenge();
            } else {
              participateInMiraeChallengeByCodeAlert(challengeId);
            }
          } else {
            closedCompanyChallenge();
          }
        }
      }).catchError((error, stackTrace) {
        // 오류 처리
      });
    });
  }

  void showMiraeAssetPopup(id) async {
    await ActivityService.getChallengeDetails(id,
        successCallback: (NewChallengeDetailModel data) async {
      if (data.challengeUserState == null) {
        miraeAssetAlert(id, null);
      } else {
        miraeAssetAlert(id, data.challengeUserState!);
      }
    });
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
