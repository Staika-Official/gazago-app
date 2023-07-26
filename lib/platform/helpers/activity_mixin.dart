import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/models/ad_watch_available_model.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/admob_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:throttling/throttling.dart';
import 'package:uuid/uuid.dart';

mixin ActivityMixin {
  GlobalController globalController = Get.find();

  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
  final RxInt loadingTime = RxInt(1);
  final Rx<Position> currentLocation = Rx(Position(speed: 0, altitude: 0, accuracy: 0, heading: 0, latitude: 0, longitude: 0, speedAccuracy: 0, timestamp: DateTime.now()));
  final RxBool isFakeGps = RxBool(false);
  final RxList<UserExerciseModel> exerciseData = RxList.empty();
  final RxList<LatLng> coordinates = RxList.empty();
  final RxInt exerciseTime = RxInt(0);
  final RxInt exerciseSteps = RxInt(0);
  final RxInt prevExerciseSteps = RxInt(0);
  final RxDouble exerciseDistance = RxDouble(0);
  final RxString pedestrianStatus = RxString('STOPPED');
  final Rx<ExerciseState> exerciseState = Rx(ExerciseState.init);
  Timer? loadingTimer;
  Timer? exerciseTimer;
  Timer? updateTimer;
  Timer? stopTimer;
  Timer? walkingStateTimer;
  final RxDouble stopProgress = RxDouble(0);
  StreamSubscription<Position>? locationSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;
  final HealthFactory health = HealthFactory();
  final RxDouble realTimeSpeed = RxDouble(0);
  final RxBool lowStaminaNotified = RxBool(false);
  final RxBool stoppedExercising = RxBool(false);
  final RxBool zeroStaminaNotified = RxBool(false);
  final RxBool lowDurabilityNotified = RxBool(false);
  final RxBool zeroDurabilityNotified = RxBool(false);
  final Throttling activityMixinThr = Throttling(duration: const Duration(milliseconds: 1500));
  final Rx<Control> luckLoadControl = Rx(Control.stop);
  RxBool isShowLuckAnimation = RxBool(false);
  final assetsAudioPlayer = AssetsAudioPlayer();

  Rx<Color> get exerciseStateTextColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        if ((avgSpeed.value < 1 || avgSpeed.value > 7) || stoppedExercising.value) {
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

  List<List<double>> get partialCoordinates {
    int lastUpdatedCoordinateIndex = HiveStore.load(key: HiveKey.lastUpdatedCoordinateIndex.name) ?? 0;
    if (coordinates.isEmpty) {
      return RxList.empty();
    } else {
      List<List<double>> partialList = List.empty(growable: true);
      for (LatLng coordinate in RxList.from(coordinates.sublist(lastUpdatedCoordinateIndex))) {
        partialList.add([coordinate.latitude, coordinate.longitude]);
      }
      return partialList;
    }
  }

  Rx<UserExerciseModel> get userExerciseData {
    return Rx(
      UserExerciseModel(
        id: userState.value.exercise!.id,
        steps: exerciseSteps.value,
        speed: avgSpeed.value,
        distance: convertKmToMeters(totalDistance.value),
        altitude: exerciseData.isNotEmpty ? exerciseData.last.altitude : 0,
        time: exerciseTime.value,
        // locations: coordinatesToString(coordinates),
        locationUpdateTime: DateTime.now(),
        adId: userState.value.exercise!.adId,
        lastLatitude: coordinates.isNotEmpty ? coordinates.last.latitude : currentLocation.value.latitude,
        lastLongitude: coordinates.isNotEmpty ? coordinates.last.longitude : currentLocation.value.longitude,
        latestLocations: partialCoordinates,
        sequence: const Uuid().v4(),
      ),
    );
  }

  bool get isSameStepCount {
    int lastStepCount = HiveStore.load(key: HiveKey.lastUpdatedStepCount.name) ?? 0;
    return lastStepCount == userExerciseData.value.steps;
  }

  void initStream() {
    initExerciseTimer();
    initStepStream();
  }

  void initExerciseStats() {
    exerciseData.value = List.empty(growable: true);
    coordinates.value = List.empty(growable: true);
    exerciseSteps.value = 0;
    exerciseTime.value = 0;
    exerciseDistance.value = 0;
    pedestrianStatus.value = 'STOPPED';
    HiveStore.initializeExerciseCoordinates();
    HiveStore.save(key: HiveKey.lastUpdatedStepCount.name, value: 0);
  }

  void initExerciseTimer() {
    if (exerciseTimer != null) {
      exerciseTimer!.cancel();
      exerciseTimer = null;
    }

    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isFakeGps.value && !isTestingFakeGps()) {
        pauseExercise();
      }
      validateTimer(timer, HiveKey.exerciseTimer);

      calRealtimeSpeed(); // 스피드 계산
      getExerciseState(exerciseSteps.value); //움직임 상태 감시

      if (exerciseState.value == ExerciseState.ongoing) {
        exerciseTime.value++;

        UserExerciseModel exerciseModel = userState.value.exercise!;
        exerciseModel.id = userState.value.exercise!.id;
        exerciseModel.steps = exerciseSteps.value;
        exerciseModel.speed = avgSpeed.value;
        exerciseModel.distance = convertKmToMeters(totalDistance.value);
        exerciseModel.altitude = exerciseData.isNotEmpty ? exerciseData.last.altitude : 0;
        exerciseModel.time = exerciseTime.value;
        // exerciseModel.locations = coordinatesToString(coordinates);
        exerciseModel.locationUpdateTime = exerciseData.isNotEmpty ? exerciseData.last.locationUpdateTime : DateTime.now();
        exerciseModel.lastLatitude = coordinates.isNotEmpty ? coordinates.last.latitude : null;
        exerciseModel.lastLongitude = coordinates.isNotEmpty ? coordinates.last.longitude : null;

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

        //abuse 갑지
        if (exerciseTime.value % abusingReportTime == 0) {
          if (catchSinglePointAbuse(coordinates)) {
            MemberService.reportAbuse(abusingType: "EXERCISE", exerciseId: exerciseModel.id, description: '좌표 데이터의 $abusingInsideRadiusRatio% 이상이 $abusingRadius미터 반경 안에 들었습니다.');
          }
        }
      }
    });

    HiveStore.save(key: HiveKey.exerciseTimer.name, value: exerciseTimer.hashCode);
  }

  void initStepStream() {
    if (stepSubscription != null) {
      stepSubscription = null;
      HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    }

    int savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;

    stepSubscription ??= Pedometer.stepCountStream.listen((StepCount event) async {
      bool isExerciseStarted = HiveStore.load(key: HiveKey.savedStepInitialized.name) ?? false;
      if (!isExerciseStarted) {
        HiveStore.save(key: HiveKey.dummyStepCount.name, value: event.steps);
        HiveStore.save(key: HiveKey.savedStepInitialized.name, value: true);
        savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
      } else if (exerciseState.value == ExerciseState.ongoing) {
        int dummySteps = HiveStore.load(key: HiveKey.dummyStepCount.name);

        // 모바일 재시작 시 event.steps 가 초기화 됨.
        if (event.steps < dummySteps) {
          dummySteps = event.steps;
          HiveStore.save(key: HiveKey.dummyStepCount.name, value: event.steps);
        }

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
    if (currentStep - prevStep > stepDifference) {
      calRealtimeSpeed.value = (exerciseState.value != ExerciseState.ongoing) ? 0 : speed;
    }

    realTimeSpeed.value = calRealtimeSpeed.value;
  }

  //not used
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

  void startExercise(ExerciseType exerciseType, ChallengeCourseModel? course, {String? adId}) async {
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    String sequence = const Uuid().v4();

    HiveStore.save(key: HiveKey.lastUpdatedStepCount.name, value: 0);

    if (Get.isDialogOpen != null && Get.isDialogOpen!) Get.until((route) => Get.currentRoute == Routes.activityActive && (Get.isDialogOpen == false || Get.isDialogOpen == null));
    if (isFakeGps.value && !isTestingFakeGps()) {
      return;
    }

    if (![ExerciseState.init, ExerciseState.ready].any((state) => state == exerciseState.value)) {
      return;
    }

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
          type: exerciseType.value == ExerciseType.walking.value ? ExerciseType.walking.value : ExerciseType.hiking.value,
          steps: 0,
          speed: 0,
          distance: 0,
          altitude: currentLocation.value.altitude,
          time: 0,
          startPoint: course != null ? course.firstName : '${currentLocation.value.longitude}, ${currentLocation.value.latitude}',
          lastLongitude: currentLocation.value.longitude,
          lastLatitude: currentLocation.value.latitude,
          challengeId: course?.challengeId,
          challengeCourseId: course?.id,
          locationUpdateTime: DateTime.now(),
          adId: adId != null ? '${adId}_${deviceId}_${DateTime.now().millisecondsSinceEpoch}' : null,
          sequence: sequence,
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
          showToastPopup(statusMessage ?? '운동을 시작하지 못했습니다. 잠시 후 다시 시도해주세요.');
        },
      );
    } else {
      showToastPopup('인터넷 상태를 확인해주세요.');
    }
  }

  void continueExerciseFromDialog() {
    if (globalController.internetConnection.value) {
      Get.back();
      Get.toNamed(Routes.activityActive);
      activityMixinThr.throttle(() => continueExercise(source: 'pendingExerciseDialog'));
    } else {
      showToastPopup('인터넷 상태를 확인해주세요.');
    }
  }

  void continueExercise({String? source}) async {
    if (isFakeGps.value && !isTestingFakeGps()) {
      return;
    }

    exerciseData.value = List.empty(growable: true);
    exerciseState.value = ExerciseState.ongoing;
    userState.value.exercise!.locationUpdateTime = DateTime.now();
    exerciseData.add(userState.value.exercise!);
    exerciseTime.value = userState.value.exercise!.time!;
    exerciseSteps.value = userState.value.exercise!.steps!;
    exerciseDistance.value = userState.value.exercise!.distance!;

    coordinates.value = List.empty(growable: true);
    coordinates.addAll(await parseCoordinates(userState.value.exercise!.id));

    initStream();
    activityMixinThr.throttle(() => updateExercise(source: source));
    startPeriodicUpdate();
  }

  Future<RxList<LatLng>> parseCoordinates(int? exerciseId) async {
    List<dynamic>? locationsList = HiveStore.load(key: HiveKey.exerciseCoordinates.name);
    if (locationsList != null) {
      return RxList(locationListToLatLng(locationsList));
    } else if (exerciseId != null) {
      List<dynamic> locationArray = List.empty(growable: true);
      List<LatLng> coordinates = List.empty(growable: true);

      locationArray = await getLocationsData(exerciseId);

      for (List location in locationArray) {
        LatLng coordinate = LatLng(double.parse(location[0]), double.parse(location[1]));
        coordinates.add(coordinate);
      }

      return RxList(coordinates);
    } else {
      return RxList.empty();
    }
  }

  void updateExercise({bool? isPaused, String? source}) async {
    void errorHandler(ErrorResponseDataModel? errorData) {
      CurrentUserStateModel? savedState = HiveStore.loadCurrentUserState();
      if (savedState != null) {
        userState.update((state) {
          state?.state = savedState.state;
          state?.exercise = savedState.exercise;
          state?.shoes = savedState.shoes;
        });
      }

      if (errorData != null && errorData.errorCode == 'ALREADY_EXERCISE_ENDED') {
        handleAlreadyFinishedExercise();
      }
    }

    void updateLocalUserState(CurrentUserStateModel newUserState) {
      HiveStore.saveExerciseCoordinate(coordinates);

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
        syncExerciseData(newUserState);
      }
    }

    // if (globalController.connectivityResult.value != ConnectivityResult.none && !batchIsInProgress()) {
    if (globalController.internetConnection.value) {
      if (isPaused != null && isPaused) {
        initLuckAnimation();

        await ActivityService.fetchPausedUserExercises(
          userExerciseData.value,
          Platform.operatingSystem,
          successCallback: (CurrentUserStateModel newUserState) {
            updateLocalUserState(newUserState);
          },
          errorCallback: errorHandler,
        );
      } else {
        // exerciseSteps.value = exerciseSteps.value + 100;
        // exerciseDistance.value = exerciseDistance.value + 100;

        if (!isSameStepCount) {
          HiveStore.save(key: HiveKey.lastUpdatedStepCount.name, value: userExerciseData.value.steps);
          initLuckAnimation();

          await ActivityService.fetchUpdateUserExercises(
            userExerciseData.value,
            Platform.operatingSystem,
            source: source,
            successCallback: (CurrentUserStateModel newUserState) async {
              // newUserState.exercise!.luckApplyRewardGo = 0.33;
              // newUserState.exercise!.luckOccurred = true;
              updateLocalUserState(newUserState);
              validateBadgeAcquisition(newUserState.exercise!.id!, newUserState.exercise!.badgeIssued, newUserState.exercise!.badgeImageUrl ?? '');

              await Future.delayed(const Duration(seconds: 1));
              if (userState.value.exercise!.luckApplyRewardGo! > 0 && userState.value.exercise!.luckOccurred!) {
                showLuckAnimation();
              }

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
        }
      }
    } else {
      errorHandler;
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
        validateTimer(timer, HiveKey.updateTimer);
        activityMixinThr.throttle(() => updateExercise(source: 'startPeriodicUpdate_${updateTimer.hashCode}'));
      },
    );
    HiveStore.save(key: HiveKey.updateTimer.name, value: updateTimer.hashCode);
  }

  void onTapDownStop(TapDownDetails tapDownDetails, ChallengeCourseModel? challenge, {String? source, required ActivityController controller}) async {
    Duration counter = Duration.zero;

    if (stopTimer != null) {
      initializeStopTimer();
    }

    stopTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (counter == const Duration(milliseconds: 500)) {
        initializeStopTimer();

        AdWatchAvailableModel adWatchAvailableModel = AdWatchAvailableModel(watchAvailable: false);
        await AdmobService.getAdWatchAvailableTime(
          'EXERCISE_END',
          callback: (AdWatchAvailableModel model) {
            adWatchAvailableModel = model;
          },
        );

        if (adWatchAvailableModel.watchAvailable!) {
          await controller.exerciseEndRewardedAdInit(
            'exerciseEndAd',
          );
          if (controller.userState.value.exercise!.rewardGo! > 0) {
            showEndExerciseAdDialog(controller);
          } else {
            checkShowEndPopup(source, controller);
          }
        } else {
          checkShowEndPopup(source, controller);
        }
      } else {
        counter = counter + const Duration(milliseconds: 10);
        stopProgress.value += (10 / 500);
      }
    });
  }

  void checkShowEndPopup(String? source, ActivityController controller) {
    if (source != null && source == 'pendingExerciseDialog') {
      if (globalController.internetConnection.value) {
        Get.back();
        controller.exerciseEndThr.throttle(() => endExercise(source: source));
      } else {
        showToastPopup('인터넷 상태를 확인해주세요.');
      }
    } else {
      showEndExerciseDialog();
    }
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
    exerciseTimer?.cancel();
    exerciseTimer = null;
    stepSubscription?.cancel();
    stepSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
    exerciseState.value = ExerciseState.paused;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    updateExercise(isPaused: true, source: 'pauseExercise${updateTimer.hashCode}');
  }

  void showEndExerciseAdDialog(ActivityController controller) {
    showEndExerciseAdAlert(controller);
    controller.adLoadTimerStart();
  }

  void showEndExerciseDialog() {
    showEndExerciseAlert(this);
  }

  Future<void> endExercise({String? source, String? adId, int retryAttempt = 0}) async {
    String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    if (isFakeGps.value && !isTestingFakeGps()) {
      return;
    }

    if (adId != null) {
      userState.update(
        (state) {
          state?.exercise?.adId = '${adId}_${deviceId}_${DateTime.now().millisecondsSinceEpoch}';
        },
      );
    }

    if (globalController.internetConnection.value) {
      // 업데이트 타이머에 의해서 미세한 차이로 운동 종료 요청후 즉시 운동 업데이트 요청이 나가지 않도록 타이머를 우선 스탑한다.
      updateTimer?.cancel();
      exerciseTimer?.cancel();
      userExerciseData.value.sequence = const Uuid().v4();
      //타이머 멈춘 후 종료 요청
      await ActivityService.fetchEndUserExercises(
        userExerciseData.value,
        source: source,
        successCallback: (CurrentUserStateModel newUserState) {
          initLuckAnimation();
          userState.update(
            (state) {
              state?.state = newUserState.state;
              state?.exercise = newUserState.exercise;
              state?.shoes = newUserState.shoes;
            },
          );

          if (newUserState.exercise!.state == 'ENDED') {
            exerciseState.value = ExerciseState.ready;
            HiveStore.deleteMultipleKeys(keys: [HiveKey.userState.name, HiveKey.endExerciseRequested.name, HiveKey.famousChallengeBadgeIssued.name]);
            resetVariables();
            resetTimer();
            resetSubscriptions();
            if (['showEndExerciseAlert', 'showEndADExerciseAlert', 'pendingExerciseDialog'].any((src) => src == source)) {
              moveToExerciseDetail(userState.value.exercise!.id!);
            }
          }

          if (newUserState.exercise!.recordState == 'ABNORMAL') {
            HiveStore.saveCurrentUserState(
              userState: CurrentUserStateModel(
                state: newUserState.state,
                exercise: newUserState.exercise,
                shoes: newUserState.shoes,
              ),
            );
            syncExerciseData(newUserState);
            if (retryAttempt > 4) {
              showToastPopup('운동 종료에 실패했습니다.\n다시 시도해주세요.');
            } else {
              endExercise(source: source, adId: adId, retryAttempt: retryAttempt + 1);
            }
          }
        },
        errorCallback: (ErrorResponseDataModel? errorData) {
          if (errorData != null && errorData.errorCode == 'ALREADY_EXERCISE_ENDED') {
            handleAlreadyFinishedExercise();
          } else {
            endExerciseLocally();
          }
        },
      );
    } else {
      showToastPopup('인터넷 상태를 확인해주세요.');
    }
  }

  void endExerciseLocally() {
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
    resetVariables();
    resetTimer();
    resetSubscriptions();
    Get.until((route) => route.isFirst);
  }

  void resetVariables() {
    exerciseTime.value = 0;
    stopProgress.value = 0;
    exerciseSteps.value = 0;
    exerciseDistance.value = 0;
    if (userState.value.exercise != null) {
      userState.value.exercise!.rewardGo = 0;
    }
    exerciseData.value = List.empty(growable: true);
    coordinates.value = List.empty(growable: true);
    Get.find<ActivityController>().selectedCourse.value = null;
  }

  void resetTimer() {
    updateTimer?.cancel();
    updateTimer = null;
    exerciseTimer?.cancel();
    exerciseTimer = null;
    HiveStore.deleteMultipleKeys(keys: [
      HiveKey.exerciseTimer.name,
      HiveKey.updateTimer.name,
    ]);
  }

  void resetSubscriptions() {
    stepSubscription?.cancel();
    stepSubscription = null;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
    HiveStore.initializeExerciseCoordinates();
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
  }

  void moveToExerciseDetail(int exerciseId) {
    Get.until((route) => route.isFirst);
    // if (Get.isRegistered<HomeMenuController>()) {
    //   Get.find<HomeMenuController>().selectMenu(0);
    // } else {
    //   Get.put(HomeMenuController()).selectMenu(0);
    // }

    if (Get.isRegistered<ArchiveController>()) {
      Get.find<ArchiveController>().toDetail(exerciseId);
    } else {
      Get.put(ArchiveController()).toDetail(exerciseId);
    }
  }

  void handleAlreadyFinishedExercise() {
    exerciseState.value = ExerciseState.ready;
    HiveStore.deleteMultipleKeys(keys: [HiveKey.userState.name, HiveKey.endExerciseRequested.name]);
    resetVariables();
    resetTimer();
    resetSubscriptions();
    Get.until((route) => route.isFirst);
  }

  void showExerciseMap(Widget mapWidget) {
    Get.dialog(mapWidget, barrierDismissible: false);
  }

  bool isTestingFakeGps() {
    return HiveStore.load(key: HiveKey.allowFakeGpsTest.name) ?? false;
  }

  void showLuckAnimation() async {
    bool isAbleSound = HiveStore.load(key: HiveKey.luckSound.name) ?? false;
    await Future.delayed(const Duration(milliseconds: 300));
    luckLoadControl.value = Control.playReverseFromEnd;
    isShowLuckAnimation.value = true;

    if (isAbleSound) {
      HapticFeedback.vibrate();

      if (!assetsAudioPlayer.isPlaying.value) {
        assetsAudioPlayer.open(Audio("assets/audio/bonus_go.mp3")).then((value) {
          assetsAudioPlayer.play();
        }).onError((error, stackTrace) {
          print(error);
        });
      }
    }
  }

  void initLuckAnimation() async {
    luckLoadControl.value = Control.stop;
    isShowLuckAnimation.value = false;
  }

  void validateBadgeAcquisition(int exerciseId, bool? badgeIssued, String badgeImgUrl) {
    bool? issuedBadge = HiveStore.load(key: HiveKey.famousChallengeBadgeIssued.name);
    if (issuedBadge != null && issuedBadge) return;
    if (badgeIssued != null && badgeIssued) {
      HiveStore.save(key: HiveKey.famousChallengeBadgeIssued.name, value: badgeIssued);
      ActivityController controller = Get.find<ActivityController>();
      showLocalNotification(
        notificationType: NotificationType.badge,
        title: '챌린지 뱃지 획득',
        message: '${controller.selectedCourse.value!.firstName} 챌린지에 성공하여 뱃지를 받았어요. 새로운 뱃지 확인하러 가자GO~~',
        payload: 'NAV-INVENTORY_BADGE',
      );
      showToastPopup('뱃지를 획득하였습니다.');
      showBadgeAcquisitionAlert(badgeImgUrl, controller.selectedCourse.value!);
    }
  }

  void getExerciseState(int exerciseSteps) {
    if (prevExerciseSteps.value == exerciseSteps) {
      walkingStateTimer ??= Timer(const Duration(seconds: 40), () {
        stoppedExercising.value = true;
      });
    } else {
      prevExerciseSteps.value = exerciseSteps;
      stoppedExercising.value = false;
      walkingStateTimer?.cancel();
      walkingStateTimer = null;
    }
  }

  void syncExerciseData(CurrentUserStateModel userState) {
    exerciseTime.value = userState.exercise!.time!;
    exerciseSteps.value = userState.exercise!.steps!;
    exerciseDistance.value = userState.exercise!.distance!;
  }
}
