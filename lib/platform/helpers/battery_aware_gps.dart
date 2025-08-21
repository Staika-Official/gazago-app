import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:easy_localization/easy_localization.dart';

/// Phase 2: Battery-aware GPS settings to optimize power consumption
/// Provides adaptive GPS settings based on battery level and charging state
class BatteryAwareGPS {
  static final Battery _battery = Battery();
  static BatteryState? _lastBatteryState;
  static int? _lastBatteryLevel;

  /// Get optimal location settings based on current battery status
  static Future<LocationSettings> getOptimalLocationSettings() async {
    try {
      int batteryLevel = await _battery.batteryLevel;
      BatteryState batteryState = await _battery.batteryState;

      // Cache battery info for logging
      _lastBatteryLevel = batteryLevel;
      _lastBatteryState = batteryState;

      // Determine GPS mode based on battery status
      GPSMode mode = _determineGPSMode(batteryLevel, batteryState);

      print(
          'Battery-aware GPS: $batteryLevel% (${batteryState.name}) -> ${mode.name} mode');

      // Get settings for the determined mode
      return _getLocationSettingsForMode(mode);
    } catch (e) {
      print('Battery-aware GPS failed, using default settings: $e');
      // Fallback to balanced mode if battery info unavailable
      return _getLocationSettingsForMode(GPSMode.balanced);
    }
  }

  /// Determine GPS mode based on battery level and state
  static GPSMode _determineGPSMode(
      int batteryLevel, BatteryState batteryState) {
    // High performance mode: Good battery or charging
    if (batteryLevel > 50 || batteryState == BatteryState.charging) {
      return GPSMode.highPerformance;
    }
    // Power saving mode: Low battery
    else if (batteryLevel <= 20) {
      return GPSMode.powerSaving;
    }
    // Balanced mode: Medium battery
    else {
      return GPSMode.balanced;
    }
  }

  /// Get location settings for specific GPS mode
  static LocationSettings _getLocationSettingsForMode(GPSMode mode) {
    LocationAccuracy accuracy;
    Duration interval;
    double distanceFilter;
    bool forceLocationManager;
    bool enableWakeLock;

    switch (mode) {
      case GPSMode.highPerformance:
        accuracy = LocationAccuracy.bestForNavigation;
        interval = Duration(
            seconds: (gpsUpdateIntervalSeconds * 0.8).toInt()); // 20% faster
        distanceFilter = gpsDistanceFilterMeters * 0.8; // 20% more sensitive
        forceLocationManager = true;
        enableWakeLock = true;
        break;

      case GPSMode.balanced:
        accuracy = LocationAccuracy.best;
        interval =
            Duration(seconds: gpsUpdateIntervalSeconds.toInt()); // Default
        distanceFilter = gpsDistanceFilterMeters; // Default
        forceLocationManager = true;
        enableWakeLock = true;
        break;

      case GPSMode.powerSaving:
        accuracy = LocationAccuracy.high;
        interval = Duration(
            seconds: (gpsUpdateIntervalSeconds * 1.5).toInt()); // 50% slower
        distanceFilter = gpsDistanceFilterMeters * 1.5; // 50% less sensitive
        forceLocationManager = false; // Allow network location
        enableWakeLock = false;
        break;
    }

    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter.toInt(),
        forceLocationManager: forceLocationManager,
        intervalDuration: interval,
        useMSLAltitude: true,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationText: 'measuring_exercise_record'.tr(),
          notificationTitle: 'recording_location'.tr(),
          enableWakeLock: enableWakeLock,
        ),
      );
    } else {
      return AppleSettings(
        accuracy: accuracy,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilter.toInt(),
        pauseLocationUpdatesAutomatically: mode == GPSMode.powerSaving,
        showBackgroundLocationIndicator: false,
      );
    }
  }

  /// Check if battery level has changed significantly
  static Future<bool> shouldUpdateGPSSettings() async {
    try {
      int currentBatteryLevel = await _battery.batteryLevel;
      BatteryState currentBatteryState = await _battery.batteryState;

      // Update if battery level changed by 10% or state changed
      bool levelChanged = _lastBatteryLevel == null ||
          (currentBatteryLevel - _lastBatteryLevel!).abs() >= 10;
      bool stateChanged = _lastBatteryState != currentBatteryState;

      return levelChanged || stateChanged;
    } catch (e) {
      print('Battery check failed: $e');
      return false;
    }
  }

  /// Get current battery info for logging
  static Future<Map<String, dynamic>> getBatteryInfo() async {
    try {
      int batteryLevel = await _battery.batteryLevel;
      BatteryState batteryState = await _battery.batteryState;
      GPSMode mode = _determineGPSMode(batteryLevel, batteryState);

      return {
        'battery_level': batteryLevel,
        'battery_state': batteryState.name,
        'gps_mode': mode.name,
        'last_update': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'last_update': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Listen to battery changes and notify when GPS settings should update
  static Stream<bool> get batteryChangeStream {
    return _battery.onBatteryStateChanged.asyncMap((_) async {
      return await shouldUpdateGPSSettings();
    });
  }
}

/// GPS operating modes for battery optimization
enum GPSMode {
  highPerformance, // Best accuracy, fastest updates, high battery usage
  balanced, // Good accuracy, normal updates, moderate battery usage
  powerSaving, // Basic accuracy, slower updates, low battery usage
}
