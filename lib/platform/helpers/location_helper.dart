import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';

bool catchSinglePointAbuse(List<LatLng> locationData) {
  final double radius = abusingRadius;
  double abuseRatio = abusingInsideRadiusRatio;
  double percentageInsideRadius = 0;
  LatLng startingPosition;

  if (locationData.length > 1) {
    startingPosition = locationData.first;
    final int countInsideRadius = locationData
        .skip(1)
        .where((location) =>
            Geolocator.distanceBetween(location.latitude, location.longitude,
                startingPosition.latitude, startingPosition.longitude) <=
            radius)
        .length;
    percentageInsideRadius =
        (countInsideRadius / (locationData.length - 1)) * 100;
  }
  return percentageInsideRadius > abuseRatio;
}

Future<List<dynamic>> getLocationsData(int exerciseId) async {
  int page = 0;
  const int size = 200;
  List<dynamic> locationsDataList = List.empty(growable: true);

  Completer<List<dynamic>> completer = Completer();
  Future<void> getLocationsList() async {
    List<dynamic> list = List.empty(growable: true);
    list = await ActivityService.fetchLocations(
      exerciseId,
      page,
      size,
    );

    locationsDataList.addAll(list);

    if (list.length == size) {
      page++;
      await getLocationsList();
    } else {
      completer.complete(locationsDataList);
    }
  }

  await getLocationsList();

  return completer.future;
}

void filterCoordinates(
    LatLng lastPosition, LatLng newPosition, int exerciseId) {
  double distance = Geolocator.distanceBetween(lastPosition.latitude,
      lastPosition.longitude, newPosition.latitude, newPosition.longitude);
  if (distance > 10) {
    MemberService.reportAbuse(
        abusingType: "EXERCISE",
        exerciseId: exerciseId,
        description: 'large_coordinate_difference'.tr());
  }
}
