import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
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
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ChallengeMixin {
  GlobalController globalController = Get.find();
  final GlobalKey listKey = GlobalKey();

  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxDouble listHeight = RxDouble(0);
  final RxList<ChallengeModel> allChallengesList = RxList.empty();
  final RxList<ChallengeHierarchyModel> hierarchyChallengesList = RxList.empty();
  final RxList<ChallengeModel> doableChallenges = RxList.empty();
  final RxList<ChallengeModel> achievableChallenges = RxList.empty();
  final Rx<ChallengeModel> selectedChallenge = Rx(ChallengeModel());
  late NaverMapController challengeMapController;
  final RxList<Marker> challengeMarkers = RxList.empty();

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

  Future<void> getNearByChallengeList(Position currentLocation, ExerciseState exerciseState) async {
    await ActivityService.getNearByChallenges(
      currentLocation,
      successCallback: (result) {
        notificationOnChallenge(result, exerciseState);
        challengeList.value = result;
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

  void notificationOnChallenge(List<ChallengeModel> result, ExerciseState exerciseState) {
    bool notification = false;
    List<ChallengeModel> filteredList = result.toSet().difference(challengeList.toSet()).toList();
    List<int> filteredIdList = List.empty(growable: true);
    List<int> challengeIdList = List.empty(growable: true);
    if (result.isNotEmpty && challengeList.isNotEmpty) {
      filteredIdList = filteredList
          .map((element) {
            return element.id!;
          })
          .toSet()
          .toList();
      challengeIdList = challengeList
          .map((element) {
            return element.id!;
          })
          .toSet()
          .toList();
    }

    if (result.isNotEmpty &&
        challengeList.isNotEmpty &&
        listEquals(filteredIdList, challengeIdList) == false &&
        !([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState))) {
      notification = true;
    }

    if (notification) {
      showLocalNotification(notificationType: NotificationType.challenge, title: '등산 챌린지 시작 포인트 발견', message: '주변에 챌린지를 시작 할 수 있는 ${filteredList.first.firstName}이 있어요. 뱃지 받으러 가자GO~~');
      showToastPopup('등산 챌린지 시작 포인트 발견');
    }
  }

  void onChallengeMapCreated(NaverMapController controller) {
    challengeMapController = controller;
    listHeight.value = listKey.currentContext!.size!.height;
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
    print('######################## detectChallengeZone');
    print(location.speed);
    print(location);

    doableChallenges.value = challengeList.where((challenge) {
      inspect('시작경도점${challenge.startLat}');
      inspect('시작위도점${challenge.startLon}');
      double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
      inspect('거리${distance}');
      inspect('반경${convertMetersToKm(challenge.startRadius!)}');
      return distance <= convertMetersToKm(challenge.startRadius!);
    }).toList();
    // inspect('가능한 챌린지 리스트${doableChallenges.value}');
    // achievableChallenges.value = challengeList.where((challenge) {
    //   double distance = calculateDistance(location.latitude, location.longitude, challenge.endLat, challenge.endLon);
    //   return distance <= convertMetersToKm(challenge.endRadius!);
    // }).toList();
  }

  void autoFinishChallenge(Position currentLocation, CurrentUserStateModel userState) async {
    if (selectedChallenge.value.id != null && userState.exercise != null && userState.exercise?.challengeId != null) {
      bool hasArrived =
          Geolocator.distanceBetween(selectedChallenge.value.endLat!, selectedChallenge.value.endLon!, currentLocation.latitude, currentLocation.longitude) < selectedChallenge.value.endRadius!;
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
      showLocalNotification(notificationType: NotificationType.badge, title: '등산 챌린지 뱃지 획득', message: '${selectedChallenge.value.firstName} 등산 챌린지에 성공하여 뱃지를 받았어요. 새로운 뱃지 확인하러 가자GO~~');
      showToastPopup('뱃지를 획득하였습니다.');
      userState.exercise!.badgeIssueId = badge.id;
      HiveStore.deleteKey(key: HiveKey.badgeIssuanceRequested.name);
      showAlert(
        isScrollControlled: true,
        title: '챌린지 뱃지 발급',
        contentWidget: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: CachedNetworkImage(
                imageUrl: badge.badge.imageUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                fit: BoxFit.contain,
                width: 150,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
              decoration: BoxDecoration(
                color: Color(0xff1d1d26),
                borderRadius: BorderRadius.circular(11),
              ),
              child: StyledText(
                '${selectedChallenge.value.firstName} | ${selectedChallenge.value.secondName}',
                fontSize: 18,
                lineHeight: 18,
                fontWeight: 500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 30),
              child: Text.rich(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffbfbfbf),
                ),
                TextSpan(
                  children: [
                    TextSpan(text: '내 장비 > 뱃지', style: TextStyle(color: Color(0xff0EE6F3))),
                    TextSpan(text: ' 카테고리에서\n획득한 뱃지를 확인하실수 있습니다.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Expanded(
            child: GazagoButton(
              buttonText: '확인',
              onTap: () async {
                Get.back();
              },
            ),
          ),
        ],
      );
    }

    void errorCallback() {
      showToastPopup('뱃지 발급에 실패했습니다.');
      HiveStore.save(key: HiveKey.badgeIssuanceRequested.name, value: true.toString());
    }

    await BadgeService.fetchUserIssuanceBadge(userState.exercise!.id!, successCallback: successCallback, errorCallback: errorCallback);
  }
}
