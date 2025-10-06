import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:throttling/throttling.dart';

import '../models/checkpoint_model.dart';

mixin ChallengeMixin on MapMixin {
  GlobalController globalController = Get.find();
  GlobalKey listKey = GlobalKey();

  final RxList<ChallengeCourseModel> nearByCourses = RxList.empty();
  final RxDouble listHeight = RxDouble(0);
  final RxList<ChallengeCourseModel> allCoursesList = RxList.empty();
  final RxList<ChallengeHierarchyModel> hierarchyChallengesList =
      RxList.empty();
  final RxList<ChallengeCourseModel> doableCourses = RxList.empty();
  final Rxn<ChallengeCourseModel> selectedCourse = Rxn();
  final Rxn<ChallengeModel> selectedChallenge = Rxn();

  final RxList challengeMarkers = RxList.empty();
  final RxList<Marker> selectedChallengeMarkers = RxList.empty();
  final Throttling challengeThr =
      Throttling(duration: const Duration(milliseconds: 500));
  List<GoogleMapController> challengeMapControllers = [];
  RxList<ChallengeCourseModel> get doableCoursesByChallenge {
    if (selectedChallenge.value != null) {
      return RxList(doableCourses
          .where((course) => course.challengeId == selectedChallenge.value!.id)
          .toList());
    } else {
      return RxList.empty();
    }
  }

  String getChallengeActivationTypeString(String activationType) {
    switch (activationType) {
      case 'ITEM':
        return 'item_equipped_1'.tr();
      case 'COURSE':
        return 'course'.tr();
      case 'CODE':
        return 'participation_code'.tr();
      case 'CREW':
        return 'crew_relay'.tr();
      case 'CREW_COMPANY':
        return 'corporate_only'.tr();
      default:
        return 'participation_fee_payment'.tr();
    }
  }

  String getChallengeExerciseType(String type) {
    switch (type) {
      case 'WALKING':
        return 'walking'.tr();
      case 'CLIMBING':
        return 'climbing'.tr();
      case 'HIKING':
        return 'hiking'.tr();
      default:
        return '';
    }
  }

  String getChallengeStatus(String status) {
    switch (status) {
      case 'READY':
        return 'before_challenge'.tr();
      case 'IN_PROGRESS':
        return 'in_progress'.tr();
      case 'CLOSED':
        return 'finished'.tr();
      default:
        return '';
    }
  }

  String getUnlimitedParticipationStatus(String status) {
    switch (status) {
      case 'READY':
        return 'unlimited'.tr();
      case 'IN_PROGRESS':
        return 'participating'.tr();
      case 'CLOSED':
        return 'participate'.tr();
      default:
        return '';
    }
  }

  String getChallengeUserStatus(userStatus, challengeState) {
    String text = '';
    if (challengeState == 'READY') {
      switch (userStatus) {
        case 'REGISTER_AVAILABLE':
          text = 'registration_in_progress'.tr();
          break;
        case 'REGISTER_READY':
          text = 'before_registration'.tr();
          break;
        case 'JOINED':
          text = 'participating_challenge'.tr();
          break;
        case 'JOIN_AVAILABLE':
          text = 'registration_in_progress'.tr();
          break;
        case 'JOIN_CLOSED':
          text = 'participation_closed'.tr();
          break;
        default:
          text = '';
      }
    } else {
      switch (userStatus) {
        case 'REGISTER_AVAILABLE':
          text = 'registration_in_progress'.tr();
          break;
        case 'REGISTER_READY':
          text = 'before_registration'.tr();
          break;
        case 'JOINED':
          text = 'participating_challenge'.tr();
          break;
        case 'JOIN_AVAILABLE':
          text = 'participation_available'.tr();
          break;
        case 'JOIN_CLOSED':
          text = 'participation_closed'.tr();
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

  Future<void> getNearByCourses(
      LocationModel currentLocation, ExerciseState exerciseState) async {
    // Future.delayed(Duration(milliseconds: 500));
    await ActivityService.getNearByCourses(currentLocation,
        successCallback: (List<ChallengeCourseModel> result) {
      // nearByCourses.clear();
      nearByCourses.value = RxList.empty();
      if (result.isNotEmpty) {
        notificationOnCourse(result, exerciseState);
      }
      nearByCourses.addAll(result);
      nearByCourses.refresh();
    }, errorCallback: () {
      nearByCourses.clear();
    });
  }

  Future<void> getChallengesHierarchy(
      LocationModel currentLocation, int challengeId) async {
    hierarchyChallengesList.clear();

    await ActivityService.getChallengesHierarchy(
      currentLocation,
      challengeId,
      successCallback: (challengeList) {
        hierarchyChallengesList.addAll(challengeList);
      },
    );
  }

  void notificationOnCourse(
      List<ChallengeCourseModel> courses, ExerciseState exerciseState) {
    bool notification = false;
    if (courses.isNotEmpty &&
        !([ExerciseState.ongoing, ExerciseState.paused]
            .any((state) => state == exerciseState))) {
      notification = true;
    }

    if (notification) {
      for (ChallengeCourseModel course in courses) {
        if (validateChallengeNotification(course)) {
          DateTime notifiedTime = DateTime.now();
          List<dynamic> notifiedChallengeList =
              HiveStore.load(key: HiveKey.courseNotificationList.name) ?? [];
          notifiedChallengeList.add({
            'courseId': course.id!,
            'challengeId': course.challengeId!,
            'notifiedTime': DateTime(
                    notifiedTime.year, notifiedTime.month, notifiedTime.day)
                .toString(),
          });
          HiveStore.save(
              key: HiveKey.courseNotificationList.name,
              value: notifiedChallengeList);
          HiveStore.save(
              key: HiveKey.courseNotificationTime.name,
              value: DateTime(
                  notifiedTime.year, notifiedTime.month, notifiedTime.day));
          showLocalNotification(
            allowSeparatePush: true,
            separatePushId: course.challengeId!,
            notificationType: NotificationType.challenge,
            title: 'challenge_start_point_found'.tr(),
            message: 'nearby_challenge_found'.tr(args: [course.title!]),
          );
          showToastPopup('challenge_start_point_found'.tr());
        }
      }
    }
  }

  bool validateChallengeNotification(ChallengeCourseModel course) {
    DateTime? notifiedTime =
        HiveStore.load(key: HiveKey.courseNotificationTime.name);
    bool isNextDay = notifiedTime != null
        ? DateTime.now().isAfter(notifiedTime.add(const Duration(hours: 24)))
        : true;
    List<dynamic>? notifiedChallengeList =
        HiveStore.load(key: HiveKey.courseNotificationList.name);

    if (isNextDay) {
      HiveStore.save(key: HiveKey.courseNotificationList.name, value: null);
      return true;
    } else {
      if (notifiedChallengeList != null && notifiedChallengeList.isNotEmpty) {
        bool challengeAlreadyNotified = notifiedChallengeList.any(
            (notifiedCourse) =>
                notifiedCourse['challengeId'] == course.challengeId);
        if (challengeAlreadyNotified) {
          return false;
        }

        return true;
      } else {
        return true;
      }
    }
  }

  LatLngBounds _createBoundsFromLatLngList(List<LatLng> list) {
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;

    for (final latLng in list) {
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void onChallengeMapCreated() {
    if (listKey.currentContext != null) {
      listHeight.value = listKey.currentContext!.size!.height;
    }
    if (selectedCourse.value?.checkpoints != null &&
        selectedCourse.value!.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getCheckPointsCourse(
          selectedCourse.value!.checkpoints!, selectedCourse.value!);

      LatLngBounds bounds = _createBoundsFromLatLngList(markers);

// 3. 카메라 이동
      challengeMapControllers.last.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 150), // padding은 px 단위
      );
    }
  }

  void selectCourse(ChallengeCourseModel course) {
    selectedCourse.value = ChallengeCourseModel.fromJson(course.toJson());
    clearOverlays();
    addOverlayAll(
      {
        ...renderCircleOverlays(selectedCourse.value),
        ...renderMarkers(selectedCourse.value),
      },
    );
    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getCheckPointsCourse(
          selectedCourse.value!.checkpoints!, selectedCourse.value!);
      challengeMapControllers.last.animateCamera(
        CameraUpdate.newLatLngBounds(
          _createBoundsFromLatLngList(markers),
          150,
        ),
      );
    } else {
      challengeMapControllers.last.animateCamera(
        CameraUpdate.newLatLngBounds(
          _createBoundsFromLatLngList(
            [
              LatLng(course.startLat!, course.startLon!),
              LatLng(course.endLat!, course.endLon!),
            ],
          ),
          80,
        ),
      );
    }
  }

  List<LatLng> getCheckPointsCourse(markers, selectCourse) {
    List<dynamic> allPoints = [
      CheckpointModel(
        lat: selectCourse.startLat,
        lon: selectCourse.startLon,
      ),
      CheckpointModel(
        lat: selectCourse.endLat,
        lon: selectCourse.endLon,
      ),
      ...markers
    ];
    double minLat =
        allPoints.map((point) => point.lat).reduce((a, b) => a < b ? a : b);
    double maxLat =
        allPoints.map((point) => point.lat).reduce((a, b) => a > b ? a : b);
    double minLng =
        allPoints.map((point) => point.lon).reduce((a, b) => a < b ? a : b);
    double maxLng =
        allPoints.map((point) => point.lon).reduce((a, b) => a > b ? a : b);
    //
    // double minLat = markers.map((marker) => marker.lat).reduce((a, b) => a < b ? a : b);
    // double maxLat = markers.map((marker) => marker.lat).reduce((a, b) => a > b ? a : b);
    // double minLng = markers.map((marker) => marker.lon).reduce((a, b) => a < b ? a : b);
    // double maxLng = markers.map((marker) => marker.lon).reduce((a, b) => a > b ? a : b);

    // double aspectRatio = (maxLng - minLng) / (maxLat - minLat);

    List<LatLng> outermostCoords = [];

    outermostCoords = [
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ];

    return outermostCoords;
  }

  // duplicate/different signature removed — use detectChallengeZone(LocationModel)

  Future<void> getChallenges(
      {required Function successCallback, Function? errorCallback}) async {
    await ActivityService.getChallenges(
      successCallback: successCallback,
      errorCallback: errorCallback,
    );
  }

  String getCourseRouteString(ChallengeCourseModel course) {
    List<String> checkpointNames =
        course.checkpoints != null && course.checkpoints!.isNotEmpty
            ? course.checkpoints!.map((checkpoint) => checkpoint.name!).toList()
            : [];
    List<String> fullCourseRoute = [
      course.startPointName ?? '',
      ...checkpointNames,
      course.endPointName ?? ''
    ];
    return fullCourseRoute.join(' - ');
  }
}
