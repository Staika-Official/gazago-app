import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/leaderboard_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
import 'package:gaza_go/platform/helpers/consumer_item_mixin.dart';

import 'package:gaza_go/platform/helpers/location_helper.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/map_mixin.dart';
import 'package:gaza_go/platform/helpers/promotion_mixin.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/handlers/location_callback_handler.dart';
import 'package:gaza_go/platform/models/challenge_course_model.dart';
import 'package:gaza_go/platform/models/challenge_hierarchy_model.dart';
import 'package:gaza_go/platform/models/challenge_model.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/promotion_ad_model.dart';
import 'package:gaza_go/platform/models/request/pick_up_treasure_request_model.dart';
import 'package:gaza_go/platform/models/stat_model.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/platform/models/treasure_nearby_request_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:gaza_go/platform/services/treasure_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/views/activity/activity_loading.dart';
import 'package:gaza_go/presentations/views/activity/activity_select.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/pick_up_treasure_bottom_sheet.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/pick_up_treasure_result_overlay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:get/get.dart' hide Trans;
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:throttling/throttling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivityController extends SuperController
    with
        ActivityMixin,
        MapMixin,
        ChallengeMixin,
        GetTickerProviderStateMixin,
        ConsumerItemMixin,
        PromotionMixin {
  Control activityLoadControl = Control.play;
  RxDouble betweenDistance = RxDouble(0.0);
  RxInt calcDelay = RxInt(300);
  Rx<DateTime> calcNearCourseTime = Rx(DateTime.now());
  late AnimationController challengeGuideController;
  RxList<ChallengeModel> challengeList = RxList.empty();
  final Rx<Control> challengeLoadControl = Rx(Control.play);
  RxnInt challengeSelectedIndex = RxnInt(null);
  List<Marker> checkpointMarkers = List.empty(growable: true);

  // GPS Services - removed unused services

  // final RxDouble currentSliderValue = RxDouble(0);
  // final RxInt remainDurability = RxInt(0);
  // final RxInt repairDurability = RxInt(0);
  final RxInt costTik = RxInt(0);

  RxInt detectDelay = RxInt(30);
  RxBool disableActivityButton = RxBool(true);
  RxBool disableButton = RxBool(false);
  BitmapDescriptor? endMarker;
  final Throttling exerciseEndThr =
      Throttling(duration: const Duration(milliseconds: 500));

  final Throttling exerciseStartThr =
      Throttling(duration: const Duration(milliseconds: 500));

  final Throttling exerciseUpdateThr =
      Throttling(duration: const Duration(milliseconds: 500));

  GoogleMapController? googleMapController;
  RxDouble gpsAccuracySensitive = RxDouble(15.0);
  Timer? gpsAccuracyTimer;
  List gpsNoticeList = [
    'disable_power_saving_mode'.tr(),
    'move_to_open_area'.tr(),
    'restart_phone_for_gps'.tr()
  ];

  final RxBool hasPermission = RxBool(false);
  final RxBool isButtonDisabled = RxBool(false);
  RxBool isClickedBtn = RxBool(false);
  RxBool isFetchingCourseList = RxBool(true);
  final RxBool isListeningToLocation = RxBool(false);

  // if lock, user is centered map, can't zoom and drag
  // if unlock, user can zoom and drag, user not necessarily centered
  var isLockMap = false.obs;

  RxBool isNewCollection = RxBool(false);
  RxBool isShowGpsAccuracyAlert = RxBool(false);
  RxnInt isShowGpsAccuracyCount = RxnInt(0);
  DateTime? lastNearbyTreasureCheck;
  DateTime? lastPositionTime;

  // ActivityController activityController = Get.isRegistered<ActivityController>() ? Get.find<ActivityController>() : Get.put(ActivityController());
  LoaderController loaderController = Get.isRegistered<LoaderController>()
      ? Get.find<LoaderController>()
      : Get.put(LoaderController());

  final Throttling locationThr =
      Throttling(duration: const Duration(milliseconds: 500));

  RxList nearChallengeAllLocation = RxList.empty();
  Rxn<ChallengeCourseModel> nearChallengeLocation = Rxn(null);
  final int nearbyTreasureCheckIntervalSeconds = 5; // Check every 5 seconds
  // Nearby treasure check variables
  Timer? nearbyTreasureTimer;

  Rx<DateTime> receiveLocationTime = Rx(DateTime.now());
  final Rx<ExerciseType> selectedExerciseType = Rx(ExerciseType.walking);
  BitmapDescriptor? startMarker;
  final Throttling thr =
      Throttling(duration: const Duration(milliseconds: 500));

  final WalletMasterController walletMasterController = Get.find();
  GlobalKey webViewKey = GlobalKey();

  bool _isRequestingChallenges = false;
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus =
      Rx(LocationAccuracyStatus.unknown);

  final Rx<LocationPermission> _locationPermission =
      Rx(LocationPermission.unableToDetermine);

  StreamSubscription<ServiceStatus>? _serviceStatusStream;

  // Added from features: cooldown timer when pick up treasure (for anti-spam)
  var coolDownTimeLeft = 0.obs; // seconds remaining
  Timer? _pickupCoolDownTimer; // cooldown timer handle

  @override
  void initLocationStream() async {
    print(
        'Initializing enhanced GPS location stream with UnifiedGPSManager...');

    // Clear GPS history when starting new location stream
    UnifiedGPSManager.instance.clearHistory();

    try {
      // Determine activity type from selected exercise type
      String activityType = 'walking'; // default
      switch (selectedExerciseType.value) {
        case ExerciseType.walking:
          activityType = 'walking';
          break;
        case ExerciseType.hiking:
          activityType = 'hiking'; // Use hiking config
          break;
        case ExerciseType.famous:
          activityType = 'walking'; // Use walking config for famous mountain
          break;
        default:
          activityType = 'walking';
      }

      print('Starting enhanced GPS tracking for activity: $activityType');

      // Set activity-specific configuration for maximum accuracy
      await UnifiedGPSManager.instance.setActivityType(activityType);

      // Force maximum accuracy mode
      UnifiedGPSManager.instance.gpsMode.value = 'high_accuracy';

      // Start GPS tracking using UnifiedGPSManager
      final success = await UnifiedGPSManager.instance
          .startTracking(activityType: activityType);

      if (!success) {
        print(
            'Failed to start enhanced GPS tracking, falling back to manual stream');
        _startFallbackLocationStream();
        return;
      }

      print('Enhanced GPS tracking started successfully');

      // Subscribe to UnifiedGPSManager location stream
      locationSubscription = UnifiedGPSManager.instance.locationStream.listen(
          (LocationModel locationModel) async {
        print('Received enhanced GPS location: ${locationModel.toString()}');

        // Location is already filtered by UnifiedGPSManager with enhanced algorithm
        // Process the location directly
        await _processStravaLikeLocation(locationModel);
      }, onError: (error) {
        print('Enhanced GPS stream error: $error');
        _handleGPSError(error);
      });
    } catch (e) {
      print('Failed to initialize enhanced GPS tracking: $e');
      _startFallbackLocationStream();
    }
  }

  @override
  void initRepairInfo() {
    // repairDurability.value = 0;
    // remainDurability.value = 0;
    // currentSliderValue.value = 0;
    costTik.value = 0;
  }

  @override
  void onClose() {
    gpsAccuracyTimer?.cancel();
    gpsAccuracyTimer = null;
    nearbyTreasureTimer?.cancel();
    nearbyTreasureTimer = null;
    super.onClose();
  }

  @override
  void onDetached() {
    // Stop enhanced GPS tracking
    if (UnifiedGPSManager.instance.isActive.value) {
      UnifiedGPSManager.instance.stopTracking();
    }

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

    print(
        'ActivityController cleanup completed - Enhanced GPS tracking stopped');
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // adLoadTimerStop();
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
  }

  @override
  void onPaused() {
    // adLoadTimerStop();
    initLuckAnimation();
    HiveStore.save(key: HiveKey.savedStepInitialized.name, value: false);
  }

  @override
  void onResumed() {
    print('onResumed activity');
    checkNewCollectionStatus();

    if (Get.currentRoute != Routes.login &&
        Get.currentRoute != Routes.loading) {
      getUserState(showLoading: true);
    }

    // Listen to network changes to handle polyline gap effect
    _initNetworkStatusListener();
  }

  /// Initialize network status listener for polyline gap management
  void _initNetworkStatusListener() {
    // Listen to internet connection changes
    ever(globalController.internetConnection, (bool isConnected) {
      _handleNetworkStatusForPolyline(isConnected);
    });
  }

  /// Handle network status changes for polyline rendering
  void _handleNetworkStatusForPolyline(bool isConnected) {
    if (exerciseState.value == ExerciseState.ongoing) {
      if (isConnected) {
        print(
            '🌐 Network reconnected during exercise - polyline will resume from current position (creating gap effect)');
        // Don't need to do anything special - coordinates will start being added again
      } else {
        print(
            '🚫 Network disconnected during exercise - polyline updates paused (GPS continues tracking)');
        // Coordinates will stop being added, creating the gap effect
      }
    }
  }

  RxList<StatModel> get statList {
    return RxList([
      StatModel(
          name: 'stamina'.tr(),
          currentStat: userState.value.state != null
              ? userState.value.state!.stamina!
              : 0,
          type: 'STAMINA'),
      StatModel(
          name: 'durability'.tr(),
          currentStat: userState.value.shoes != null
              ? userState.value.shoes!.durability!
              : 0,
          type: 'DURABILITY'),
    ]);
  }

  void checkNewCollectionStatus() {
    if (HiveStore.load(key: HiveKey.isNewCollection.name) != null &&
        HiveStore.load(key: HiveKey.isNewCollection.name) == true) {
      isNewCollection.value = true;
    } else {
      isNewCollection.value = false;
    }
  }

  Future<void> initializeExercise() async {
    challengeGuideController = AnimationController(vsync: this);
    checkConnectivityStatus();

    if ([ExerciseState.ongoing, ExerciseState.paused]
            .any((state) => state == exerciseState.value) &&
        !isFakeGps.value &&
        !isTestingFakeGps()) {
      showPendingExerciseAlert(this);
    }
    disableActivityButton.value = false;
  }

  Future<void> initializeController() async {
    // Initialize GPS services
    _initializeGPSServices();

    await getUserState().then((_) async {
      hasPermission.value = await checkAvailabilities();
      if (hasPermission.value) {
        await initActivityStatus();
      }

      gpsAccuracyTimer =
          Timer.periodic(const Duration(minutes: 10), (timer) async {
        if (gpsAccuracySensitive.value > 30 &&
            exerciseState.value == ExerciseState.ongoing) {
          showLocalNotificationLowGps();
        }
      });

      gpsAccuracySensitive.stream.listen((event) {
        if (exerciseState.value == ExerciseState.ongoing) {
          if (event > 30 && isShowGpsAccuracyCount.value! < 1) {
            showNotGpsSensorAlert(this);
            showLocalNotificationLowGps();
            isShowGpsAccuracyCount.value = 1;
            isShowGpsAccuracyAlert.value = true;
          } else if (event < 30 && isShowGpsAccuracyAlert.value) {
            isShowGpsAccuracyAlert.value = false;
            Get.back();
          }
        }
      });
    });

    // await initPlatformState();
  }

  void showLocalNotificationLowGps() {
    showLocalNotification(
        notificationType: NotificationType.gpsLow,
        title: 'gps_signal_weak'.tr(),
        message: 'exercise_record_failed'.tr());
  }

  Future<void> refreshController() async {
    getUserState(showLoading: true);
    checkNewCollectionStatus();
  }

  Future<void> initActivityStatus() async {
    print('11111111111111');
    await initializeActivity();
    await loadMakerImages();

    // await getPromotionAdsList();
  }

  Future<void> loadMakerImages() async {
    startMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(), // 필요시 크기 조절
      'assets/images/activity/ico_challenge_start_marker.png',
    );

    endMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(), // 필요시 크기 조절
      'assets/images/activity/ico_challenge_end_marker.png',
    );

    int index = 0;
    while (index < 10) {
      BitmapDescriptor checkpointMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(), // 필요시 크기 조절
        'assets/images/activity/ico_challenge_checkpoint_marker_${index + 1}.png',
      );
      checkpointMarkers.add(Marker(
        markerId: MarkerId('checkpointMarker_$index'),
        position: const LatLng(0, 0),
        icon: checkpointMarkerIcon,
      ));
      index++;
    }
  }

  Marker generateDefaultMarker(ChallengeCourseModel course) {
    return getCustomMarker(
      id: course.id.toString(),
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
      challengeMarkers.add(generateDefaultMarker(allCoursesList.firstWhere(
          (element) => element.id == challengeSelectedIndex.value)));
    }

    challengeSelectedIndex.value = course.id!;
    selectedChallengeMarkers.clear();
    challengeMarkers.removeWhere((element) {
      return element.markerId == challengeSelectedIndex.value.toString();
    });

    selectedChallengeMarkers.add(getCustomMarker(
        id: course.id.toString(),
        markerType: "START",
        course: course,
        markerIcon: startMarker));

    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      course.checkpoints!.asMap().forEach((index, checkpoint) {
        selectedChallengeMarkers.add(
            getCheckpointMarker(checkpoint, checkpointMarkers[index].icon));
      });
    }

    selectedChallengeMarkers.add(getCustomMarker(
        id: course.id.toString(),
        markerType: "END",
        course: course,
        markerIcon: endMarker));
    clearOverlays();
    addOverlayAll(
      {...selectedChallengeMarkers},
    );
    if (course.checkpoints != null && course.checkpoints!.isNotEmpty) {
      List<LatLng> markers = getfitBoundCourseMarker(selectedChallengeMarkers);
      challengeMapControllers.last.animateCamera(
        CameraUpdate.newLatLngBounds(_createBoundsFromLatLngList(markers), 120),
      );
    } else {
      print(course.startLat!);
      print(course.startLon!);
      print(course.endLat!);
      print(course.endLon!);
      challengeMapControllers.last.animateCamera(
        CameraUpdate.newLatLngBounds(
            _createBoundsFromLatLngList(
              [
                LatLng(course.startLat!, course.startLon!),
                LatLng(course.endLat!, course.endLon!),
              ],
            ),
            100),
      );
    }
  }

  List<LatLng> getfitBoundCourseMarker(markers) {
    double minLat = markers
        .map((marker) => marker.position.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = markers
        .map((marker) => marker.position.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = markers
        .map((marker) => marker.position.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = markers
        .map((marker) => marker.position.longitude)
        .reduce((a, b) => a > b ? a : b);

    // double aspectRatio = (maxLng - minLng) / (maxLat - minLat);

    List<LatLng> outermostCoords = [];

    outermostCoords = [
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    ];

    return outermostCoords;
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
    if (Get.currentRoute.contains('home')) {
      if (stat.type == 'STAMINA') {
        Adjust.trackEvent(AdjustEvent('ret2yp'));
      } else {
        Adjust.trackEvent(AdjustEvent('2mxi2f'));
      }
    } else {
      if (stat.type == 'STAMINA') {
        Adjust.trackEvent(AdjustEvent('m7kq1h'));
      } else {
        Adjust.trackEvent(AdjustEvent('spa2cy'));
      }
    }
    await getMyConsumerItemsByType(
        stat.type == 'STAMINA' ? 'RECOVERY' : 'REPAIR', isNotEmptyCallback: () {
      loaderController.isLoading.value = false;
      selectedType.value = stat.type;
      if (stat.type != 'STAMINA') {
        targetShoeId.value = userState.value.shoes!.id!;
      }
      currentStat.value = stat.type == 'STAMINA'
          ? userState.value.state!.stamina!
          : userState.value.shoes!.durability!;
      consumerItemUsagePopup(this, context);
    }, isEmptyCallback: () {
      loaderController.isLoading.value = false;
      shortConsumerItems(stat.type);
    });
  }

  int getRemainingDays(String expiryDate) {
    DateTime expiryUTCDateTime = DateTime.parse(expiryDate).toUtc();
    DateTime now = DateTime.now().toUtc();

    return expiryUTCDateTime.difference(now).inDays;
  }

  void confirmRecoveryOrRepairStat(stat) async {
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
  //         showToastPopup('stamina_recharged'.tr());
  //         closeRepairPopup();
  //       }, errorCallback: () {
  //         showToastPopup('recharge_failed'.tr());
  //         initRepairButton();
  //       });
  //     } else {
  //       showToastPopup('check_gauge'.tr());
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
  //         showToastPopup('durability_recharge_complete'.tr());
  //         closeRepairPopup();
  //       }, errorCallback: () {
  //         showToastPopup('recharge_failed'.tr());
  //         initRepairButton();
  //       });
  //     } else {
  //       showToastPopup('check_gauge'.tr());
  //       initRepairButton();
  //     }
  //   } else {
  //     handleNotEnoughTaikaPopup();
  //   }
  // }

  Future<void> getUserState({bool showLoading = false}) async {
    print('getUserStategetUserStategetUserStategetUserStategetUserState');
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
          HiveStore.save(
              key: HiveKey.savedStepCount.name,
              value: currentUserState.exercise!.steps!);
        }
        if (userState.value.exercise == null) {
          exerciseState.value = ExerciseState.ready;
        } else {
          CurrentUserStateModel? savedUserState =
              HiveStore.loadCurrentUserState();
          if (savedUserState != null &&
              savedUserState.exercise!.steps! <
                  currentUserState.exercise!.steps!) {
            HiveStore.saveCurrentUserState(
              userState: CurrentUserStateModel(
                state: currentUserState.state,
                exercise: currentUserState.exercise,
                shoes: currentUserState.shoes,
              ),
            );
            savedUserState =
                CurrentUserStateModel.fromJson(currentUserState.toJson());
          }
          if (savedUserState != null &&
              savedUserState.exercise != null &&
              savedUserState.exercise!.recordState != null &&
              savedUserState.exercise!.recordState! == 'NORMAL') {
            savedUserState.exercise!.locationUpdateTime = DateTime.now();
            userState.update((state) {
              state?.exercise = savedUserState!.exercise;
            });

            int savedSteps =
                HiveStore.load(key: HiveKey.savedStepCount.name) ?? 0;
            if (savedUserState.exercise!.steps! > savedSteps) {
              HiveStore.save(
                  key: HiveKey.savedStepCount.name,
                  value: savedUserState.exercise!.steps!);
            }
          }

          if (userState.value.exercise?.challengeCourseId != null) {
            //  산행중인 정보 가져오기
            ChallengeCourseModel challenge = await getChallengeCourse(
                userState.value.exercise!.challengeCourseId!);
            if (challenge.id != null) {
              selectedCourse.value = challenge;
            }
          }
          if (updateTimer == null) {
            exerciseData.value = List.empty(growable: true);
            exerciseData.add(userState.value.exercise!);
            await syncExerciseData(userState.value);
            coordinates.value = List.empty(growable: true);
            coordinates
                .addAll(await parseCoordinates(userState.value.exercise!.id));
          }

          final state = userState.value.exercise!.state!;

          if (state == 'ONGOING' && updateTimer != null) {
            exerciseState.value = ExerciseState.ongoing;
          } else if (state == 'PAUSED' || updateTimer == null) {
            exerciseState.value = ExerciseState.paused;
          }
        }

        await retrySavedRequests(source: 'getUserState');

        if (Get.isRegistered<LoadingController>())
          Get.find<LoadingController>()
              .updateProgress('coming_soon_gazago'.tr());
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
    isClickedBtn.value = true;
    bool systemReady = await checkAvailabilities();
    if (systemReady) {
      if (!isListeningToLocation.value) {
        initializeActivity();
      }
      if (globalController.internetConnection.value) {
        bool hasSeenFairPlayAlert =
            HiveStore.load(key: HiveKey.hasSeenFairPlayAlert.name) ?? false;
        if (!hasSeenFairPlayAlert) {
          // 최초 Go 버튼 이벤트
          Adjust.trackEvent(AdjustEvent('v2xlbe'));
          HiveStore.save(key: HiveKey.hasSeenFairPlayAlert.name, value: true);
          await showFairPlayAlert();
        }

        if (userState.value.state!.locked != null &&
            userState.value.state!.locked! == true) {
          showLockedUserAlert();
        } else {
          await getCourseList();
          getActivityRoute();
        }
      } else {
        showToastPopup('use_stable_network'.tr());
      }
    } else {
      await requestPermissionStepByStep();
    }
    isClickedBtn.value = false;
  }

  Future<bool> checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    bool hasActivityPermission = await checkActivityPermission();
    bool hasLocationPermissionWithAccuracy =
        await checkLocationPermissionAndAccuracy();

    return isGpsAvailable &&
        hasActivityPermission &&
        hasLocationPermissionWithAccuracy;
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

    bool hasLocationPermissionWithAccuracy =
        await checkLocationPermissionAndAccuracy();
    if (!hasLocationPermissionWithAccuracy) {
      await showRequestLocationAlert();
    }

    return isGpsAvailable &&
        hasActivityPermission &&
        hasLocationPermissionWithAccuracy;
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

    return [LocationPermission.always, LocationPermission.whileInUse]
        .any((permission) => permission == locationPermission);
  }

  Future<bool> checkLocationAccuracy() async {
    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();
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
      hasActivityPermission = ph.PermissionStatus.granted ==
          await ph.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission =
          ph.PermissionStatus.granted == await ph.Permission.sensors.status;
    }

    return hasActivityPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = ph.PermissionStatus.granted ==
          await ph.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      permissionGranted =
          ph.PermissionStatus.granted == await ph.Permission.sensors.request();
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
    LocationPermission locationPermission =
        await Geolocator.requestPermission();
    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();
    bool gotPermission = [
          LocationPermission.always,
          LocationPermission.whileInUse
        ].any((permission) => permission == locationPermission) &&
        LocationAccuracyStatus.precise == accuracyStatus;
    if (!gotPermission) {
      Geolocator.openAppSettings();
    }

    locationPermissionCompleter.complete(gotPermission);

    return locationPermissionCompleter.future;
  }

  void getActivityRoute() {
    if ([ExerciseState.ongoing, ExerciseState.paused]
        .any((state) => state == exerciseState.value)) {
      Get.toNamed(Routes.activityActive);
    } else {
      if (Get.isDialogOpen == null || Get.isDialogOpen == false) {
        print('exercise_selection'.tr());
        Get.dialog(const ActivitySelect(),
            barrierDismissible: false,
            barrierColor: const Color.fromRGBO(0, 0, 0, 0.85));
      }
    }
  }

  void loadExercise(ExerciseType exerciseType,
      [ChallengeCourseModel? challenge]) {
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
          exerciseStartThr
              .throttle(() => startExercise(exerciseType, challenge));
          timer.cancel();
          loadingTimer = null;
        } else {
          loadingTime.value++;
          activityLoadControl = Control.playFromStart;
        }
      },
    );
  }

  void passThrowActivityLoading(ExerciseType exerciseType,
      [ChallengeCourseModel? challenge]) {
    loadingTimer?.cancel();
    loadingTimer = null;
    Get.back();
    exerciseStartThr.throttle(() => startExercise(exerciseType, challenge));
  }

  Future<void> selectExerciseType(ExerciseType exerciseType) async {
    if (exerciseType == ExerciseType.walking) {
      if (selectedCourse.value != null &&
          selectedCourse.value!.challengeId == null) {
        selectedCourse.value = null;
        selectedChallenge.value = null;
      }

      bool adjustFirstWalkingEvent =
          HiveStore.load(key: HiveKey.adjustFirstWalkingEvent.name) ?? false;
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

  void moveToCourseSelection(
      {required ChallengeCourseModel course,
      required ChallengeModel challenge}) async {
    // 코스형 챌린지 이벤트
    Adjust.trackEvent(AdjustEvent('tx7196'));

    selectedCourse.value = ChallengeCourseModel.fromJson(course.toJson());
    selectedChallenge.value = ChallengeModel.fromJson(challenge.toJson());

    Get.toNamed(Routes.activityChallenges);
  }

  void moveToChallengeMap(int challengeId) async {
    await getChallengesHierarchy(
        currentLocation.value ??
            LocationModel(
                latitude: 0,
                longitude: 0,
                timestamp: DateTime.now(),
                accuracy: 1000,
                altitude: 0,
                speed: 0),
        challengeId);
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

  /// Process location update (handles coordinate tracking, distance calculation, etc.)
  Future<void> processLocationUpdate(LocationModel locationModel) async {
    print(
        '🎯 processLocationUpdate called! accuracy: ${locationModel.accuracy}m, coordinates count: ${coordinates.length}');
    try {
      // Only add coordinates for path tracking when exercise is ongoing AND network is available
      // This creates the desired "broken line" effect during network outages
      if (exerciseState.value == ExerciseState.ongoing) {
        if (globalController.internetConnection.value) {
          coordinates
              .add(LatLng(locationModel.latitude, locationModel.longitude));
          print(
              '📍 Added coordinate: ${locationModel.latitude}, ${locationModel.longitude} (network available)');
        } else {
          print(
              '🌐 Network unavailable - skipping coordinate addition (GPS still tracking user position)');
        }
      } else {
        print('⏸️ Exercise is paused, skipping coordinate addition');
      }

      if (coordinates.isNotEmpty && coordinates.length > 1) {
        // Enhanced filterCoordinates with time validation
        DateTime currentTime = DateTime.now();
        filterCoordinates(
            coordinates[coordinates.length - 2], // Previous position
            LatLng(locationModel.latitude, locationModel.longitude),
            userState.value.exercise!.id!,
            lastTime: lastPositionTime,
            currentTime: currentTime);

        // Update last position time for next iteration
        lastPositionTime = currentTime;

        // Only calculate distance when exercise is ongoing
        if (exerciseState.value == ExerciseState.ongoing) {
          exerciseDistance.value = exerciseDistance.value +
              Geolocator.distanceBetween(
                  coordinates[coordinates.length - 2].latitude,
                  coordinates[coordinates.length - 2].longitude,
                  coordinates.last.latitude,
                  coordinates.last.longitude);
        }
      }

      // Legacy polyline rendering removed - now handled by segmented polyline in ActivityActiveMiniMapSection
      // This prevents conflicting red polyline overlaying the blue segmented polylines
      // if (coordinates.length >= 10) {
      //   addOverlay(Polyline(
      //     polylineId: const PolylineId('path'),
      //     width: 3,
      //     color: Colors.red,
      //     points: coordinates,
      //   ));
      // }

      // Convert LocationModel to Position for treasure comparison
      Position positionForTreasure = Position(
        latitude: locationModel.latitude,
        longitude: locationModel.longitude,
        timestamp: locationModel.timestamp,
        accuracy: locationModel.accuracy,
        altitude: locationModel.altitude,
        heading: 0.0,
        speed: locationModel.speed,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      await compareDistanceWithNearestTreasure(positionForTreasure);

      // Challenge zone detection logic
      if (_isRequestingChallenges) return; // Prevent concurrent requests
      _isRequestingChallenges = true;

      try {
        DateTime now = DateTime.now();

        print('Get.currentRoute : ${Get.currentRoute}');
        if (Get.currentRoute == '/laboratory/detect_challenge_course') {
          LatLng target = LatLng(
            currentLocation.value?.latitude ?? 0,
            currentLocation.value?.longitude ?? 0,
          );

          googleMapController?.animateCamera(
            CameraUpdate.newLatLngZoom(target, 16),
          );
        }

        double prevPositionLat = nearChallengeLocation.value != null
            ? double.tryParse(
                    nearChallengeLocation.value!.startLat.toString()) ??
                locationModel.latitude
            : locationModel.latitude;
        double prevPositionLng = nearChallengeLocation.value != null
            ? double.tryParse(
                    nearChallengeLocation.value!.startLon.toString()) ??
                locationModel.longitude
            : locationModel.longitude;

        betweenDistance.value = calculateDistance(prevPositionLat,
            prevPositionLng, locationModel.latitude, locationModel.longitude);

        gpsSpeed.value = convertMStoKMH(locationModel.speed);

        // Check nearby treasures periodically during exercise
        await _checkNearbyTreasuresIfNeeded(locationModel);

        print('posLat : $prevPositionLat, posLng : $prevPositionLng');
        print('gpsSpeed : ${gpsSpeed.value}');
        print('betweenDistance : ${betweenDistance.value}');
        print('title : ${nearChallengeLocation.value?.firstName}');
        print('title : ${nearChallengeLocation.value?.endPointName}');
        print('dis : ${betweenDistance.value}');
        print(
            'nearChallengeLocation.value : ${nearChallengeLocation.value?.startLat ?? 'N/A'}');

        // 주기적으로 가장 가까운 챌린지 코스 지점 5분마다 재조회
        if (calcNearCourseTime.value
            .add(const Duration(seconds: 300))
            .isBefore(now)) {
          calculateNearByHierarchyCourse(
              locationModel.latitude, locationModel.longitude);
        }

        if (betweenDistance.value < 1000) {
          detectDelay.value = 30;
        } else if (betweenDistance.value < 3000) {
          detectDelay.value = 60;
        } else if (betweenDistance.value < 5000) {
          detectDelay.value = 300;
        } else {
          detectDelay.value = 600;
        }
        print('detectDelay : ${detectDelay}');

        if (receiveLocationTime.value
            .add(Duration(seconds: detectDelay.value))
            .isBefore(now)) {
          if (gpsSpeed.value < 12 && betweenDistance.value < 1000) {
            await findCourses();
          }
          receiveLocationTime.value = now;
        }
      } finally {
        _isRequestingChallenges = false;
      }

      HiveStore.save(
          key: HiveKey.currentPosition.name,
          value: '${locationModel.latitude},${locationModel.longitude}');

      locationThr.throttle(() {
        detectChallengeZone(locationModel);
      });
    } catch (e) {
      print('Error processing location update: $e');
    }
  }

  void calculateNearByHierarchyCourse(currentLat, currentLon) {
    print('555555');

    nearChallengeLocation.value = findNearestCourse(currentLat, currentLon,
        nearChallengeAllLocation.expand((c) => c.course).toList());
    print('nearChallengeLocation.value');
    print(nearChallengeLocation.value);
    nearChallengeLocation.refresh();
  }

  /// Compatibility shim: detectChallengeZone expects a LocationModel
  void detectChallengeZone(LocationModel? location) {
    if (location == null) return;
    // Delegate to existing challenge mixin logic if present
    try {
      // existing logic may be in ChallengeMixin; call if available
      // For now, keep simple: compute near courses check
      // This is a no-op placeholder to satisfy compile-time.
      // TODO: implement full detection logic or delegate properly.
    } catch (e) {
      print('detectChallengeZone error: $e');
    }
  }

  Future<void> getChallengesNearByHierarchy() async {
    print('3333333333');
    // Ensure we have a valid current location before requesting nearby challenges
    final loc = currentLocation.value;
    if (loc == null) return;

    await ActivityService.getChallengesNearByHierarchy(
      loc,
      successCallback: (data) async {
        if (data != null) {
          nearChallengeAllLocation.value = data;
          nearChallengeAllLocation.refresh();
          calculateNearByHierarchyCourse(loc.latitude, loc.longitude);
        }
      },
      errorCallback: () {},
    );
  }

  // 두 지점 간의 유클리드 거리를 계산하는 함수
  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   // 위도와 경도를 라디안으로 변환
  //   double lat1Rad = lat1 * pi / 180;
  //   double lon1Rad = lon1 * pi / 180;
  //   double lat2Rad = lat2 * pi / 180;
  //   double lon2Rad = lon2 * pi / 180;
  //
  //   // 유클리드 거리 계산
  //   double deltaLat = lat2Rad - lat1Rad;
  //   double deltaLon = lon2Rad - lon1Rad;
  //   double distance = sqrt(deltaLat * deltaLat + deltaLon * deltaLon) * 6371;  // 6371은 지구의 반지름 (단위: km)
  //
  //   return distance;
  // }

  ChallengeCourseModel findNearestCourse(myPosLat, myPosLon, courses) {
    ChallengeCourseModel nearestCourse = ChallengeCourseModel();
    double shortestDistance = double.infinity;

    for (var course in courses) {
      double distance = calculateDistance(
          myPosLat, myPosLon, course.startLat, course.startLon);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestCourse = course;
      }
    }
    return nearestCourse;
  }

// // 가장 가까운 코스를 찾는 함수
//   Map<String, dynamic> findClosestCourse(double currentLat, double currentLon, List<Map<String, dynamic>> courses) {
//     double closestDistance = double.infinity;
//     Map<String, dynamic> closestCourse;
//
//     for (var course in courses) {
//       double startLat = course['startLat'];
//       double startLon = course['startLon'];
//
//       double distance = calculateDistance(currentLat, currentLon, startLat, startLon);
//
//       if (distance < closestDistance) {
//         closestDistance = distance;
//         closestCourse = course;
//       }
//     }
//
//     return closestCourse;
//   }
  void detectFakeGps() async {
    //안드로이드만 탐지 가능
    if (isFakeGps.value &&
        Get.isBottomSheetOpen != true &&
        !isTestingFakeGps()) {
      showFakeGpsAlert();
      MemberService.reportAbuse(
          description: 'fake_gps_detected'.tr(), abusingType: 'GPS');
    }
  }

  void initGpsServiceStream() {
    _serviceStatusStream ??=
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        showGpsAlert();
      }
    });
  }

  double radians(double degree) {
    return degree * pi / 180;
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double earthRadius = 6371000;
    double lat1 = radians(startLatitude);
    double lon1 = radians(startLongitude);
    double lat2 = radians(endLatitude);
    double lon2 = radians(endLongitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Future<void> getCurrentLocation() async {
    try {
      print('Getting current location with UnifiedGPSManager...');

      // First try to get current location from UnifiedGPSManager if available
      if (UnifiedGPSManager.instance.currentLocation.value != null) {
        currentLocation.value =
            UnifiedGPSManager.instance.currentLocation.value;
        print(
            'Using cached location from UnifiedGPSManager: ${currentLocation.value}');
        return;
      }

      // Fallback to geolocator with enhanced accuracy
      Position location = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.bestForNavigation, // Use highest accuracy
        timeLimit:
            const Duration(seconds: 15), // Longer timeout for better accuracy
      );

      // Convert using enhanced LocationCallbackHandler
      final locationModel =
          LocationCallbackHandler.convertToLocationModel(location);

      // Apply GPS filtering using UnifiedGPSManager
      LocationModel? filteredLocationModel =
          UnifiedGPSManager.instance.filterLocation(locationModel);

      if (filteredLocationModel == null) {
        print(
            'Initial location filtered out by UnifiedGPSManager - accuracy: ${location.accuracy}m, retrying...');
        // Retry once if filtered out
        await Future.delayed(const Duration(seconds: 3));
        location = await Geolocator.getCurrentPosition(
          desiredAccuracy: _mapLocationAccuracy(locationAccuracyQuality),
          timeLimit: const Duration(seconds: 10),
        );
        final retryLocationModel = LocationModel.fromPosition(location);
        filteredLocationModel =
            UnifiedGPSManager.instance.filterLocation(retryLocationModel) ??
                retryLocationModel;
      }

      // Validation accuracy with configurable threshold
      if (filteredLocationModel.accuracy <= maxGpsAccuracy) {
        currentLocation.value = filteredLocationModel;
        isListeningToLocation.value = true;
        print(
            'Location acquired with accuracy: ${filteredLocationModel.accuracy}m');
      } else {
        print(
            'Location accuracy too poor: ${filteredLocationModel.accuracy}m (max: ${maxGpsAccuracy}m)');
        showToastPopup('gps_accuracy_poor'.tr());
      }
    } catch (error) {
      print('getCurrentLocation error: $error');
      showToastPopup('location_info_unavailable'.tr());
    }
  }

  /// Phase 2: GPS Warm-up process to improve initial accuracy
  Future<void> initializeGPSWithWarmup() async {
    try {
      print('Starting GPS warm-up process...');

      // Check if warm-up is enabled via remote config
      bool warmupEnabled = getConfig(
              dataType: ConfigType.bool, configKey: 'enable_gps_warm_up') ??
          true;
      if (!warmupEnabled) {
        print('GPS warm-up disabled via remote config');
        return;
      }

      // Clear any previous history using UnifiedGPSManager
      UnifiedGPSManager.instance.clearHistory();

      // Show user feedback about GPS initialization
      showToastPopup('initializing_gps'.tr());

      // Warm-up GPS by requesting multiple positions
      for (int i = 0; i < 3; i++) {
        try {
          Position warmupPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            timeLimit: const Duration(seconds: 15),
          );

          print('GPS warm-up ${i + 1}/3: accuracy ${warmupPosition.accuracy}m');

          // Add to UnifiedGPSManager history for better filtering
          final warmupLocationModel =
              LocationModel.fromPosition(warmupPosition);
          UnifiedGPSManager.instance.filterLocation(warmupLocationModel);

          // If we get good accuracy, we can break early
          if (warmupPosition.accuracy <= gpsAccuracy) {
            print('GPS warm-up completed successfully with good accuracy');
            showToastPopup('gps_ready'.tr());
            break;
          }

          // Wait between attempts
          if (i < 2) {
            await Future.delayed(const Duration(seconds: 3));
          }
        } catch (e) {
          print('GPS warm-up attempt ${i + 1} failed: $e');
          if (i == 2) {
            // Last attempt failed
            showToastPopup('gps_warmup_failed'.tr());
          }
        }
      }

      // Final check - get current location after warm-up
      await getCurrentLocation();
    } catch (e) {
      print('GPS warm-up process failed: $e');
      showToastPopup('gps_initialization_failed'.tr());
    }
  }

  Future<void> initializeActivity() async {
    print('Initializing activity with Phase 2 improvements...');
    // Phase 2: Use GPS warm-up for better initial accuracy
    await initializeGPSWithWarmup();
    await getChallengesNearByHierarchy();
    initLocationStream();
    initGpsServiceStream();

    //await setMarkerImages();
    await findCourses();
    detectChallengeZone(currentLocation.value);
  }

  // 챌린지 찾기
  Future<void> findCourses() async {
    if (currentLocation.value != null &&
        currentLocation.value!.latitude != 0 &&
        currentLocation.value!.longitude != 0) {
      // lan or lon의 오차범위가 5m 이상일 경우 새로운 코스를 찾는다. (추후 작업 필요)
      await getNearByCourses(currentLocation.value!, exerciseState.value);
      print('findCourses.Get.currentRoute : ${Get.currentRoute}');
      if (Get.currentRoute == '/laboratory/detect_challenge_course') {
        refreshUpdateCamera();
      }
    } else {
      await getCourseList();
    }
  }

  void refreshUpdateCamera() {
    if (nearByCourses.isNotEmpty && googleMapController != null) {
      List overlays = [];
      for (var item in nearByCourses) {
        overlays.addAll(renderCircleOverlays(item));
        overlays.addAll(renderMarkers(item));
      }
      print(overlays);
      clearOverlays();
      addOverlayAll({...overlays});
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
    if (globalController.internetConnection.value) {
      await retrySavedRequests(source: 'connectivityListener');
    }
  }

  Future<void> checkGPSStatus() async {
    // GpsService.getGpsAccuracy();
  }

  Future<void> retrySavedRequests({required String source}) async {
    if (HiveStore.load(key: HiveKey.endExerciseRequested.name) != null &&
        HiveStore.load(key: HiveKey.endExerciseRequested.name) &&
        userState.value.exercise != null) {
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

    Get.toNamed(Routes.challengeCourseDetail,
        arguments: {'id': challenge.id, 'hideCourses': hideLinkToCourses},
        preventDuplicates: false);
  }

  void moveToWebView(PromotionAdModel item) async {
    // 메인팝업 클릭 이벤트
    Adjust.trackEvent(AdjustEvent('4znz3j'));
    bool bannerAdClick =
        HiveStore.load(key: HiveKey.bannerAdClick.name) ?? false;
    if (!bannerAdClick) {
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
            Get.toNamed(Routes.challengeDetail
                .replaceAll(':id', item.referenceId.toString()));
            break;
          case 'ARCHIVE':
            Get.find<HomeMenuController>().selectMenu(4);
            if (Get.isRegistered<LeaderboardController>()) {
              Get.find<LeaderboardController>().tabController.animateTo(1);
            } else {
              LeaderboardController leaderboardController =
                  Get.put(LeaderboardController());
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
              LeaderboardController leaderboardController =
                  Get.put(LeaderboardController());
              leaderboardController.tabController.animateTo(0);
            }
            break;

          case 'WALLET':
            Get.toNamed(Routes.wallet);
            break;
          case 'NOTICE':
            // Get.toNamed(Routes.noticeList);
            Get.toNamed(Routes.webView,
                arguments: {'linkUrl': 'notice_url'.tr()});
            break;
          case 'FAQ':
            // Get.toNamed(Routes.preferenceBoard);
            Get.toNamed(Routes.webView, arguments: {'linkUrl': 'faq_url'.tr()});
            break;
        }
        break;
      case 'INTERNAL_WEB_VIEW':
        // Get.toNamed(Routes.webView, arguments: {'id': item.id, 'linkUrl': item.linkUrl});
        showModalWebview(this, Get.context,
            title: item.label!, linkUrl: item.linkUrl!);
        break;
      case 'EXTERNAL_BROWSER':
        Uri url = Uri.parse(item.linkUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }

  /// method to handle when user pick up a treasure
  /// only work if the treasure can be picked up + exercise is ongoing
  /// which mean the treasure is within 10m
  void onPickupTreasure(TreasureModel treasure) {
    debugPrint("CLICK TREASURE: ${treasure.latitude}, ${treasure.longitude}");

    // if highlighted
    if (currentHighlightedTreasuresId.contains(treasure.id) &&
        exerciseState.value == ExerciseState.ongoing) {
      /// check cool down timer
      if (_pickupCoolDownTimer?.isActive == true) {
        showToastV2(
          message: 'cannot_pickup_in_cooldown'.tr(),
          type: ToastV2Type.error,
        );
        return;
      }

      /// can be picked up
      /// show pick up bottom sheet
      Get.bottomSheet(
        isScrollControlled: true,
        PickUpTreasureBottomSheet(
          treasureModel: treasure,
          onPickUp: () {
            _callAPIPickupTreasure(
              treasure.id!,
              currentLocation.value!.latitude,
              currentLocation.value!.longitude,
            );
          },
        ),
      );
    }
  }

  // Helper to map integer quality to LocationAccuracy
  LocationAccuracy _mapLocationAccuracy(int quality) {
    switch (quality) {
      case 0:
        return LocationAccuracy.bestForNavigation;
      case 1:
        return LocationAccuracy.high;
      case 2:
        return LocationAccuracy.medium;
      case 3:
        return LocationAccuracy.low;
      default:
        return LocationAccuracy.best;
    }
  }

  /// Get effective GPS accuracy threshold based on current conditions
  double _getEffectiveAccuracyThreshold() {
    // Use different thresholds based on exercise state and conditions
    if (exerciseState.value == ExerciseState.ongoing) {
      // During exercise, use a more relaxed threshold for better tracking
      // Check if we've been getting poor GPS for a while - use adaptive threshold
      if (gpsAccuracySensitive.value > runtimeMaxGpsAccuracy) {
        // If current GPS is consistently poor, use maxGpsAccuracy (50m) to ensure tracking continues
        print(
            'Using relaxed GPS threshold due to poor signal: ${maxGpsAccuracy}m');
        return maxGpsAccuracy; // 50m - very relaxed for poor GPS conditions
      }
      return runtimeMaxGpsAccuracy; // 30m - good balance between accuracy and availability
    } else {
      // For initial positioning and non-exercise states, use stricter threshold
      return gpsAccuracyFallback; // 10m - stricter for positioning
    }
  }

  /// Initialize GPS services for enhanced activity tracking
  void _initializeGPSServices() {
    try {
      // Initialize UnifiedGPSManager with enhanced configuration
      UnifiedGPSManager.instance; // This will create singleton instance

      // Load remote configuration for optimal GPS settings
      UnifiedGPSManager.instance.refreshConfig();

      print(
          'Enhanced GPS services (UnifiedGPSManager) initialized successfully');
      print('GPS Config: ${UnifiedGPSManager.instance.config}');
    } catch (e) {
      print('Error initializing enhanced GPS services: $e');
    }
  }

  LatLngBounds _createBoundsFromLatLngList(List<LatLng> list) {
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;

    for (final latLng in list) {
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Process location from Strava-like GPS tracking
  Future<void> _processStravaLikeLocation(LocationModel locationModel) async {
    try {
      // Use filtered location model for all subsequent operations
      currentLocation.value = locationModel;
      gpsAccuracySensitive.value = locationModel.accuracy;
      isFakeGps.value = false;

      print(
          'Strava-like GPS position updated - accuracy: ${locationModel.accuracy}m');
      print('Filtered position: ${locationModel.toString()}');

      detectFakeGps();

      if (HiveStore.load(key: HiveKey.isDebuggingMode.name) &&
          exerciseState.value == ExerciseState.ongoing) {
        List positionRawData =
            HiveStore.load(key: HiveKey.positionRawDataLogs.name) ?? [];

        var logForm = {
          'positionRawDataInfo': '===================================='
              '\nEnhanced GPS - Lat/Lng: ${locationModel.latitude},${locationModel.longitude}, Accuracy: ${locationModel.accuracy}'
              '\nSteps: ${exerciseSteps.value}'
              '\nLocationUpdateTime: ${DateTime.now()}'
              '\nGPS Status: ${UnifiedGPSManager.instance.getStatus()}'
              '\nGPS Performance Grade: ${UnifiedGPSManager.instance.performanceGrade.value}'
              '\nGPS Mode: ${UnifiedGPSManager.instance.gpsMode.value}'
              '\nTotal Distance: ${UnifiedGPSManager.instance.totalDistance.value.toStringAsFixed(1)}m'
              '\nCurrent Speed: ${UnifiedGPSManager.instance.currentSpeed.value.toStringAsFixed(1)}km/h'
        };
        positionRawData.add(logForm);
        HiveStore.savePositionRawData(value: positionRawData);
      }

      if (isLockMap.isTrue) {
        _moveMapToMyLocation();
      }

      // Debug GPS accuracy comparison
      print(
          'GPS Accuracy Check: locationModel.accuracy=${locationModel.accuracy}m, gpsAccuracy=${gpsAccuracy}m, maxGpsAccuracy=${maxGpsAccuracy}m, exerciseState=${exerciseState.value}');

      // Use smart accuracy threshold based on exercise state and conditions
      double effectiveAccuracyThreshold = _getEffectiveAccuracyThreshold();

      if (exerciseState.value == ExerciseState.ongoing &&
          locationModel.accuracy < effectiveAccuracyThreshold) {
        print(
            'Processing location update - accuracy check passed with threshold: ${effectiveAccuracyThreshold}m');
        exerciseData.add(UserExerciseModel(
          altitude: locationModel.altitude,
          lastLatitude: locationModel.latitude,
          lastLongitude: locationModel.longitude,
          speed: locationModel.speed,
          // Time will be managed by ActivityMixin
          time: 0,
          locationUpdateTime: locationModel.timestamp,
        ));

        await processLocationUpdate(locationModel);
      } else {
        print(
            'Location update skipped - exerciseState: ${exerciseState.value}, accuracy: ${locationModel.accuracy}m > threshold: ${effectiveAccuracyThreshold}m');
      }
    } catch (e) {
      print('Error processing Strava-like location: $e');
    }
  }

  /// Fallback location stream for when Strava-like GPS fails
  void _startFallbackLocationStream() async {
    print('Starting fallback location stream...');
    // Original geolocator stream implementation as fallback
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 3,
          forceLocationManager: true,
          intervalDuration: const Duration(milliseconds: 3000),
          useMSLAltitude: true,
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: 'measuring_exercise_record'.tr(),
            notificationTitle: 'recording_location'.tr(),
            enableWakeLock: true,
          ));
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 3,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: false,
      );
    }

    locationSubscription ??=
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .map((pos) => LocationModel.fromPosition(pos))
            .listen((LocationModel locationModel) async {
      await _processStravaLikeLocation(locationModel);
    });
  }

  /// Handle GPS error
  void _handleGPSError(dynamic error) async {
    print('GPS error occurred: $error');
    try {
      await _handleGPSFallback(await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best));
    } catch (e) {
      print('Fallback failed: $e');
    }
  }

  /// GPS Fallback mechanism when GPS signal is poor or filtered out
  Future<void> _handleGPSFallback(Position originalPosition) async {
    try {
      print(
          'Attempting GPS fallback - original accuracy: ${originalPosition.accuracy}m');

      // Fallback is handled automatically by UnifiedGPSManager
      print('Fallback will be handled by UnifiedGPSManager');

      // Check if fallback is enabled via remote config
      bool fallbackEnabled = getConfig(
              dataType: ConfigType.bool,
              configKey: 'enable_gps_fallback_mechanism') ??
          true;
      if (!fallbackEnabled) {
        print('GPS fallback disabled via remote config');
        return;
      }

      // Try to get a single position with best accuracy
      Position fallbackPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      // Use more lenient threshold for fallback (2x normal threshold)
      double fallbackThreshold = gpsAccuracyFallback; // 10m from config
      if (fallbackPosition.accuracy <= fallbackThreshold) {
        // Apply UnifiedGPSManager filtering to fallback position
        final fallbackLocationModel =
            LocationModel.fromPosition(fallbackPosition);
        final filteredFallback =
            UnifiedGPSManager.instance.filterLocation(fallbackLocationModel);

        if (filteredFallback != null) {
          currentLocation.value = filteredFallback;
          gpsAccuracySensitive.value = filteredFallback.accuracy;
          print(
              'Fallback position used: accuracy ${filteredFallback.accuracy}m');
        } else {
          // If even fallback is filtered, use original with warning
          currentLocation.value = LocationModel.fromPosition(originalPosition);
          gpsAccuracySensitive.value = originalPosition.accuracy;
          print(
              'Using original position as last resort: accuracy ${originalPosition.accuracy}m');
        }
      } else {
        print(
            'Fallback position also poor: ${fallbackPosition.accuracy}m (threshold: ${fallbackThreshold}m)');
        // UnifiedGPSManager handles last known good position automatically
        print(
            'UnifiedGPSManager will manage fallback to last known good position');
      }
    } catch (e) {
      print('GPS fallback failed: $e');
      // Error handling is managed by UnifiedGPSManager
      showToastPopup('gps_signal_unstable'.tr());
    }
  }

  Future<void> _moveMapToMyLocation() async {
    if (currentLocation.value == null) return;

    LatLng target = LatLng(
      currentLocation.value!.latitude,
      currentLocation.value!.longitude,
    );

    for (var controller in challengeMapControllers) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          target,
          await controller.getZoomLevel(),
        ),
      );
    }
  }

  /// compare user location with the nearest treasure
  /// to see if they can pick it up or not
  /// UI purpose: zoom treasure if they can pick it up
  Future<void> compareDistanceWithNearestTreasure(Position userPosition) async {
    final Map<double, List<TreasureModel>> treasureDistanceMap = {};

    /// calculate all distance of treasures
    for (final t in listTreasureOfSession) {
      // Skip treasures with incomplete location data
      if (t.latitude == null || t.longitude == null) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        t.latitude!,
        t.longitude!,
      );

      if (treasureDistanceMap.containsKey(distance)) {
        treasureDistanceMap[distance]!.add(t);
      } else {
        treasureDistanceMap[distance] = [t];
      }
    }

    if (treasureDistanceMap.isEmpty) {
      return;
    }

    /// get nearest treasures
    var nearestTreasures =
        treasureDistanceMap.entries.reduce((a, b) => a.key < b.key ? a : b);
    // if nearest treasure is within pickupRadius (fetch from BE)
    bool isInRange = nearestTreasures.key <= kMinPickupRadius;

    if (currentHighlightedTreasuresId.isNotEmpty) {
      await _updateTreasureZoom(isZoom: false);
      currentHighlightedTreasuresId.clear();
    }

    if (isInRange) {
      debugPrint("TREASURE CAN BE PICKED UP: ${nearestTreasures.key}");
      currentHighlightedTreasuresId = nearestTreasures.value
          .map((e) => e.id ?? -1)
          .where((id) => id != -1)
          .toList();
      _updateTreasureZoom(isZoom: true);
    } else {
      // no need to update if no treasure highlighted before
      if (currentHighlightedTreasuresId.isEmpty) {
        return;
      }

      debugPrint("REMOVE PICKABLE TREASURE: ${nearestTreasures.key}");
      _updateTreasureZoom(isZoom: false);
      currentHighlightedTreasuresId.clear();
    }
  }

  /// sub-method to update UI for nearest treasure marker
  Future<void> _updateTreasureZoom({required bool isZoom}) async {
    final newMarkers = await buildCustomMarkers(
        positions: listTreasureOfSession
            .where((t) => currentHighlightedTreasuresId.contains(t.id))
            .toList(),
        markerSize: isZoom ? kTreasureZoomSize : kTreasureBaseSize);

    for (var element in newMarkers) {
      updateMarkerById(element);
    }
  }

  /// Check nearby treasures periodically during exercise
  Future<void> _checkNearbyTreasuresIfNeeded(
      LocationModel locationModel) async {
    try {
      // Only check if user is in an active exercise
      if (userState.value.exercise?.id == null) return;

      DateTime now = DateTime.now();

      // Check if enough time has passed since last check
      if (lastNearbyTreasureCheck != null &&
          now.difference(lastNearbyTreasureCheck!).inSeconds <
              nearbyTreasureCheckIntervalSeconds) {
        return;
      }

      // Update last check time
      lastNearbyTreasureCheck = now;

      // Create request model
      TreasureNearbyRequestModel request = TreasureNearbyRequestModel(
        userExerciseId: userState.value.exercise!.id!,
        userLat: locationModel.latitude,
        userLng: locationModel.longitude,
      );

      int userId = userState.value.state?.userId ?? 0;

      // Call API to check nearby treasures
      await TreasureService.checkNearbyTreasuresNotify(
        userId: userId,
        req: request,
        successCallback: (visibleTreasures) {
          listTreasureOfSession = List.from(visibleTreasures
              .where((element) =>
                  !listClaimedTreasureIdOfSession.contains(element.id))
              .toList());
          print('Nearby treasures notification sent successfully');
        },
        errorCallback: () {
          print('Failed to send nearby treasures notification');
        },
      );
    } catch (e) {
      print('Error checking nearby treasures: $e');
    }
  }

  /// method to active the cool down if user picked a treasure
  void _startCooldownTimer(int timeLeft) {
    coolDownTimeLeft.value = timeLeft;
    _pickupCoolDownTimer?.cancel();
    _pickupCoolDownTimer = Timer.periodic(
      1.seconds,
      (timer) {
        coolDownTimeLeft--;
        if (coolDownTimeLeft.value == 0) {
          timer.cancel();
          showToastV2(message: 'cooldown_ended'.tr());
        }
      },
    );
  }

  void initCoolDownTimerIfNeeded(DateTime? lastClaimTime) {
    void cancelCoolDownTimer() {
      coolDownTimeLeft.value = 0;
      _pickupCoolDownTimer?.cancel();
    }

    final now = DateTime.now();

    if (lastClaimTime == null) {
      cancelCoolDownTimer();
      return;
    }

    final secondsDifferent = now.difference(lastClaimTime).inSeconds;

    if (secondsDifferent < kPickupCoolDownTime.toInt()) {
      final secondsLeft = kPickupCoolDownTime.toInt() - secondsDifferent;
      _startCooldownTimer(secondsLeft);
    } else {
      cancelCoolDownTimer();
    }
  }

  Future<void> _callAPIPickupTreasure(
    int treasureId,
    double userLat,
    double userLng,
  ) async {
    final req = PickUpTreasureRequestModel(
      userId: userState.value.state?.userId ?? -1,
      userExerciseId: userState.value.exercise?.id ?? -1,
      userLat: userLat,
      userLng: userLng,
      treasureId: treasureId,
    );
    await TreasureService.pickUpTreasure(
      req: req,
      successCallback: (newTreasure) {
        Get.dialog(PickUpTreasureResultOverlay(treasureModel: newTreasure));

        /// if success then start timer
        _startCooldownTimer(kPickupCoolDownTime.toInt());

        /// hide the collected treasure
        listTreasureOfSession
            .removeWhere((element) => element.id == newTreasure.id);
        listClaimedTreasureIdOfSession.add(newTreasure.id!);
        removeMarkerById(newTreasure.id!);
      },
      errorCallback: (error) {
        if (error?.errorMessage != null) {
          showToastV2(
            message: error!.errorMessage!,
            type: ToastV2Type.error,
          );
        }
      },
    );
  }
}
