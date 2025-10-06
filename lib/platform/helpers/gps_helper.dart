import 'package:geolocator/geolocator.dart';

/// GPS Helper - Legacy compatibility functions
///
/// This file provides backward compatibility functions for GPS operations.
/// All actual GPS functionality is now handled by UnifiedGPSManager.
/// Use the GPS class from unified_gps_manager.dart instead.

/// Check if location permissions are granted
Future<bool> hasLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

/// Check and request location permissions
Future<bool> checkAndRequestPermissions() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

/// Check if location services are enabled
Future<bool> isLocationServiceEnabled() async {
  return await Geolocator.isLocationServiceEnabled();
}
