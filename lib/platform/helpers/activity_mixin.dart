import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
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
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';

mixin ActivityMixin {
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
  final RxBool lowStaminaNotified = RxBool(false);
  final RxBool zeroStaminaNotified = RxBool(false);
  final RxBool lowDurabilityNotified = RxBool(false);
  final RxBool zeroDurabilityNotified = RxBool(false);

  Rx<Color> get exerciseStateTextColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        if (realTimeSpeed.value < 1 || realTimeSpeed.value > 7) {
          color = textRedColor;
        } else {
          color = textGreenColor;
        }
        break;
      case ExerciseState.paused:
        color = textYellowColor;
        break;
      default:
        color = Colors.white;
        break;
    }
    return Rx(color);
  }

  Rx<Color> get exerciseStateGaugeColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        if (realTimeSpeed.value < 1 || realTimeSpeed.value > 7) {
          color = speedRedColor;
        } else {
          color = speedGreenColor;
        }
        break;
      case ExerciseState.paused:
        color = speedYellowColor;
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
    */ /*double speed = exerciseData.isNotEmpty ? exerciseData.last.speed! : 0;
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
    }*/ /*

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
        locationUpdateTime: DateTime.now(),
        adId: userState.value.exercise!.adId,
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

        UserExerciseModel exerciseModel = userState.value.exercise!;
        exerciseModel.id = userState.value.exercise!.id;
        exerciseModel.steps = exerciseSteps.value;
        exerciseModel.speed = avgSpeed.value;
        exerciseModel.distance = convertKmToMeters(totalDistance.value);
        exerciseModel.altitude = highestAltitude.value;
        exerciseModel.time = exerciseTime.value;
        exerciseModel.locations = coordinatesToString(coordinates);
        exerciseModel.locationUpdateTime = exerciseData.isNotEmpty ? exerciseData.last.locationUpdateTime : DateTime.now();

        HiveStore.saveCurrentUserState(
          userState: CurrentUserStateModel(
            state: userState.value.state,
            exercise: exerciseModel,
            shoes: userState.value.shoes,
          ),
        );

        if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
          List userExerciseDataLogs = HiveStore.load(key: HiveKey.userExerciseDataLogs.name) ?? [];

          var logForm = {
            'exerciseInfo': '===================================='
                '\nCurrentTime: ${DateTime.now()}'
                '\nId: ${exerciseModel.id}'
                '\nSteps: ${exerciseModel.steps}'
                '\nSpeed: ${exerciseModel.speed}'
                '\nDistance: ${exerciseModel.distance}'
                '\nAltitude: ${exerciseModel.altitude}'
                '\nTime: ${exerciseModel.time}'
          };
          userExerciseDataLogs.add(logForm);
          HiveStore.saveUserExerciseData(value: userExerciseDataLogs);
        }
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
        savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
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
    // print('calRealtimeSpeed: ${realTimeSpeed.value}, exerciseData.length: ${exerciseData.length}');

    RxDouble calRealtimeSpeed = RxDouble(0);

    double speed = exerciseData.isNotEmpty ? exerciseData.last.speed! : 0;
    List<UserExerciseModel> sortedList = List.empty(growable: true);
    UserExerciseModel? prevData;
    if (exerciseData.length > 1) {
      sortedList = [...exerciseData];
      sortedList.sort((a, b) => (b.locationUpdateTime!.compareTo(a.locationUpdateTime!)));
      prevData = sortedList.firstWhere((sortedData) => (DateTime.now().subtract(Duration(seconds: stopTimeInterval)).compareTo(sortedData.locationUpdateTime!) == 1),
          orElse: () => UserExerciseModel(steps: 0));
    }
    int prevStep = prevData != null ? prevData.steps! : 0;
    int currentStep = exerciseData.isNotEmpty && exerciseData.length > 2 ? exerciseData.last.steps! : 0;
    // int currentStep = 10;

    // 15초 이상 걷기 감지가 되지 않을 경우에는 속도 0으로 표시
    print('$currentStep - $prevStep > $stepDifference');
    if (currentStep - prevStep > stepDifference) {
      calRealtimeSpeed.value = (exerciseState.value != ExerciseState.ongoing) ? 0 : speed;
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

  void startExercise(ExerciseType exerciseType, ChallengeModel? challenge, {String? adId}) async {
    if (Get.isDialogOpen != null && Get.isDialogOpen!) Get.until((route) => Get.isDialogOpen == false);
    print(globalController.internetConnection.value);
    if (!batchIsInProgress()) {
      // if (globalController.connectivityResult.value != ConnectivityResult.none) {
      if (globalController.internetConnection.value) {
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
            locationUpdateTime: DateTime.now(),
            adId: adId,
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
          errorCallback: (String? statusMessage) {
            showToastPopup(statusMessage ?? '운동을 시작하지 못했습니다. 잠시후 다시 시도해주세요.');
          },
        );
      } else {
        showToastPopup('인터넷 상태를 확인해주세요.');
      }
    } else {
      showToastPopup('지금은 리워드 정산시간입니다.');
    }
  }

  void continueExerciseFromDialog() {
    Get.back();
    Get.toNamed(Routes.activityActive);
    continueExercise(source: 'pendingExerciseDialog');
  }

  void continueExercise({String? source}) {
    exerciseData.value = List.empty(growable: true);
    exerciseState.value = ExerciseState.ongoing;
    userState.value.exercise!.locationUpdateTime = DateTime.now();
    exerciseData.add(userState.value.exercise!);
    exerciseTime.value = userState.value.exercise!.time!;
    exerciseSteps.value = userState.value.exercise!.steps!;
    exerciseDistance.value = userState.value.exercise!.distance!;

    coordinates.value = List.empty(growable: true);
    if (userState.value.exercise!.locations != null && userState.value.exercise!.locations!.length > 0) {
      coordinates.addAll(parseCoordinates());
    }

    initStream();
    updateExercise(source: source);
    startPeriodicUpdate();
  }

  RxList<LatLng> parseCoordinates() {
    return RxList(locationStringToLatLng(userState.value.exercise!.locations!));
  }

  void updateExercise({bool? isPaused, String? source}) async {
    void errorHandler() {
      CurrentUserStateModel? savedState = HiveStore.loadCurrentUserState();
      if (savedState != null) {
        userState.update((state) {
          state?.state = savedState.state;
          state?.exercise = savedState.exercise;
          state?.shoes = savedState.shoes;
        });
      }
    }

    void updateLocalUserState(CurrentUserStateModel newUserState) {
      newUserState.exercise!.locationUpdateTime = DateTime.now();
      userState.update((state) {
        state?.state = newUserState.state;
        state?.exercise = newUserState.exercise;
        state?.shoes = newUserState.shoes;
      });

      if (newUserState.exercise!.recordState == 'ABNORMAL') {
        HiveStore.saveCurrentUserState(
          userState: CurrentUserStateModel(
            state: newUserState.state,
            exercise: newUserState.exercise,
            shoes: newUserState.shoes,
          ),
        );
      }
    }

    // if (globalController.connectivityResult.value != ConnectivityResult.none && !batchIsInProgress()) {
    if (globalController.internetConnection.value && !batchIsInProgress()) {
      isPaused != null && isPaused
          ? await ActivityService.fetchPausedUserExercises(
              userExerciseData.value,
              Platform.operatingSystem,
              successCallback: (CurrentUserStateModel newUserState) {
                updateLocalUserState(newUserState);
              },
              errorCallback: errorHandler,
            )
          : await ActivityService.fetchUpdateUserExercises(
              userExerciseData.value,
              Platform.operatingSystem,
              source: source,
              successCallback: (CurrentUserStateModel newUserState) {
                updateLocalUserState(newUserState);

                if (userState.value.state!.stamina! < 30) {
                  if (userState.value.state!.stamina! == 0 && !zeroStaminaNotified.value) {
                    showLocalNotification(notificationType: NotificationType.staminaDepleted, title: '체력 충전 알림', message: '지금 체력이 0이 되어 GO보상이 되지 않고 있어요. 체력 충전하러 가자GO~~');
                    zeroStaminaNotified.value = true;
                  } else if (!lowStaminaNotified.value) {
                    showLocalNotification(notificationType: NotificationType.staminaLow, title: '체력 충전 알림', message: '체력이 부족하면 GO보상이 되지 않아요. 체력 충전하러 가자GO~~');
                    lowStaminaNotified.value = true;
                  }
                }
                if (userState.value.shoes!.durability! < 30 && !zeroDurabilityNotified.value) {
                  if (userState.value.shoes!.durability! == 0) {
                    showLocalNotification(notificationType: NotificationType.durabilityDepleted, title: '아이템 수리 알림', message: '지금 내구도(신발)가 0이 되어 GO보상이 되지 않고 있어요. 내구도 보충하러 가자GO~~');
                    zeroDurabilityNotified.value = true;
                  } else if (!lowDurabilityNotified.value) {
                    showLocalNotification(notificationType: NotificationType.durabilityLow, title: '아이템 수리 알림', message: '내구도(신발)가 부족하면 GO보상이 되지 않아요. 내구도 보충하러 가자GO~~');
                    lowDurabilityNotified.value = true;
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
        updateExercise(source: 'startPeriodicUpdate_${updateTimer.hashCode}');
      },
    );
  }

  void onTapDownStop(TapDownDetails tapDownDetails, ChallengeModel challenge, {String? source, required ActivityController controller}) async {
    Duration counter = Duration.zero;

    if (stopTimer != null) {
      initializeStopTimer();
    }

    print(controller.userState.value.exercise?.type);
    await controller.checkActivityType(controller.userState.value.exercise?.type);
    await controller.handleSelectAdType(controller.userState.value.exercise?.type == 'HIKING'
        ? 'endHikingAd'
        : controller.userState.value.exercise?.type == 'WALKING'
            ? 'endWalkingAd'
            : 'endFamousAd');
    DateTime? date = HiveStore.load(
        key: controller.userState.value.exercise?.type == 'HIKING'
            ? 'endHikingAd'
            : controller.userState.value.exercise?.type == 'WALKING'
                ? 'endWalkingAd'
                : 'endFamousAd');

    DateTime? viewableTime = date?.add(const Duration(hours: 1));
    DateTime now = DateTime.now();
    // HiveStore.save(key: 'endWalkingAd', value: null);
    stopTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (counter == const Duration(milliseconds: 500)) {
        initializeStopTimer();

        if (source != null && source == 'pendingExerciseDialog') {
          Get.back();
        }
        if (date == null || viewableTime!.isBefore(now)) {
          controller.initEndAdmobAdId(controller.selectedAd.value);

          await controller.exerciseEndRewardedAdInit(
            controller.selectedAd.value,
            successCallback: () {
              controller.updateAbleViewAd();
            },
            errorCallback: () {
              controller.updateNotAbleViewAd();
            },
          );
          if (controller.userState.value.exercise!.rewardGo! > 0) {
            showEndExerciseAdDialog(challenge, controller);
            controller.adLoadTimerStart();
          } else {
            showEndExerciseDialog(challenge);
          }
        } else {
          if (source != null && source == 'pendingExerciseDialog') {
            endExercise(challenge, source: source);
          } else {
            showEndExerciseDialog(challenge);
          }
        }
      } else {
        counter = counter + const Duration(milliseconds: 10);
        stopProgress.value += (10 / 500);
      }
    });
  }

  void onTapUpStop(TapUpDetails tapUpDetails, {String? source}) {
    // if (source != null && source != 'pendingExerciseDialog') showToastPopup('3초간 눌러야 정지됩니다.');
    showToastPopup('길게 눌러주세요!');
    initializeStopTimer();
  }

  void initializeStopTimer() {
    stopTimer?.cancel();
    stopTimer = null;
    stopProgress.value = 0;
  }

  void pauseExercise() {
    updateTimer?.cancel();
    updateTimer = null;
    //exerciseTimer?.cancel();
    //exerciseTimer = null;
    stepSubscription?.cancel();
    stepSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
    exerciseState.value = ExerciseState.paused;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    updateExercise(isPaused: true, source: 'pauseExercise${updateTimer.hashCode}');
  }

  void showEndExerciseAdDialog(ChallengeModel challenge, ActivityController controller) {
    showEndExerciseAdAlert(challenge, controller);
    controller.adLoadTimerStop();
  }

  void showEndExerciseDialog(ChallengeModel challenge) {
    showEndExerciseAlert(this, challenge);
  }

  Future<void> endExercise(ChallengeModel challenge, {String? source, String? adId}) async {
    if (adId != null) {
      userState.update(
        (state) {
          state?.exercise?.adId = adId;
        },
      );
    }
    if (!batchIsInProgress()) {
      await ActivityService.fetchEndUserExercises(
        userExerciseData.value,
        source: source,
        successCallback: (CurrentUserStateModel newUserState) {
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
            if (['showEndExerciseAlert', 'showEndADExerciseAlert', 'pendingExerciseDialog'].any((src) => src == source)) {
              moveToExerciseDetail(userState.value.exercise!.id!);
            }
          }
        },
        errorCallback: () {
          endExerciseLocally(challenge);
        },
      );
    } else {
      endExerciseLocally(challenge);
    }
  }

  void endExerciseLocally(ChallengeModel challenge) {
    print('endedLocally');
    exerciseState.value = ExerciseState.ready;
    CurrentUserStateModel? savedState = HiveStore.loadCurrentUserState();
    if (savedState != null) {
      userState.update((state) {
        state?.state = savedState.state;
        state?.exercise = savedState.exercise;
        state?.shoes = savedState.shoes;
      });
    }
    userState.value.exercise!.state = 'ENDED';
    HiveStore.saveCurrentUserState(userState: userState.value);
    HiveStore.save(key: HiveKey.endExerciseRequested.name, value: true);
    resetVariables(challenge);
    resetTimer();
    resetSubscriptions();
    print(HiveStore.load(key: HiveKey.endExerciseRequested.name));
    Get.until((route) => route.isFirst);
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
    Get.find<HomeMenuController>().selectMenu(0);
    // Get.put(HomeMenuController()).selectMenu(0);
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
