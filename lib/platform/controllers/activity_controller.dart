import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

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
  RxList<StatModel> get statList {
    return RxList([
      StatModel(name: '체력', currentStat: userState.value.state != null ? userState.value.state!.stamina : 0, type: 'STAMINA'),
      StatModel(name: '내구도', currentStat: userState.value.shoes != null ? userState.value.shoes!.durability! : 0, type: 'DURABILITY'),
    ]);
  }

  RxList<Map> get activitySumList {
    return RxList([
      {'title': '총 운동 시간', 'content': '1일 ${'03:15:12'}'},
      {'title': '총 운동 거리', 'content': '${300.34.toString()} km'},
      {'title': '총 걸음 수', 'content': '${12682.toString()}'},
      {'title': '총 획득 Taika', 'content': '${200.toString()}'},
    ]);
  }

  final RxDouble _currentSliderValue = RxDouble(0);
  RxInt remainDurability = RxInt(0);
  RxInt repairDurability = RxInt(0);
  RxInt costTik = RxInt(0);

  void onClickRepairStat(stat) {
    if (stat.type == 'DURABILITY') {
      _currentSliderValue.value = stat.currentStat;
      remainDurability.value = stat.currentStat.toInt();
    }
    handleShowStaminaPopup(stat);
  }

  void handleShowStaminaPopup(stat) {
    Get.dialog(
      AlertDialog(
        title: stat.type == 'STAMINA'
            ? const Text(
                '체력 충전 하기',
                textAlign: TextAlign.center,
              )
            : const Text(
                '내구도 수리 하기',
                textAlign: TextAlign.center,
              ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '체력 ${stat.currentStat}/100',
              textAlign: TextAlign.center,
            ),
            Obx(() {
              return Slider(
                value: _currentSliderValue.value > 100 ? 100 : double.parse(_currentSliderValue.value.toStringAsFixed(0)),
                max: 100,
                min: 0,
                divisions: stat.type == 'STAMINA' ? 10 : 100,
                label: _currentSliderValue.value.floor().toString(),
                onChanged: (double value) {
                  if (stat.type == 'STAMINA') {
                    _currentSliderValue.value = double.parse(value.toStringAsFixed(0));
                    costTik.value = _currentSliderValue.value.toInt() * 100;
                  } else {
                    if (value >= stat.currentStat.toInt().floor()) {
                      _currentSliderValue.value = value;
                      repairDurability.value = value.toInt();
                      costTik.value = (value.toInt() - remainDurability.value).abs() * 100;
                    }
                  }
                },
              );
            }),
            Obx(() {
              return Text('비용: ${costTik.value} TIK');
            }),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => closeRepairPopup(), child: const Text('아니요')),
          ElevatedButton(onPressed: () => stat.type == 'STAMINA' ? fetchRechargeStamina(stat.type) : fetchRepairShoes(), child: const Text('네')),
        ],
      ),
    );
  }

  void fetchRechargeStamina(type) async {
    UserStateModel newUserState = await ActivityService.fetchUserStaminaRecharge(
      UserStaminaRechargeModel(
        type: type,
        stat: _currentSliderValue.value.toInt(),
        feeTik: costTik.value,
      ),
    );
    userState.update((state) {
      state!.state = newUserState;
    });

    closeRepairPopup();
  }

  void fetchRepairShoes() async {
    InventoryItemModel repairModel = await ItemService.fetchRepairItemShoes(
      RepairShoesModel(
        id: userState.value.shoes!.id,
        durability: repairDurability.value,
        tik: costTik.toInt(),
      ),
    );
    userState.update((state) {
      state!.shoes!.durability = repairModel.durability;
    });

    closeRepairPopup();
  }

  void initRepairInfo() {
    repairDurability.value = 0;
    remainDurability.value = 0;
    _currentSliderValue.value = 0;
    costTik.value = 0;
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }

  //activity active

  @override
  void onInit() async {
    getUserState();
    await getCurrentLocation();
    await getNearByChallengeList(currentLocation.value);
    await setMarkerImages();
    initLocationStream();
    super.onInit();
  }

  @override
  void onClose() {
    updateTimer?.cancel();
    exerciseTimer?.cancel();
    stepSubscription?.cancel();
    locationSubscription?.cancel();
    pedestrianStatusSubscription?.cancel();
    super.onClose();
  }

  void getUserState() async {
    userState.value = await ActivityService.getCurrentUserState();
    exerciseState.value = ExerciseState.ready;

    if (userState.value.exercise != null && userState.value.exercise!.state == 'ONGOING') {
      exerciseState.value = ExerciseState.ongoing;
      continueExercise();
    }
  }

  void checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    if (!isGpsAvailable) return;

    bool hasPermission = await checkLocationPermission();
    if (hasPermission) getActivityRoute();

    requestActivityPermission();
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
        startExercise(exerciseType, doableChallenges);
      },
    );
  }

  Future<Permissions> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();

    return Permissions(locationPermission: permission, locationAccuracyStatus: accuracyStatus);
  }

  Future<PH.PermissionStatus?> checkActivityPermission() async {
    if (Platform.isAndroid) {
      return await PH.Permission.activityRecognition.status;
    }
    return null;
  }

  Future<PH.PermissionStatus?> requestActivityPermission() async {
    if (Platform.isAndroid) {
      return await PH.Permission.activityRecognition.request();
    }
    return null;
  }

  Future<void> requestPermission(Permissions permissions) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always || permission != LocationPermission.whileInUse) {
      await Geolocator.openAppSettings();
    }
  }

  void initLocationStream() {
    location.onLocationChanged.listen((LocationData location) {
      currentLocation.value = location;
      exerciseData.add(UserExerciseModel(
        altitude: location.altitude,
        speed: location.speed,
      ));
      coordinates.add(LatLng(location.latitude!, location.longitude!));
      detectChallengeZone(location);
      autoFinishChallenge(userState.value);
    });
  }

  Future<void> getCurrentLocation() async {
    await location.enableBackgroundMode(enable: true);
    currentLocation.value = await location.getLocation();
  }
}
