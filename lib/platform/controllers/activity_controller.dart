import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class Permissions {
  final LocationPermission locationPermission;
  final LocationAccuracyStatus locationAccuracyStatus;

  Permissions({
    required this.locationPermission,
    required this.locationAccuracyStatus,
  });
}

class ActivityController extends GetxController with MapMixin, ActivityMixin, ChallengeMixin {
  //index.dart
  final RxList<StatModel> statList = RxList.empty();
  RxList<Map> get activitySumList {
    return RxList([
      {'title': '총 운동 시간', 'content': '1일 ${'03:15:12'}'},
      {'title': '총 운동 거리', 'content': '${300.34.toString()} km'},
      {'title': '총 걸음 수', 'content': '${12682.toString()}'},
      {'title': '총 획득 Taika', 'content': '${200.toString()}'},
    ]);
  }

  //activity active

  @override
  void onInit() async {
    getUserState();
    await getCurrentLocation();
    getNearByChallengeList(currentLocation.value);
    initLocationStream();
    getChallengeList();
    await setMarkerImages();
    super.onInit();
  }

  @override
  void onClose() {
    updateTimer?.cancel();
    exerciseTimer?.cancel();
    stepSubscription!.cancel();
    locationSubscription!.cancel();
    pedestrianStatusSubscription!.cancel();
    super.onClose();
  }

  void getUserState() async {
    userState.value = await ActivityService.getCurrentUserState();
    statList.value = [
      StatModel(name: '체력', currentStat: userState.value.state!.stamina),
      StatModel(name: '내구도', currentStat: userState.value.shoes!.durability!),
    ];

    if (userState.value.exercise != null && userState.value.exercise!.state == 'ONGOING') {
      continueExercise();
    }
  }

  void checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    if (!isGpsAvailable) return;

    bool hasPermission = await checkLocationPermission();
    if (hasPermission) getActivityRoute();
  }

  Future<bool> checkGpsSensor() async {
    bool isGpsAvailable = await Geolocator.isLocationServiceEnabled();
    if (!isGpsAvailable) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('운동을 시작하기 위해서 GPS를 켜주세요.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }

    return isGpsAvailable;
  }

  Future<bool> checkLocationPermission() async {
    Permissions permissions = await checkPermissions();
    bool hasPermission = (permissions.locationPermission == LocationPermission.always || permissions.locationPermission == LocationPermission.whileInUse) &&
        permissions.locationAccuracyStatus == LocationAccuracyStatus.precise;
    if (!hasPermission) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('원활한 채굴을 위하여\n"항상", "정확한" 위치공유를\n할 수 있도록 설정해주시기 바랍니다.'),
          actions: [
            ElevatedButton(onPressed: () => requestPermission(permissions), child: const Text('확인')),
            ElevatedButton(onPressed: () => getActivityRoute(), child: const Text('무시')),
          ],
        ),
      );
    }

    return hasPermission;
  }

  void getActivityRoute() {
    if (userState.value.exercise != null) {
      Get.toNamed(Routes.activityActive);
    } else {
      Get.toNamed(Routes.activitySelect);
    }
  }

  void loadExercise(ExerciseType exerciseType) {
    Get.toNamed(Routes.activityLoading);
    Timer(
      Duration(seconds: 3),
      () {
        Get.offNamed(Routes.activityActive);
        startExercise(exerciseType);
      },
    );
  }

  Future<Permissions> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();

    return Permissions(locationPermission: permission, locationAccuracyStatus: accuracyStatus);
  }

  Future<void> requestPermission(Permissions permissions) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always) {
      await Geolocator.openAppSettings();
    }
  }

  void initLocationStream() {
    location.onLocationChanged.listen((LocationData location) {
      currentLocation.value = location;
      detectChallengeZone(location);
      locations.add(location);
    });
  }

  Future<void> getCurrentLocation() async {
    await location.enableBackgroundMode(enable: true);
    currentLocation.value = await location.getLocation();
  }
}
