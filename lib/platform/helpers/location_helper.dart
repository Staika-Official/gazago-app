import 'dart:async';
import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/services/activity_service.dart';
import 'package:gaza_go/platform/services/member_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Calculate distance between two points using Haversine formula
/// Replaces Geolocator.distanceBetween
double _distanceBetween(double lat1, double lng1, double lat2, double lng2) {
  const double earthRadiusKm = 6371.0;
  
  final double dLat = _degreesToRadians(lat2 - lat1);
  final double dLng = _degreesToRadians(lng2 - lng1);
  
  final double lat1Rad = _degreesToRadians(lat1);
  final double lat2Rad = _degreesToRadians(lat2);
  
  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
                   math.sin(dLng / 2) * math.sin(dLng / 2) * 
                   math.cos(lat1Rad) * math.cos(lat2Rad);
  
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  
  return earthRadiusKm * c * 1000; // Convert to meters
}

double _degreesToRadians(double degrees) {
  return degrees * (math.pi / 180);
}

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
            _distanceBetween(location.latitude, location.longitude,
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

/// Enhanced coordinate filtering with speed and time validation - Phase 2
/// Synchronized with GPSFilterHelper to use consistent runtime thresholds
void filterCoordinates(LatLng lastPosition, LatLng newPosition, int exerciseId,
    {DateTime? lastTime, DateTime? currentTime}) {
  double distance = _distanceBetween(lastPosition.latitude,
      lastPosition.longitude, newPosition.latitude, newPosition.longitude);

  // Basic distance check (legacy behavior)
  if (distance > 100) {
    // Increased from 10m to 100m for more realistic threshold
    MemberService.reportAbuse(
        abusingType: "EXERCISE",
        exerciseId: exerciseId,
        description: 'large_coordinate_difference'.tr());
    return;
  }

  // Enhanced validation with time and speed - Phase 2
  if (lastTime != null && currentTime != null) {
    double timeInterval = currentTime.difference(lastTime).inSeconds.toDouble();

    // Avoid division by zero
    if (timeInterval <= 0) {
      print('Invalid time interval: $timeInterval seconds');
      return;
    }

    double speed = distance / timeInterval; // m/s
    double speedKmh = speed * 3.6; // km/h

    // Speed validation for different exercise types - synchronized with GPS filter helper
    double maxSpeedThreshold = runtimeGpsFilterMaxSpeed; // Uses runtime configurable threshold (default 3.0 km/h)

    // Detect abnormal speed (teleportation)
    if (speedKmh > maxSpeedThreshold) {
      MemberService.reportAbuse(
          abusingType: "EXERCISE",
          exerciseId: exerciseId,
          description:
              'abnormal_speed_detected: ${speedKmh.toStringAsFixed(1)} km/h'
                  .tr());
      print('Abnormal speed detected: ${speedKmh.toStringAsFixed(1)} km/h');
      return;
    }

    // Detect GPS jumps (large distance in short time)
    if (distance > 50 && timeInterval < 5) {
      MemberService.reportAbuse(
          abusingType: "EXERCISE",
          exerciseId: exerciseId,
          description:
              'gps_jump_detected: ${distance.toStringAsFixed(1)}m in ${timeInterval.toStringAsFixed(1)}s'
                  .tr());
      print(
          'GPS jump detected: ${distance.toStringAsFixed(1)}m in ${timeInterval.toStringAsFixed(1)}s');
      return;
    }

    // Log normal movement for debugging
    if (distance > 1) {
      // Only log significant movements
      print(
          'Normal movement: ${distance.toStringAsFixed(1)}m in ${timeInterval.toStringAsFixed(1)}s (${speedKmh.toStringAsFixed(1)} km/h)');
    }
  }
}

/// Get current thresholds used by location helper - for debugging and validation
Map<String, dynamic> getLocationHelperThresholds() {
  return {
    'speed_threshold_kmh': runtimeGpsFilterMaxSpeed,
    'distance_threshold_m': 100.0, // Basic distance check threshold
    'gps_jump_distance_m': 50.0, // GPS jump detection distance
    'gps_jump_time_s': 5.0, // GPS jump detection time
    'min_log_distance_m': 1.0, // Minimum distance to log movement
    'synchronized_with_gps_filter': true,
    'last_checked': DateTime.now().toIso8601String(),
  };
}
