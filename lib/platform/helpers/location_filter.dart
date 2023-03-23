import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:geolocator/geolocator.dart';

bool catchSinglePointAbuse(List<LatLng> locationData) {
  final double radius = abusingRadius;
  double abuseRatio = abusingInsideRadiusRatio;
  double percentageInsideRadius = 0;
  LatLng startingPosition;

  if (locationData.length > 1) {
    startingPosition = locationData.first;
    final int countInsideRadius =
        locationData.skip(1).where((location) => Geolocator.distanceBetween(location.latitude, location.longitude, startingPosition.latitude, startingPosition.longitude) <= radius).length;
    percentageInsideRadius = (countInsideRadius / (locationData.length - 1)) * 100;
  }
  return percentageInsideRadius > abuseRatio;
}
