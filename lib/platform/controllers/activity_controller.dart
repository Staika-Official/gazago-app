import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
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
import 'package:permission_handler/permission_handler.dart' as PH;

class ActivityController extends GetxController with MapMixin, ActivityMixin, ChallengeMixin {
  final WalletMasterController walletMasterController;

  ActivityController(this.walletMasterController);
  //index.dart
  RxList<StatModel> get statList {
    return RxList([
      StatModel(name: '체력', currentStat: userState.value.state != null ? userState.value.state!.stamina! : 0, type: 'STAMINA'),
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
  final Rx<LocationPermission> _locationPermission = Rx(LocationPermission.unableToDetermine);
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus = Rx(LocationAccuracyStatus.unknown);
  StreamSubscription<ServiceStatus>? _serviceStatusStream;

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

  Future<void> initController() async {
    repairDurability.value = 0;
    remainDurability.value = 0;
    _currentSliderValue.value = 0;
    costTik.value = 0;
  }

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
    if (costTik.value > 0) {
      InventoryItemModel repairModel = await ItemService.fetchRepairItemShoes(
        RepairShoesModel(
          id: userState.value.shoes!.id,
          durability: repairDurability.value,
          feeTik: costTik.value.toInt(),
        ),
      );
      userState.update((state) {
        state!.shoes!.durability = repairModel.durability;
      });

      closeRepairPopup();
    } else {
      print('수리할 내구도가 없습니다.');
    }
  }

  //activity active

  @override
  void onInit() async {
    await checkAvailabilities();
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
    _serviceStatusStream?.cancel();
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

  requestExerciseInitialization() async {
    bool systemReady = await checkAvailabilities();
    if (systemReady) {
      getActivityRoute();
    }

    if (!isListeningToLocation.value) {
      initializeActivity();
    }
  }

  Future<bool> checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    if (!isGpsAvailable) return false;

    bool hasActivityPermission = await checkActivityPermission();
    if (!hasActivityPermission) return false;

    bool hasLocationPermissionWithAccuracy = await checkLocationPermissionAndAccuracy();
    if (!hasLocationPermissionWithAccuracy) return false;

    return true;
  }

  Future<bool> checkGpsSensor() async {
    bool isGpsAvailable = await Geolocator.isLocationServiceEnabled();
    if (!isGpsAvailable) {
      await Get.dialog(
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
    _locationPermission.value = locationPermission;
    print('locationPermission: ' + locationPermission.name);

    return [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
  }

  Future<bool> checkLocationAccuracy() async {
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();
    _locationAccuracyStatus.value = accuracyStatus;
    print('accuracy: ' + accuracyStatus.name);

    return accuracyStatus == LocationAccuracyStatus.precise;
  }

  Future<bool> checkLocationPermissionAndAccuracy() async {
    bool hasPermission = await checkLocationPermission();

    bool isAccurate = false;
    if (hasPermission) {
      isAccurate = await checkLocationAccuracy();
    }

    if (!hasPermission && !isAccurate) {
      await Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('원활한 채굴을 위하여\n"항상", "정확한" 위치공유를\n할 수 있도록 설정해주시기 바랍니다.'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  await requestLocationPermission();
                  Get.back();
                },
                child: const Text('확인')),
          ],
        ),
        barrierDismissible: false,
      );
    }

    return hasPermission && isAccurate;
  }

  Future<bool> checkActivityPermission() async {
    bool hasActivityPermission = false;
    if (Platform.isAndroid) {
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.sensors.status;
    }
    if (!hasActivityPermission) {
      await Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('정확한 운동기록을 위해서 신체활동 권한을 허용해주세요'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                hasActivityPermission = await requestActivityPermission();
                Get.back();
              },
              child: const Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
    return hasActivityPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      permissionGranted = PH.PermissionStatus.granted == await PH.Permission.sensors.request();
    }
    activityRecognitionPermission.complete(permissionGranted);

    return activityRecognitionPermission.future;
  }

  Future<bool> requestLocationPermission() async {
    Completer<bool> locationPermissionCompleter = Completer();
    LocationPermission locationPermission = await Geolocator.requestPermission();
    bool gotPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
    locationPermissionCompleter.complete(gotPermission);

    return locationPermissionCompleter.future;
  }

  void getActivityRoute() {
    if (exerciseState.value == ExerciseState.ongoing) {
      Get.toNamed(Routes.activityActive);
    } else {
      Get.toNamed(Routes.activitySelect);
    }
  }

  void loadExercise(ExerciseType exerciseType, [ChallengeModel? challenge]) {
    Get.toNamed(Routes.activityLoading);
    Timer(
      Duration(seconds: 3),
      () {
        Get.offNamed(Routes.activityActive);
        startExercise(exerciseType, challenge);
      },
    );
  }

  void moveToChallangeSelection() {
    Get.toNamed(Routes.activityChallenges);
  }

  void initLocationStream() {
    // location.onLocationChanged.listen((LocationData location) {
    //   currentLocation.value = location;
    //   exerciseData.add(UserExerciseModel(
    //     altitude: location.altitude,
    //     speed: location.speed,
    //   ));
    //   coordinates.add(LatLng(location.latitude!, location.longitude!));
    //   detectChallengeZone(location);
    //   autoFinishChallenge(userState.value);
    // });

    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 5),
          useMSLAltitude: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: "운동 기록을 측정중",
            notificationTitle: "위치 기록 중",
            enableWakeLock: true,
          ));
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: false,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    }

    locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      currentLocation.value = position;
      exerciseData.add(UserExerciseModel(
        altitude: position.altitude,
        speed: position.speed,
      ));
      coordinates.add(LatLng(position.latitude, position.longitude));
      detectChallengeZone(position);
      autoFinishChallenge(userState.value);
    });
  }

  initGpsServiceStream() {
    _serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        Get.dialog(AlertDialog(
          title: Text('경고'),
          content: Text('위치 기능이 꺼져있습니다. 서비스를 정상적으로 이용하기 위해서 다시 활성화해주세요.'),
        ));
      }
    });
  }

  Future<void> getCurrentLocation() async {
    // bool isBackgroundAllowed = await location.isBackgroundModeEnabled();
    // bool hasBackgroundPermission = false;
    // if (Platform.isAndroid && _locationPermission.value == LocationPermission.always) {
    //   hasBackgroundPermission = true;
    // } else if (Platform.isIOS && [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == _locationPermission.value)) {
    //   hasBackgroundPermission = true;
    // }
    // if (hasBackgroundPermission && !isBackgroundAllowed) {
    //   await location.enableBackgroundMode();
    // }

    // currentLocation.value = await location.getLocation();

    currentLocation.value = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (currentLocation.value.latitude != null && currentLocation.value.longitude != null) {
      isListeningToLocation.value = true;
    }
  }

  Future<void> initializeActivity() async {
    await getCurrentLocation();
    initLocationStream();
    initGpsServiceStream();
    if (currentLocation.value.latitude != null && currentLocation.value.longitude != null) {
      await getNearByChallengeList(currentLocation.value);
    } else {
      await getChallengeList();
    }
    await setMarkerImages();
  }
}
