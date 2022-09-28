import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
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

class ActivityController extends GetxController with MapMixin, ActivityMixin {
  //index.dart
  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
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
  final updateInterval = 10000;
  final Location location = Location();
  final Rx<LocationData> currentLocation = Rx(LocationData.fromMap({}));
  final RxList<ChallengeModel> challengeList = RxList.empty();
  final RxList<LocationData> locations = RxList.empty();
  final RxString pedestrianStatus = RxString('');
  final RxBool isInsideChallengeStart = RxBool(false);
  final RxBool isInsideChallengeFinish = RxBool(false);
  final RxInt exerciseTime = RxInt(0);
  Timer? exerciseTimer;
  Timer? updateTimer;
  Completer<NaverMapController> mapCompleter = Completer();
  StreamSubscription<LocationData>? locationSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;

  RxInt get steps {
    return RxInt(userState.value.exercise?.steps ?? 0);
  }

  RxDouble get speed {
    return RxDouble(currentLocation.value.speed ?? 0);
  }

  RxDouble get altitude {
    return RxDouble(currentLocation.value.altitude ?? 0);
  }

  RxList<LatLng> get coordinates {
    if (userState.value.exercise?.locations != null) {
      List<LatLng> locations = locationStringToLatLng(userState.value.exercise!.locations!);
      return RxList(locations.map((location) => LatLng(location.latitude, location.longitude)).toList());
    } else {
      return RxList.empty();
    }
  }

  RxList<double> get speeds {
    return RxList(locations.where((location) => location.speed! > 0.2).map((filteredLocation) => filteredLocation.speed!).toList());
  }

  RxList<double> get distances {
    if (userState.value.exercise!.locations != null) {
      List<LatLng> coordinates = locationStringToLatLng(userState.value.exercise!.locations!);
      List<double> distanceList = List.empty(growable: true);
      for (int i = 0; i < coordinates.length - 1; i++) {
        distanceList.add(
          calculateDistance(
            coordinates[i].latitude,
            coordinates[i].longitude,
            coordinates[i + 1].latitude,
            coordinates[i + 1].longitude,
          ),
        );
      }
      return RxList(distanceList);
    } else {
      return RxList.empty();
    }
  }

  RxDouble get totalDistance {
    return RxDouble(calculateTotalDistance(distances));
  }

  RxList<double> get altitudes {
    return RxList(locations.map((location) => location.altitude!).toList());
  }

  late final Rx<OverlayImage?> startMarkerImage = Rx(null);
  late final Rx<OverlayImage?> finishMarkerImage = Rx(null);

  @override
  void onInit() async {
    getUserState();
    getCurrentLocation();
    initLocationStream();
    getNearByChallengeList();
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

  void startExercise(ExerciseType exerciseType) async {
    UserExerciseModel exerciseModel = await ActivityService.fetchStartUserExercises(
      UserExerciseModel(
        userId: int.parse(
          HiveStore.loadString(
            key: HiveKey.userId.name,
          )!,
        ),
        userNickname: HiveStore.loadString(key: HiveKey.nickname.name),
        userProfileImageUrl: HiveStore.loadString(key: HiveKey.profileImageUrl.name),
        type: exerciseType.value,
        steps: 0,
        speed: 0,
        distance: 0,
        altitude: currentLocation.value.altitude,
        time: 0,
        startPoint: '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
        challengeId: null, // TODO. 현위치랑 가까운 곳에 있는 챌린지를 처음 앱실행할때 가져오도록 수정필요
      ),
    );
    userState.value.exercise = exerciseModel;
    initExerciseStats();
    initStream();
    startPeriodicUpdate();
  }

  void continueExercise() {
    locations.value = List.empty(growable: true);
    String storeList = HiveStore.loadString(key: HiveKey.locationData.name)!;
    print(storeList);
    // locations.addAll();
    initStream();
    updateExercise();
    startPeriodicUpdate();
  }

  void updateExercise() async {
    CurrentUserStateModel newUserState = await ActivityService.fetchUpdateUserExercises(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: userState.value.exercise!.steps,
        speed: calculateAvgSpeed(speeds),
        distance: calculateTotalDistance(distances),
        altitude: highestClimbed(altitudes),
        time: userState.value.exercise!.time,
        locations: coordinatesToString(coordinates),
      ),
    );
    userState.value = newUserState;
  }

  void startPeriodicUpdate() {
    updateTimer = Timer.periodic(
      Duration(milliseconds: updateInterval),
      (timer) {
        updateExercise();
      },
    );
  }

  void endExercise() async {
    CurrentUserStateModel newUserState = await ActivityService.fetchEndUserExercises(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: userState.value.exercise!.steps,
        speed: calculateAvgSpeed(speeds),
        distance: calculateTotalDistance(distances),
        altitude: highestClimbed(altitudes),
        time: userState.value.exercise!.time,
        locations: coordinatesToString(coordinates),
      ),
    );

    if (newUserState.exercise!.state == 'ENDED') {
      userState.value = newUserState;
      userState.value.exercise = null;
      updateTimer!.cancel();
      exerciseTimer!.cancel();
      stepSubscription!.cancel();
      pedestrianStatusSubscription!.cancel();
      HiveStore.deleteKey(key: HiveKey.locationData.name);
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

  void initStream() {
    initExerciseTimer();
    initStepStream();
    initPedestrianStatusStream();
  }

  void initExerciseTimer() {
    if (userState.value.exercise!.time == null) userState.value.exercise!.time = 0;
    exerciseTime.value = userState.value.exercise!.time!;

    exerciseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (userState.value.exercise?.time != null) {
        userState.value.exercise!.time = userState.value.exercise!.time! + 1;
        exerciseTime.value++;
      }
    });
  }

  void initStepStream() {
    stepSubscription = Pedometer.stepCountStream.listen((StepCount event) {
      userState.value.exercise!.steps = event.steps;
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void initPedestrianStatusStream() {
    pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen((PedestrianStatus event) {
      pedestrianStatus.value = event.status;
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void initLocationStream() {
    location.onLocationChanged.listen((LocationData location) {
      print('----------------------------------------');
      print('----------------------------------------');
      print('----------------------------------------');
      print('----------------------------------------');
      currentLocation.value = location;
      locations.add(location);
      for (var element in locations) {
        print(element);
        print(element.speed);
        print(element.time);
      }
    });
  }

  void detectChallengeZone(LocationData location) {}

  void initExerciseStats() {
    locations.value = List.empty(growable: true);
    userState.value.exercise!.steps = 0;
    userState.value.exercise!.time = 0;
    pedestrianStatus.value = '';
  }

  void getCurrentLocation() async {
    await location.enableBackgroundMode(enable: true);
    currentLocation.value = await location.getLocation();
  }

  void getChallengeList() async {
    challengeList.value = await ActivityService.getChallenges();
  }

  void getNearByChallengeList() async {
    challengeList.value = await ActivityService.getNearByChallenges(currentLocation.value);
  }

  Future<void> setMarkerImages() async {
    startMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/start.png');
    finishMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/finish.png');
  }
}
