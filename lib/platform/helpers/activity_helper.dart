import 'dart:math';

double calculateAvgSpeed(List<double> speedList) {
  if (speedList.isNotEmpty) {
    double sumSpeed = speedList.fold(0, (summedValue, speed) => summedValue + speed);
    return sumSpeed / speedList.length >= 0 ? sumSpeed / speedList.length : 0;
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
  // Haversine formula implementation
  const double earthRadius = 6371000; // Earth radius in meters
  
  double lat1Rad = lat1 * (pi / 180);
  double lat2Rad = lat2 * (pi / 180);
  double deltaLatRad = (lat2 - lat1) * (pi / 180);
  double deltaLngRad = (lon2 - lon1) * (pi / 180);

  double a = (sin(deltaLatRad / 2) * sin(deltaLatRad / 2)) +
      (cos(lat1Rad) * cos(lat2Rad) * sin(deltaLngRad / 2) * sin(deltaLngRad / 2));
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return convertMetersToKm(earthRadius * c);
}

double highestClimbed(List<double> altitudeList) {
  return altitudeList.fold(0, max);
}

bool batchIsInProgress() {
  DateTime currentDateTime = DateTime.now().toUtc();
  DateTime batchProcessStartDateTime = DateTime.utc(currentDateTime.year, currentDateTime.month, currentDateTime.day, 14, 55);
  DateTime batchProcessEndDateTime = DateTime.utc(currentDateTime.year, currentDateTime.month, currentDateTime.day, 15, 5);
  if (currentDateTime.isAfter(batchProcessStartDateTime) && currentDateTime.isBefore(batchProcessEndDateTime)) {
    return true;
  } else {
    return false;
  }
}
