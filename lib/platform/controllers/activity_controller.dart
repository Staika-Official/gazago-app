import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';

class Permissions {
  final LocationPermission locationPermission;
  final LocationAccuracyStatus locationAccuracyStatus;

  Permissions({
    required this.locationPermission,
    required this.locationAccuracyStatus,
  });
}

class ActivityController extends GetxController {
  //index.dart
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

  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());

  //activity active
  final updateInterval = 3000;
  final Location location = Location();
  final Rx<LocationData> currentLocation = Rx(LocationData.fromMap({}));
  final RxList<ChallengeModel> challengeList = RxList.empty();
  late final Timer? updateTimer;
  final RxList<LatLng> coordinates = RxList.empty();
  Completer<NaverMapController> _controllerMap = Completer();
  Stream<StepCount> _stepCountStream = Pedometer.stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  final RxInt steps = RxInt(0);
  final RxString pedestrianStatus = RxString('');

  RxDouble get speed {
    return RxDouble(currentLocation.value.speed ?? 0);
  }

  RxDouble get altitude {
    return RxDouble(currentLocation.value.altitude ?? 0);
  }

  @override
  void onInit() {
    initStats();
    getExerciseStatus();
    getCurrentLocation();
    super.onInit();
  }

  @override
  void onClose() {
    updateTimer!.cancel();
    super.onClose();
  }

  void initStats() {
    statList.value = [
      StatModel(name: '체력', currentStat: 78),
      StatModel(name: '내구도', currentStat: 55),
    ];
  }

  void getExerciseStatus() async {
    userState.value = await ActivityService.getCurrentUserState();
    inspect(userState.value);
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
    if ((permissions.locationPermission != LocationPermission.always && permissions.locationPermission != LocationPermission.whileInUse) ||
        permissions.locationAccuracyStatus != LocationAccuracyStatus.precise) {
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
    if (userState.value.exercise != null) {
      Get.toNamed(Routes.activityActive);
    } else {
      Get.toNamed(Routes.activitySelect);
    }
  }

  void startExercise() {
    getChallengeList();
    initStream();
    updateTimer = updateActivityRecord();
  }

  void endActivity() async {
    CurrentUserStateModel newUserState = await ActivityService.fetchEndUserExercises(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: userState.value.exercise!.steps,
        speed: userState.value.exercise!.speed,
        distance: userState.value.exercise!.distance,
        altitude: userState.value.exercise!.altitude,
        time: userState.value.exercise!.time,
        locations: userState.value.exercise!.locations,
      ),
    );
    if (newUserState.exercise!.state == 'ENDED') {
      userState.value = newUserState;
      userState.value.exercise = null;
      updateTimer!.cancel();
    }
  }

  void loadActivity() {
    Get.toNamed(Routes.activityLoading);
    Timer(
      Duration(seconds: 3),
      () {
        Get.offNamed(Routes.activityActive);
        startExercise();
      },
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
    if (permission != LocationPermission.always) {
      await Geolocator.openAppSettings();
    }
  }

  //activtiy active method

  initStream() async {
    UserExerciseModel exerciseModel = await ActivityService.fetchStartUserExercises(
      UserExerciseModel(
        userId: int.parse(
          HiveStore.loadString(
            key: HiveKey.userId.name,
          )!,
        ),
        steps: 0,
        speed: 0.0,
        distance: 0.0,
        altitude: currentLocation.value.altitude,
        time: 0,
        startPoint: '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
      ),
    );
    userState.value.exercise = exerciseModel;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
    addLocationListener();
  }

  void onStepCount(StepCount event) {
    steps.value = event.steps;
    userState.value.exercise!.steps = event.steps;
  }

  void onStepCountError(error) {
    /// Handle the error
    print(error);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    pedestrianStatus.value = event.status;
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
    print(error);
  }

  void getCurrentLocation() async {
    await location.enableBackgroundMode(enable: true);
    currentLocation.value = await location.getLocation();
  }

  void addLocationListener() {
    location.onLocationChanged.listen((LocationData location) {
      currentLocation.value = location;

      addLocation(location);
    });
  }

  Timer updateActivityRecord() {
    return Timer.periodic(
      Duration(milliseconds: updateInterval),
      (timer) async {
        CurrentUserStateModel newUserState = await ActivityService.fetchUpdateUserExercises(
          UserExerciseModel(
            id: userState.value.exercise!.id,
            steps: userState.value.exercise!.steps,
            speed: currentLocation.value.speed,
            distance: userState.value.exercise!.distance,
            altitude: currentLocation.value.altitude,
            time: userState.value.exercise!.time,
            locations: userState.value.exercise!.locations,
          ),
        );
        userState.value = newUserState;
      },
    );
  }

  void addLocation(LocationData location) {
    coordinates.add(LatLng(location.latitude!, location.longitude!));
  }

  void getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  void onMapCreated(NaverMapController controller) {
    if (_controllerMap.isCompleted) _controllerMap = Completer();
    _controllerMap.complete(controller);
  }

  onMapTap(LatLng position) async {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapLongTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapDoubleTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onMapTwoFingerTap(LatLng position) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  onSymbolTap(LatLng? position, String? caption) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        '[onSymbolTap] caption: $caption, lat: ${position!.latitude}, lon: ${position!.longitude}',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.black,
    ));
  }

  void onCameraChange(LatLng? latLng, CameraChangeReason? reason, bool? isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng!.latitude}, ${latLng!.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void onCameraIdle() {
    print('카메라 움직임 멈춤');
  }
}
