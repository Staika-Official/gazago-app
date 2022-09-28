import 'dart:convert';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> isUpdateTarget() async {
  dynamic remoteAppVersion = getConfig(dataType: ConfigType.string, configKey: 'minimum_app_version');
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  List<int> splitVersionString(String versionString) {
    return versionString.split('.').map((element) => int.parse(element)).toList();
  }

  List<int> minAppVersion = splitVersionString(remoteAppVersion);
  List<int> deviceAppVersion = splitVersionString(packageInfo.version);

  bool isUnderMinVersion = false;

  for (int i = 0; i < minAppVersion.length; i++) {
    if (minAppVersion[i] > deviceAppVersion[i]) {
      isUnderMinVersion = true;
      break;
    } else if (minAppVersion[i] < deviceAppVersion[i]) {
      break;
    }
  }
  return isUnderMinVersion;
}

String formatDate(String? isoDateString) {
  if (isoDateString != null) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(isoDateString));
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
