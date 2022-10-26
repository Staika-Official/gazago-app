import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ChallengeMixin {
  GlobalController globalController = Get.find();

  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<ChallengeModel> allChallengesList = RxList.empty();
  final RxList<ChallengeModel> doableChallenges = RxList.empty();
  final RxList<ChallengeModel> achievableChallenges = RxList.empty();
  final Rx<ChallengeModel> selectedChallenge = Rx(ChallengeModel());
  late NaverMapController _challengeMapController;

  Future<void> getChallengeList() async {
    allChallengesList.value = await ActivityService.getChallenges();
  }

  Future<ChallengeModel> getChallenge(int id) async {
    return await ActivityService.getChallenge(id);
  }

  Future<void> getNearByChallengeList(Position currentLocation) async {
    List<ChallengeModel> result = await ActivityService.getNearByChallenges(currentLocation);
    inspect(result);
    notificationOnChallenge(result);
    challengeList.value = result;
  }

  void notificationOnChallenge(List<ChallengeModel> result) {
    bool notification = false;
    var filteredList = result.toSet().difference(challengeList.value.toSet()).toList();
    if (filteredList.length != challengeList.length) {
      notification = true;
    }
    if (notification) {
      Get.snackbar('도전 지역 발견', '새로운 도전을 시작하세요.', colorText: Colors.green);
    }
  }

  void onChallengeMapCreated(NaverMapController controller) {
    _challengeMapController = controller;
  }

  void selectChallenge(ChallengeModel challenge) {
    selectedChallenge.value = challenge;
    _challengeMapController.moveCamera(CameraUpdate.toCameraPosition(
      CameraPosition(
        target: LatLng(challenge.endLat!, challenge.endLon!),
      ),
    ));
  }

  void detectChallengeZone(Position location) {
    print('######################## detectChallengeZone');
    print(location);

    doableChallenges.value = challengeList.where((challenge) {
      inspect('시작경도점${challenge.startLat}');
      inspect('시작위도점${challenge.startLon}');
      double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
      inspect('거리${distance}');
      inspect('반경${convertMetersToKm(challenge.startRadius!)}');
      return distance <= convertMetersToKm(challenge.startRadius!);
    }).toList();
    inspect('가능한 챌린지 리스트${doableChallenges.value}');
    achievableChallenges.value = challengeList.where((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.endLat, challenge.endLon);
      return distance <= convertMetersToKm(challenge.endRadius!);
    }).toList();
  }

  void autoFinishChallenge(Position currentLocation, CurrentUserStateModel userState) async {
    if (selectedChallenge.value.id != null && userState.exercise != null && userState.exercise?.challengeId != null) {
      bool hasArrived = selectedChallenge.value.endRadius! < Geolocator.distanceBetween(selectedChallenge.value.startLat!, selectedChallenge.value.startLon!, currentLocation.latitude, currentLocation.longitude);
      if (hasArrived && userState.exercise!.badgeIssueId == null) {
        if (globalController.connectivityResult.value != ConnectivityResult.none) {
          requestBadgeIssuance(userState);
        } else {
          HiveStore.save(key: HiveKey.badgeIssuanceRequested.name, value: true.toString());
        }
      }
    }
  }

  Future<void> requestBadgeIssuance(CurrentUserStateModel userState) async {
    void successCallback(InventoryBadgeModel badge) {
      Get.snackbar('뱃지 발급', '뱃지가 발급되었습니다.', colorText: Colors.white);
      userState.exercise!.badgeIssueId = badge.id;
      HiveStore.deleteKey(key: HiveKey.badgeIssuanceRequested.name);
    }

    VoidCallback errorCallback = () {
      Get.snackbar('뱃지 발급 실패', '뱃지 발급에 실패했습니다.', colorText: Colors.white);
    };

    await BadgeService.fetchUserIssuanceBadge(userState.exercise!.id!, successCallback, errorCallback);
  }
}
