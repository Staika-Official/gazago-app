import 'dart:async';

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
  final RxList<LocationData> locations = RxList.empty();
  final RxString pedestrianStatus = RxString('');
  Timer? exerciseTimer;
  Timer? updateTimer;
  Completer<NaverMapController> mapCompleter = Completer();
  StreamSubscription<LocationData>? locationSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;

  RxInt get steps {
    return RxInt(userState.value.exercise?.steps ?? 0);
  }

  RxInt get time {
    return RxInt(userState.value.exercise?.time ?? 0);
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

  void initStream() {
    initExerciseTimer();
    initStepStream();
    initPedestrianStatusStream();
  }

  void initExerciseStats() {
    locations.value = List.empty(growable: true);
    userState.update((state) {
      state?.exercise!.steps = 0;
      state?.exercise!.time = 0;
    });
    pedestrianStatus.value = '';
  }

  void initExerciseTimer() {
    if (userState.value.exercise!.time == null) userState.update((state) => state?.exercise!.time = 0);

    exerciseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (userState.value.exercise?.time != null) {
        userState.update((state) {
          state?.exercise!.time = state.exercise!.time! + 1;
        });
      }
    });
  }

  void initStepStream() {
    stepSubscription = Pedometer.stepCountStream.listen((StepCount event) {
      print('================');
      print('================');
      print('================');
      print(event.steps);
      print('================');
      print('================');
      print(userState.value.exercise?.steps);
      print('================');
      print('================');
      userState.update((state) => state?.exercise!.steps = event.steps);
      print(userState.value.exercise?.steps);
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
        startPoint: '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
        challengeId: challengeId, // TODO. 현위치랑 가까운 곳에 있는 챌린지를 처음 앱실행할때 가져오도록 수정필요
      ),
    );
    userState.update((state) => state!.exercise = exerciseModel);
    initExerciseStats();
    initStream();
    startPeriodicUpdate();
  }

  void continueExercise() {
    locations.value = List.empty(growable: true);
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
      userState.update((state) {
        state = newUserState;
        userState.value.exercise = null;
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
