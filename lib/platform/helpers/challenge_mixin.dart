import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/inventory_badge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/badge_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ChallengeMixin {
  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<ChallengeModel> doableChallenges = RxList.empty();
  final RxList<ChallengeModel> achievableChallenges = RxList.empty();
  final Rx<ChallengeModel> selectedChallenge = Rx(ChallengeModel());
  late NaverMapController _challengeMapController;

  Future<void> getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  Future<void> getNearByChallengeList(Position currentLocation) async {
    List<ChallengeModel> result = await ActivityService.getNearByChallenges(currentLocation);
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
        target: LatLng(challenge.startLat!, challenge.startLon!),
      ),
    ));
  }

  void detectChallengeZone(Position location) {
    doableChallenges.value = challengeList.where((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
      return distance <= convertMetersToKM(challenge.startRadius!);
    }).toList();

    achievableChallenges.value = challengeList.where((challenge) {
      double distance = calculateDistance(location.latitude, location.longitude, challenge.endLat, challenge.endLon);
      return distance <= convertMetersToKM(challenge.endRadius!);
    }).toList();
  }

  void autoFinishChallenge(CurrentUserStateModel userState) async {
    if (achievableChallenges.isNotEmpty && userState.exercise != null) {
      bool hasArrived = achievableChallenges.any((challenge) {
        return challenge.id == userState.exercise!.challengeId;
      });

      if (hasArrived && userState.exercise!.badgeIssueId == null) {
        VoidCallback successCallback = () {
          Get.snackbar('뱃지 발급', '뱃지가 발급되었습니다.', colorText: Colors.white);
        };

        VoidCallback errorCallback = () {
          Get.snackbar('뱃지 발급 실패', '뱃지 발급에 실패했습니다.', colorText: Colors.white);
        };

        InventoryBadgeModel badge = await BadgeService.fetchUserIssuanceBadge(userState.exercise!.id!, successCallback, errorCallback);
        userState.exercise!.badgeIssueId = badge.id;
      }
    }
  }
}
