import 'dart:async';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:geolocator/geolocator.dart';

/// GPS Helper - Clean API wrapper for UnifiedGPSManager
///
/// Provides a simplified interface for GPS operations using the unified GPS system.
/// This helper wraps UnifiedGPSManager to provide backward compatibility and
/// clean API surface for location tracking operations.
class GPS {
  static GPS? _instance;
  static GPS get instance => _instance ??= GPS._();

  GPS._();

  /// Get the location stream from UnifiedGPSManager
  Stream<LocationModel> get locationStream =>
      UnifiedGPSManager.instance.locationStream;

  /// Get current position using UnifiedGPSManager
  Future<LocationModel?> getCurrentPosition() async {
    return await UnifiedGPSManager.instance.getCurrentLocation();
  }

  /// Start location tracking with UnifiedGPSManager
  Future<bool> startLocationTracking() async {
    return await UnifiedGPSManager.instance.startTracking();
  }

  /// Stop location tracking
  Future<void> stopLocationTracking() async {
    await UnifiedGPSManager.instance.stopTracking();
  }

  /// Check if location permissions are granted
  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Check and request location permissions
  static Future<bool> checkAndRequestPermissions() async {
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
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get GPS metrics from UnifiedGPSManager
  Map<String, dynamic> get metrics => UnifiedGPSManager.instance.getStatus();

  /// Get last known position from UnifiedGPSManager
  LocationModel? get lastKnownPosition =>
      UnifiedGPSManager.instance.currentLocation.value;

  /// Check if GPS is currently tracking
  bool get isTracking => UnifiedGPSManager.instance.isActive.value;
}
