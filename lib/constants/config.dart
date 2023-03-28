import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:geolocator/geolocator.dart';

int updateInterval = 30000;
double gpsAccuracy = 30;
LocationAccuracy locationAccuracyQuality = LocationAccuracy.high;
int stopTimeInterval = 5;
int stepDifference = 0;
double abusingRadius = 50;
double abusingInsideRadiusRatio = 80;
double abusingReportTime = 600;

void initRemoteConfigData() {
  abusingRadius = getConfig(dataType: ConfigType.double, configKey: 'abuse_radius');
  abusingInsideRadiusRatio = getConfig(dataType: ConfigType.double, configKey: 'abuse_inside_radius_ratio');
  abusingReportTime = getConfig(dataType: ConfigType.double, configKey: 'abuse_report_time');
}
