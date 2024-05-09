import 'dart:async';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/consumer_item_mixin.dart';
import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/promotion_mixin.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/promotion_ad_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/views/activity/activity_loading.dart';
import 'package:gaza_go/presentations/views/activity/activity_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:throttling/throttling.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityController extends SuperController with ActivityMixin, ChallengeMixin, GetTickerProviderStateMixin, ConsumerItemMixin, PromotionMixin {
  final WalletMasterController walletMasterController = Get.find();
  // ActivityController activityController = Get.isRegistered<ActivityController>() ? Get.find<ActivityController>() : Get.put(ActivityController());
  LoaderController loaderController = Get.isRegistered<LoaderController>() ? Get.find<LoaderController>() : Get.put(LoaderController());
  RxList<StatModel> get statList {
    return RxList([
      StatModel(name: '체력', currentStat: userState.value.state != null ? userState.value.state!.stamina! : 0, type: 'STAMINA'),
      StatModel(name: '신발 내구도', currentStat: userState.value.shoes != null ? userState.value.shoes!.durability! : 0, type: 'DURABILITY'),
    ]);
  }
  GlobalKey webViewKey = GlobalKey();
  // final RxDouble currentSliderValue = RxDouble(0);
  // final RxInt remainDurability = RxInt(0);
  // final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);
  final RxBool isListeningToLocation = RxBool(false);
  final RxBool hasPermission = RxBool(false);
  final Rx<ExerciseType> selectedExerciseType = Rx(ExerciseType.walking);
  final Rx<LocationPermission> _locationPermission = Rx(LocationPermission.unableToDetermine);
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus = Rx(LocationAccuracyStatus.unknown);
  StreamSubscription<ServiceStatus>? _serviceStatusStream;
  final Rx<DateTime> receiveLocationTime = Rx(DateTime.now());
  OverlayImage? startMarker;
  OverlayImage? endMarker;
  List<OverlayImage> checkpointMarkers = List.empty(growable: true);
  RxnInt challengeSelectedIndex = RxnInt(null);
  Control activityLoadControl = Control.play;
  RxBool disableButton = RxBool(false);
  RxBool disableActivityButton = RxBool(true);
  final Throttling thr = Throttling(duration: const Duration(milliseconds: 500));
  final Throttling exerciseStartThr = Throttling(duration: const Duration(milliseconds: 500));
  final Throttling exerciseUpdateThr = Throttling(duration: const Duration(milliseconds: 500));
  final Throttling exerciseEndThr = Throttling(duration: const Duration(milliseconds: 500));
  final Throttling locationThr = Throttling(duration: const Duration(milliseconds: 500));
  late AnimationController challengeGuideController;
  final Rx<Control> challengeLoadControl = Rx(Control.play);
  final RxBool isButtonDisabled = RxBool(false);
  RxList<ChallengeModel> challengeList = RxList.empty();
   RxBool isFetchingCourseList = RxBool(true);
   RxDouble gpsAccuracySensitive = RxDouble(0.0);
  RxnInt showGpsAlertCount = RxnInt(0);


  Future<void> initializeExercise() async {
    challengeGuideController = AnimationController(vsync: this);
    checkConnectivityStatus();


    if ([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState.value) && !isFakeGps.value && !isTestingFakeGps()) {
      showPendingExerciseAlert(this);
    }
    disableActivityButton.value = false;
  }

  Future<void> initializeController() async {
    await getUserState().then((_) async {
      print('getUserState');
      hasPermission.value = await checkAvailabilities();
      if (hasPermission.value) {
        print('hasPermission');
        await initActivityStatus();
      }

      await loadChallenges();

    });

    // await initPlatformState();
  }

  Future<void> refreshController() async {
    getUserState(showLoading: true);
  }

  Future<void> initActivityStatus() async {
    await initializeActivity();
    await loadMakerImages();
    await getPromotionAdsList();
  }

  Future<void> loadMakerImages() async {
    startMarker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_start_marker.png',
    );

    endMarker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_end_marker.png',
    );

    int index = 0;
    while (index < 10) {
      checkpointMarkers.add(await OverlayImage.fromAssetImage(
        assetName: 'assets/images/activity/ico_challenge_checkpoint_marker_${index + 1}.png',
      ));
      index++;
    }
  }

  Marker generateDefaultMarker(ChallengeCourseModel course) {
    return getCustomMarker(
      markerType: "START",
      course: course,
      markerIcon: startMarker,
      onMarkerTab: (marker, iconSize) {
        showPathPointMarkers(course);
      },
    );
  }

  void generateChallengeMarkerList() {
    allCoursesList.value = RxList.empty();
    challengeMarkers.value = RxList.empty();
    for (ChallengeHierarchyModel challenge in hierarchyChallengesList) {
      for (ChallengeCourseModel course in challenge.course) {
        allCoursesList.add(course);

        challengeMarkers.add(generateDefaultMarker(course));
      }
    }
  }

  Future<void> loadChallenges() async {
    challengeList.value = RxList.empty();
    await getChallenges(
      successCallback: (List<ChallengeModel> data) {
        challengeList.addAll(data);
      },
    );
    isFetchingCourseList.value = false;

    generateChallengeMarkerList();
  }

  void showPathPointMarkers(ChallengeCourseModel course) {
    if (challengeSelectedIndex.value != null) {
      challengeMarkers.add(generateDefaultMarker(allCoursesList.firstWhere((element) => element.id == challengeSelectedIndex.value)));
    }

    challengeSelectedIndex.value = course.id!;
    selectedChallengeMarkers.clear();
    challengeMarkers.removeWhere((element) {
      return element.markerId == challengeSelectedIndex.value.toString();
    });

    selectedChallengeMarkers.add(getCustomMarker(markerType: "START", course: course, markerIcon: startMarker));

    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      course.checkpoints!.asMap().forEach((index, checkpoint) {
        selectedChallengeMarkers.add(getCheckpointMarker(checkpoint, checkpointMarkers[index]));
      });
    }

    selectedChallengeMarkers.add(getCustomMarker(markerType: "END", course: course, markerIcon: endMarker));

    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getfitBoundCourseMarker(selectedChallengeMarkers);
      print(markers);
      challengeMapController.moveCamera(
        CameraUpdate.fitBounds(
          LatLngBounds.fromLatLngList(markers),
          padding: 120,
        ),
      );
    } else {
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
  }

  List<LatLng> getfitBoundCourseMarker(markers) {
    double minLat = markers.map((marker) => marker.position.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = markers.map((marker) => marker.position.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = markers.map((marker) => marker.position.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = markers.map((marker) => marker.position.longitude).reduce((a, b) => a > b ? a : b);

    // double aspectRatio = (maxLng - minLng) / (maxLat - minLat);

    List<LatLng> outermostCoords = [];

    outermostCoords = [
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ];

    return outermostCoords;
  }

  void initRepairInfo() {
    // repairDurability.value = 0;
    // remainDurability.value = 0;
    // currentSliderValue.value = 0;
    costTik.value = 0;
  }

  void initRepairButton() {
    if (disableButton.value) {
      Timer(const Duration(seconds: 1), () {
        disableButton.value = false;
      });
    }
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
    initRepairButton();
  }

  void onClickRepairStat(stat, context) async {
    loaderController.isLoading.value = true;
    if(Get.currentRoute.contains('home')){
      if(stat.type == 'STAMINA'){
        Adjust.trackEvent(AdjustEvent('ret2yp'));
      } else {
        Adjust.trackEvent(AdjustEvent('2mxi2f'));
      }
    } else {
      if(stat.type == 'STAMINA'){
        Adjust.trackEvent(AdjustEvent('m7kq1h'));
      } else {
        Adjust.trackEvent(AdjustEvent('spa2cy'));
      }
    }
    await getMyConsumerItemsByType(stat.type == 'STAMINA' ? 'RECOVERY' : 'REPAIR', isNotEmptyCallback: () {
      loaderController.isLoading.value = false;
      selectedType.value = stat.type;
      if (stat.type != 'STAMINA') {
        targetShoeId.value = userState.value.shoes!.id!;
      }
      currentStat.value = stat.type == 'STAMINA' ? userState.value.state!.stamina! : userState.value.shoes!.durability!;
      consumerItemUsagePopup(this, context);
    }, isEmptyCallback: () {
      loaderController.isLoading.value = false;
      shortConsumerItems(stat.type);
    });
  }

  void confirmRecoveryOrRepairStat(stat) async {
    print(stat);
    if (selectedType.value == 'STAMINA') {
      await fetchRecoveryStamina();
    } else {
      await fetchRepairShoes();
    }
    await getUserState();
    // currentStat.value = selectedType.value == 'STAMINA' ? userState.value.state!.stamina! : userState.value.shoes!.durability!;
    // currentStat.value = equippedItems.items.firstWhere((element) => element.itemCategory == 'SHOES').durability;
    // getUserEquippedItems();
    initStat();
  }

  // void handleShowStaminaPopup(stat) async {
  //   await walletMasterController.getFeeTik();
  //   showRepairStatSlider(this, stat, walletMasterController.feeTikStamina.value, walletMasterController.feeTikDurability.value);
  // }

  void handleNotEnoughTaikaPopup() {
    showNotEnoughTaikaAlert();
    initRepairButton();
  }

  // void fetchRechargeStamina(type) async {
  //   disableButton.value = true;
  //
  //   if (walletMasterController.tik.value.amount == null) {
  //     await walletMasterController.getSpendingWalletBalances();
  //   }
  //   if (walletMasterController.tik.value.amount! >= costTik.value) {
  //     if (costTik.value > 0) {
  //       await ActivityService.fetchUserStaminaRecharge(
  //           UserStaminaRechargeModel(
  //             type: type,
  //             stat: currentSliderValue.value.toInt(),
  //             feeTik: costTik.value,
  //           ), successCallback: (userState) {
  //         UserStateModel newUserState = userState;
  //         this.userState.update((state) {
  //           state?.state = newUserState;
  //         });
  //         walletMasterController.getSpendingWalletBalances();
  //         showToastPopup('체력이 충전되었습니다.');
  //         closeRepairPopup();
  //       }, errorCallback: () {
  //         showToastPopup('충전 요청이 실패했습니다.');
  //         initRepairButton();
  //       });
  //     } else {
  //       showToastPopup('충전할 게이지를 확인해주세요.');
  //       initRepairButton();
  //     }
  //   } else {
  //     handleNotEnoughTaikaPopup();
  //   }
  // }

  // void fetchRepairShoes() async {
  //   disableButton.value = true;
  //   if (walletMasterController.tik.value.amount == null) {
  //     await walletMasterController.getSpendingWalletBalances();
  //   }
  //   if (walletMasterController.tik.value.amount! >= costTik.value) {
  //     if (costTik.value > 0) {
  //       await ItemService.fetchRepairItemShoes(
  //           RepairShoesModel(
  //             repairUuid: userState.value.shoes!.id,
  //             durability: currentSliderValue.value.toInt(),
  //             feeTik: costTik.value.toInt(),
  //           ), successCallback: (repairModel) {
  //         InventoryItemModel newRepairModel = repairModel;
  //         userState.update((state) {
  //           state!.shoes!.durability = newRepairModel.durability;
  //         });
  //         walletMasterController.getSpendingWalletBalances();
  //         showToastPopup('내구도 충전이 완료되었습니다.');
  //         closeRepairPopup();
  //       }, errorCallback: () {
  //         showToastPopup('충전 요청이 실패했습니다.');
  //         initRepairButton();
  //       });
  //     } else {
  //       showToastPopup('충전할 게이지를 확인해주세요.');
  //       initRepairButton();
  //     }
  //   } else {
  //     handleNotEnoughTaikaPopup();
  //   }
  // }

  Future<void> getUserState({bool showLoading = false}) async {
    await ActivityService.getCurrentUserState(
      showLoading: showLoading,
      successCallback: (CurrentUserStateModel currentUserState) async {
        currentUserState.exercise?.locationUpdateTime = DateTime.now();
        userState.update((state) {
          state?.state = currentUserState.state;
          state?.exercise = currentUserState.exercise;
          state?.shoes = currentUserState.shoes;
        });
        if (currentUserState.exercise != null) {
          HiveStore.save(key: HiveKey.savedStepCount.name, value: currentUserState.exercise!.steps!);
        }
        if (userState.value.exercise == null) {
          exerciseState.value = ExerciseState.ready;
        } else {
          CurrentUserStateModel? savedUserState = HiveStore.loadCurrentUserState();
          if (savedUserState != null && savedUserState.exercise!.steps! < currentUserState.exercise!.steps!) {
            HiveStore.saveCurrentUserState(
              userState: CurrentUserStateModel(
                state: currentUserState.state,
                exercise: currentUserState.exercise,
                shoes: currentUserState.shoes,
              ),
            );
            savedUserState = CurrentUserStateModel.fromJson(currentUserState.toJson());
          }
          if (savedUserState != null && savedUserState.exercise != null && savedUserState.exercise!.recordState != null && savedUserState.exercise!.recordState! == 'NORMAL') {
            savedUserState.exercise!.locationUpdateTime = DateTime.now();
            userState.update((state) {
              state?.exercise = savedUserState!.exercise;
            });

            int savedSteps = HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
            if (savedUserState.exercise!.steps! > savedSteps) {
              HiveStore.save(key: HiveKey.savedStepCount.name, value: savedUserState.exercise!.steps!);
            }
          }

          if (userState.value.exercise?.challengeCourseId != null) {
            //  산행중인 정보 가져오기
            ChallengeCourseModel challenge = await getChallengeCourse(userState.value.exercise!.challengeCourseId!);
            if (challenge.id != null) {
              selectedCourse.value = challenge;
            }
          }
          if (updateTimer == null) {
            exerciseData.value = List.empty(growable: true);
            exerciseData.add(userState.value.exercise!);
            await syncExerciseData(userState.value);
            coordinates.value = List.empty(growable: true);
            coordinates.addAll(await parseCoordinates(userState.value.exercise!.id));
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
      },
      errorCallback: (int? statusCode) {
        if (statusCode != null && statusCode == 404) {
          onLogout();
        }
      },
    );
  }

  void onLogout() async {
    await UaaService.fetchLogout(
      successCallback: () {
        forceLogout();
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
      if (globalController.internetConnection.value) {
        bool hasSeenFairPlayAlert = HiveStore.load(key: HiveKey.hasSeenFairPlayAlert.name) ?? false;
        if (!hasSeenFairPlayAlert) {
          // 최초 Go 버튼 이벤트
          Adjust.trackEvent(AdjustEvent('v2xlbe'));
          HiveStore.save(key: HiveKey.hasSeenFairPlayAlert.name, value: true);
          await showFairPlayAlert();
        }

        if (userState.value.state!.locked != null && userState.value.state!.locked! == true) {
          showLockedUserAlert();
        } else {
          await getCourseList();
          getActivityRoute();
        }
      } else {
        showToastPopup('원할한 네트워크에서 진행해주세요.');
      }
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
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy();
    bool gotPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission) && LocationAccuracyStatus.precise == accuracyStatus;
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
      if (Get.isDialogOpen == null || Get.isDialogOpen == false) Get.dialog(const ActivitySelect(), barrierDismissible: false, barrierColor: const Color.fromRGBO(0, 0, 0, 0.85));
    }
  }

  void loadExercise(ExerciseType exerciseType, [ChallengeCourseModel? challenge]) {
    loadingTime.value = 1;

    if (loadingTimer != null) {
      loadingTimer = null;
    }

    Get.dialog(
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      ActivityLoading(
        exerciseType: exerciseType,
        challenge: challenge,
      ),
    );

    loadingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (loadingTime.value >= 3) {
          exerciseStartThr.throttle(() => startExercise(exerciseType, challenge));
          timer.cancel();
          loadingTimer = null;
        } else {
          loadingTime.value++;
          activityLoadControl = Control.playFromStart;
        }
      },
    );
  }

  void passThrowActivityLoading(ExerciseType exerciseType, [ChallengeCourseModel? challenge]) {
    loadingTimer?.cancel();
    loadingTimer = null;
    Get.back();
    exerciseStartThr.throttle(() => startExercise(exerciseType, challenge));
  }

  Future<void> selectExerciseType(ExerciseType exerciseType) async {
    if (exerciseType == ExerciseType.walking) {
      if(selectedCourse.value != null && selectedCourse.value!.challengeId == null) {
        selectedCourse.value = null;
        selectedChallenge.value = null;
      }


      bool adjustFirstWalkingEvent = HiveStore.load(key: HiveKey.adjustFirstWalkingEvent.name) ?? false;
      if (!adjustFirstWalkingEvent) {
        Adjust.trackEvent(AdjustEvent('v2xlbe'));
        HiveStore.save(key: HiveKey.adjustFirstWalkingEvent.name, value: true);
      }
    }

    selectedExerciseType.value = exerciseType;

    // AdWatchAvailableModel adWatchAvailableModel = AdWatchAvailableModel(watchAvailable: false);
    //
    // await AdmobService.getAdWatchAvailableTime(
    //   'EXERCISE_START',
    //   callback: (AdWatchAvailableModel model) {
    //     adWatchAvailableModel = model;
    //     isButtonDisabled.value = false;
    //   },
    // );

    // if (adWatchAvailableModel.watchAvailable!) {
    //   Get.back();
    //   Get.dialog(const AdSelect(), barrierDismissible: false, barrierColor: const Color.fromRGBO(0, 0, 0, 0.85));
    //   if (startAd.value == null) {
    //     adLoadTimerStart();
    //     exerciseStartRewardedAdInit(
    //       'exerciseStartAd',
    //     );
    //   }
    // } else {
    //   handleMoveExerciseActive(exerciseType);
    // }

    handleMoveExerciseActive(exerciseType);
  }

  // void showAdAndMoveActivity() {
  //   showExerciseStartAd(this, selectedAd.value);
  // }

  void showAdTip() {
    showAdTipAlert(selectedCourse.value?.id, selectedExerciseType.value);
  }

  void handleMoveExerciseActive(ExerciseType exerciseType) {
    Get.offNamed(Routes.activityActive);
    loadExercise(
      selectedExerciseType.value,
      selectedCourse.value,
    );
  }

  void moveToCourseSelection({required ChallengeCourseModel course, required ChallengeModel challenge}) async {
    // 코스형 챌린지 이벤트
    Adjust.trackEvent(AdjustEvent('tx7196'));

    selectedCourse.value = ChallengeCourseModel.fromJson(course.toJson());
    selectedChallenge.value = ChallengeModel.fromJson(challenge.toJson());


    Get.toNamed(Routes.activityChallenges);
  }

  void moveToChallengeMap(int challengeId) async {
    await getChallengesHierarchy(currentLocation.value, challengeId);
    bool systemReady = await checkAvailabilities();
    if (systemReady) {
      challengeSelectedIndex.value = null;
      selectedChallengeMarkers.value = RxList.empty();
      generateChallengeMarkerList();
      Get.toNamed(Routes.challengeMap);
    } else {
      await requestPermissionStepByStep();
    }
  }

  void initLocationStream() async {
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

    locationSubscription ??= Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position, ) async {
      currentLocation.value = position;
      gpsAccuracySensitive.value = position.accuracy;
      isFakeGps.value = position.isMocked;
      print('position : $position');
      print('position.accuracy : ${position.accuracy}');

      detectFakeGps();

      if (HiveStore.load(key: HiveKey.isDebuggingMode.name) && exerciseState.value == ExerciseState.ongoing) {
        List positionRawData = HiveStore.load(key: HiveKey.positionRawDataLogs.name) ?? [];

        var logForm = {
          'positionRawDataInfo': '===================================='
              '\nAltitude: ${position.altitude}'
              '\nSpeed: ${convertMStoKMH(position.speed)}'
              '\nSteps: ${exerciseSteps.value}'
              '\nAccuracy: ${position.accuracy}'
              '\nLatitude: ${position.latitude}'
              '\nLongitude: ${position.longitude}'
              '\nLocationUpdateTime: ${DateTime.now()}'
        };
        positionRawData.add(logForm);
        HiveStore.savePositionRawData(value: positionRawData);
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
          //TODO. need to edit filter test
          filterCoordinates(coordinates.last, LatLng(position.latitude, position.longitude), userState.value.exercise!.id!);
          exerciseDistance.value = exerciseDistance.value +
              Geolocator.distanceBetween(coordinates[coordinates.length - 2].latitude, coordinates[coordinates.length - 2].longitude, coordinates.last.latitude, coordinates.last.longitude);
        }
      } else {
        // 첼린지 존 찾기(30초마다 요청)
        DateTime now = DateTime.now();


        if (receiveLocationTime.value.add(const Duration(seconds: 30)).compareTo(now) < 0 ) {
          await findCourses();
          receiveLocationTime.value = now;
        }
      }

      locationThr.throttle(() {
        detectChallengeZone(position);
      });
    }, onError: (e) {
      print(e.toString());
    });
  }

  void detectFakeGps() async {
    //안드로이드만 탐지 가능
    if (isFakeGps.value && Get.isBottomSheetOpen != true && !isTestingFakeGps()) {
      showFakeGpsAlert();
      MemberService.reportAbuse(description: 'Fake GPS 사용 감지', abusingType: 'GPS');
    }
  }

  void initGpsServiceStream() {
    _serviceStatusStream ??= Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        showGpsAlert();
      }
    });
  }

  Future<void> getCurrentLocation() async {
    print('getCurrentLocation');
    await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracyQuality, timeLimit: const Duration(seconds: 5)).then((location) {
      currentLocation.value = location;
      print('location.acc : ${location.accuracy}');
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
    await findCourses();
    detectChallengeZone(currentLocation.value);
  }

  // 챌린지 찾기
  Future<void> findCourses() async {
    if (currentLocation.value.latitude != 0 && currentLocation.value.longitude != 0) {
      await getNearByCourses(currentLocation.value, exerciseState.value);
    } else {
      await getCourseList();
    }
  }

  void requestJoinChallenge(Function callback) async {
    if (await handleCheckUserVerified()) {
      callback();
    } else {
      showChallengeNeedVerificationAlert();
    }
  }

  void checkConnectivityStatus() async {
    print('인터넷 연결됐는지 확인중');
    if (globalController.internetConnection.value) {
      await retrySavedRequests(source: 'connectivityListener');
    }
  }

  Future<void> checkGPSStatus() async {
    // GpsService.getGpsAccuracy();
  }

  Future<void> retrySavedRequests({required String source}) async {
    if (HiveStore.load(key: HiveKey.endExerciseRequested.name) != null && HiveStore.load(key: HiveKey.endExerciseRequested.name) && userState.value.exercise != null) {
      await endExercise(source: source);
    }
  }



  // void closeAdSelectPopup() {
  //   adLoadTimerStop();
  //   selectedCourse.value = null;
  //   Get.back();
  //   Timer(const Duration(seconds: 1), () {
  //     startAd.value = null;
  //     endAd.value = null;
  //   });
  // }

  void moveToChallengeDetail(ChallengeModel challenge, bool hideLinkToCourses) {
    // 100대명산 챌린지 이벤트
    Adjust.trackEvent(AdjustEvent('r9akvp'));

    Get.toNamed(Routes.challengeCourseDetail, arguments: {'id': challenge.id, 'hideCourses': hideLinkToCourses}, preventDuplicates: false);
  }

  void moveToWebView(PromotionAdModel item) async {
    // 메인팝업 클릭 이벤트
    Adjust.trackEvent(AdjustEvent('4znz3j'));
    bool bannerAdClick = HiveStore.load(key: HiveKey.bannerAdClick.name) ?? false;
    if(!bannerAdClick){
      Adjust.trackEvent(AdjustEvent('ytqi48'));
      HiveStore.save(key: HiveKey.bannerAdClick.name, value: true);
    }



    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    switch (item.openType) {
      case 'IN_APP':
        if (!Get.currentRoute.contains('home')) {
          Get.until((route) => Get.currentRoute == Routes.home);
        }
        switch (item.linkUrl) {
          case 'CHALLENGES':
            Get.find<HomeMenuController>().selectMenu(0);
            Get.toNamed(Routes.challengeDetail.replaceAll(':id', item.referenceId.toString()));
            break;
          case 'ARCHIVE':
            Get.find<HomeMenuController>().selectMenu(4);
            if (Get.isRegistered<LeaderboardController>()) {
              Get.find<LeaderboardController>().tabController.animateTo(1);
            } else {
              LeaderboardController leaderboardController = Get.put(LeaderboardController());
              leaderboardController.tabController.animateTo(1);
            }

            break;
          case 'ITEM':
            Get.find<HomeMenuController>().selectMenu(1);
            break;
          case 'SHOP':
            Get.find<HomeMenuController>().selectMenu(3);
            break;
          case 'RANKING':
            Get.find<HomeMenuController>().selectMenu(4);
            if (Get.isRegistered<LeaderboardController>()) {
              Get.find<LeaderboardController>().tabController.animateTo(0);
            } else {
              LeaderboardController leaderboardController = Get.put(LeaderboardController());
              leaderboardController.tabController.animateTo(0);
            }
            break;

          case 'WALLET':
            Get.toNamed(Routes.wallet);
            break;
          case 'NOTICE':
          // Get.toNamed(Routes.noticeList);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/c5103042de5d4e3a9a61c1101508ffed'});
            break;
          case 'FAQ':
          // Get.toNamed(Routes.preferenceBoard);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://eztechfin.notion.site/FAQ-2f6b0ec4d6134fd398cd7a832bfa6cd3'});
            break;
        }
        break;
      case 'INTERNAL_WEB_VIEW':
      // Get.toNamed(Routes.webView, arguments: {'id': item.id, 'linkUrl': item.linkUrl});
        showModalWebview(this, Get.context, title: item.label!, linkUrl: item.linkUrl!);
        break;
      case 'EXTERNAL_BROWSER':
        Uri url = Uri.parse(item.linkUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }


  @override
  void onDetached() {
    updateTimer?.cancel();
    updateTimer = null;
    exerciseTimer?.cancel();
    exerciseTimer = null;
    stepSubscription?.cancel();
    stepSubscription = null;
    locationSubscription?.cancel();
    locationSubscription = null;
    pedestrianStatusSubscription?.cancel();
    pedestrianStatusSubscription = null;
    _serviceStatusStream?.cancel();
    _serviceStatusStream = null;
    // adTimer?.cancel();
    // adTimer = null;
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
  }

  @override
  void onInactive() {
    print('onInactive');
    // adLoadTimerStop();
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
  }

  @override
  void onPaused() {
    print('onPaused');
    // adLoadTimerStop();
    initLuckAnimation();
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
  }

  @override
  void onResumed() {
    print('onResumed activity');

    if (Get.currentRoute != Routes.login && Get.currentRoute != Routes.loading) {
      getUserState(showLoading: true);
    }
    // TODO: implement onResumed
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
