import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:throttling/throttling.dart';

mixin ChallengeMixin {
  GlobalController globalController = Get.find();
  GlobalKey listKey = GlobalKey();

  final RxList<ChallengeCourseModel> nearByCourses = RxList.empty();
  final RxDouble listHeight = RxDouble(0);
  final RxList<ChallengeCourseModel> allCoursesList = RxList.empty();
  final RxList<ChallengeHierarchyModel> hierarchyChallengesList = RxList.empty();
  final RxList<ChallengeCourseModel> doableCourses = RxList.empty();
  final Rx<ChallengeCourseModel> selectedCourse = Rx(ChallengeCourseModel());
  final Rxn<ChallengeModel> selectedChallenge = Rxn();
  late NaverMapController challengeMapController;
  final RxList<Marker> challengeMarkers = RxList.empty();
  final RxList<Marker> selectedChallengeMarkers = RxList.empty();
  final Throttling challengeThr = Throttling(duration: const Duration(milliseconds: 500));

  RxList<ChallengeCourseModel> get doableCoursesByChallenge {
    if (selectedChallenge.value != null) {
      return RxList(doableCourses.where((course) => course.challengeId == selectedChallenge.value!.id).toList());
    } else {
      return RxList.empty();
    }
  }

  String getChallengeExerciseType(String type) {
    switch (type) {
      case 'WALKING':
        return '걷기';
      case 'CLIMBING':
        return '오르기';
      case 'HIKING':
        return '등산';
      default:
        return '';
    }
  }

  String getChallengeStatus(String status) {
    switch (status) {
      case 'READY':
        return '챌린지 전';
      case 'IN_PROGRESS':
        return '진행 중';
      case 'CLOSED':
        return '종료';
      default:
        return '';
    }
  }

  String getChallengeUserStatus(status) {
    String text = '';

    switch (status) {
      case 'REGISTER_AVAILABLE':
        text = '접수 중';
        break;
      case 'REGISTER_READY':
        text = '접수 ';
        break;
      case 'JOINED':
        text = '참가 중';
        break;
      case 'JOIN_AVAILABLE':
        text = '참가 가능';
        break;
      case 'JOIN_CLOSED':
        text = '참가 마감';
        break;
      default:
        text = '이거야';
    }
    return text;
  }

  Future<void> getCourseList() async {
    await ActivityService.getCourses(
      successCallback: (challengesList) {
        allCoursesList.value = challengesList;
      },
    );
  }

  Future<ChallengeCourseModel> getChallengeCourse(int id) async {
    ChallengeCourseModel challengeItem = ChallengeCourseModel();
    await ActivityService.getChallengeCourse(
      id,
      successCallback: (challenge) {
        challengeItem = challenge;
      },
    );

    return challengeItem;
  }

  Future<void> getNearByCourses(Position currentLocation, ExerciseState exerciseState) async {
    await ActivityService.getNearByCourses(currentLocation, successCallback: (List<ChallengeCourseModel> result) {
      if (result.isNotEmpty) {
        notificationOnCourse(result, exerciseState);
      }
      nearByCourses.addAll(result);
    }, errorCallback: () {
      nearByCourses.clear();
    });
  }

  Future<void> getChallengesHierarchy(Position currentLocation, int challengeId) async {
    hierarchyChallengesList.clear();

    await ActivityService.getChallengesHierarchy(
      currentLocation,
      challengeId,
      successCallback: (challengeList) {
        hierarchyChallengesList.addAll(challengeList);
      },
    );
  }

  void notificationOnCourse(List<ChallengeCourseModel> challenges, ExerciseState exerciseState) {
    bool notification = false;
    if (challenges.isNotEmpty && !([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState))) {
      notification = true;
    }

    if (notification) {
      for (ChallengeCourseModel challenge in challenges) {
        if (validateChallengeNotification(challenge.id!)) {
          DateTime notifiedTime = DateTime.now();
          List<int> notifiedChallengeList = HiveStore.load(key: HiveKey.challengeNotificationList.name) ?? [];
          notifiedChallengeList.add(challenge.id!);
          HiveStore.save(key: HiveKey.challengeNotificationList.name, value: notifiedChallengeList);
          HiveStore.save(key: HiveKey.challengeNotificationTime.name, value: DateTime(notifiedTime.year, notifiedTime.month, notifiedTime.day));
          showLocalNotification(notificationType: NotificationType.challenge, title: '등산 챌린지 시작 포인트 발견', message: '주변에 챌린지를 시작 할 수 있는 ${challenge.firstName}이 있어요. 뱃지 받으러 가자GO~~');
          showToastPopup('등산 챌린지 시작 포인트 발견');
        }
      }
    }
  }

  bool validateChallengeNotification(int challengeId) {
    DateTime? notifiedTime = HiveStore.load(key: HiveKey.challengeNotificationTime.name);
    bool isNextDay = notifiedTime != null ? DateTime.now().isAfter(notifiedTime.add(const Duration(hours: 24))) : true;
    List<int>? notifiedChallengeList = HiveStore.load(key: HiveKey.challengeNotificationList.name);

    if (isNextDay) {
      HiveStore.save(key: HiveKey.challengeNotificationList.name, value: null);
      return true;
    } else {
      if (notifiedChallengeList != null && notifiedChallengeList.isNotEmpty) {
        bool challengeAlreadyNotified = notifiedChallengeList.contains(challengeId);
        if (challengeAlreadyNotified) {
          return false;
        }

        return true;
      } else {
        return true;
      }
    }
  }

  void onChallengeMapCreated(NaverMapController controller) {
    challengeMapController = controller;
    if (listKey.currentContext != null) {
      listHeight.value = listKey.currentContext!.size!.height;
    }
  }

  void selectCourse(ChallengeCourseModel course) {
    selectedCourse.value = ChallengeCourseModel.fromJson(course.toJson());

    print(selectedCourse.value.toJson());

    challengeMapController.moveCamera(
      CameraUpdate.fitBounds(
        LatLngBounds.fromLatLngList(
          [
            LatLng(course.startLat!, course.startLon!),
            LatLng(course.endLat!, course.endLon!),
          ],
        ),
        padding: 80,
      ),
    );
  }

  void detectChallengeZone(Position location) {
    if (nearByCourses.isNotEmpty) {
      doableCourses.clear();
      for (ChallengeCourseModel challenge in nearByCourses) {
        double distance = calculateDistance(location.latitude, location.longitude, challenge.startLat, challenge.startLon);
        if (distance <= convertMetersToKm(challenge.startRadius!)) {
          doableCourses.add(challenge);
        }
      }
    } else {
      doableCourses.clear();
    }
  }

  Future<void> getChallenges({required Function successCallback, Function? errorCallback}) async {
    await ActivityService.getChallenges(
      successCallback: successCallback,
      errorCallback: errorCallback,
    );
  }
}
