import 'dart:math';

double calculateAvgSpeed(List<double> speedList) {
  if (speedList.length > 0) {
    double sumSpeed = speedList.fold(0, (summedValue, speed) => summedValue + speed);
    return convertMStoKMH(sumSpeed / speedList.length);
  } else {
    return 0.0;
  }
}

double convertMStoKMH(double avgSpeedMS) {
  return (avgSpeedMS * 3600 / 1000);
}

double calculateTotalDistance(List<double> distanceList) {
  return distanceList.fold(0, (summedValue, distance) => summedValue + distance);
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double highestClimbed(List<double> altitudeList) {
  return altitudeList.fold(0, max);
}
