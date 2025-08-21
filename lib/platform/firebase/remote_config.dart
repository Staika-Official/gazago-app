import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:logger/logger.dart';

enum ConfigType { bool, double, int, string, json }

Map<String, dynamic> _defaultConfigs = {
  // Existing abuse detection configs
  "abuse_radius": 50,
  "abuse_inside_radius_ratio": 80,
  "abuse_report_time": 600,

  // GPS Accuracy Configs
  "gps_accuracy_threshold": 5.0,
  "gps_accuracy_fallback": 10.0,
  "gps_max_acceptable_accuracy": 20.0,
  "gps_filter_max_speed": 50.0,
  "gps_filter_history_size": 5,
  "gps_update_interval_seconds": 2.0,
  "gps_distance_filter_meters": 3.0,
  "gps_filter_min_time_interval": 1.0,

  // GPS Feature Flags
  "enable_advanced_gps_filtering": true,
  "enable_gps_fallback_mechanism": true,
  "enable_gps_warm_up": true,
};

Future<void> initRemoteConfig() async {
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero));
  await _setDefaultConfigs(_defaultConfigs);
  try {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    await initRemoteConfigData();
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

//리모트 컨피그에서 값을 받아오기 전에 세팅할 기본값을 넣기 위한 메소드
Future<void> _setDefaultConfigs(Map<String, dynamic> defaultConfigs) async {
  await FirebaseRemoteConfig.instance.setDefaults(defaultConfigs);
}

dynamic getConfig({required ConfigType dataType, required String configKey}) {
  dynamic remoteData;
  switch (dataType) {
    case ConfigType.bool:
      remoteData = FirebaseRemoteConfig.instance.getBool(configKey);
      break;
    case ConfigType.double:
      remoteData = FirebaseRemoteConfig.instance.getDouble(configKey);
      break;
    case ConfigType.int:
      remoteData = FirebaseRemoteConfig.instance.getInt(configKey);
      break;
    case ConfigType.string:
    case ConfigType.json:
      remoteData = FirebaseRemoteConfig.instance.getString(configKey);
      break;
  }

  return remoteData;
}

void remoteConfigHealthCheck({String? configKey}) {
  if (configKey != null) {
    Logger().d(FirebaseRemoteConfig.instance.getValue(configKey).source);
  }
  Logger().d(FirebaseRemoteConfig.instance.lastFetchTime);
  Logger().d(FirebaseRemoteConfig.instance.lastFetchStatus);
}
