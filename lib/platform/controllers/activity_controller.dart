import 'dart:async';
import 'dart:io';

import 'package:another_xlider/another_xlider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/activity_mixin.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/challenge_mixin.dart';
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
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/activity/activity_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

class ActivityController extends GetxController with ActivityMixin, ChallengeMixin {
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
  final Rx<ExerciseType> selectedExerciseType = Rx(ExerciseType.walking);
  final Rx<LocationPermission> _locationPermission = Rx(LocationPermission.unableToDetermine);
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus = Rx(LocationAccuracyStatus.unknown);
  StreamSubscription<ServiceStatus>? _serviceStatusStream;
  final Rx<DateTime> receiveLocationTime = Rx(DateTime.now());

  @override
  void onInit() async {
    await initController();
    checkConnectivityStatus();
    super.onInit();
  }

  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
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

    super.onClose();
  }

  Future<void> initController() async {
    await checkAvailabilities();
    await initializeActivity();
    await getChallengeList();
    getUserState();
  }

  Future<void> refreshController() async {
    getUserState();
  }

  Future<void> onClickTestNoti() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails, iOS: IOSNotificationDetails());

    await flutterLocalNotificationsPlugin.show(0, 'Title', 'Body', platformChannelSpecifics, payload: 'Payload');
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
    if (stat.type == 'DURABILITY') {
      _currentSliderValue.value = stat.currentStat;
      remainDurability.value = stat.currentStat.toInt();
    }
    handleShowStaminaPopup(stat);
  }

  void handleShowStaminaPopup(stat) {
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
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    stat.type == 'STAMINA'
                        ? const StyledText(
                            '체력 충전',
                            fontSize: 22,
                            lineHeight: 22,
                            fontWeight: 500,
                          )
                        : const StyledText(
                            '내구도 충전',
                            fontSize: 22,
                            lineHeight: 22,
                            fontWeight: 500,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: stat.type == 'STAMINA'
                          ? StyledText(
                              '체력 ${stat.currentStat}/100',
                              fontSize: 16,
                              lineHeight: 22,
                              fontWeight: 500,
                              color: const Color(0xFF8A8A8A),
                            )
                          : StyledText(
                              '내구도 ${stat.currentStat}/100',
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
                        step: FlutterSliderStep(
                          step: stat.type == 'STAMINA' ? 10 : 1, // default
                        ),
                        handlerHeight: 32.0,
                        ignoreSteps: [
                          stat.type == 'DURABILITY' ? FlutterSliderIgnoreSteps(from: -1, to: stat.currentStat - 1) : FlutterSliderIgnoreSteps(from: 0, to: 0),
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
                          if (stat.type == 'STAMINA') {
                            _currentSliderValue.value = lowerValue;
                            costTik.value = _currentSliderValue.value.toInt() * 100;
                          } else {
                            if (lowerValue >= stat.currentStat.floor().toInt()) {
                              _currentSliderValue.value = lowerValue;
                              repairDurability.value = (lowerValue - stat.currentStat.floor()).toInt();
                              costTik.value = (lowerValue.toInt() - remainDurability.value).abs() * 100;
                            }
                          }
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
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF363841),
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
                                onTap: () => closeRepairPopup(),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Center(
                                      child: StyledText(
                                    '취소',
                                    fontSize: 18,
                                    lineHeight: 18,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                              onTap: () => stat.type == 'STAMINA' ? fetchRechargeStamina(stat.type) : fetchRepairShoes(),
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
              StyledText(
                'Taika 가 부족하여 진행할 수 없습니다.\n 인벤토리에 Taika를 충전해 주세요.',
                fontWeight: 500,
                fontSize: 18,
                lineHeight: 28,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
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
            durability: repairDurability.value,
            feeTik: costTik.value.toInt(),
          ),
        );
        userState.update((state) {
          state!.shoes!.durability = repairModel.durability;
        });

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
      if (userState.value.exercise?.challengeId != null) {
        selectedChallenge.value = allChallengesList.singleWhere((challenge) => challenge.id == userState.value.exercise!.challengeId!);
      }
      if (updateTimer == null) {
        exerciseData.value = List.empty(growable: true);
        exerciseData.add(userState.value.exercise!);
        exerciseTime.value = userState.value.exercise!.time!;
        exerciseSteps.value = userState.value.exercise!.steps!;

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
      getActivityRoute();
    }

    if (!isListeningToLocation.value) {
      initializeActivity();
    }
  }

  Future<bool> checkAvailabilities() async {
    bool isGpsAvailable = await checkGpsSensor();
    if (!isGpsAvailable) return false;

    bool hasActivityPermission = await checkActivityPermission();
    if (!hasActivityPermission) return false;

    bool hasLocationPermissionWithAccuracy = await checkLocationPermissionAndAccuracy();
    if (!hasLocationPermissionWithAccuracy) return false;

    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("조금만 기다려주세요");

    return true;
  }

  Future<bool> checkGpsSensor() async {
    bool isGpsAvailable = await Geolocator.isLocationServiceEnabled();
    if (!isGpsAvailable) {
      await Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('운동을 시작하기 위해서 GPS를 켜주세요.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }

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

    if (!hasPermission && !isAccurate) {
      await Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('원활한 채굴을 위하여\n"항상", "정확한" 위치공유를\n할 수 있도록 설정해주시기 바랍니다.'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  hasLocationPermission = await requestLocationPermission();
                  Get.back();
                },
                child: const Text('확인')),
          ],
        ),
        barrierDismissible: false,
      );
    }

    return hasLocationPermission;
  }

  Future<bool> checkActivityPermission() async {
    bool hasActivityPermission = false;
    if (Platform.isAndroid) {
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission = PH.PermissionStatus.granted == await PH.Permission.sensors.status;
    }
    if (!hasActivityPermission) {
      await Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: const Text('정확한 운동기록을 위해서 신체활동 권한을 허용해주세요'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                hasActivityPermission = await requestActivityPermission();
                Get.back();
              },
              child: const Text('확인'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
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
    }
    activityRecognitionPermission.complete(permissionGranted);

    return activityRecognitionPermission.future;
  }

  Future<bool> requestLocationPermission() async {
    Completer<bool> locationPermissionCompleter = Completer();
    LocationPermission locationPermission = await Geolocator.requestPermission();
    bool gotPermission = [LocationPermission.always, LocationPermission.whileInUse].any((permission) => permission == locationPermission);
    locationPermissionCompleter.complete(gotPermission);

    return locationPermissionCompleter.future;
  }

  void getActivityRoute() {
    if ([ExerciseState.ongoing, ExerciseState.paused].any((state) => state == exerciseState.value)) {
      Get.toNamed(Routes.activityActive);
    } else {
      Get.dialog(const ActivitySelect(), barrierDismissible: false, barrierColor: Color.fromRGBO(0, 0, 0, 0.85));
    }
  }

  // void loadExercise(ExerciseType exerciseType, [ChallengeModel? challenge]) {
  //   Get.offNamed(Routes.activityLoading);
  //   Timer(
  //     Duration(seconds: 3),
  //     () {
  //       Get.offNamed(Routes.activityActive);
  //       startExercise(exerciseType, challenge);
  //     },
  //   );
  // }

  void selectExerciseType(ExerciseType exerciseType) {
    selectedExerciseType.value = exerciseType;
    if (selectedExerciseType.value == ExerciseType.walking) selectedChallenge.value = ChallengeModel();
    Get.offNamed(Routes.activityActive);
  }

  void moveToChallengeSelection() {
    selectedChallenge.value = ChallengeModel();
    Get.toNamed(Routes.activityChallenges);
  }

  void initLocationStream() {
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 5),
          useMSLAltitude: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: "운동 기록을 측정중",
            notificationTitle: "위치 기록 중",
            enableWakeLock: true,
          ));
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
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
      if (exerciseState.value == ExerciseState.ongoing) {
        exerciseData.add(UserExerciseModel(
          altitude: position.altitude,
          speed: convertMStoKMH(position.speed),
        ));
        coordinates.add(LatLng(position.latitude, position.longitude));
      } else {
        // 첼린지 존 찾기(30초마다 요청)
        DateTime now = DateTime.now();

        if (receiveLocationTime.value.add(const Duration(seconds: 30)).compareTo(now) < 0) {
          findChallenge();
          receiveLocationTime.value = now;
        }
      }

      detectChallengeZone(position);
      autoFinishChallenge(userState.value);
    });
  }

  initGpsServiceStream() {
    _serviceStatusStream ??= Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        Get.dialog(AlertDialog(
          title: Text('경고'),
          content: Text('위치 기능이 꺼져있습니다. 서비스를 정상적으로 이용하기 위해서 다시 활성화해주세요.'),
        ));
      }
    });
  }

  Future<void> getCurrentLocation() async {
    print('getCurrentLocation');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation, timeLimit: Duration(seconds: 5)).then((location) {
      print('getCurrentLocation 위치정보 가져옴');
      currentLocation.value = location;
      isListeningToLocation.value = true;
    }).onError((error, stackTrace) {
      Get.snackbar('위치정보 수신실패', '위치정보를 가져오지 못했습니다.', colorText: Colors.white);
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
      await getNearByChallengeList(currentLocation.value);
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
}
