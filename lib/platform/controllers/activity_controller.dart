import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Permissions {
  final LocationPermission locationPermission;
  final LocationAccuracyStatus locationAccuracyStatus;

  Permissions({
    required this.locationPermission,
    required this.locationAccuracyStatus,
  });
}

class ActivityController extends GetxController {
  final RxList<StatModel> statList = RxList.empty();
  final RxInt stepCount = RxInt(0);
  RxList<Map> get activitySumList {
    return RxList([
      {'title': '총 운동 시간', 'content': '1일 ${'03:15:12'}'},
      {'title': '총 운동 거리', 'content': '${300.34.toString()} km'},
      {'title': '총 걸음 수', 'content': '${stepCount.value.toString()}'},
      {'title': '총 획득 Taika', 'content': '${200.toString()}'},
    ]);
  }

  @override
  void onInit() {
    initStats();
    super.onInit();
  }

  void initStats() {
    statList.value = [
      StatModel(name: '체력', currentStat: 78),
      StatModel(name: '내구도', currentStat: 55),
    ];
  }

  void startActivity() async {
    bool isGpsAvailable = await checkGpsAvailability();
    if (!isGpsAvailable) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('운동을 시작하기 위해서 GPS를 켜주세요.'),
          actions: [
            ElevatedButton(onPressed: () => Get.back(), child: const Text('확인')),
          ],
        ),
      );

      return;
    }

    Permissions permissions = await checkPermissions();
    if (permissions.locationPermission != LocationPermission.always || permissions.locationAccuracyStatus != LocationAccuracyStatus.precise) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('원활한 채굴을 위하여\n"항상", "정확한" 위치공유를\n할 수 있도록 설정해주시기 바랍니다.'),
          actions: [
            ElevatedButton(onPressed: () => requestPermission(permissions), child: const Text('확인')),
            ElevatedButton(onPressed: () => selectActivity(), child: const Text('무시')),
          ],
        ),
      );
    } else {
      selectActivity();
    }
  }

  void selectActivity() {
    Get.toNamed(Routes.activitySelect);
  }

  void loadActivity() {
    Get.toNamed(Routes.activityLoading);
    Timer(
      Duration(seconds: 3),
      () => Get.toNamed(Routes.activityActive),
    );
  }

  Future<bool> checkGpsAvailability() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Permissions> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();

    return Permissions(locationPermission: permission, locationAccuracyStatus: accuracyStatus);
  }

  Future<void> requestPermission(Permissions permissions) async {
    LocationPermission permission = await Geolocator.requestPermission();
    print(permission);
    if (permission != LocationPermission.always) {
      await Geolocator.openAppSettings();
    }
  }
}
