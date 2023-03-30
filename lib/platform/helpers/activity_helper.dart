import 'dart:math';

import 'package:geolocator/geolocator.dart';

double calculateAvgSpeed(List<double> speedList) {
  if (speedList.isNotEmpty) {
    double sumSpeed = speedList.fold(0, (summedValue, speed) => summedValue + speed);
    return sumSpeed / speedList.length;
  } else {
    return 0;
  }
}

double convertMStoKMH(double avgSpeedMS) {
  return (avgSpeedMS * 3600 / 1000);
}

double convertMetersToKm(double meters) {
  return meters / 1000;
}

double convertKmToMeters(double km) {
  return km * 1000;
}

double calculateTotalDistance(List<double> distanceList) {
  return distanceList.fold(0, (summedValue, distance) => summedValue + distance);
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  // var p = 0.017453292519943295;
  // var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  // return 12742 * asin(sqrt(a));
  return convertMetersToKm(Geolocator.distanceBetween(lat1, lon1, lat2, lon2));
}

double highestClimbed(List<double> altitudeList) {
  return altitudeList.fold(0, max);
}

bool batchIsInProgress() {
  DateTime currentDateTime = DateTime.now().toUtc();
  DateTime batchProcessStartDateTime = DateTime.utc(currentDateTime.year, currentDateTime.month, currentDateTime.day, 6, 43);
  DateTime batchProcessEndDateTime = DateTime.utc(currentDateTime.year, currentDateTime.month, currentDateTime.day, 6, 45);
  if (currentDateTime.isAfter(batchProcessStartDateTime) && currentDateTime.isBefore(batchProcessEndDateTime)) {
    return true;
  } else {
    return false;
  }
}
