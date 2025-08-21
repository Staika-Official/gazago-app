import 'dart:convert';

import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

int updateInterval = 30000;
// GPS Accuracy Settings - Phase 1 Improvements
double gpsAccuracy = 5; // Improved from 30m to 5m for better accuracy
double gpsAccuracyFallback = 10; // Fallback threshold when primary fails
double maxGpsAccuracy = 20; // Maximum acceptable accuracy
LocationAccuracy locationAccuracyQuality = LocationAccuracy
    .bestForNavigation; // Improved from high to bestForNavigation

// GPS Filtering Parameters
double gpsFilterMaxSpeed =
    50.0; // km/h - Maximum acceptable speed for fitness tracking
int gpsFilterHistorySize =
    5; // Number of positions to keep in history for filtering
double gpsFilterMinTimeInterval =
    1.0; // seconds - Minimum time interval between positions
double gpsUpdateIntervalSeconds = 2.0; // GPS update interval in seconds
double gpsDistanceFilterMeters =
    3.0; // Distance filter in meters (improved from 1m to 3m)

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
  gpsFilterMaxSpeed =
      getConfig(dataType: ConfigType.double, configKey: 'gps_filter_max_speed');
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
