import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/repair_shoes_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_stamina_recharge_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/views/activity/activity_loading.dart';
import 'package:gaza_go/presentations/views/activity/activity_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:throttling/throttling.dart';

class ActivityController extends SuperController with ActivityMixin, ChallengeMixin, GetTickerProviderStateMixin {
  final WalletMasterController walletMasterController = Get.find();

  //index.dart
  RxList<StatModel> get statList {
    return RxList([
      StatModel(name: '체력', currentStat: userState.value.state != null ? userState.value.state!.stamina! : 0, type: 'STAMINA'),
      StatModel(name: '내구도', currentStat: userState.value.shoes != null ? userState.value.shoes!.durability! : 0, type: 'DURABILITY'),
    ]);
  }

  RxList<dynamic> get activitySumList {
    return RxList([
      {'title': '운동 시간', 'unit': '', 'content': '1일 ${'03:15:12'}', 'icon': iconActivityStoryWatch},
      {'title': '운동 거리', 'unit': 'km', 'content': 300.34.toString(), 'icon': iconActivityStoryDistance},
      {'title': '걸음 수', 'unit': '', 'content': 12682.toString(), 'icon': iconActivityStorySteps},
      {'title': '총 획득 타이카', 'unit': 'TIK', 'content': 200.toString(), 'icon': iconActivityStoryTaika},
    ]);
  }

  final RxDouble currentSliderValue = RxDouble(0);
  final RxInt remainDurability = RxInt(0);
  final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);
  final RxBool isListeningToLocation = RxBool(false);
  final RxBool hasPermission = RxBool(false);
  final Rx<ExerciseType> selectedExerciseType = Rx(ExerciseType.walking);
  final Rx<LocationPermission> _locationPermission = Rx(LocationPermission.unableToDetermine);
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus = Rx(LocationAccuracyStatus.unknown);
  StreamSubscription<ServiceStatus>? _serviceStatusStream;
  final Rx<DateTime> receiveLocationTime = Rx(DateTime.now());
  final HealthFactory health = HealthFactory();
  final Rxn<OverlayImage>? challengeStartMaker = Rxn();
  OverlayImage? startMaker;
  OverlayImage? endMaker;
  RxInt challengeSelectedIndex = RxInt(-1);
  Control activityLoadControl = Control.play;
  RxBool disableButton = RxBool(false);
  RxBool disableActivityButton = RxBool(true);
  final Throttling thr = Throttling(duration: const Duration(milliseconds: 500));
  late AnimationController challengeGuideController;
  final Rx<Control> challengeLoadControl = Rx(Control.play);
  final RxDouble challengeLoadControlPosition = RxDouble(0);

  Future<void> initializeController() async {
    challengeGuideController = AnimationController(vsync: this);
    await initController();
    checkConnectivityStatus();
    if ([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState.value)) {
      showPendingExerciseAlert(this);
    }
    disableActivityButton.value = false;
  }

  @override
  void onClose() {
    print('################# onClose ActivityController');

    updateTimer?.cancel();
    updateTimer = null;
    exerciseTimer?.cancel();
    exerciseTimer = null;
    stepSubscription?.cancel();
    stepSubscription = null;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    locationSubscription?.cancel();
    locationSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
    _serviceStatusStream?.cancel();
    _serviceStatusStream = null;

    super.onClose();
  }

  Future<void> initController() async {
    await getUserState().then((_) async {
      hasPermission.value = await checkAvailabilities();
      if (hasPermission.value) {
        await initActivityStatus();
      }
      await loadChallenges();
    });
  }

  Future<void> refreshController() async {
    getUserState();
  }

  Future<void> initActivityStatus() async {
    await initializeActivity();
    await loadMakerImages();
  }

  Future<void> loadMakerImages() async {
    startMaker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_start_maker.png',
    );

    endMaker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_end_maker.png',
    );
  }

  Marker generateDefaultMarker(ChallengeModel course) {
    return Marker(
      markerId: course.id!.toString(),
      position: LatLng(course.startLat!, course.startLon!),
      captionText: course.startPointName,
      captionColor: skyBlueColor,
      captionHaloColor: Colors.black,
      captionTextSize: 16.0,
      subCaptionTextSize: 14,
      subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
      subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
      captionOffset: 5,
      icon: startMaker,
      width: 20,
      height: 20,
      onMarkerTab: (marker, iconSize) {
        showEndPointMarker(course);
      },
    );
  }

  void generateChallengeMarkerList() {
    allChallengesList.value = RxList.empty();
    challengeMarkers.value = RxList.empty();
    for (ChallengeHierarchyModel challenge in hierarchyChallengesList) {
      for (ChallengeModel course in challenge.course) {
        allChallengesList.add(course);

        challengeMarkers.add(generateDefaultMarker(course));
      }
    }
  }

  Future<void> loadChallenges() async {
    await getChallengesHierarchy(currentLocation.value);
    generateChallengeMarkerList();
  }

  void showEndPointMarker(ChallengeModel course) {
    if (challengeSelectedIndex.value != -1) {
      challengeMarkers.add(generateDefaultMarker(allChallengesList.firstWhere((element) => element.id == challengeSelectedIndex.value)));
    }

    challengeSelectedIndex.value = course.id!;
    selectedChallengeMarkers.value = RxList.empty();
    challengeMarkers.removeWhere((element) {
      return element.markerId == challengeSelectedIndex.value.toString();
    });

    selectedChallengeMarkers.add(Marker(
      markerId: 'start_${course.id!.toString()}',
      position: LatLng(course.startLat!, course.startLon!),
      captionText: '시작: ${course.startPointName}',
      captionColor: skyBlueColor,
      captionHaloColor: Colors.black,
      captionTextSize: 16.0,
      subCaptionTextSize: 14,
      subCaptionText: course.secondName,
      subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
      subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
      captionOffset: 5,
      icon: startMaker,
      width: 20,
      height: 20,
    ));

    selectedChallengeMarkers.add(Marker(
      markerId: 'end_${course.id!.toString()}',
      position: LatLng(course.endLat!, course.endLon!),
      captionText: '도착: ${course.endPointName}',
      captionColor: const Color(0xFFFF6F75),
      captionHaloColor: Colors.black,
      captionTextSize: 16.0,
      captionOffset: 5,
      subCaptionText: course.secondName,
      subCaptionTextSize: 14,
      subCaptionColor: (Platform.isAndroid) ? Colors.white : Colors.black,
      subCaptionHaloColor: (Platform.isAndroid) ? Colors.black : Colors.white,
      icon: endMaker,
      width: 20,
      height: 20,
    ));

    challengeMapController.moveCamera(
      CameraUpdate.fitBounds(
        LatLngBounds.fromLatLngList(
          [
            LatLng(course.startLat!, course.startLon!),
            LatLng(course.endLat!, course.endLon!),
          ],
        ),
        padding: 100,
      ),
    );
  }

  void initRepairInfo() {
    repairDurability.value = 0;
    remainDurability.value = 0;
    currentSliderValue.value = 0;
    costTik.value = 0;
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }

  void onClickRepairStat(stat) {
    handleShowStaminaPopup(stat);
  }

  void handleShowStaminaPopup(stat) async {
    currentSliderValue.value = 0;
    await walletMasterController.getFeeTik();
    showRepairStatSlider(this, stat, walletMasterController.feeTikStamina.value, walletMasterController.feeTikDurability.value);
  }

  void handleNotEnoughTaikaPopup() {
    showNotEnoughTaikaAlert();
  }

  void fetchRechargeStamina(type) async {
    disableButton.value = true;
    if (walletMasterController.tik.value.amount! >= costTik.value) {
      if (costTik.value > 0) {
        await ActivityService.fetchUserStaminaRecharge(
            UserStaminaRechargeModel(
              type: type,
              stat: currentSliderValue.value.toInt(),
              feeTik: costTik.value,
            ), successCallback: (userState) {
          UserStateModel newUserState = userState;
          this.userState.update((state) {
            state?.state = newUserState;
          });
          walletMasterController.getSpendingWalletBalances();
          showToastPopup('체력이 충전되었습니다.');
          closeRepairPopup();
        }, errorCallback: () {
          Timer(const Duration(milliseconds: 500), () {
            disableButton.value = false;
          });
        });
      } else {
        showToastPopup('충전할 게이지를 확인해주세요.');
      }
    } else {
      handleNotEnoughTaikaPopup();
    }

    Timer(const Duration(milliseconds: 500), () {
      disableButton.value = false;
    });
  }

  void fetchRepairShoes() async {
    disableButton.value = true;
    if (walletMasterController.tik.value.amount! >= costTik.value) {
      if (costTik.value > 0) {
        await ItemService.fetchRepairItemShoes(
            RepairShoesModel(
              id: userState.value.shoes!.id,
              durability: currentSliderValue.value.toInt(),
              feeTik: costTik.value.toInt(),
            ), successCallback: (repairModel) {
          InventoryItemModel newRepairModel = repairModel;
          userState.update((state) {
            state!.shoes!.durability = newRepairModel.durability;
          });
          walletMasterController.getSpendingWalletBalances();
          showToastPopup('내구도 충전이 완료되었습니다.');
          closeRepairPopup();
        }, errorCallback: () {
          Timer(const Duration(milliseconds: 500), () {
            disableButton.value = false;
          });
        });
      } else {
        showToastPopup('충전할 게이지를 확인해주세요.');
      }
    } else {
      handleNotEnoughTaikaPopup();
    }

    Timer(const Duration(milliseconds: 500), () {
      disableButton.value = false;
    });
  }

  Future<void> getUserState() async {
    await ActivityService.getCurrentUserState(successCallback: (currentUserState) async {
      currentUserState.exercise?.locationUpdateTime = DateTime.now();
      userState.update((state) {
        state?.state = currentUserState.state;
        state?.exercise = currentUserState.exercise;
        state?.shoes = currentUserState.shoes;
      });

      if (userState.value.exercise == null) {
        exerciseState.value = ExerciseState.ready;
      } else {
        CurrentUserStateModel? savedUserState = HiveStore.loadCurrentUserState();
        if (savedUserState != null && savedUserState.exercise != null && savedUserState.exercise!.recordState! == 'NORMAL') {
          savedUserState.exercise!.locationUpdateTime = DateTime.now();
          userState.update((state) {
            state?.exercise = savedUserState.exercise;
          });

          int savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
          if (savedUserState.exercise!.steps! > savedSteps) {
            HiveStore.save(key: HiveKey.savedStepCount.name, value: savedUserState.exercise!.steps!);
          }
        }

        if (userState.value.exercise?.challengeId != null) {
          //  산행중인 정보 가져오기
          ChallengeModel challenge = await getChallenge(userState.value.exercise!.challengeId!);
          if (challenge.id != null) {
            selectedChallenge.value = challenge;
          }
        }
        if (updateTimer == null) {
          exerciseData.value = List.empty(growable: true);
          exerciseData.add(userState.value.exercise!);
          exerciseTime.value = userState.value.exercise!.time!;
          exerciseSteps.value = userState.value.exercise!.steps!;
          exerciseDistance.value = userState.value.exercise!.distance!;

          coordinates.value = List.empty(growable: true);
          if (userState.value.exercise!.locations != null) {
            coordinates.addAll(parseCoordinates());
          }
        }

        final state = userState.value.exercise!.state!;

        if (state == 'ONGOING' && updateTimer != null) {
          exerciseState.value = ExerciseState.ongoing;
        } else if (state == 'PAUSED' || updateTimer == null) {
          exerciseState.value = ExerciseState.paused;
        }
      }

      await retrySavedRequests(source: 'getUserState');

      if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("곧 가자고와 가자고~!");
    }, errorCallback: (statusCode) {
      if (statusCode == 404) {
        onLogout();
      }
      throw statusCode;
    });
  }

  void onLogout() async {
    await UaaService.fetchLogout(
      successCallback: () {
        HiveStore.deleteMultipleKeys(keys: [
          HiveKey.accessToken.name,
          HiveKey.refreshToken.name,
          HiveKey.userState.name,
          HiveKey.exerciseData.name,
          HiveKey.endExerciseRequested.name,
          HiveKey.badgeIssuanceRequested.name,
          HiveKey.savedStepCount.name,
          HiveKey.dummyStepCount.name,
          HiveKey.savedStepInitialized.name,
          HiveKey.authorities.name,
        ]);
        Get.offAllNamed(Routes.login);
      },
      errorCallback: () {},
    );
  }

  requestExerciseInitialization() async {
    bool systemReady = await checkAvailabilities();
    if (systemReady) {
      if (!isListeningToLocation.value) {
        initializeActivity();
      }
      getActivityRoute();
    } else {
      await requestPermissionStepByStep();
    }
  }

  Future<bool> checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    bool hasActivityPermission = await checkActivityPermission();
    bool hasLocationPermissionWithAccuracy = await checkLocationPermissionAndAccuracy();

    return isGpsAvailable && hasActivityPermission && hasLocationPermissionWithAccuracy;
  }

  Future<bool> requestPermissionStepByStep() async {
    bool isGpsAvailable = await checkGpsSensor();
    if (!isGpsAvailable) {
      await showGpsRequestAlert();
    }
    bool hasActivityPermission = await checkActivityPermission();
    if (!hasActivityPermission) {
      await showRequestActivityAlert();
    }

    bool hasLocationPermissionWithAccuracy = await checkLocationPermissionAndAccuracy();
    if (!hasLocationPermissionWithAccuracy) {
      await showRequestLocationAlert();
    }

    return isGpsAvailable && hasActivityPermission && hasLocationPermissionWithAccuracy;
  }

  Future<void> showRequestLocationAlert() async {
    await showLocationAlert(this);
  }

  Future<void> showRequestActivityAlert() async {
    await showActivityAlert(this);
  }

  Future<void> showGpsRequestAlert() async {
    await showGpsAlert();
  }

  Future<bool> checkGpsSensor() async {
    bool isGpsAvailable = await Geolocator.isLocationServiceEnabled();

    return isGpsAvailable;
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    _locationPermission.value = locationPermission;

    return [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
  }

  Future<bool> checkLocationAccuracy() async {
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();
    _locationAccuracyStatus.value = accuracyStatus;

    return accuracyStatus == LocationAccuracyStatus.precise;
  }

  Future<bool> checkLocationPermissionAndAccuracy() async {
    bool hasPermission = await checkLocationPermission();

    bool isAccurate = false;
    if (hasPermission) {
      isAccurate = await checkLocationAccuracy();
    }

    bool hasLocationPermission = hasPermission && isAccurate;

    return hasLocationPermission;
  }

  Future<bool> checkActivityPermission() async {
    bool hasActivityPermission = false;
    if (Platform.isAndroid) {
      hasActivityPermission = ph.PermissionStatus.granted == await ph.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission = ph.PermissionStatus.granted == await ph.Permission.sensors.status;
    }

    return hasActivityPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = ph.PermissionStatus.granted == await ph.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      permissionGranted = ph.PermissionStatus.granted == await ph.Permission.sensors.request();
      await health.requestAuthorization([HealthDataType.STEPS]);

      // permissionGranted = sensorGranted && healthGranted;
    }
    if (!permissionGranted) {
      ph.openAppSettings();
    }
    activityRecognitionPermission.complete(permissionGranted);

    return activityRecognitionPermission.future;
  }

  Future<bool> requestLocationPermission() async {
    Completer<bool> locationPermissionCompleter = Completer();
    LocationPermission locationPermission = await Geolocator.requestPermission();
    bool gotPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
    if (!gotPermission) {
      Geolocator.openAppSettings();
    }

    locationPermissionCompleter.complete(gotPermission);

    return locationPermissionCompleter.future;
  }

  void getActivityRoute() {
    if ([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState.value)) {
      Get.toNamed(Routes.activityActive);
    } else {
      Get.dialog(const ActivitySelect(), barrierDismissible: false, barrierColor: const Color.fromRGBO(0, 0, 0, 0.85));
    }
  }

  void loadExercise(ExerciseType exerciseType, [ChallengeModel? challenge]) {
    loadingTime.value = 1;

    Get.dialog(
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      const ActivityLoading(),
    );

    loadingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (loadingTime.value == 3) {
          timer.cancel();
          loadingTimer = null;
          thr.throttle(() => startExercise(exerciseType, challenge));
        } else {
          loadingTime.value++;
          activityLoadControl = Control.playFromStart;
        }
      },
    );
  }

  void selectExerciseType(ExerciseType exerciseType) {
    selectedExerciseType.value = exerciseType;
    if (selectedExerciseType.value == ExerciseType.walking) selectedChallenge.value = ChallengeModel();
    Get.offNamed(Routes.activityActive);
    loadExercise(selectedExerciseType.value, selectedChallenge.value.id != null ? selectedChallenge.value : null);
  }

  void moveToChallengeSelection() {
    selectedChallenge.value = ChallengeModel();
    Get.toNamed(Routes.activityChallenges);
  }

  void moveToChallengeMap() async {
    bool systemReady = await checkAvailabilities();
    if (systemReady) {
      challengeSelectedIndex.value = -1;
      selectedChallengeMarkers.value = RxList.empty();
      generateChallengeMarkerList();
      Get.toNamed(Routes.challengeMap);
    } else {
      await requestPermissionStepByStep();
    }
  }

  void initLocationStream() {
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: locationAccuracyQuality,
          distanceFilter: 1,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 5),
          useMSLAltitude: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "운동 기록을 측정중",
            notificationTitle: "위치 기록 중",
            enableWakeLock: true,
          ));
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: locationAccuracyQuality,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: false,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    }

    locationSubscription ??= Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      currentLocation.value = position;

      if (HiveStore.load(key: HiveKey.isDebuggingMode.name) && exerciseState.value == ExerciseState.ongoing) {
        List positionLowData = HiveStore.load(key: HiveKey.positionLowDataLogs.name) ?? [];

        var logForm = {
          'positionLowDataInfo': '===================================='
              '\nAltitude: ${position.altitude}'
              '\nSpeed: ${convertMStoKMH(position.speed)}'
              '\nSteps: ${exerciseSteps.value}'
              '\nAccuracy: ${position.accuracy}'
              '\nLatitude: ${position.latitude}'
              '\nLongitude: ${position.longitude}'
              '\nLocationUpdateTime: ${DateTime.now()}'
        };
        positionLowData.add(logForm);
        HiveStore.savePositionLowData(value: positionLowData);
      }
      if (exerciseState.value == ExerciseState.ongoing && position.accuracy < gpsAccuracy) {
        exerciseData.add(UserExerciseModel(
          altitude: position.altitude,
          speed: convertMStoKMH(position.speed),
          steps: exerciseSteps.value,
          locationUpdateTime: DateTime.now(),
        ));

        coordinates.add(LatLng(position.latitude, position.longitude));
        if (coordinates.isNotEmpty && coordinates.length > 1) {
          exerciseDistance.value = exerciseDistance.value +
              Geolocator.distanceBetween(coordinates[coordinates.length - 2].latitude, coordinates[coordinates.length - 2].longitude, coordinates.last.latitude, coordinates.last.longitude);
        }
      } else {
        // 첼린지 존 찾기(30초마다 요청)
        DateTime now = DateTime.now();

        if (receiveLocationTime.value.add(const Duration(seconds: 30)).compareTo(now) < 0) {
          findChallenge();
          receiveLocationTime.value = now;
        }
      }

      detectChallengeZone(position);
      autoFinishChallenge(position, userState.value);
    });
  }

  initGpsServiceStream() {
    _serviceStatusStream ??= Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        showGpsAlert();
      }
    });
  }

  Future<void> getCurrentLocation() async {
    print('getCurrentLocation');
    await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracyQuality, timeLimit: const Duration(seconds: 5)).then((location) {
      print('getCurrentLocation 위치정보 가져옴');
      currentLocation.value = location;
      isListeningToLocation.value = true;
    }).onError((error, stackTrace) {
      showToastPopup('위치정보를 가져오지 못했습니다.');
    });
  }

  Future<void> initializeActivity() async {
    await getCurrentLocation();
    initLocationStream();
    initGpsServiceStream();
    //await setMarkerImages();
    await findChallenge();
    detectChallengeZone(currentLocation.value);
  }

  // 챌린지 찾기
  Future<void> findChallenge() async {
    if (currentLocation.value.latitude != 0 && currentLocation.value.longitude != 0) {
      await getNearByChallengeList(currentLocation.value, exerciseState.value);
    } else {
      await getChallengeList();
    }
  }

  void checkConnectivityStatus() {
    globalController.connectivityResult.listen((value) async {
      if (value != ConnectivityResult.none) {
        await retrySavedRequests(source: 'connectivityListener');
      }
    });
  }

  Future<void> retrySavedRequests({required String source}) async {
    if (HiveStore.load(key: HiveKey.badgeIssuanceRequested.name) != null && HiveStore.load(key: HiveKey.badgeIssuanceRequested.name) && userState.value.exercise != null) {
      await requestBadgeIssuance(userState.value);
    }

    if (HiveStore.load(key: HiveKey.endExerciseRequested.name) != null && HiveStore.load(key: HiveKey.endExerciseRequested.name) && userState.value.exercise != null) {
      await endExercise(selectedChallenge.value, source: source);
    }
  }

  @override
  void onDetached() {
    print('onDetached');
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    print('onInactive');
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    print('onPaused');
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    print('onResumed');
    // TODO: implement onResumed
  }
}
