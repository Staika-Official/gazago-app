import 'dart:math';

class ActivityMixin {
  double calculateAvgSpeed(List<double> speeds) {
    if (speeds.length > 0) {
      double sumSpeed = speeds.fold(0, (summedValue, speed) => summedValue + speed);
      return (sumSpeed / speeds.length / 1000) / (1 / 3600);
    } else {
      return 0.0;
    }
  }

  double calculateTotalDistance(List<double> distances) {
    return distances.fold(0, (summedValue, distance) => summedValue + distance);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double highestClimbed(List<double> altitudes) {
    return altitudes.fold(0, max);
  }
}
