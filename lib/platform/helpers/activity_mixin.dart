import 'dart:async';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:easy_localization/easy_localization.dart';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/handlers/location_callback_handler.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/image_helper.dart';
import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/request/get_treasure_request_model.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/treasure_geofencing_service.dart';
import 'package:gaza_go/platform/services/treasure_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/platform/services/activity_gps_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:throttling/throttling.dart';
import 'package:uuid/uuid.dart';
import 'package:gaza_go/platform/models/location_model.dart';

mixin ActivityMixin {
  GlobalController globalController = Get.find();

  // InspectionNoticeController inspectionNoticeController = Get.isRegistered<InspectionNoticeController>() ? Get.find<InspectionNoticeController>() : Get.put(InspectionNoticeController());
  final Rx<CurrentUserStateModel> userState = Rx(CurrentUserStateModel());
  final RxInt loadingTime = RxInt(1);
  final Rxn<LocationModel> currentLocation = Rxn<LocationModel>();

  // LocationModel support for modern location tracking
  final Rxn<LocationModel> currentLocationModel = Rxn<LocationModel>();
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
  StreamSubscription<LocationModel>? locationSubscription;
  StreamSubscription<LocationModel>? locationModelSubscription;
  StreamSubscription<StepCount>? stepSubscription;
  StreamSubscription<PedestrianStatus>? pedestrianStatusSubscription;
  final Health health = Health();
  final RxDouble realTimeSpeed = RxDouble(0);
  final RxDouble gpsSpeed = RxDouble(0);
  final RxDouble smoothedSpeed = RxDouble(0); // For UI color stability
  final RxBool lowStaminaNotified = RxBool(false);
  final RxBool stoppedExercising = RxBool(false);
  final RxBool zeroStaminaNotified = RxBool(false);
  final RxBool lowDurabilityNotified = RxBool(false);
  final RxBool zeroDurabilityNotified = RxBool(false);
  final Throttling activityMixinThr =
      Throttling(duration: const Duration(milliseconds: 1500));
  final Rx<Control> luckLoadControl = Rx(Control.stop);
  RxBool isShowLuckAnimation = RxBool(false);

  // treasure of current exercise session
  List<int> currentHighlightedTreasuresId = [];
  final listClaimedTreasureIdOfSession = <int>[];
  var listTreasureOfSession = <TreasureModel>[];
  final kTreasureBaseSize = const Size(12, 12);
  late final kTreasureZoomSize = kTreasureBaseSize * 1.5;
  num kMinPickupRadius = 10;
  num kTreasureVisibleRadius = 10;
  num kPickupCoolDownTime = 5.minutes.inSeconds;

  // Circle synchronization state management
  static const CircleId _pickupCircleId = CircleId('pickup_radius');
  LatLng? _lastCircleCenter;
  DateTime? _lastCircleUpdateAt;
  Timer? _circleUpdateDebounce;

  // Circle update thresholds (tunable)
  static const int kCircleUpdateDebounceMs = 16; // ~60fps for smooth updates
  static const double kStationarySpeedThresholdMs = 0.5; // m/s
  static const double kJitterDistanceMeters = 0.5; // More sensitive to movement
  static const int kHardRefreshIntervalMs = 100; // More frequent updates

  // final assetsAudioPlayer = AssetsAudioPlayer();

  // this field to keep track if this session is pause then resume or resume when re-open app
  bool isExerciseInitOnce = false;

  Rx<Color> get exerciseStateTextColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        if (((userState.value.exercise!.type! == ExerciseType.hiking.name
                    ? avgSpeed.value < 0.7
                    : avgSpeed.value < 1) ||
                avgSpeed.value > 40) ||
            stoppedExercising.value) {
          color = AppColorData.regular().colorTextWarning;
        } else {
          color = AppColorData.regular().colorTextSuccess;
        }
        break;
      case ExerciseState.paused:
        color = AppColorData.regular().colorPointYellow;
        break;
      default:
        color = AppColorData.regular().colorBgWhite;
        break;
    }
    return Rx(color);
  }

  Rx<Color> get exerciseStateGaugeColor {
    Color color = Colors.white;
    switch (exerciseState.value) {
      case ExerciseState.ongoing:
        // Use smoothedSpeed for more stable color changes
        double speedForColor =
            smoothedSpeed.value > 0 ? smoothedSpeed.value : realTimeSpeed.value;
        if ((userState.value.exercise!.type! == ExerciseType.hiking.name
                ? speedForColor < 0.7
                : speedForColor < 1) ||
            speedForColor > 40) {
          color = AppColorData.regular().colorTextWarning;
        } else {
          color = AppColorData.regular().colorTextSuccess;
        }
        break;
      case ExerciseState.paused:
        color = AppColorData.regular().colorPointYellow;
        break;
      default:
        color = AppColorData.regular().colorBgWhite;
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
    // List<double> speedList = exerciseData.where((data) => (data.speed ?? 0) > 0.833).map((filteredLocation) => filteredLocation.speed ?? 0).toList();

    // List<double> speedList = exerciseData.where((data) => (data.speed ?? 0) > 0.2 && (data.speed ?? 0) < 15).map((filteredLocation) => filteredLocation.speed ?? 0).toList();
    List<double> speedList = exerciseData
        .where((data) => (data.speed ?? 0) > 0)
        .map((filteredLocation) => filteredLocation.speed ?? 0)
        .toList();
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

  RxDouble get rewardDistance {
    return RxDouble(
      userState.value.exercise != null
          ? convertMetersToKm(userState.value.exercise!.rewardDistance != null
              ? userState.value.exercise!.rewardDistance!
              : 0)
          : 0,
    );
  }

  RxList<double> get altitudes {
    return RxList(exerciseData.map((location) => location.altitude!).toList());
  }

  RxDouble get highestAltitude {
    List<double> altitudeList =
        exerciseData.map((location) => location.altitude!).toList();
    return RxDouble(highestClimbed(altitudeList));
  }

  List<List<double>> get partialCoordinates {
    int lastUpdatedCoordinateIndex =
        HiveStore.load(key: HiveKey.lastUpdatedCoordinateIndex.name) ?? 0;
    if (coordinates.isEmpty) {
      return RxList.empty();
    } else {
      List<List<double>> partialList = List.empty(growable: true);
      for (LatLng coordinate
          in RxList.from(coordinates.sublist(lastUpdatedCoordinateIndex))) {
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
        // speed: 5,
        distance: convertKmToMeters(totalDistance.value),
        altitude: exerciseData.isNotEmpty ? exerciseData.last.altitude : 0,
        time: exerciseTime.value,
        // locations: coordinatesToString(coordinates),
        locationUpdateTime: DateTime.now(),
        adId: userState.value.exercise!.adId,
        lastLatitude: coordinates.isNotEmpty
            ? coordinates.last.latitude
            : currentLocation.value?.latitude ?? 0.0,
        lastLongitude: coordinates.isNotEmpty
            ? coordinates.last.longitude
            : currentLocation.value?.longitude ?? 0.0,
        latestLocations: partialCoordinates,
        sequence: const Uuid().v4(),
      ),
    );
  }

  bool get isSameStepCount {
    int lastStepCount =
        HiveStore.load(key: HiveKey.lastUpdatedStepCount.name) ?? 0;
    return lastStepCount == userExerciseData.value.steps;
  }

  void initStream() {
    initExerciseTimer();
    initStepStream();
    initLocationStream();
  }

  void initLocationStream() {
    // Cancel existing subscription
    locationModelSubscription?.cancel();
    locationModelSubscription = null;

    // Subscribe to UnifiedGPSManager location stream
    locationModelSubscription = GPS.locationStream.listen(
      (LocationModel location) {
        currentLocationModel.value = location;
        currentLocation.value = location; // For backward compatibility

        if (exerciseState.value == ExerciseState.ongoing) {
          // Add location to exercise data
          exerciseData.add(UserExerciseModel(
            id: userState.value.exercise?.id,
            userId: int.parse(
                HiveStore.loadString(key: HiveKey.userId.name) ?? '0'),
            steps: exerciseSteps.value,
            speed: location.speed,
            distance: exerciseDistance.value,
            altitude: location.altitude,
            time: exerciseTime.value,
            locationUpdateTime: DateTime.now(),
            lastLatitude: location.latitude,
            lastLongitude: location.longitude,
          ));

          // Only add coordinates to route if internet connection is available
          if (globalController.internetConnection.value) {
            coordinates.add(LatLng(location.latitude, location.longitude));
          }

          // Update real-time speed
          gpsSpeed.value = location.speed;
          calRealtimeSpeed();
        }
      },
      onError: (error) {
        print('Location stream error: $error');
      },
    );
  }

  void initExerciseStats() {
    exerciseData.value = List.empty(growable: true);
    coordinates.value = List.empty(growable: true);
    exerciseSteps.value = 0;
    exerciseTime.value = 0;
    exerciseDistance.value = 0;
    pedestrianStatus.value = 'STOPPED';

    // Reset speed values
    realTimeSpeed.value = 0;
    gpsSpeed.value = 0;
    smoothedSpeed.value = 0;

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
        exerciseModel.altitude =
            exerciseData.isNotEmpty ? exerciseData.last.altitude : 0;
        exerciseModel.time = exerciseTime.value;
        // exerciseModel.locations = coordinatesToString(coordinates);
        exerciseModel.locationUpdateTime = exerciseData.isNotEmpty
            ? exerciseData.last.locationUpdateTime
            : DateTime.now();
        exerciseModel.lastLatitude =
            coordinates.isNotEmpty ? coordinates.last.latitude : null;
        exerciseModel.lastLongitude =
            coordinates.isNotEmpty ? coordinates.last.longitude : null;

        HiveStore.saveCurrentUserState(
          userState: CurrentUserStateModel(
            state: userState.value.state,
            exercise: exerciseModel,
            shoes: userState.value.shoes,
          ),
        );

        if (HiveStore.load(key: HiveKey.isDebuggingMode.name)) {
          List userExerciseDataLogs =
              HiveStore.load(key: HiveKey.userExerciseDataLogs.name) ?? [];

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
            MemberService.reportAbuse(
                abusingType: "EXERCISE",
                exerciseId: exerciseModel.id,
                description: 'abusing_coordinates'.tr(args: [
                  abusingInsideRadiusRatio.toString(),
                  abusingRadius.toString()
                ]));
          }
        }
      }
    });

    HiveStore.save(
        key: HiveKey.exerciseTimer.name, value: exerciseTimer.hashCode);
  }

  void initStepStream() {
    if (stepSubscription != null) {
      stepSubscription = null;
      HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    }

    int savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
    stepSubscription ??=
        Pedometer.stepCountStream.listen((StepCount event) async {
      bool isExerciseStarted =
          HiveStore.load(key: HiveKey.savedStepInitialized.name) ?? false;
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
      showToastPopup('step_count_unavailable'.tr());
      HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    });
  }

  void calRealtimeSpeed() {
    // print('calRealtimeSpeed: ${realTimeSpeed.value}, exerciseData.length: ${exerciseData.length}');

    RxDouble calRealtimeSpeed = RxDouble(0);

    // Improved initial speed handling - use GPS speed immediately if available
    double speed = 0;
    if (exerciseData.isNotEmpty) {
      speed = exerciseData.last.speed ?? 0;

      // For initial data (first few seconds), use GPS speed directly
      if (exerciseData.length <= 3) {
        // Convert m/s to km/h and use GPS speed directly for immediate display
        double gpsSpeedKmh = speed * 3.6;
        if (gpsSpeedKmh > 0 && gpsSpeedKmh < 15) {
          // Reasonable walking/running speed
          realTimeSpeed.value =
              (exerciseState.value != ExerciseState.ongoing) ? 0 : gpsSpeedKmh;
          return;
        }
      }
    }

    // Original step-based calculation for established tracking
    List<UserExerciseModel> sortedList = List.empty(growable: true);
    UserExerciseModel? prevData;
    if (exerciseData.length > 1) {
      sortedList = [...exerciseData];
      sortedList.sort((a, b) => ((b.locationUpdateTime ??
              DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(
              a.locationUpdateTime ?? DateTime.fromMillisecondsSinceEpoch(0))));
      prevData = sortedList.firstWhere(
          (sortedData) => (DateTime.now()
                  .subtract(Duration(seconds: stopTimeInterval))
                  .compareTo(sortedData.locationUpdateTime ??
                      DateTime.fromMillisecondsSinceEpoch(0)) ==
              1),
          orElse: () => UserExerciseModel(steps: 0));
    }
    int prevStep = prevData?.steps ?? 0;
    int currentStep = exerciseData.isNotEmpty && exerciseData.length > 2
        ? (exerciseData.last.steps ?? 0)
        : 0;
    // int currentStep = 10;

    // 15초 이상 걷기 감지가 되지 않을 경우에는 속도 0으로 표시
    if (currentStep - prevStep > stepDifference) {
      calRealtimeSpeed.value = (exerciseState.value != ExerciseState.ongoing)
          ? 0
          : speed * 3.6; // Convert to km/h
    }

    realTimeSpeed.value = calRealtimeSpeed.value;
  }

  //not used
  void initPedestrianStatusStream() {
    if (pedestrianStatusSubscription != null) {
      pedestrianStatusSubscription = null;
    }

    pedestrianStatusSubscription ??= Pedometer.pedestrianStatusStream
        .skip(1)
        .listen((PedestrianStatus event) {
      pedestrianStatus.value = event.status.toUpperCase();
    });
    stepSubscription!.onError((error) {});
  }

  void startExercise(
      ExerciseType exerciseType, ChallengeCourseModel? course) async {
    // String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;

    String sequence = const Uuid().v4();

    HiveStore.save(key: HiveKey.lastUpdatedStepCount.name, value: 0);

    if (Get.isDialogOpen != null && Get.isDialogOpen!) {
      Get.until((route) =>
          Get.currentRoute == Routes.activityActive &&
          (Get.isDialogOpen == false || Get.isDialogOpen == null));
    }
    if (isFakeGps.value && !isTestingFakeGps()) {
      return;
    }

    if (![ExerciseState.init, ExerciseState.ready]
        .any((state) => state == exerciseState.value)) {
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
          userProfileImageUrl:
              HiveStore.loadString(key: HiveKey.profileImageUrl.name),
          type: exerciseType.value == ExerciseType.walking.value
              ? ExerciseType.walking.value
              : exerciseType.value == ExerciseType.treasureHunting.value
                  ? ExerciseType.treasureHunting.value
                  : ExerciseType.hiking.value,
          steps: 0,
          speed: 0,
          distance: 0,
          altitude: currentLocation.value?.altitude ?? 0.0,
          time: 0,
          startPoint: course != null
              ? course.firstName
              : '${currentLocation.value?.longitude ?? 0.0}, ${currentLocation.value?.latitude ?? 0.0}',
          lastLongitude: currentLocation.value?.longitude ?? 0.0,
          lastLatitude: currentLocation.value?.latitude ?? 0.0,
          challengeId: course?.challengeId,
          challengeCourseId: course?.id,
          locationUpdateTime: DateTime.now(),
          // adId: adId != null ? '${adId}_${deviceId}_${DateTime.now().millisecondsSinceEpoch}' : null,
          sequence: sequence,
        ),
        Platform.operatingSystem,
        successCallback: (UserExerciseModel userExerciseData) {
          isExerciseInitOnce = true;
          userState.update((state) => state!.exercise = userExerciseData);
          exerciseState.value = ExerciseState.ongoing;
          HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
          HiveStore.save(key: HiveKey.savedStepCount.name, value: 0);
          initExerciseStats();
          initStream();

          // Start enhanced GPS tracking with ActivityGPSService
          _startEnhancedGPSTracking();
          startPeriodicUpdate();
          
          // Only start treasure hunting features for treasure hunting mode
          if (exerciseType == ExerciseType.treasureHunting) {
            fetchExerciseTreasures().whenComplete(
              () {
                // Start nearby treasure timer for 5-second API checks
                (this as ActivityController).startNearbyTreasureTimer();
              },
            );
          }
        },
        errorCallback: (String? statusMessage) {
          showToastPopup(statusMessage ?? 'exercise_start_failed'.tr());
        },
      );
    } else {
      showToastPopup('check_internet_connection'.tr());
    }
  }

  void continueExerciseFromDialog() {
    if (globalController.internetConnection.value) {
      Get.back();
      Get.toNamed(Routes.activityActive);
      continueExercise(source: 'pendingExerciseDialog');
    } else {
      showToastPopup('check_internet_connection'.tr());
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

    // Start enhanced GPS tracking for continued exercise
    _startEnhancedGPSTracking();
    
    // Only start treasure hunting features if current exercise is treasure hunting mode
    bool isTreasureHuntingMode = (this as ActivityController).selectedExerciseType.value == ExerciseType.treasureHunting;
    
    if (!isExerciseInitOnce && isTreasureHuntingMode) {
      fetchExerciseTreasures().whenComplete(
        () {
          (this as ActivityController).startNearbyTreasureTimer();
        },
      );
    }

    activityMixinThr
        .throttle(() => updateExercise(source: source, wasPaused: true));
    startPeriodicUpdate();

    if (isExerciseInitOnce && isTreasureHuntingMode) {
      // Start nearby treasure timer for continued exercise
      (this as ActivityController).startNearbyTreasureTimer();
    }
  }

  Future<RxList<LatLng>> parseCoordinates(int? exerciseId) async {
    List<dynamic>? locationsList =
        HiveStore.load(key: HiveKey.exerciseCoordinates.name);
    if (locationsList != null) {
      return RxList(locationListToLatLng(locationsList));
    } else if (exerciseId != null) {
      List<dynamic> locationArray = List.empty(growable: true);
      List<LatLng> coordinates = List.empty(growable: true);

      locationArray = await getLocationsData(exerciseId);

      for (List location in locationArray) {
        LatLng coordinate =
            LatLng(double.parse(location[0]), double.parse(location[1]));
        coordinates.add(coordinate);
      }

      return RxList(coordinates);
    } else {
      return RxList.empty();
    }
  }

  void updateExercise(
      {bool? isPaused, String? source, bool wasPaused = false}) async {
    void errorHandler(ErrorResponseDataModel? errorData) {
      CurrentUserStateModel? savedState = HiveStore.loadCurrentUserState();
      if (savedState != null) {
        userState.update((state) {
          state?.state = savedState.state;
          state?.exercise = savedState.exercise;
          state?.shoes = savedState.shoes;
        });
      }

      if (errorData != null &&
          errorData.errorCode == 'ALREADY_EXERCISE_ENDED') {
        handleAlreadyFinishedExercise();
      }
    }

    void updateLocalUserState(CurrentUserStateModel newUserState) async {
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
        await syncExerciseData(newUserState);
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
        // exerciseSteps.value = exerciseSteps.value + 10;
        // exerciseDistance.value = exerciseDistance.value + 10;

        if (!isSameStepCount || wasPaused) {
          HiveStore.save(
              key: HiveKey.lastUpdatedStepCount.name,
              value: userExerciseData.value.steps);
          initLuckAnimation();

          await ActivityService.fetchUpdateUserExercises(
            userExerciseData.value,
            Platform.operatingSystem,
            source: source,
            successCallback: (CurrentUserStateModel newUserState) async {
              // newUserState.exercise!.luckApplyRewardGo = 0.33;
              // newUserState.exercise!.luckOccurred = true;
              updateLocalUserState(newUserState);
              validateBadgeAcquisition(
                  newUserState.exercise!.id!,
                  newUserState.exercise!.badgeIssued,
                  newUserState.exercise!.badgeImageUrl ?? '');

              await Future.delayed(const Duration(seconds: 1));
              if (userState.value.exercise!.luckApplyRewardGo! > 0 &&
                  userState.value.exercise!.luckOccurred!) {
                showLuckAnimation();
              }

              if (userState.value.state!.stamina! < 30) {
                if (userState.value.state!.stamina! == 0 &&
                    !zeroStaminaNotified.value) {
                  showLocalNotification(
                      notificationType: NotificationType.staminaDepleted,
                      title: 'stamina_recovery_notification'.tr(),
                      message: 'stamina_zero_go_reward_unavailable'.tr());
                  zeroStaminaNotified.value = true;
                } else if (!lowStaminaNotified.value) {
                  showLocalNotification(
                      notificationType: NotificationType.staminaLow,
                      title: 'stamina_recovery_notification'.tr(),
                      message: 'low_stamina_go_reward_unavailable'.tr());
                  lowStaminaNotified.value = true;
                }
              }
              if (userState.value.shoes?.durability != null &&
                  userState.value.shoes!.durability! < 30 &&
                  !zeroDurabilityNotified.value) {
                if (userState.value.shoes!.durability == 0) {
                  showLocalNotification(
                      notificationType: NotificationType.durabilityDepleted,
                      title: 'item_repair_notification'.tr(),
                      message: 'durability_zero_go_reward_unavailable'.tr());
                  zeroDurabilityNotified.value = true;
                } else if (!lowDurabilityNotified.value) {
                  showLocalNotification(
                      notificationType: NotificationType.durabilityLow,
                      title: 'item_repair_notification'.tr(),
                      message: 'low_durability_go_reward_unavailable'.tr());
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
        activityMixinThr.throttle(() => updateExercise(
            source: 'startPeriodicUpdate_${updateTimer.hashCode}'));
      },
    );
    HiveStore.save(key: HiveKey.updateTimer.name, value: updateTimer.hashCode);
  }

  void onTapDownStop(
      TapDownDetails tapDownDetails, ChallengeCourseModel? challenge,
      {String? source, required ActivityController controller}) async {
    Duration counter = Duration.zero;

    if (stopTimer != null) {
      initializeStopTimer();
    }

    stopTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (counter.compareTo(const Duration(milliseconds: 500)) == 0 ||
          counter.compareTo(const Duration(milliseconds: 500)) > 0) {
        initializeStopTimer();
        checkShowEndPopup(source, controller);
        // AdWatchAvailableModel adWatchAvailableModel = AdWatchAvailableModel(watchAvailable: false);
        // await AdmobService.getAdWatchAvailableTime(
        //   'EXERCISE_END',
        //   callback: (AdWatchAvailableModel model) {
        //     adWatchAvailableModel = model;
        //   },
        // );
        //
        // if (adWatchAvailableModel.watchAvailable!) {
        //   await controller.exerciseEndRewardedAdInit(
        //     'exerciseEndAd',
        //   );
        //   if (controller.userState.value.exercise!.rewardGo! > 0) {
        //     showEndExerciseAdDialog(controller);
        //   } else {
        //     checkShowEndPopup(source, controller);
        //   }
        // } else {
        //   checkShowEndPopup(source, controller);
        // }
      } else {
        counter = counter + const Duration(milliseconds: 10);
      }
    });
  }

  void checkShowEndPopup(String? source, ActivityController controller) {
    if (source != null && source == 'pendingExerciseDialog') {
      if (globalController.internetConnection.value) {
        Get.back();
        controller.exerciseEndThr.throttle(() => endExercise(source: source));
      } else {
        showToastPopup('check_internet_connection'.tr());
      }
    } else {
      showEndExerciseDialog();
    }
  }

  void onTapUpStop(TapUpDetails tapUpDetails, {String? source}) {
    // if (source != null && source != 'pendingExerciseDialog') showToastPopup('hold_3_seconds_to_stop'.tr());
    showToastPopup('press_and_hold'.tr());
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
    locationModelSubscription?.cancel();
    locationModelSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;

    // Stop GPS tracking when paused to prevent route drawing during pause
    _stopEnhancedGPSTracking();

    // Stop nearby treasure timer when paused
    (this as ActivityController).stopNearbyTreasureTimer();

    exerciseState.value = ExerciseState.paused;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    updateExercise(
        isPaused: true, source: 'pauseExercise${updateTimer.hashCode}');
  }

  // void showEndExerciseAdDialog(ActivityController controller) {
  //   showEndExerciseAdAlert(controller);
  //   controller.adLoadTimerStart();
  // }

  void showEndExerciseDialog() {
    showEndExerciseAlert(this);
  }

  Future<void> endExercise({String? source, int retryAttempt = 0}) async {
    // String deviceId = HiveStore.loadString(key: HiveKey.uuid.name)!;
    if (isFakeGps.value && !isTestingFakeGps()) {
      return;
    }

    bool adjustFirstEndedExerciseEvent =
        HiveStore.load(key: HiveKey.adjustFirstEndedExerciseEvent.name) ??
            false;
    if (!adjustFirstEndedExerciseEvent) {
      Adjust.trackEvent(AdjustEvent('fi36if'));
      HiveStore.save(
          key: HiveKey.adjustFirstEndedExerciseEvent.name, value: true);
    }

    // if (adId != null) {
    //   userState.update(
    //     (state) {
    //       state?.exercise?.adId = '${adId}_${deviceId}_${DateTime.now().millisecondsSinceEpoch}';
    //     },
    //   );
    // }

    listClaimedTreasureIdOfSession.clear();
    currentHighlightedTreasuresId.clear();
    (this as ActivityController).clearMarkers();
    (this as ActivityController).clearCircles();

    if (globalController.internetConnection.value) {
      // 업데이트 타이머에 의해서 미세한 차이로 운동 종료 요청후 즉시 운동 업데이트 요청이 나가지 않도록 타이머를 우선 스탑한다.
      updateTimer?.cancel();
      exerciseTimer?.cancel();
      userExerciseData.value.sequence = const Uuid().v4();
      //타이머 멈춘 후 종료 요청
      await ActivityService.fetchEndUserExercises(
        userExerciseData.value,
        source: source,
        successCallback: (CurrentUserStateModel newUserState) async {
          isExerciseInitOnce = false;
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
            HiveStore.deleteMultipleKeys(keys: [
              HiveKey.userState.name,
              HiveKey.endExerciseRequested.name,
              HiveKey.famousChallengeBadgeIssued.name
            ]);
            resetVariables();
            resetTimer();
            resetSubscriptions();

            // Stop enhanced GPS tracking and treasure geofencing
            _stopEnhancedGPSTracking();

            // Stop nearby treasure timer when exercise ends
            (this as ActivityController).stopNearbyTreasureTimer();

            if ([
              'showEndExerciseAlert',
              'showEndADExerciseAlert',
              'pendingExerciseDialog'
            ].any((src) => src == source)) {
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
            await syncExerciseData(newUserState);
            if (retryAttempt > 4) {
              showToastPopup('exercise_end_failed'.tr());
            } else {
              endExercise(source: source, retryAttempt: retryAttempt + 1);
            }
          }
        },
        errorCallback: (ErrorResponseDataModel? errorData) {
          if (errorData != null &&
              errorData.errorCode == 'ALREADY_EXERCISE_ENDED') {
            handleAlreadyFinishedExercise();
          } else {
            endExerciseLocally();
          }
        },
      );
    } else {
      showToastPopup('check_internet_connection'.tr());
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

    // Stop enhanced GPS tracking and treasure geofencing
    _stopEnhancedGPSTracking();

    // Stop nearby treasure timer when exercise ends locally
    (this as ActivityController).stopNearbyTreasureTimer();

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

    // Reset treasure and circle state
    listTreasureOfSession.clear();
    currentHighlightedTreasuresId.clear();
    listClaimedTreasureIdOfSession.clear();
    _lastCircleCenter = null;
    _lastCircleUpdateAt = null;
    _circleUpdateDebounce?.cancel();
    _circleUpdateDebounce = null;
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
    locationModelSubscription?.cancel();
    locationModelSubscription = null;
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
    HiveStore.deleteMultipleKeys(
        keys: [HiveKey.userState.name, HiveKey.endExerciseRequested.name]);
    resetVariables();
    resetTimer();
    resetSubscriptions();

    // Stop nearby treasure timer for already finished exercise
    (this as ActivityController).stopNearbyTreasureTimer();

    Get.until((route) => route.isFirst);
  }

  Future<void> showExerciseMap() async {
    await Get.toNamed(Routes.activityMap);
  }

  bool isTestingFakeGps() {
    return HiveStore.load(key: HiveKey.allowFakeGpsTest.name) ?? false;
  }

  void showLuckAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    luckLoadControl.value = Control.playReverseFromEnd;
    isShowLuckAnimation.value = true;

    // if (isAbleSound) {
    //   HapticFeedback.vibrate();
    //
    //   if (!assetsAudioPlayer.isPlaying.value) {
    //     assetsAudioPlayer.open(Audio("assets/audio/bonus_go.mp3")).then((value) {
    //       assetsAudioPlayer.play();
    //     }).onError((error, stackTrace) {});
    //   }
    // }
  }

  void initLuckAnimation() async {
    luckLoadControl.value = Control.stop;
    isShowLuckAnimation.value = false;
  }

  void validateBadgeAcquisition(
      int exerciseId, bool? badgeIssued, String badgeImgUrl) {
    bool? issuedBadge =
        HiveStore.load(key: HiveKey.famousChallengeBadgeIssued.name);
    if (issuedBadge != null && issuedBadge) return;
    if (badgeIssued != null && badgeIssued) {
      HiveStore.save(
          key: HiveKey.famousChallengeBadgeIssued.name, value: badgeIssued);
      ActivityController controller = Get.find<ActivityController>();
      showLocalNotification(
        notificationType: NotificationType.badge,
        title: 'challenge_badge_obtained'.tr(),
        message: 'challenge_success_badge_obtained'
            .tr(args: ['${controller.selectedCourse.value!.firstName}']),
        payload: 'NAV-INVENTORY_BADGE',
      );
      showToastPopup('badge_obtained'.tr());
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

  Future<void> syncExerciseData(CurrentUserStateModel userState) async {
    exerciseTime.value = userState.exercise!.time!;
    exerciseSteps.value = userState.exercise!.steps!;
    exerciseDistance.value = userState.exercise!.distance!;
    HiveStore.save(
        key: HiveKey.savedStepCount.name, value: userState.exercise!.steps!);

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> fetchExerciseTreasures() async {
    // Use manager's current location or get fresh one
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final loc = LocationCallbackHandler.convertToLocationModel(pos);

    final req = GetTreasureRequestModel(
      userId: userState.value.state?.userId ?? -1,
      userExerciseId: userState.value.exercise?.id ?? -1,
      userLat: loc.latitude,
      userLng: loc.longitude,
    );
    final loaderController = (this as ActivityController).loaderController;
    loaderController.isLoading.value = true;
    await TreasureService.getTreasureByExerciseId(
      req: req,
      successCallback: (treasures) async {
        listTreasureOfSession = List.from(treasures.treasures
            .where((element) =>
                !listClaimedTreasureIdOfSession.contains(element.id))
            .toList());
        kMinPickupRadius = treasures.minPickupDistance;
        kTreasureVisibleRadius = treasures.visibleRadius;
        kPickupCoolDownTime = treasures.cooldownDuration; // in seconds
        // Initialize cooldown timer if needed
        (this as ActivityController)
            .initCoolDownTimerIfNeeded(treasures.lastClaimTime);

        final myLocationMarker =
            (this as ActivityController).getMyLocationMarker();
        (this as ActivityController).clearOverlays();
        await initTreasureMarker();
        drawTreasureVisibilityCircle(isUpdate: false);

        // redraw my location blue dot at after draw treasure
        if (myLocationMarker.length == 2) {
          (this as ActivityController).addOverlay(myLocationMarker.first);
          (this as ActivityController)
              .updateOrInsertCircle(myLocationMarker.last);
        }

        // Use LatLng version with fetched location coordinates
        await (this as ActivityController)
            .compareDistanceWithNearestTreasure(LatLng(
          loc.latitude,
          loc.longitude,
        ));
        loaderController.isLoading.value = false;
      },
      errorCallback: (_) {
        loaderController.isLoading.value = false;
        print("error fetching exercise treasures");
      },
    );
  }

  Future<void> initTreasureMarker() async {
    final markers = await buildCustomMarkers(
      positions: listTreasureOfSession,
      markerSize: kTreasureBaseSize,
    );
    (this as ActivityController).clearMarkers();
    (this as ActivityController).addOverlayAll(markers);
  }

  /// make custom marker based on position
  Future<Set<Marker>> buildCustomMarkers({
    required List<TreasureModel> positions,
    required Size markerSize,
  }) async {
    final Set<Marker> markers = {};

    for (int i = 0; i < positions.length; i++) {
      final treasure = positions[i];

      // Skip treasures with incomplete data
      if (treasure.id == null ||
          treasure.latitude == null ||
          treasure.longitude == null) {
        continue;
      }

      final BitmapDescriptor customIcon =
          await ImageHelper.bitmapDescriptorFromSvgAsset(
        treasure.iconPathLocal,
        markerSize,
        treasure.id!,
      );
      markers.add(
        Marker(
          markerId: MarkerId(treasure.id.toString()),
          position: LatLng(treasure.latitude!, treasure.longitude!),
          icon: customIcon,
          onTap: () => (this as ActivityController).onPickupTreasure(treasure),
        ),
      );
    }

    return markers;
  }

  /// Start enhanced GPS tracking with ActivityGPSService
  Future<void> _startEnhancedGPSTracking() async {
    try {
      // Get ActivityGPSService instance
      final activityGPSService = Get.isRegistered<ActivityGPSService>()
          ? Get.find<ActivityGPSService>()
          : Get.put(ActivityGPSService(), permanent: true);

      // Start GPS tracking
      final started = await activityGPSService.startTracking();
      if (started) {
        print('Enhanced GPS tracking started successfully');

        // Listen to GPS location updates (ActivityGPSService processes them internally)
        GPS.locationStream.listen((location) {
          _handleEnhancedLocationUpdate(location);
        });
      } else {
        print(
            'Failed to start enhanced GPS tracking, falling back to standard GPS');
      }
    } catch (e) {
      print('Error starting enhanced GPS tracking: $e');
    }
  }

  /// Handle enhanced location updates from ActivityGPSService
  void _handleEnhancedLocationUpdate(LocationModel location) {
    try {
      // Update current location
      currentLocation.value = location;

      // Update treasure visibility circle immediately for real-time sync
      if (exerciseState.value == ExerciseState.ongoing &&
          listTreasureOfSession.isNotEmpty) {
        // For immediate updates, skip debounce and update directly
        _performCircleUpdateImmediate(location);
      }

      // Only update coordinates for map display when exercise is ongoing AND network is available
      // This creates the desired "broken line" effect during network outages while GPS still tracks user position
      if (exerciseState.value == ExerciseState.ongoing) {
        final newCoord = LatLng(location.latitude, location.longitude);
        if (coordinates.isEmpty ||
            coordinates.last.latitude != location.latitude ||
            coordinates.last.longitude != location.longitude) {
          // Only add coordinates to polyline when network is available (business requirement)
          if (globalController.internetConnection.value) {
            coordinates.add(newCoord);
          }
        }
      }

      // Update exercise data if ongoing
      if (exerciseState.value == ExerciseState.ongoing) {
        exerciseData.add(UserExerciseModel(
          altitude: location.altitude,
          speed: location.speed,
          // store in m/s for consistency
          steps: exerciseSteps.value,
          locationUpdateTime: DateTime.now(),
          lastLatitude: location.latitude,
          lastLongitude: location.longitude,
        ));
      }

      // Update real-time speed and distance from ActivityGPSService
      try {
        final activityGPS = Get.find<ActivityGPSService>();
        exerciseDistance.value = activityGPS.totalDistance.value;
        gpsSpeed.value = activityGPS.currentSpeed.value;

        // Update realTimeSpeed for main UI display with smoothing to prevent flickering
        double newSpeed = activityGPS.currentSpeed.value;

        // Always update realTimeSpeed for accurate display
        realTimeSpeed.value = newSpeed;

        // Update smoothedSpeed with more conservative logic for color stability
        if ((newSpeed - smoothedSpeed.value).abs() > 1.0 ||
            smoothedSpeed.value == 0) {
          // Only update smoothedSpeed if speed change is significant (> 1.0 km/h) or first time
          smoothedSpeed.value = newSpeed;
          print(
              'Speed updated: realTime=${realTimeSpeed.value.toStringAsFixed(1)}, smoothed=${smoothedSpeed.value.toStringAsFixed(1)}');
        }
      } catch (e) {
        // Fallback to original speed calculation if ActivityGPSService not available
        gpsSpeed.value = location.speedKmh;
        // Don't override realTimeSpeed here, let calRealtimeSpeed() handle it
      }
    } catch (e) {
      print('Error handling enhanced location update: $e');
    }
  }

  /// Stop enhanced GPS tracking and treasure geofencing
  Future<void> _stopEnhancedGPSTracking() async {
    try {
      // Stop ActivityGPSService
      if (Get.isRegistered<ActivityGPSService>()) {
        final activityGPS = Get.find<ActivityGPSService>();
        await activityGPS.stopTracking();
        print('ActivityGPSService stopped');
      }

      // Stop TreasureGeofencingService
      if (Get.isRegistered<TreasureGeofencingService>()) {
        final treasureGeofencing = Get.find<TreasureGeofencingService>();
        await treasureGeofencing.stopMonitoring();
        print('TreasureGeofencingService stopped');
      }

      // Clean up circle update timer
      _circleUpdateDebounce?.cancel();
      _circleUpdateDebounce = null;

      print('Enhanced GPS tracking stopped successfully');
    } catch (e) {
      print('Error stopping enhanced GPS tracking: $e');
    }
  }

  Future<void> drawTreasureVisibilityCircle({required bool isUpdate}) async {
    // Get center from current location (synchronized with dot) or fallback to GPS
    LatLng? center = _getDisplayLatLng();

    if (center == null) {
      // Fallback to GPS manager if location not available
      try {
        final loc = await GPS.getCurrentLocation();
        if (loc != null) {
          center = LatLng(loc.latitude, loc.longitude);
        } else {
          print('Cannot draw treasure circle: GPS manager returned null');
          return;
        }
      } catch (e) {
        print('Cannot draw treasure circle: GPS manager error - $e');
        return;
      }
    }

    // Remember initial state for sync
    _lastCircleCenter = center;
    _lastCircleUpdateAt = DateTime.now();

    // Build circle with synchronized center
    final circle = Circle(
      circleId: _pickupCircleId,
      center: center,
      radius: kTreasureVisibleRadius.toDouble(),
      fillColor: const Color(0xff0E79F3).withOpacity(0.15),
      strokeColor: Colors.transparent,
      strokeWidth: 0,
    );

    if (isUpdate) {
      (this as ActivityController).updateOrInsertCircle(circle);
    } else {
      (this as ActivityController).updateOrInsertCircle(circle);
    }

    print(
        'Treasure visibility circle drawn at: ${center.latitude}, ${center.longitude}');
  }

  /// Helper: Get the display LatLng from currentLocation
  LatLng? _getDisplayLatLng() {
    final loc = currentLocation.value;
    if (loc == null) {
      // Fallback to last coordinate if available
      if (coordinates.isNotEmpty) {
        return coordinates.last;
      }
      return null;
    }
    return LatLng(loc.latitude, loc.longitude);
  }

  /// Helper: Calculate distance between two LatLng points in meters
  double _distanceMeters(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }

  /// Helper: Check if speed indicates stationary status
  bool _isStationary(double speedMs) {
    return speedMs < kStationarySpeedThresholdMs;
  }

  /// Schedule debounced circle update
  void _scheduleCircleUpdate(LocationModel location) {
    // Cancel any existing debounce timer
    _circleUpdateDebounce?.cancel();

    // Schedule new update after debounce period
    _circleUpdateDebounce = Timer(
      const Duration(milliseconds: kCircleUpdateDebounceMs),
      () => _performCircleUpdate(location),
    );
  }

  /// Perform the actual circle update with jitter control
  void _performCircleUpdate(LocationModel location) {
    final newCenter = LatLng(location.latitude, location.longitude);
    final now = DateTime.now();

    // Check if we should skip this update due to jitter
    if (_lastCircleCenter != null && _lastCircleUpdateAt != null) {
      final timeSinceLastUpdate =
          now.difference(_lastCircleUpdateAt!).inMilliseconds;
      final distanceMoved = _distanceMeters(newCenter, _lastCircleCenter!);

      // Determine jitter threshold based on movement state
      double effectiveJitterThreshold = kJitterDistanceMeters;
      if (_isStationary(location.speed)) {
        // Use slightly larger threshold when stationary to reduce wobble
        effectiveJitterThreshold = kJitterDistanceMeters * 1.5;
      }

      // Skip update if movement is too small and not enough time has passed
      if (distanceMoved < effectiveJitterThreshold &&
          timeSinceLastUpdate < kHardRefreshIntervalMs) {
        return;
      }

      // Handle poor GPS accuracy
      if (location.accuracy > 50 &&
          timeSinceLastUpdate < kHardRefreshIntervalMs) {
        // Throttle updates during poor GPS conditions
        return;
      }
    }

    // Update state
    _lastCircleCenter = newCenter;
    _lastCircleUpdateAt = now;

    // Build and update circle
    final circle = Circle(
      circleId: _pickupCircleId,
      center: newCenter,
      radius: kTreasureVisibleRadius.toDouble(),
      fillColor: const Color(0xff0E79F3).withOpacity(0.15),
      strokeColor: Colors.transparent,
      strokeWidth: 0,
    );

    // Use updateOrInsertCircle for smooth updates
    (this as ActivityController).updateOrInsertCircle(circle);
  }

  /// Perform immediate circle update for real-time synchronization
  /// This bypasses debouncing and most jitter controls for instant response
  void _performCircleUpdateImmediate(LocationModel location) {
    final newCenter = LatLng(location.latitude, location.longitude);
    final now = DateTime.now();

    // Only apply minimal jitter control for stationary users
    if (_lastCircleCenter != null && _isStationary(location.speed)) {
      final distanceMoved = _distanceMeters(newCenter, _lastCircleCenter!);
      // Only skip if movement is truly negligible (< 0.3m for stationary)
      if (distanceMoved < 0.3) {
        return;
      }
    }

    // Update state
    _lastCircleCenter = newCenter;
    _lastCircleUpdateAt = now;

    // Build circle with exact same position as location
    final circle = Circle(
      circleId: _pickupCircleId,
      center: newCenter,
      radius: kTreasureVisibleRadius.toDouble(),
      fillColor: const Color(0xff0E79F3).withOpacity(0.15),
      strokeColor: Colors.transparent,
      strokeWidth: 0,
    );

    // Immediate update without batching
    (this as ActivityController).updateOrInsertCircle(circle);
  }

  /// Update treasure visibility circle with debouncing and jitter control
  Future<void> updateTreasureVisibilityCircle() async {
    // Use current location for immediate update
    final loc = currentLocation.value;
    if (loc == null) {
      return;
    }

    // Schedule debounced update to prevent flickering
    _scheduleCircleUpdate(loc);
  }
}
