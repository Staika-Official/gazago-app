import 'dart:async';
import 'dart:convert';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';

class ActivityMixin {
  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
  final updateInterval = 10000;
  final Location location = Location();
  final Rx<LocationData> currentLocation = Rx(LocationData.fromMap({}));
  final RxList<UserExerciseModel> exerciseData = RxList.empty();
  final RxList<LatLng> coordinates = RxList.empty();
  final RxInt exerciseTime = RxInt(0);
  final RxInt exerciseSteps = RxInt(0);
  final RxString pedestrianStatus = RxString('STOPPED');
  final Rx<ExerciseState> exerciseState = Rx(ExerciseState.init);
  Timer? exerciseTimer;
  Timer? updateTimer;
  Completer<NaverMapController> mapCompleter = Completer();
  StreamSubscription<LocationData>? locationSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;

  RxDouble get realTimeSpeed {
    double speed = currentLocation.value.speed ?? 0;
    return RxDouble(speed <= 0 ? 0 : currentLocation.value.speed!);
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
    exerciseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      exerciseTime.value++;
    });
  }

  void initStepStream() {
    stepSubscription = Pedometer.stepCountStream.listen((StepCount event) {
      exerciseSteps.value++;
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void initPedestrianStatusStream() {
    pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen((PedestrianStatus event) {
      pedestrianStatus.value = event.status.toUpperCase();
    });
    stepSubscription!.onError((error) {
      print(error);
    });
  }

  void startExercise(ExerciseType exerciseType, List<ChallengeModel> doableChallengeList) async {
    int? challengeId;
    if (exerciseType == ExerciseType.hiking && doableChallengeList.isNotEmpty) challengeId = doableChallengeList.first.id!;

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
        startPoint: challengeId != null ? doableChallengeList.first.firstName : '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
        challengeId: challengeId,
      ),
    );
    userState.update((state) => state!.exercise = exerciseModel);
    print('===================================');
    print('===================================');
    print('===================================');
    print(jsonEncode(exerciseModel));
    print('===================================');
    print('===================================');
    print('===================================');
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
      updateTimer!.cancel();
      exerciseTimer!.cancel();
      stepSubscription!.cancel();
      pedestrianStatusSubscription!.cancel();
    }
  }

  Future<void> setMarkerImages() async {
    startMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/start.png');
    finishMarkerImage.value = await OverlayImage.fromAssetImage(assetName: 'assets/icons/finish.png');
  }
}
