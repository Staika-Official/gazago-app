import 'dart:async';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

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
      Adjust.trackEvent(AdjustEvent('u6e7il'));

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
    LocationAccuracyStatus accuracyStatus = await Geolocator.getLocationAccuracy().onError((error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return LocationAccuracyStatus.unknown;
    });

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
      hasActivityPermission = ph.PermissionStatus.granted == await ph.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission = ph.PermissionStatus.granted == await ph.Permission.sensors.status;
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
      permissionGranted = ph.PermissionStatus.granted == await ph.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      sensorGranted = ph.PermissionStatus.granted == await ph.Permission.sensors.request();
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
    ph.PermissionStatus permissionStatus;
    final AndroidDeviceInfo? androidInfo = Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid && androidInfo != null && androidInfo.version.sdkInt <= 32) {
      permissionStatus = await ph.Permission.storage.status;
    } else {
      permissionStatus = await ph.Permission.photos.status;
    }
    hasPhotoPermission = [ph.PermissionStatus.granted, ph.PermissionStatus.restricted, ph.PermissionStatus.limited].any((permission) => permission == permissionStatus);
    if (!hasPhotoPermission) {
      hasPhotoPermission = await requestPhotoPermission();
    }
    return hasPhotoPermission;
  }

  Future<bool> checkCameraPermission() async {
    bool hasCameraPermission = false;
    hasCameraPermission = ph.PermissionStatus.granted == await ph.Permission.camera.status;
    if (!hasCameraPermission) {
      hasCameraPermission = await requestCameraPermission();
    }
    return hasCameraPermission;
  }

  Future<bool> requestPhotoPermission() async {
    Completer<bool> photoPermissionCompleter = Completer();
    bool permissionGranted = false;
    final AndroidDeviceInfo? androidInfo = Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid && androidInfo != null && androidInfo.version.sdkInt <= 32) {
      permissionGranted = ph.PermissionStatus.granted == await ph.Permission.storage.request();
    } else {
      permissionGranted = ph.PermissionStatus.granted == await ph.Permission.photos.request();
    }
    photoPermissionCompleter.complete(permissionGranted);

    return photoPermissionCompleter.future;
  }

  Future<bool> requestCameraPermission() async {
    Completer<bool> mediaPermissionCompleter = Completer();
    bool permissionGranted = false;
    permissionGranted = ph.PermissionStatus.granted == await ph.Permission.camera.request();
    mediaPermissionCompleter.complete(permissionGranted);

    return mediaPermissionCompleter.future;
  }
}
