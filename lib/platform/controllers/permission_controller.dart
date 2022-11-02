import 'dart:async';
import 'dart:io';

import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as PH;

class PermissionController extends GetxController {
  final HealthFactory health = HealthFactory();
  final Rx<LocationPermission> _locationPermission = Rx(LocationPermission.unableToDetermine);
  final Rx<LocationAccuracyStatus> _locationAccuracyStatus = Rx(LocationAccuracyStatus.unknown);
  StreamSubscription<ServiceStatus>? _serviceStatusStream;

  @override
  void onClose() {
    _serviceStatusStream?.cancel();
    _serviceStatusStream = null;

    super.onClose();
  }

  Future<void> requestPermissions() async {
    await checkActivityPermission();
    await checkLocationPermissionAndAccuracy();
    await checkPhotoPermission();
    await checkCameraPermission();
    HiveStore.save(key: HiveKey.permissionRequestOnFirstLaunch.name, value: true);

    bool? isNewUser = HiveStore.load(key: HiveKey.isNewUser.name);

    if (isNewUser != null && isNewUser) {
      Get.offAllNamed(Routes.signupComplete);
    } else {
      Get.offAllNamed(Routes.loading);
    }
  }

  Future<bool> checkGpsSensor() async {
    bool isGpsAvailable = await Geolocator.isLocationServiceEnabled();
    if (!isGpsAvailable) {
      showToastPopup('운동을 시작하기 위해서 GPS를 켜주세요.');
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
      hasLocationPermission = await requestLocationPermission();
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
      hasActivityPermission = await requestActivityPermission();
    }
    return hasActivityPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    bool sensorGranted = false;
    bool healthGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = PH.PermissionStatus.granted == await PH.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      sensorGranted = PH.PermissionStatus.granted == await PH.Permission.sensors.request();
      healthGranted = await health.requestAuthorization([HealthDataType.STEPS]);

      permissionGranted = sensorGranted && healthGranted;
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

  Future<bool> checkPhotoPermission() async {
    bool hasPhotoPermission = false;
    PH.PermissionStatus permissionStatus = await PH.Permission.photos.status;
    hasPhotoPermission = [PH.PermissionStatus.granted, PH.PermissionStatus.restricted, PH.PermissionStatus.limited].any((permission) => permission == permissionStatus);
    if (!hasPhotoPermission) {
      hasPhotoPermission = await requestPhotoPermission();
    }
    return hasPhotoPermission;
  }

  Future<bool> checkCameraPermission() async {
    bool hasCameraPermission = false;
    hasCameraPermission = PH.PermissionStatus.granted == await PH.Permission.camera.status;
    if (!hasCameraPermission) {
      hasCameraPermission = await requestCameraPermission();
    }
    return hasCameraPermission;
  }

  Future<bool> requestPhotoPermission() async {
    Completer<bool> photoPermissionCompleter = Completer();
    bool permissionGranted = false;
    permissionGranted = PH.PermissionStatus.granted == await PH.Permission.photos.request();
    photoPermissionCompleter.complete(permissionGranted);

    return photoPermissionCompleter.future;
  }

  Future<bool> requestCameraPermission() async {
    Completer<bool> mediaPermissionCompleter = Completer();
    bool permissionGranted = false;
    permissionGranted = PH.PermissionStatus.granted == await PH.Permission.camera.request();
    mediaPermissionCompleter.complete(permissionGranted);

    return mediaPermissionCompleter.future;
  }
}
