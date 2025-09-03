import 'dart:convert';

import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

int updateInterval = 30000;
// GPS Accuracy Settings - Phase 1 Improvements
double gpsAccuracy = 5; // Improved from 30m to 5m for better accuracy
double gpsAccuracyFallback = 10; // Fallback threshold when primary fails
double maxGpsAccuracy = 50; // Maximum acceptable accuracy (relaxed for indoor testing)
// GPS quality setting (best for navigation equivalent)
int locationAccuracyQuality = 0; // 0 = best for navigation, 1 = high, 2 = medium, 3 = low
 
int gpsFilterHistorySize =
    5; // Number of positions to keep in history for filtering
double gpsFilterMinTimeInterval =
    0.5; // seconds - Minimum time interval between positions
double gpsUpdateIntervalSeconds = 2.0; // GPS update interval in seconds
double gpsDistanceFilterMeters =
    3.0; // Distance filter in meters (improved from 1m to 3m)

// Runtime GPS Configuration - These are the ACTIVE thresholds used by helpers
double runtimeMaxGpsAccuracy = 30.0; // Runtime accuracy threshold (meters) - relaxed for indoor testing
double runtimeGpsFilterMaxSpeed = 40.0; // ACTIVE speed threshold used by all GPS helpers (km/h) - increased to 40km/h business requirement
int runtimeGpsUpdateInterval = 1000; // Runtime update interval in ms

int stopTimeInterval = 5;
int stepDifference = 0;
double abusingRadius = 50;
double abusingInsideRadiusRatio = 80;
double abusingReportTime = 600;
Map? appliedEndpoint;

Future<void> initRemoteConfigData() async {
  // Existing abuse detection configs
  abusingRadius =
      getConfig(dataType: ConfigType.double, configKey: 'abuse_radius');
  abusingInsideRadiusRatio = getConfig(
      dataType: ConfigType.double, configKey: 'abuse_inside_radius_ratio');
  abusingReportTime =
      getConfig(dataType: ConfigType.double, configKey: 'abuse_report_time');

  // GPS Accuracy Configs - Phase 1
  gpsAccuracy = getConfig(
      dataType: ConfigType.double, configKey: 'gps_accuracy_threshold');
  gpsAccuracyFallback = getConfig(
      dataType: ConfigType.double, configKey: 'gps_accuracy_fallback');
  maxGpsAccuracy = getConfig(
      dataType: ConfigType.double, configKey: 'gps_max_acceptable_accuracy'); 
  gpsFilterHistorySize =
      getConfig(dataType: ConfigType.int, configKey: 'gps_filter_history_size');
  gpsUpdateIntervalSeconds = getConfig(
      dataType: ConfigType.double, configKey: 'gps_update_interval_seconds');
  gpsDistanceFilterMeters = getConfig(
      dataType: ConfigType.double, configKey: 'gps_distance_filter_meters');
  gpsFilterMinTimeInterval = getConfig(
      dataType: ConfigType.double, configKey: 'gps_filter_min_time_interval');

  String json =
      getConfig(dataType: ConfigType.json, configKey: 'app_review_endpoint');
  String appVersion =
      await PackageInfo.fromPlatform().then((info) => info.version);
  List<dynamic> endpointListByVersions = List.empty(growable: true);
  endpointListByVersions.addAll(jsonDecode(json)['versions']);
  for (Map endpoint in endpointListByVersions) {
    if (endpoint['version'] == appVersion) {
      appliedEndpoint = endpoint;
    }
  }
}

Map<String, String> imageNetworkHeader = {
  'Connection': 'Keep-Alive',
  'Keep-Alive': 'timeout=10, max=5',
};