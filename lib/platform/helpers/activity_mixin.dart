import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';

class ActivityMixin {
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

  RxDouble get realTimeSpeed {
    double speed = currentLocation.value.speed ?? 0;
    return RxDouble(speed <= 0 ? 0 : convertMStoKMH(currentLocation.value.speed!));
  }

  RxDouble get avgSpeed {
    //보통사람의 걷기 속도는 평균 3~4.5kmH이다. 따라서 3 = 0.8333 m/s 4.5 = 1.25m/s
    // List<double> speedList = exerciseData.where((data) => data.speed! > 0.833).map((filteredLocation) => filteredLocation.speed!).toList();

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
      exerciseTimer = null;
    }

    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      exerciseTime.value++;
    });
  }

  void initStepStream() {
    stepSubscription ??= Pedometer.stepCountStream.listen((StepCount event) {
      exerciseSteps.value++;
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void initPedestrianStatusStream() {
    pedestrianStatusSubscription ??= Pedometer.pedestrianStatusStream.listen((PedestrianStatus event) {
      pedestrianStatus.value = event.status.toUpperCase();
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void startExercise(ExerciseType exerciseType, ChallengeModel? challenge) async {
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
        startPoint: challenge != null ? challenge.firstName : '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
        challengeId: challenge?.id,
      ),
    );
    userState.update((state) => state!.exercise = exerciseModel);
    exerciseState.value = ExerciseState.ongoing;
    initExerciseStats();
    initStream();
    startPeriodicUpdate();
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

    CurrentUserStateModel newUserState = await ActivityService.fetchUpdateUserExercises(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: exerciseSteps.value,
        speed: avgSpeed.value,
        distance: totalDistance.value,
        altitude: highestAltitude.value,
        time: exerciseTime.value,
        locations: coordinatesToString(coordinates),
      ),
      onError: errorHandler,
    );
    userState.value = newUserState;
  }

  void startPeriodicUpdate() {
    if (updateTimer != null) {
      updateTimer = null;
    }

    updateTimer = Timer.periodic(
      Duration(milliseconds: updateInterval),
      (timer) {
        updateExercise();
      },
    );
  }

  void onTapDownStop(TapDownDetails tapDownDetails) {
    Duration counter = Duration.zero;

    if (stopTimer != null) {
      initializeStopTimer();
    }

    stopTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (counter == const Duration(seconds: 1)) {
        initializeStopTimer();
        endExercise();
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
    stepSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
    exerciseState.value = ExerciseState.paused;
    updateExercise();
  }

  void endExercise() async {
    CurrentUserStateModel newUserState = await ActivityService.fetchEndUserExercises(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: exerciseSteps.value,
        speed: avgSpeed.value,
        distance: totalDistance.value,
        altitude: highestAltitude.value,
        time: exerciseTime.value,
        locations: coordinatesToString(coordinates),
      ),
    );

    if (newUserState.exercise!.state == 'ENDED') {
      exerciseState.value = ExerciseState.ready;
      userState.update((state) {
        state = newUserState;
      });
      exerciseTime.value = 0;
      stopProgress.value = 0;
      updateTimer?.cancel();
      updateTimer = null;
      exerciseTimer?.cancel();
      exerciseTimer = null;
      stepSubscription?.cancel();
      stepSubscription = null;
      pedestrianStatusSubscription?.cancel();
      pedestrianStatusSubscription = null;
    }
  }

  void showExerciseMap(Widget mapWidget) {
    Get.dialog(mapWidget, barrierDismissible: false);
  }

  Future<void> setMarkerImages() async {
    startMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/start.png');
    finishMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/finish.png');
  }
}
