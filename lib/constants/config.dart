import 'dart:convert';

import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

int updateInterval = 30000;
double gpsAccuracy = 30;
LocationAccuracy locationAccuracyQuality = LocationAccuracy.high;
int stopTimeInterval = 5;
int stepDifference = 0;
double abusingRadius = 50;
double abusingInsideRadiusRatio = 80;
double abusingReportTime = 600;
Map? appliedEndpoint;

Future<void> initRemoteConfigData() async {
  abusingRadius = getConfig(dataType: ConfigType.double, configKey: 'abuse_radius');
  abusingInsideRadiusRatio = getConfig(dataType: ConfigType.double, configKey: 'abuse_inside_radius_ratio');
  abusingReportTime = getConfig(dataType: ConfigType.double, configKey: 'abuse_report_time');
  String json = getConfig(dataType: ConfigType.json, configKey: 'app_review_endpoint');
  String appVersion = await PackageInfo.fromPlatform().then((info) => info.version);
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
