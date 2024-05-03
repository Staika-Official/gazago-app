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
  final Rxn<ChallengeCourseModel> selectedCourse = Rxn();
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

  String getChallengeActivationTypeString(String activationType) {
    switch (activationType) {
      case 'ITEM':
        return '아이템 장착';
      case 'COURSE':
        return '코스';
      case 'CODE':
        return '참가코드';
      case 'CREW':
        return '크루릴레이';
      case 'CREW_COMPANY':
        return '기업전용';
      default:
        return '참가비 납부';
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

  String getUnlimitedParticipationStatus(String status) {
    switch (status) {
      case 'READY':
        return ' 제한없음';
      case 'IN_PROGRESS':
        return ' 참여중';
      case 'CLOSED':
        return ' 참여';
      default:
        return '';
    }
  }

  String getChallengeUserStatus(userStatus, challengeState) {
    String text = '';
    if(challengeState == 'READY'){
      switch (userStatus) {
        case 'REGISTER_AVAILABLE':
          text = '참가 가능';
          break;
        case 'REGISTER_READY':
          text = '접수 전';
          break;
        case 'JOINED':
          text = '시작 전';
          break;
        case 'JOIN_AVAILABLE':
          text = '참가 가능';
          break;
        case 'JOIN_CLOSED':
          text = '참가 마감';
          break;
        default:
          text = '';
      }
    } else {
      switch (userStatus) {
        case 'REGISTER_AVAILABLE':
          text = '접수 중';
          break;
        case 'REGISTER_READY':
          text = '접수 전';
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
          text = '';
      }
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
    nearByCourses.clear();
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

  void notificationOnCourse(List<ChallengeCourseModel> courses, ExerciseState exerciseState) {
    bool notification = false;
    if (courses.isNotEmpty && !([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState))) {
      notification = true;
    }

    if (notification) {
      for (ChallengeCourseModel course in courses) {
        if (validateChallengeNotification(course)) {
          DateTime notifiedTime = DateTime.now();
          List<dynamic> notifiedChallengeList = HiveStore.load(key: HiveKey.courseNotificationList.name) ?? [];
          notifiedChallengeList.add({
            'courseId': course.id!,
            'challengeId': course.challengeId!,
            'notifiedTime': DateTime(notifiedTime.year, notifiedTime.month, notifiedTime.day).toString(),
          });
          HiveStore.save(key: HiveKey.courseNotificationList.name, value: notifiedChallengeList);
          HiveStore.save(key: HiveKey.courseNotificationTime.name, value: DateTime(notifiedTime.year, notifiedTime.month, notifiedTime.day));
          showLocalNotification(
            allowSeparatePush: true,
            separatePushId: course.challengeId!,
            notificationType: NotificationType.challenge,
            title: '챌린지 시작 포인트 발견',
            message: '주변에 시작 할 수 있는 ${course.title}가 있어요. 뱃지 받으러 가자GO~~',
          );
          showToastPopup('챌린지 시작 포인트 발견');
        }
      }
    }
  }

  bool validateChallengeNotification(ChallengeCourseModel course) {
    DateTime? notifiedTime = HiveStore.load(key: HiveKey.courseNotificationTime.name);
    bool isNextDay = notifiedTime != null ? DateTime.now().isAfter(notifiedTime.add(const Duration(hours: 24))) : true;
    List<dynamic>? notifiedChallengeList = HiveStore.load(key: HiveKey.courseNotificationList.name);

    if (isNextDay) {
      HiveStore.save(key: HiveKey.courseNotificationList.name, value: null);
      return true;
    } else {
      if (notifiedChallengeList != null && notifiedChallengeList.isNotEmpty) {
        bool challengeAlreadyNotified = notifiedChallengeList.any((notifiedCourse) => notifiedCourse['challengeId'] == course.challengeId);
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
    if (selectedCourse.value?.checkpoints != null && selectedCourse.value!.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getCheckPointsCourse(selectedCourse.value!.checkpoints!);

      challengeMapController.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds.fromLatLngList(markers),
          padding: 120,
        ),
      );
    }
  }

  void selectCourse(ChallengeCourseModel course) {
    selectedCourse.value = ChallengeCourseModel.fromJson(course.toJson());
    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getCheckPointsCourse(selectedCourse.value!.checkpoints!);

      challengeMapController.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds.fromLatLngList(markers),
          padding: 120,
        ),
      );
    } else {
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
    print(course.checkpoints);
  }

  List<LatLng> getCheckPointsCourse(markers) {
    double minLat = markers.map((marker) => marker.lat).reduce((a, b) => a < b ? a : b);
    double maxLat = markers.map((marker) => marker.lat).reduce((a, b) => a > b ? a : b);
    double minLng = markers.map((marker) => marker.lon).reduce((a, b) => a < b ? a : b);
    double maxLng = markers.map((marker) => marker.lon).reduce((a, b) => a > b ? a : b);

    // double aspectRatio = (maxLng - minLng) / (maxLat - minLat);

    List<LatLng> outermostCoords = [];

    outermostCoords = [
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ];

    return outermostCoords;
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

  String getCourseRouteString(ChallengeCourseModel course) {
    List<String> checkpointNames = course.checkpoints != null && course.checkpoints!.isNotEmpty ? course.checkpoints!.map((checkpoint) => checkpoint.name!).toList() : [];
    List<String> fullCourseRoute = [course.startPointName ?? '', ...checkpointNames, course.endPointName ?? ''];
    return fullCourseRoute.join(' - ');
  }
}
