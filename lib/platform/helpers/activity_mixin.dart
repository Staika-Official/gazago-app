import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';

class ActivityMixin {
  GlobalController globalController = Get.find();

  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
  final RxInt loadingTime = RxInt(1);
  final Rx<Position> currentLocation = Rx(Position(speed: 0, altitude: 0, accuracy: 0, heading: 0, latitude: 0, longitude: 0, speedAccuracy: 0, timestamp: DateTime.now()));
  final RxList<UserExerciseModel> exerciseData = RxList.empty();
  final RxList<LatLng> coordinates = RxList.empty();
  final RxInt exerciseTime = RxInt(0);
  final RxInt exerciseSteps = RxInt(0);
  final RxDouble exerciseDistance = RxDouble(0);
  final RxString pedestrianStatus = RxString('STOPPED');
  final Rx<ExerciseState> exerciseState = Rx(ExerciseState.init);
  Timer? loadingTimer;
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
  final RxDouble realTimeSpeed = RxDouble(0);

  Rx<Color> get exerciseStateColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        if (realTimeSpeed.value < 1 || realTimeSpeed.value > 6) {
          color = Color(0xffFF2525);
        } else {
          color = Color(0xff18FF82);
        }
        break;
      case ExerciseState.paused:
        color = Color(0xffFBCB24);
        break;
      default:
        color = Colors.white;
        break;
    }
    return Rx(color);
  }

  /*RxDouble get realTimeSpeed {
    //realTimeSpeed.value += realTimeSpeed.value;

    print('realTimeSpeed.value ${realTimeSpeed.value}');
    *//*double speed = exerciseData.isNotEmpty ? exerciseData.last.speed! : 0;
    int prevStep = exerciseData.isNotEmpty && exerciseData.length > 2 ? exerciseData[exerciseData.length - 2].steps! : 0;
    int currentStep = exerciseData.isNotEmpty && exerciseData.length > 2 ? exerciseData.last.steps! : 0;
    DateTime now = DateTime.now();

    // 15초 이상 걷기 감지가 되지 않을 경우에는 속도 0으로 표시
    if (currentStep - prevStep <= stepDifference || exerciseState.value != ExerciseState.ongoing) {
      DateTime now = DateTime.now();
      if (pedestrianStoppedTime.value.add(const Duration(seconds: 15)).compareTo(now) < 0) {
        return RxDouble(0);
      }
    } else {
      pedestrianStoppedTime.value = DateTime.now();
    }*//*

    return RxDouble(0);
  }*/

  RxDouble get avgSpeed {
    //보통사람의 걷기 속도는 평균 3~4.5kmH이다. 따라서 3 = 0.8333 m/s 4.5 = 1.25m/s
    // List<double> speedList = exerciseData.where((data) => data.speed! > 0.833).map((filteredLocation) => filteredLocation.speed!).toList();

    // List<double> speedList = exerciseData.where((data) => data.speed! > 0.2 && data.speed! < 15).map((filteredLocation) => filteredLocation.speed!).toList();
    List<double> speedList = exerciseData.where((data) => data.speed! > 0).map((filteredLocation) => filteredLocation.speed!).toList();
    return RxDouble(calculateAvgSpeed(speedList));
  }

  RxDouble get totalDistance {
    // List<double> distanceList = List.empty(growable: true);
    //
    // for (int i = 0; i < coordinates.length - 1; i++) {
    //   distanceList.add(
    //     calculateDistance(
    //       coordinates[i].latitude,
    //       coordinates[i].longitude,
    //       coordinates[i + 1].latitude,
    //       coordinates[i + 1].longitude,
    //     ),
    //   );
    // }
    // return coordinates.isNotEmpty ? RxDouble(calculateTotalDistance(distanceList)) : RxDouble(0);
    return RxDouble(convertMetersToKm(exerciseDistance.value));
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
    exerciseDistance.value = 0;
    pedestrianStatus.value = 'STOPPED';
  }

  void initExerciseTimer() {
    if (exerciseTimer != null) {
      exerciseTimer!.cancel();
      exerciseTimer = null;
    }

    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 스피드 계산
      calRealtimeSpeed();

      if (exerciseState.value == ExerciseState.ongoing) {
        exerciseTime.value++;

        print('speedTimer ${timer}');
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
      }
    });
  }

  void initStepStream() {
    if (stepSubscription != null) {
      stepSubscription = null;
      HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    }

    int savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
    stepSubscription ??= Pedometer.stepCountStream.listen((StepCount event) async {
      print(event.steps);
      bool isExerciseStarted = HiveStore.load(key: HiveKey.savedStepInitialized.name) ?? false;
      if (!isExerciseStarted) {
        HiveStore.save(key: HiveKey.dummyStepCount.name, value: event.steps);
        HiveStore.save(key: HiveKey.savedStepInitialized.name, value: true);
        savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name);
      } else if (exerciseState.value == ExerciseState.ongoing) {
        int dummySteps = HiveStore.load(key: HiveKey.dummyStepCount.name);
        int actualSteps = (event.steps - dummySteps) + savedSteps;
        exerciseSteps.value = actualSteps;
        HiveStore.save(key: HiveKey.savedStepCount.name, value: actualSteps);
      }
    });

    stepSubscription!.onError((error) {
      showToastPopup('걸음 수를 측정할 수 없습니다.\n일시정지 후 다시 시작해주세요');
      HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    });
  }

  void calRealtimeSpeed() {
    print('calRealtimeSpeed: ${realTimeSpeed.value}, exerciseData.length: ${exerciseData.length}');

    RxDouble calRealtimeSpeed = RxDouble(0);

    double speed = exerciseData.isNotEmpty ? exerciseData.last.speed! : 0;
    int prevStep = exerciseData.isNotEmpty && exerciseData.length > 2 ? exerciseData[exerciseData.length - 2].steps! : 0;
    int currentStep = exerciseData.isNotEmpty && exerciseData.length > 2 ? exerciseData.last.steps! : 0;

    // 15초 이상 걷기 감지가 되지 않을 경우에는 속도 0으로 표시
    print('${currentStep} - ${prevStep} > ${stepDifference}');
    if (currentStep - prevStep > stepDifference) {
      DateTime now = DateTime.now();
      if (pedestrianStoppedTime.value.add(const Duration(seconds: 15)).compareTo(now) < 0) {
        calRealtimeSpeed = (exerciseState.value != ExerciseState.ongoing) ? RxDouble(0) : RxDouble(speed);
      }
    } else {
      pedestrianStoppedTime.value = DateTime.now();
    }
    realTimeSpeed.value = calRealtimeSpeed.value;
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
    if (Get.isDialogOpen != null && Get.isDialogOpen!) Get.until((route) => Get.isDialogOpen == false);
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
          HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
          HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
          initExerciseStats();
          initStream();
          startPeriodicUpdate();
        },
        errorCallback: (int statusCode, String statusMessage) {
          showToastPopup(statusMessage);
        },
      );
    } else {
      showToastPopup('인터넷 상태를 확인해주세요');
    }
  }

  void continueExercise() {
    exerciseData.value = List.empty(growable: true);
    exerciseState.value = ExerciseState.ongoing;
    exerciseData.add(userState.value.exercise!);
    exerciseTime.value = userState.value.exercise!.time!;
    exerciseSteps.value = userState.value.exercise!.steps!;
    exerciseDistance.value = userState.value.exercise!.distance!;

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
      CurrentUserStateModel savedState = HiveStore.loadCurrentUserState()!;
      userState.update((state) {
        state?.state = savedState.state;
        state?.exercise = savedState.exercise;
        state?.shoes = savedState.shoes;
      });
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

          if (userState.value.state!.stamina! < 30) {
            if (userState.value.shoes!.durability! == 0) {
              showLocalNotification(notificationType: NotificationType.stamina, title: '체력 충전 알림', message: '체력이 부족하면 GO보상이 되지 않아요. 체력 충전하러 가자GO~~');
            } else {
              showLocalNotification(notificationType: NotificationType.stamina, title: '체력 충전 알림', message: '지금 체력이 0이 되어 GO보상이 되지 않고 있어요. 체력 충전하러 가자GO~~');
            }
          }
          if (userState.value.shoes!.durability! < 30) {
            if (userState.value.shoes!.durability! == 0) {
              showLocalNotification(notificationType: NotificationType.durability, title: '아이템 수리 알림', message: '내구도(신발)가 부족하면 GO보상이 되지 않아요. 내구도 보충하러 가자GO~~');
            } else {
              showLocalNotification(notificationType: NotificationType.durability, title: '아이템 수리 알림', message: '지금 내구도(신발)가 0이 되어 GO보상이 되지 않고 있어요. 내구도 보충하러 가자GO~~');
            }
          }
          // updateCount.value = updateCount.value + 1;
          // lastUpdateTime.value = DateTime.now().toIso8601String();
        },
        errorCallback: errorHandler,
      );
    } else {
      errorHandler();
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
      if (counter == const Duration(seconds: 3)) {
        initializeStopTimer();
        showEndExerciseDialog(challenge);
      } else {
        counter = counter + const Duration(milliseconds: 10);
        stopProgress.value += (10 / 3000);
      }
    });
  }

  void onTapUpStop(TapUpDetails tapUpDetails) {
    showToastPopup('3초간 눌러야 정지됩니다.');
    initializeStopTimer();
  }

  void initializeStopTimer() {
    stopTimer?.cancel();
    stopTimer = null;
    stopProgress.value = 0;
  }

  void pauseExercise() {
    updateTimer?.cancel();
    updateTimer == null;
    //exerciseTimer?.cancel();
    //exerciseTimer == null;
    stepSubscription?.cancel();
    stepSubscription == null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription == null;
    exerciseState.value = ExerciseState.paused;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    updateExercise();
  }

  void showEndExerciseDialog(ChallengeModel challenge) {
    showAlert(
      title: '운동 종료',
      contentText: '지금까지의 기록만 저장됩니다.',
      actions: [
        Expanded(
          child: GazagoButton(
            onTap: () => Get.back(),
            buttonText: '취소',
            textColor: Colors.white,
            buttonColor: const Color(0xFF363841),
          ),
        ),
        const SizedBox(
          width: 9,
        ),
        Expanded(
          child: GazagoButton(
            onTap: () => endExercise(challenge),
            buttonText: '운동종료',
            buttonColor: const Color(0xFF0EE6F3),
          ),
        ),
      ],
    );
  }

  void endExercise(ChallengeModel challenge) async {
    if (globalController.connectivityResult.value != ConnectivityResult.none) {
      await ActivityService.fetchEndUserExercises(userExerciseData.value, successCallback: (CurrentUserStateModel newUserState) {
        if (newUserState.exercise!.state == 'ENDED') {
          exerciseState.value = ExerciseState.ready;
          userState.update(
            (state) {
              state?.state = newUserState.state;
              state?.exercise = newUserState.exercise;
              state?.shoes = newUserState.shoes;
            },
          );
          HiveStore.deleteMultipleKeys(keys: [HiveKey.userState.name, HiveKey.endExerciseRequested.name]);
          resetVariables(challenge);
          resetTimer();
          resetSubscriptions();
          moveToExerciseDetail(userState.value.exercise!.id!);
        }
      }, errorCallback: () {
        showToastPopup('운동이 정상적으로 종료되지 않았습니다.');
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
      moveToExerciseDetail(userState.value.exercise!.id!);
    }
  }

  void resetVariables(ChallengeModel challenge) {
    exerciseTime.value = 0;
    stopProgress.value = 0;
    exerciseSteps.value = 0;
    exerciseDistance.value = 0;
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
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
  }

  void moveToExerciseDetail(int exerciseId) {
    Get.until((route) => route.isFirst);
    Get.find<HomeMenuController>().selectMenu(1);
    if (Get.isRegistered<ArchiveController>()) {
      Get.find<ArchiveController>().toDetail(exerciseId);
    } else {
      Get.put(ArchiveController()).toDetail(exerciseId);
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
