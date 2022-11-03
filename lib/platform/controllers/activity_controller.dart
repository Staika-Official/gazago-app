import 'dart:async';
import 'dart:io';

import 'package:another_xlider/another_xlider.dart';
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
import 'package:gaza_go/platform/helpers/base_helper.dart';
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
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/activity/activity_loading.dart';
import 'package:gaza_go/presentations/views/activity/activity_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

class ActivityController extends SuperController with ActivityMixin, ChallengeMixin {
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
      {'title': '운동 거리', 'unit': 'km', 'content': '${300.34.toString()}', 'icon': iconActivityStoryDistance},
      {'title': '걸음 수', 'unit': '', 'content': '${12682.toString()}', 'icon': iconActivityStorySteps},
      {'title': '총 획득 타이카', 'unit': 'TIK', 'content': '${200.toString()}', 'icon': iconActivityStoryTaika},
    ]);
  }

  final RxDouble _currentSliderValue = RxDouble(0);
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

  @override
  void onInit() async {
    await initController();
    checkConnectivityStatus();
    super.onInit();
  }

  @override
  void onClose() {
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
    getUserState();
    hasPermission.value = await checkAvailabilities();
    if (hasPermission.value) {
      await initActivityStatus();
    }
  }

  Future<void> refreshController() async {
    getUserState();
  }

  Future<void> initActivityStatus() async {
    await initializeActivity();
    await loadMakerImages();
    await loadChallenges();
  }

  Future<void> loadMakerImages() async {
    startMaker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_start_maker.png',
    );

    endMaker = await OverlayImage.fromAssetImage(
      assetName: 'assets/images/activity/ico_challenge_end_maker.png',
    );
  }

  Future<void> loadChallenges() async {
    await getChallengesHierarchy(currentLocation.value);
    for (ChallengeHierarchyModel challenge in hierarchyChallengesList) {
      for (ChallengeModel course in challenge.course) {
        allChallengesList.add(course);

        challengeMarkers.add(Marker(
          markerId: course.id!.toString(),
          position: LatLng(course.startLat!, course.startLon!),
          captionText: course.startPointName,
          captionColor: const Color(0xFF0EE6F3),
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
          onMarkerTab: (marker, iconSize) {
            showEndPointMarker(course);
          },
        ));
      }
    }
  }

  void showEndPointMarker(ChallengeModel course) {
    challengeSelectedIndex.value = course.id!;

    if (challengeMarkers.value.last.markerId.contains('end_')) {
      challengeMarkers.removeLast();
    }

    challengeMarkers.add(Marker(
      markerId: 'end_${course.id!.toString()}',
      position: LatLng(course.endLat!, course.endLon!),
      captionText: '도착 ${course.endPointName}',
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
    _currentSliderValue.value = 0;
    costTik.value = 0;
  }

  void closeRepairPopup() {
    initRepairInfo();
    Get.back();
  }

  void onClickRepairStat(stat) {
    // if (stat.type == 'DURABILITY') {
    //   _currentSliderValue.value = stat.currentStat;
    //   remainDurability.value = stat.currentStat.toInt();
    // }
    handleShowStaminaPopup(stat);
  }

  void handleShowStaminaPopup(stat) {
    _currentSliderValue.value = 0;

    Get.bottomSheet(
      Obx(() {
        return Container(
          height: 340,
          decoration: const BoxDecoration(
            color: Color(0xff363841),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    stat.type == 'STAMINA'
                        ? const StyledText(
                            '체력 충전하기',
                            fontSize: 22,
                            lineHeight: 22,
                            fontWeight: 500,
                          )
                        : const StyledText(
                            '내구도 충전하기',
                            fontSize: 22,
                            lineHeight: 22,
                            fontWeight: 500,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: stat.type == 'STAMINA'
                          ? StyledText(
                              '현재 체력 ${stat.currentStat}',
                              fontSize: 16,
                              lineHeight: 22,
                              fontWeight: 500,
                              color: const Color(0xFF8A8A8A),
                            )
                          : StyledText(
                              '현재 신발 내구도 ${stat.currentStat}',
                              fontSize: 16,
                              lineHeight: 22,
                              fontWeight: 500,
                              color: const Color(0xFF8A8A8A),
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: FlutterSlider(
                        values: [_currentSliderValue.value],
                        max: 100,
                        min: 0,
                        step: const FlutterSliderStep(
                          step: 1, // default
                        ),
                        handlerHeight: 32.0,
                        ignoreSteps: [
                          FlutterSliderIgnoreSteps(from: 0, to: 0),
                        ],
                        trackBar: FlutterSliderTrackBar(
                          inactiveTrackBarHeight: 16,
                          activeTrackBarHeight: 15,
                          inactiveTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF494954),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: stat.type == 'STAMINA' ? const Color(0xFFCDFF41) : const Color(0xFFB85DFF),
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          _currentSliderValue.value = lowerValue;
                          costTik.value = _currentSliderValue.value.toInt() * 10;
                        },
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(
                            color: stat.type == 'STAMINA' ? const Color(0xFFCDFF41) : const Color(0xFFB85DFF),
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 3),
                              )
                            ],
                          ),
                          child: stat.type == 'STAMINA' ? iconSliderStamina : iconSliderShoe,
                        ),
                        tooltip: FlutterSliderTooltip(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                          format: (label) => '+ ${formatDecimalPlaces(double.parse(label), 0)}',
                          boxStyle: FlutterSliderTooltipBox(
                            decoration: BoxDecoration(
                              color: stat.type == 'STAMINA' ? const Color(0xFFCDFF41) : const Color(0xFFB85DFF),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const StyledText(
                            '비용 :',
                            fontSize: 22,
                            fontWeight: 500,
                            color: Color(0xFFA7A7A7),
                          ),
                          StyledText(
                            ' ${costTik.value} TIK',
                            fontSize: 22,
                            fontWeight: 500,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GazagoButton(
                            onTap: () => closeRepairPopup(),
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
                            onTap: () => stat.type == 'STAMINA' ? fetchRechargeStamina(stat.type) : fetchRepairShoes(),
                            buttonText: '네',
                            buttonColor: const Color(0xFF0EE6F3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void handleNotEnoughTaikaPopup() {
    Get.bottomSheet(
      Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Color(0xff363841),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          child: Column(
            children: [
              const StyledText(
                'Taika 가 부족하여 진행할 수 없습니다.\n 인벤토리에 Taika를 충전해 주세요.',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 28,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EE6F3),
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(
                        child: StyledText(
                      '확인',
                      fontSize: 18,
                      lineHeight: 18,
                      color: Colors.black,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchRechargeStamina(type) async {
    if (walletMasterController.tik.value.amount! >= costTik.value) {
      if (costTik.value > 0) {
        UserStateModel newUserState = await ActivityService.fetchUserStaminaRecharge(
          UserStaminaRechargeModel(
            type: type,
            stat: _currentSliderValue.value.toInt(),
            feeTik: costTik.value,
          ),
        );
        userState.update((state) {
          state?.state = newUserState;
        });
        walletMasterController.getSpendingWalletBalances();
        showToastPopup('체력이 충전되었습니다.');
        closeRepairPopup();
      } else {
        showToastPopup('충전할 게이지를 확인해주세요.');
      }
    } else {
      handleNotEnoughTaikaPopup();
    }
  }

  void fetchRepairShoes() async {
    if (walletMasterController.tik.value.amount! >= costTik.value) {
      if (costTik.value > 0) {
        InventoryItemModel repairModel = await ItemService.fetchRepairItemShoes(
          RepairShoesModel(
            id: userState.value.shoes!.id,
            durability: _currentSliderValue.value.toInt(),
            feeTik: costTik.value.toInt(),
          ),
        );
        userState.update((state) {
          state!.shoes!.durability = repairModel.durability;
        });
        walletMasterController.getSpendingWalletBalances();
        showToastPopup('내구도 충전이 완료되었습니다.');
        closeRepairPopup();
      } else {
        showToastPopup('충전할 게이지를 확인해주세요.');
      }
    } else {
      handleNotEnoughTaikaPopup();
    }
  }

  void getUserState() async {
    CurrentUserStateModel currentUserState = await ActivityService.getCurrentUserState();
    userState.update((state) {
      state?.state = currentUserState.state;
      state?.exercise = currentUserState.exercise;
      state?.shoes = currentUserState.shoes;
    });
    exerciseState.value = ExerciseState.ready;

    if (userState.value.exercise != null && userState.value.exercise!.state == 'ONGOING') {
      CurrentUserStateModel? savedUserState = HiveStore.loadCurrentUserState();
      if (savedUserState != null) {
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

        exerciseState.value = ExerciseState.paused;
      } else {
        exerciseState.value = ExerciseState.ongoing;
      }
    }

    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("곧 가자고와 가자고~!");
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
    await showAlert(
      title: '알림',
      contentWidget: const Padding(
        padding: EdgeInsets.only(top: 30, bottom: 50),
        child: Text.rich(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          TextSpan(
            text: '정확한 운동기록을 위해서 ',
            children: [
              TextSpan(text: '위치', style: TextStyle(color: Color(0xff0EE6F3))),
              TextSpan(text: '엑세스 \n권한을 허용해 주세요'),
            ],
          ),
        ),
      ),
      actions: [
        Expanded(
          child: GazagoButton(
            buttonText: '확인',
            onTap: () async {
              Get.back();
              await requestLocationPermission();
            },
          ),
        ),
      ],
    );
  }

  Future<void> showRequestActivityAlert() async {
    await showAlert(
      title: '알림',
      contentWidget: const Padding(
        padding: EdgeInsets.only(top: 30, bottom: 50),
        child: Text.rich(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          TextSpan(
            text: '정확한 운동기록을 위해서 ',
            children: [
              TextSpan(text: '신체 활동\n', style: TextStyle(color: Color(0xff0EE6F3))),
              TextSpan(text: '엑세스 권한을 허용해 주세요.'),
            ],
          ),
        ),
      ),
      actions: [
        Expanded(
          child: GazagoButton(
            buttonText: '확인',
            onTap: () async {
              Get.back();
              await requestActivityPermission();
            },
          ),
        ),
      ],
    );
  }

  Future<void> showGpsRequestAlert() async {
    await showAlert(
      title: '알림',
      contentWidget: const Padding(
        padding: EdgeInsets.only(top: 30, bottom: 50),
        child: Text.rich(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          TextSpan(
            text: '앱을 정상적으로 이용하기 위해서\n디바이스의 ',
            children: [
              TextSpan(text: 'GPS', style: TextStyle(color: Color(0xff0EE6F3))),
              TextSpan(text: '기능을 켜주세요'),
            ],
          ),
        ),
      ),
      actions: [
        Expanded(
          child: GazagoButton(
            buttonText: '확인',
            onTap: () {
              Get.back();
            },
          ),
        ),
      ],
    );
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
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.sensors.status;
    }

    return hasActivityPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      permissionGranted = PH.PermissionStatus.granted == await PH.Permission.sensors.request();
      await health.requestAuthorization([HealthDataType.STEPS]);

      // permissionGranted = sensorGranted && healthGranted;
    }
    if (!permissionGranted) {
      PH.openAppSettings();
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
        print(loadingTime.value);
        if (loadingTime.value == 3) {
          timer.cancel();
          loadingTimer = null;
          startExercise(exerciseType, challenge);
        } else {
          loadingTime.value++;
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

      // if (exerciseState.value == ExerciseState.ongoing && position.accuracy < 20) {
      if (exerciseState.value == ExerciseState.ongoing && position.accuracy < gpsAccuracy) {
        exerciseData.add(UserExerciseModel(
          altitude: position.altitude,
          speed: convertMStoKMH(position.speed),
          steps: exerciseSteps.value,
        ));
        coordinates.add(LatLng(position.latitude, position.longitude));
        if (exerciseData.isNotEmpty && exerciseData.length >= 2) {
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
        showAlert(
          title: '알림',
          contentWidget: const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 50),
            child: Text.rich(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 24 / 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              TextSpan(
                text: '앱을 정상적으로 이용하기 위해서\n디바이스의 ',
                children: [
                  TextSpan(text: 'GPS', style: TextStyle(color: Color(0xff0EE6F3))),
                  TextSpan(text: '기능을 켜주세요'),
                ],
              ),
            ),
          ),
          actions: [
            Expanded(
              child: GazagoButton(
                buttonText: '확인',
                onTap: () {
                  Get.back();
                },
              ),
            ),
          ],
        );
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
        if (HiveStore.loadString(key: HiveKey.badgeIssuanceRequested.name) != null) {
          await requestBadgeIssuance(userState.value);
        }

        if (HiveStore.loadString(key: HiveKey.endExerciseRequested.name) != null) {
          endExercise(selectedChallenge.value);
        }
      }
    });
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
