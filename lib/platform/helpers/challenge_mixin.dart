import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:throttling/throttling.dart';

mixin ChallengeMixin {
  GlobalController globalController = Get.find();
  final GlobalKey listKey = GlobalKey();

  final Rxn<ChallengeModel> nearByChallenge = Rxn();
  final RxDouble listHeight = RxDouble(0);
  final RxList<ChallengeModel> allChallengesList = RxList.empty();
  final RxList<ChallengeHierarchyModel> hierarchyChallengesList = RxList.empty();
  final Rxn<ChallengeModel> doableChallenge = Rxn();
  final Rx<ChallengeModel> selectedChallenge = Rx(ChallengeModel());
  late NaverMapController challengeMapController;
  final RxList<Marker> challengeMarkers = RxList.empty();
  final RxList<Marker> selectedChallengeMarkers = RxList.empty();

  Future<void> getChallengeList() async {
    await ActivityService.getChallenges(
      successCallback: (challengesList) {
        allChallengesList.value = challengesList;
      },
    );
  }

  Future<ChallengeModel> getChallenge(int id) async {
    ChallengeModel challengeItem = ChallengeModel();
    await ActivityService.getChallenge(
      id,
      successCallback: (challenge) {
        challengeItem = challenge;
      },
    );

    return challengeItem;
  }

  Future<void> getNearByChallenge(Position currentLocation, ExerciseState exerciseState) async {
    await ActivityService.getNearByChallenge(
      currentLocation,
      successCallback: (result) {
        notificationOnChallenge(result, exerciseState);
        nearByChallenge.value = result;
      },
    );
  }

  Future<void> getChallengesHierarchy(Position currentLocation) async {
    await ActivityService.getChallengesHierarchy(
      currentLocation,
      successCallback: (challengeList) {
        hierarchyChallengesList.value = challengeList;
      },
    );
  }

  void notificationOnChallenge(ChallengeModel? challenge, ExerciseState exerciseState) {
    bool notification = false;
    if (challenge != null && !([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState))) {
      notification = true;
    }

    if (notification) {
      showLocalNotification(notificationType: NotificationType.challenge, title: '등산 챌린지 시작 포인트 발견', message: '주변에 챌린지를 시작 할 수 있는 ${challenge!.firstName}이 있어요. 뱃지 받으러 가자GO~~');
      showToastPopup('등산 챌린지 시작 포인트 발견');
    }
  }

  void onChallengeMapCreated(NaverMapController controller) {
    challengeMapController = controller;
    if (listKey.currentContext != null) {
      listHeight.value = listKey.currentContext!.size!.height;
    }
  }

  void selectChallenge(ChallengeModel challenge) {
    selectedChallenge.value = ChallengeModel.fromJson(challenge.toJson());

    challengeMapController.moveCamera(
      CameraUpdate.fitBounds(
        LatLngBounds.fromLatLngList(
          [
            LatLng(challenge.startLat!, challenge.startLon!),
            LatLng(challenge.endLat!, challenge.endLon!),
          ],
        ),
        padding: 80,
      ),
    );
  }

  void detectChallengeZone(Position location) {
    if (nearByChallenge.value != null) {
      double distance = calculateDistance(location.latitude, location.longitude, nearByChallenge.value!.startLat, nearByChallenge.value!.startLon);
      if (distance <= convertMetersToKm(nearByChallenge.value!.startRadius!)) {
        doableChallenge.value = nearByChallenge.value;
      }
    }
  }

  void autoFinishChallenge(Position currentLocation, CurrentUserStateModel userState) async {
    if (selectedChallenge.value.id != null && userState.exercise != null && userState.exercise?.challengeId != null) {
      bool hasArrived =
          Geolocator.distanceBetween(selectedChallenge.value.endLat!, selectedChallenge.value.endLon!, currentLocation.latitude, currentLocation.longitude) < selectedChallenge.value.endRadius!;
      if (hasArrived && userState.exercise!.badgeIssueId == null) {
        if (globalController.internetConnection.value) {
          Throttling(duration: const Duration(milliseconds: 500)).throttle(() => requestBadgeIssuance(userState));
        } else {
          HiveStore.save(key: HiveKey.badgeIssuanceRequested.name, value: true);
        }
      }
    }
  }

  Future<void> requestBadgeIssuance(CurrentUserStateModel userState) async {
    void successCallback(InventoryBadgeModel badge) {
      showLocalNotification(notificationType: NotificationType.badge, title: '등산 챌린지 뱃지 획득', message: '${selectedChallenge.value.firstName} 등산 챌린지에 성공하여 뱃지를 받았어요. 새로운 뱃지 확인하러 가자GO~~');
      showToastPopup('뱃지를 획득하였습니다.');
      userState.exercise!.badgeIssueId = badge.id;
      HiveStore.deleteKey(key: HiveKey.badgeIssuanceRequested.name);
      showBadgeAcquisitionAlert(badge, selectedChallenge.value);
    }

    void errorCallback() {
      showToastPopup('뱃지 발급에 실패했습니다.');
      HiveStore.save(key: HiveKey.badgeIssuanceRequested.name, value: true);
    }

    await BadgeService.fetchUserIssuanceBadge(userState.exercise!.id!, successCallback: successCallback, errorCallback: errorCallback);
  }
}
