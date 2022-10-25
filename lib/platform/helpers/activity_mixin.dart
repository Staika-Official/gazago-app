import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';

class ActivityMixin {
  GlobalController globalController = Get.find();

  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
  final updateInterval = 10000;
  final Rx<Position> currentLocation = Rx(Position(speed: 0, altitude: 0, accuracy: 0, heading: 0, latitude: 0, longitude: 0, speedAccuracy: 0, timestamp: DateTime.now()));
  final RxList<UserExerciseModel> exerciseData = RxList.empty();
  final RxList<LatLng> coordinates = RxList.empty();
  final RxInt exerciseTime = RxInt(0);
  final RxInt exerciseSteps = RxInt(0);
  final RxString pedestrianStatus = RxString('STOPPED');
  final Rx<ExerciseState> exerciseState = Rx(ExerciseState.init);
  Timer? exerciseTimer;
  Timer? updateTimer;
  Timer? stopTimer;
  final RxDouble stopProgress = RxDouble(0);
  Completer<NaverMapController> mapCompleter = Completer();
  StreamSubscription<Position>? locationSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;
  final HealthFactory health = HealthFactory();
  final Rx<DateTime> pedestrianStoppedTime = Rx(DateTime.now());
  final RxInt updateCount = RxInt(0);
  final RxString lastUpdateTime = RxString('');

  RxDouble get realTimeSpeed {
    double speed = exerciseData.isNotEmpty ? exerciseData.last.speed! : 0;

    // 15초 이상 걷기 감지가 되지 않을 경우에는 속도 0으로 표시
    if (speed > 0 && pedestrianStatus.value == 'STOPPED') {
      DateTime now = DateTime.now();
      if (pedestrianStoppedTime.value.add(const Duration(seconds: 15)).compareTo(now) < 0) {
        speed = 0;
      }
    } else {
      pedestrianStoppedTime.value = DateTime.now();
    }
    return RxDouble(speed <= 0 ? 0 : speed);
  }

  RxDouble get avgSpeed {
    //보통사람의 걷기 속도는 평균 3~4.5kmH이다. 따라서 3 = 0.8333 m/s 4.5 = 1.25m/s
    // List<double> speedList = exerciseData.where((data) => data.speed! > 0.833).map((filteredLocation) => filteredLocation.speed!).toList();

    // List<double> speedList = exerciseData.where((data) => data.speed! > 0.2 && data.speed! < 15).map((filteredLocation) => filteredLocation.speed!).toList();
    List<double> speedList = exerciseData.where((data) => data.speed! > 0).map((filteredLocation) => filteredLocation.speed!).toList();
    return RxDouble(calculateAvgSpeed(speedList));
  }

  RxDouble get totalDistance {
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
    return coordinates.isNotEmpty ? RxDouble(calculateTotalDistance(distanceList)) : RxDouble(0);
  }

  RxList<double> get altitudes {
    return RxList(exerciseData.map((location) => location.altitude!).toList());
  }

  RxDouble get highestAltitude {
    List<double> altitudeList = exerciseData.map((location) => location.altitude!).toList();
    return RxDouble(highestClimbed(altitudeList));
  }

  Rx<UserExerciseModel> get userExerciseData {
    return Rx(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: exerciseSteps.value,
        speed: avgSpeed.value,
        distance: convertKmToMeters(totalDistance.value),
        altitude: highestAltitude.value,
        time: exerciseTime.value,
        locations: coordinatesToString(coordinates),
      ),
    );
  }

  late final Rx<OverlayImage?> startMarkerImage = Rx(null);
  late final Rx<OverlayImage?> finishMarkerImage = Rx(null);

  void initStream() {
    initExerciseTimer();
    initStepStream();
    initPedestrianStatusStream();
  }

  void initExerciseStats() {
    exerciseData.value = List.empty(growable: true);
    coordinates.value = List.empty(growable: true);
    exerciseSteps.value = 0;
    exerciseTime.value = 0;
    pedestrianStatus.value = 'STOPPED';
  }

  void initExerciseTimer() {
    if (exerciseTimer != null) {
      exerciseTimer!.cancel();
      exerciseTimer = null;
    }

    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      exerciseTime.value++;

      UserExerciseModel exerciseModel = userState.value.exercise!;
      exerciseModel.id = userState.value.exercise!.id;
      exerciseModel.steps = exerciseSteps.value;
      exerciseModel.speed = avgSpeed.value;
      exerciseModel.distance = convertKmToMeters(totalDistance.value);
      exerciseModel.altitude = highestAltitude.value;
      exerciseModel.time = exerciseTime.value;
      exerciseModel.locations = coordinatesToString(coordinates);

      HiveStore.saveCurrentUserState(
        userState: CurrentUserStateModel(
          state: userState.value.state,
          exercise: exerciseModel,
          shoes: userState.value.shoes,
        ),
      );
    });
  }

  void initStepStream() {
    if (stepSubscription != null) {
      stepSubscription = null;
      HiveStore.save(key: HiveKey.exerciseStarted.name, value: false);
    }
    // if (Platform.isAndroid) {
    //   stepSubscription ??= Pedometer.stepCountStream.skip(1).listen((StepCount event) async {
    //     if (exerciseState.value == ExerciseState.ongoing) exerciseSteps.value++;
    //   });
    // } else {
    //   int savedSteps = 0;
    //   stepSubscription ??= Pedometer.stepCountStream.listen((StepCount event) async {
    //     bool isExerciseStarted = HiveStore.load(key: HiveKey.exerciseStarted.name);
    //     if (!isExerciseStarted) {
    //       print('!started');
    //       deviceSteps.value = event.steps;
    //       HiveStore.save(key: HiveKey.dummyStepCount.name, value: deviceSteps.value);
    //       HiveStore.save(key: HiveKey.exerciseStarted.name, value: true);
    //       savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name);
    //       print('savedSteps !start: $savedSteps');
    //     } else if (exerciseState.value == ExerciseState.ongoing) {
    //       int dummySteps = HiveStore.load(key: HiveKey.dummyStepCount.name);
    //       print('dummySteps: $dummySteps');
    //       print('event.steps: ${event.steps}');
    //       print('savedSteps: $savedSteps');
    //       int actualSteps = (event.steps - dummySteps) + savedSteps;
    //       print('actualSteps: $actualSteps');
    //       exerciseSteps.value = actualSteps;
    //       deviceSteps.value = event.steps;
    //       HiveStore.save(key: HiveKey.currentStepCount.name, value: event.steps);
    //       HiveStore.save(key: HiveKey.savedStepCount.name, value: actualSteps);
    //     }
    //   });
    // }

    int savedSteps = 0;
    stepSubscription ??= Pedometer.stepCountStream.listen((StepCount event) async {
      bool isExerciseStarted = HiveStore.load(key: HiveKey.exerciseStarted.name);
      if (!isExerciseStarted) {
        HiveStore.save(key: HiveKey.dummyStepCount.name, value: event.steps);
        HiveStore.save(key: HiveKey.exerciseStarted.name, value: true);
        savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name);
      } else if (exerciseState.value == ExerciseState.ongoing) {
        int dummySteps = HiveStore.load(key: HiveKey.dummyStepCount.name);
        int actualSteps = (event.steps - dummySteps) + savedSteps;
        exerciseSteps.value = actualSteps;
        HiveStore.save(key: HiveKey.savedStepCount.name, value: actualSteps);
      }
    });

    stepSubscription!.onError((error) {
      print(error);
      HiveStore.save(key: HiveKey.exerciseStarted.name, value: false);
    });
  }

  void initPedestrianStatusStream() {
    if (pedestrianStatusSubscription != null) {
      pedestrianStatusSubscription = null;
    }

    pedestrianStatusSubscription ??= Pedometer.pedestrianStatusStream.skip(1).listen((PedestrianStatus event) {
      pedestrianStatus.value = event.status.toUpperCase();
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void startExercise(ExerciseType exerciseType, ChallengeModel? challenge) async {
    if (globalController.connectivityResult.value != ConnectivityResult.none) {
      await ActivityService.fetchStartUserExercises(
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
          startPoint: challenge != null ? challenge.firstName : '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
          challengeId: challenge?.id,
        ),
        Platform.operatingSystem,
        successCallback: (UserExerciseModel userExerciseData) {
          userState.update((state) => state!.exercise = userExerciseData);
          exerciseState.value = ExerciseState.ongoing;
          HiveStore.save(key: HiveKey.exerciseStarted.name, value: false);
          HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
          initExerciseStats();
          initStream();
          startPeriodicUpdate();
        },
        errorCallback: (int statusCode, String statusMessage) {
          Get.snackbar(statusCode.toString(), statusMessage);
        },
      );
    } else {
      Get.snackbar('인터넷 연결 불가', '인터넷 상태를 확인해주세요', colorText: Colors.white);
    }
  }

  void continueExercise() {
    exerciseData.value = List.empty(growable: true);
    exerciseState.value = ExerciseState.ongoing;
    exerciseData.add(userState.value.exercise!);
    exerciseTime.value = userState.value.exercise!.time!;
    exerciseSteps.value = userState.value.exercise!.steps!;

    coordinates.value = List.empty(growable: true);
    if (userState.value.exercise!.locations != null) {
      coordinates.addAll(parseCoordinates());
    }

    initStream();
    updateExercise();
    startPeriodicUpdate();
  }

  RxList<LatLng> parseCoordinates() {
    return RxList(locationStringToLatLng(userState.value.exercise!.locations!));
  }

  void updateExercise() async {
    void errorHandler() {
      updateTimer?.cancel();
      updateTimer = null;
    }

    if (globalController.connectivityResult.value != ConnectivityResult.none) {
      await ActivityService.fetchUpdateUserExercises(
        userExerciseData.value,
        Platform.operatingSystem,
        successCallback: (CurrentUserStateModel newUserState) {
          userState.update((state) {
            state?.state = newUserState.state;
            state?.exercise = newUserState.exercise;
            state?.shoes = newUserState.shoes;
          });
          updateCount.value = updateCount.value + 1;
          lastUpdateTime.value = DateTime.now().toIso8601String();
        },
        errorCallback: errorHandler,
      );
    } else {
      CurrentUserStateModel savedState = HiveStore.loadCurrentUserState()!;
      userState.update((state) {
        state?.state = savedState.state;
        state?.exercise = savedState.exercise;
        state?.shoes = savedState.shoes;
      });
    }
  }

  void startPeriodicUpdate() {
    if (updateTimer != null) {
      updateTimer!.cancel();
      updateTimer = null;
    }

    updateTimer = Timer.periodic(
      Duration(milliseconds: updateInterval),
      (timer) {
        updateExercise();
      },
    );
  }

  void onTapDownStop(TapDownDetails tapDownDetails, ChallengeModel challenge) {
    Duration counter = Duration.zero;

    if (stopTimer != null) {
      initializeStopTimer();
    }

    stopTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (counter == const Duration(seconds: 1)) {
        initializeStopTimer();
        endExercise(challenge);
      }
      counter = counter + const Duration(milliseconds: 10);
      stopProgress.value += 0.01;
    });
  }

  void onTapUpStop(TapUpDetails tapUpDetails) {
    stopProgress.value = 0;
    initializeStopTimer();
  }

  void initializeStopTimer() {
    stopTimer?.cancel();
    stopTimer = null;
  }

  void pauseExercise() {
    updateTimer?.cancel();
    exerciseTimer?.cancel();
    stepSubscription?.cancel();
    pedestrianStatusSubscription?.cancel();
    exerciseState.value = ExerciseState.paused;
    updateExercise();
  }

  void endExercise(ChallengeModel challenge) async {
    if (globalController.connectivityResult.value != ConnectivityResult.none) {
      await ActivityService.fetchEndUserExercises(userExerciseData.value, successCallback: (CurrentUserStateModel newUserState) {
        if (newUserState.exercise!.state == 'ENDED') {
          exerciseState.value = ExerciseState.ready;
          userState.update((state) {
            state?.state = newUserState.state;
            state?.exercise = newUserState.exercise;
            state?.shoes = newUserState.shoes;
          });
          HiveStore.deleteMultipleKeys(keys: [HiveKey.userState.name, HiveKey.endExerciseRequested.name]);
          resetVariables(challenge);
          resetTimer();
          resetSubscriptions();
        }
      }, errorCallback: () {
        Get.snackbar('운동 종료 불가', '운동이 정상적으로 종료되지 않았습니디.', colorText: Colors.white);
      });
    } else {
      exerciseState.value = ExerciseState.ready;
      CurrentUserStateModel savedState = HiveStore.loadCurrentUserState()!;
      userState.update((_state) {
        _state?.state = savedState.state;
        _state?.exercise = savedState.exercise;
        _state?.shoes = savedState.shoes;
      });
      userState.value.exercise!.state = 'ENDED';
      HiveStore.saveCurrentUserState(userState: userState.value);
      HiveStore.save(key: HiveKey.endExerciseRequested.name, value: true.toString());
      resetVariables(challenge);
      resetTimer();
      resetSubscriptions();
    }
  }

  void resetVariables(ChallengeModel challenge) {
    exerciseTime.value = 0;
    stopProgress.value = 0;
    exerciseSteps.value = 0;
    userState.value.exercise!.rewardGo = 0;
    exerciseData.value = List.empty(growable: true);
    coordinates.value = List.empty(growable: true);
    challenge.id = null;

    //TODO 삭제
    updateCount.value = 0;
    lastUpdateTime.value = '';
  }

  void resetTimer() {
    updateTimer?.cancel();
    updateTimer = null;
    exerciseTimer?.cancel();
    exerciseTimer = null;
  }

  void resetSubscriptions() {
    stepSubscription?.cancel();
    stepSubscription = null;
    HiveStore.save(key: HiveKey.exerciseStarted.name, value: false);
    HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
  }

  void showExerciseMap(Widget mapWidget) {
    Get.dialog(mapWidget, barrierDismissible: false);
  }

  Future<void> setMarkerImages() async {
    startMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/start.png');
    finishMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/finish.png');
  }
}
