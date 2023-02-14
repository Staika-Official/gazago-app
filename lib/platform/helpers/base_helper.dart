import 'dart:convert';
import 'dart:math';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> isForceUpdateTarget() async {
  String remoteAppVersion = getConfig(dataType: ConfigType.string, configKey: 'minimum_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> isRecommendUpdateTarget() async {
  String remoteAppVersion = getConfig(dataType: ConfigType.string, configKey: 'recommended_app_version');
  return await compareVersion(remoteAppVersion);
}

Future<bool> compareVersion(String versionString) async {
  String remoteAppVersion = versionString;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  List<int> splitVersionString(String versionString) {
    return versionString.split('.').map((element) => int.parse(element)).toList();
  }

  List<int> targetAppVersion = splitVersionString(remoteAppVersion);
  List<int> deviceAppVersion = splitVersionString(packageInfo.version);

  bool isUnderTargetVersion = false;

  for (int i = 0; i < targetAppVersion.length; i++) {
    if (targetAppVersion[i] > deviceAppVersion[i]) {
      isUnderTargetVersion = true;
      break;
    } else if (targetAppVersion[i] < deviceAppVersion[i]) {
      break;
    }
  }
  return isUnderTargetVersion;
}

String formatDate(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy.MM.dd HH:mm:ss").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String formatDateUntilDay(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(isoDateString).toLocal());
  } else {
    return '';
  }
}

String coordinatesToString(List<LatLng> coordinates) {
  List<List<String>> coordinateStringList = List.empty(growable: true);
  for (LatLng coordinate in coordinates) {
    coordinateStringList.add([coordinate.latitude.toString(), coordinate.longitude.toString()]);
  }
  return coordinateStringList.toString();
}

List<LatLng> locationStringToLatLng(String locationString) {
  List<LatLng> coordinates = List.empty(growable: true);
  List<dynamic> locationArray = json.decode(locationString);
  for (List location in locationArray) {
    LatLng coordination = LatLng(location[0], location[1]);
    coordinates.add(coordination);
  }
  return coordinates;
}

String formatDecimalPlaces(double val, int decimalPlaces, {RoundType roundType = RoundType.round}) {
  num mod = pow(10.0, decimalPlaces);
  double? formattedNumber;
  switch (roundType) {
    case RoundType.round:
      formattedNumber = ((val * mod).round().toDouble() / mod);
      break;
    case RoundType.ceil:
      formattedNumber = ((val * mod).ceilToDouble() / mod);
      break;
    case RoundType.floor:
      formattedNumber = ((val * mod).floorToDouble() / mod);
      break;
  }

  NumberFormat formatter;
  if (decimalPlaces != 0) {
    if (val == 0) {
      formatter = NumberFormat('0');
    } else {
      formatter = NumberFormat('#,###.${"0" * decimalPlaces}');
    }
  } else {
    formatter = NumberFormat('#,###');
  }

  return formatter.format(formattedNumber);
}

String formatSeconds(int time) {
  Duration seconds = Duration(seconds: time);
  return seconds.toString().split('.').first.padLeft(8, "0");
}
