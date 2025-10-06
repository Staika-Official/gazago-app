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
import 'package:get/get.dart' hide Trans;
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/platform/helpers/background_location_permission_helper.dart';

class PermissionController extends GetxController {
  final Health health = Health();
  final RxBool _locationPermission = RxBool(false);
  final RxBool _locationAccuracyStatus = RxBool(false);
  StreamSubscription<bool>? _serviceStatusStream;

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
    await checkTrackingPermission();
    HiveStore.save(
        key: HiveKey.permissionRequestOnFirstLaunch.name, value: true);

    bool? isNewUser = HiveStore.load(key: HiveKey.isNewUser.name);

    if (isNewUser != null && isNewUser) {
      Adjust.trackEvent(AdjustEvent('u6e7il'));

      Get.offAllNamed(Routes.signupComplete);
    } else {
      Get.offAllNamed(Routes.loading);
    }
  }

  Future<bool> checkGpsSensor() async {
    // Use BackgroundLocationPermissionHelper for GPS sensor check
    return await BackgroundLocationPermissionHelper.isLocationServiceEnabled();
  }

  Future<bool> checkLocationPermission() async {
    final status = await BackgroundLocationPermissionHelper.checkPermission();
    _locationPermission.value = status.isGranted;
    return status.isGranted;
  }

  Future<bool> checkLocationAccuracy() async {
    // Location accuracy is handled by UnifiedGPSManager
    _locationAccuracyStatus.value = true;
    return true;
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
      hasActivityPermission = ph.PermissionStatus.granted ==
          await ph.Permission.activityRecognition.status;
    } else if (Platform.isIOS) {
      hasActivityPermission =
          ph.PermissionStatus.granted == await ph.Permission.sensors.status;
    }
    if (!hasActivityPermission) {
      hasActivityPermission = await requestActivityPermission();
    }
    return hasActivityPermission;
  }

  Future<bool> checkTrackingPermission() async {
    bool hasTrackingPermission = false;

    if (Platform.isIOS) {
      hasTrackingPermission = ph.PermissionStatus.permanentlyDenied ==
          await ph.Permission.appTrackingTransparency.status;
    }
    if (hasTrackingPermission) {
      hasTrackingPermission = await requestTrakingPermission();
    }
    return hasTrackingPermission;
  }

  Future<bool> requestActivityPermission() async {
    Completer<bool> activityRecognitionPermission = Completer();
    bool permissionGranted = false;
    bool sensorGranted = false;
    bool healthGranted = false;
    if (Platform.isAndroid) {
      permissionGranted = ph.PermissionStatus.granted ==
          await ph.Permission.activityRecognition.request();
    } else if (Platform.isIOS) {
      sensorGranted =
          ph.PermissionStatus.granted == await ph.Permission.sensors.request();
      healthGranted = await health.requestAuthorization([HealthDataType.STEPS]);

      permissionGranted = sensorGranted && healthGranted;
    }

    activityRecognitionPermission.complete(permissionGranted);

    return activityRecognitionPermission.future;
  }

  Future<bool> requestLocationPermission() async {
    Completer<bool> locationPermissionCompleter = Completer();
    final status = await BackgroundLocationPermissionHelper.requestPermission();
    bool gotPermission = status.isGranted;

    locationPermissionCompleter.complete(gotPermission);

    return locationPermissionCompleter.future;
  }

  Future<bool> checkPhotoPermission() async {
    bool hasPhotoPermission = false;
    ph.PermissionStatus permissionStatus;
    final AndroidDeviceInfo? androidInfo =
        Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid &&
        androidInfo != null &&
        androidInfo.version.sdkInt <= 32) {
      permissionStatus = await ph.Permission.storage.status;
    } else {
      permissionStatus = await ph.Permission.photos.status;
    }
    hasPhotoPermission = [
      ph.PermissionStatus.granted,
      ph.PermissionStatus.restricted,
      ph.PermissionStatus.limited
    ].any((permission) => permission == permissionStatus);
    if (!hasPhotoPermission) {
      hasPhotoPermission = await requestPhotoPermission();
    }
    return hasPhotoPermission;
  }

  Future<bool> checkCameraPermission() async {
    bool hasCameraPermission = false;
    hasCameraPermission =
        ph.PermissionStatus.granted == await ph.Permission.camera.status;
    if (!hasCameraPermission) {
      hasCameraPermission = await requestCameraPermission();
    }
    return hasCameraPermission;
  }

  Future<bool> requestPhotoPermission() async {
    Completer<bool> photoPermissionCompleter = Completer();
    bool permissionGranted = false;
    final AndroidDeviceInfo? androidInfo =
        Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
    if (Platform.isAndroid &&
        androidInfo != null &&
        androidInfo.version.sdkInt <= 32) {
      permissionGranted =
          ph.PermissionStatus.granted == await ph.Permission.storage.request();
    } else {
      permissionGranted =
          ph.PermissionStatus.granted == await ph.Permission.photos.request();
    }
    photoPermissionCompleter.complete(permissionGranted);

    return photoPermissionCompleter.future;
  }

  Future<bool> requestCameraPermission() async {
    Completer<bool> mediaPermissionCompleter = Completer();
    bool permissionGranted = false;
    permissionGranted =
        ph.PermissionStatus.granted == await ph.Permission.camera.request();
    mediaPermissionCompleter.complete(permissionGranted);

    return mediaPermissionCompleter.future;
  }

  Future<bool> requestTrakingPermission() async {
    Completer<bool> trackingPermissionCompleter = Completer();
    bool permissionGranted = false;
    permissionGranted = ph.PermissionStatus.granted ==
        await ph.Permission.appTrackingTransparency.request();
    trackingPermissionCompleter.complete(permissionGranted);

    return trackingPermissionCompleter.future;
  }

  // LocationModel compatibility methods
  
  /// Check if permissions are compatible with LocationModel usage
  Future<bool> arePermissionsCompatibleWithLocationModel() async {
    return await BackgroundLocationPermissionHelper.isCompatibleWithLocationModel();
  }

  /// Get detailed permission status for LocationModel
  Future<Map<String, bool>> getLocationModelPermissionStatus() async {
    return await BackgroundLocationPermissionHelper.getLocationModelRequirements();
  }

  /// Request all permissions needed for LocationModel
  Future<bool> requestLocationModelPermissions() async {
    // First ensure basic permissions
    bool basicPerms = await checkLocationPermissionAndAccuracy();
    
    // Then check background permission if needed
    final bgStatus = await BackgroundLocationPermissionHelper.checkPermission();
    bool backgroundPerm = bgStatus.isGranted;
    
    if (!backgroundPerm) {
      final newStatus = await BackgroundLocationPermissionHelper.requestPermission();
      backgroundPerm = newStatus.isGranted;
    }
    
    return basicPerms && backgroundPerm;
  }

  /// Get user-friendly permission status message for LocationModel
  Future<String> getLocationModelPermissionMessage() async {
    final status = await BackgroundLocationPermissionHelper.checkPermission();
    return BackgroundLocationPermissionHelper.getPermissionStatusMessage(status);
  }
}
