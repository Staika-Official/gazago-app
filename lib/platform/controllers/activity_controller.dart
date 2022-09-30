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
  final RxInt remainDurability = RxInt(0);
  final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);
  final RxBool isListeningToLocation = RxBool(false);

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
    await initializeActivity();
    getUserState();
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

    if (Platform.isAndroid) {
      bool hasActivityPermission = await checkActivityPermission();
      if (!hasActivityPermission) return;
    }

    bool hasPermission = await checkLocationPermission();

    bool isAccurate = false;
    if (hasPermission) {
      isAccurate = await checkLocationPermission();
    }

    if (!hasPermission && !isAccurate) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('원활한 채굴을 위하여\n"항상", "정확한" 위치공유를\n할 수 있도록 설정해주시기 바랍니다.'),
          actions: [
            ElevatedButton(onPressed: () => requestLocationPermission(), child: const Text('확인')),
          ],
        ),
      );
    } else {
      getActivityRoute();
    }

    if (!isListeningToLocation.value) {
      initializeActivity();
    }
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
    LocationPermission locationPermission = await Geolocator.checkPermission();
    bool hasPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);

    return hasPermission;
  }

  Future<bool> checkLocationAccuracy() async {
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();
    return accuracyStatus == LocationAccuracyStatus.precise;
  }

  Future<bool> checkActivityPermission() async {
    bool hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.status;
    if (!hasActivityPermission) {
      Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('정확한 운동기록을 위해서 신체활동 권한을 허용해주세요'),
          actions: [
            ElevatedButton(
              onPressed: () {
                requestActivityPermission();
                Get.back();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
    return hasActivityPermission;
  }

  Future<void> requestActivityPermission() async {
    bool permissionGranted = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.request();
    if (!permissionGranted) {
      Geolocator.openAppSettings();
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.requestPermission();
    bool gotPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
    if (!gotPermission) {
      await Geolocator.openAppSettings();
    }
  }

  void getActivityRoute() {
    if (exerciseState.value == ExerciseState.ongoing) {
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
    // TODO. 백그라운드 허용
    // bool isBackgroundAllowed = await location.enableBackgroundMode(enable: true);

    currentLocation.value = await location.getLocation();
    if (currentLocation.value.latitude != null && currentLocation.value.longitude != null) {
      isListeningToLocation.value = true;
    }
  }

  Future<void> initializeActivity() async {
    await getCurrentLocation();
    initLocationStream();
    await getNearByChallengeList(currentLocation.value);
    await setMarkerImages();
  }
}
