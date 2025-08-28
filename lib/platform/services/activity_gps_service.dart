import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';

/// Activity GPS Service
/// Clean GPS tracking service for activity pages
/// Uses UnifiedGPSManager properly without conflicts
class ActivityGPSService extends GetxService {
  static ActivityGPSService? _instance;
  static ActivityGPSService get instance {
    _instance ??= Get.put(ActivityGPSService(), permanent: true);
    return _instance!;
  }

  // GPS State
  final RxBool isTracking = false.obs;
  final Rxn<LocationModel> currentLocation = Rxn<LocationModel>();
  final RxList<LatLng> coordinates = <LatLng>[].obs;
  final RxDouble totalDistance = 0.0.obs;
  final RxDouble currentSpeed = 0.0.obs;

  // Polyline for map
  final Rx<Polyline> trackingPolyline = const Polyline(
    polylineId: PolylineId('activity_path'),
    width: 3,
    color: Color(0xFFFF0000),
    points: [],
  ).obs;

  StreamSubscription<LocationModel>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }

  /// Initialize the GPS service
  void _initializeService() {
    // Listen to coordinates changes to update polyline
    coordinates.listen((coords) {
      _updatePolyline(coords);
    });
  }

  /// Start GPS tracking for activity
  Future<bool> startTracking() async {
    try {
      if (isTracking.value) {
        print('GPS tracking already active');
        return true;
      }

      // Start UnifiedGPSManager tracking
      final started =
          await GPS.startTracking(activityType: 'activity_tracking');
      if (!started) {
        print('Failed to start UnifiedGPSManager');
        return false;
      }

      // Listen to location stream
      _locationSubscription = GPS.locationStream.listen(
        _onLocationUpdate,
        onError: (error) {
          print('ActivityGPSService location error: $error');
        },
      );

      // Reset tracking data
      coordinates.clear();
      totalDistance.value = 0.0;
      isTracking.value = true;

      print('ActivityGPSService: Started GPS tracking');
      return true;
    } catch (e) {
      print('Error starting GPS tracking: $e');
      return false;
    }
  }

  /// Stop GPS tracking
  Future<void> stopTracking() async {
    try {
      isTracking.value = false;

      // Cancel location subscription
      _locationSubscription?.cancel();
      _locationSubscription = null;

      // Stop UnifiedGPSManager
      await GPS.stopTracking();

      print('ActivityGPSService: Stopped GPS tracking');
    } catch (e) {
      print('Error stopping GPS tracking: $e');
    }
  }

  /// Handle location updates from UnifiedGPSManager
  void _onLocationUpdate(LocationModel location) {
    if (!isTracking.value) return;

    try {
      // Update current location
      currentLocation.value = location;

      // Update speed (convert m/s to km/h)
      currentSpeed.value = location.speed * 3.6;

      // Add coordinate for tracking
      final newCoord = LatLng(location.latitude, location.longitude);
      coordinates.add(newCoord);

      // Calculate distance if we have previous coordinates
      if (coordinates.length > 1) {
        final prevCoord = coordinates[coordinates.length - 2];
        final distance = Geolocator.distanceBetween(
          prevCoord.latitude,
          prevCoord.longitude,
          newCoord.latitude,
          newCoord.longitude,
        );

        // Only add meaningful distances (> 1 meter)
        if (distance > 1.0) {
          totalDistance.value += distance;
        }
      }

      print(
          'ActivityGPS: Location updated - Speed: ${currentSpeed.value.toStringAsFixed(1)} km/h, Distance: ${totalDistance.value.toStringAsFixed(0)}m');
    } catch (e) {
      print('Error processing location update: $e');
    }
  }

  /// Update polyline for map display
  void _updatePolyline(List<LatLng> coords) {
    if (coords.length < 2) return;

    trackingPolyline.value = Polyline(
      polylineId: const PolylineId('activity_path'),
      width: 3,
      color: const Color(0xFFFF0000),
      points: coords,
    );
  }

  /// Get current tracking status
  Map<String, dynamic> getStatus() {
    return {
      'is_tracking': isTracking.value,
      'coordinates_count': coordinates.length,
      'total_distance_m': totalDistance.value,
      'current_speed_kmh': currentSpeed.value,
      'gps_active': GPS.isActive,
      'location_permission': GPS.hasPermission,
    };
  }

  /// Get polyline for map display
  Polyline get polyline => trackingPolyline.value;

  /// Get coordinates list
  List<LatLng> get trackingCoordinates => coordinates.toList();

  /// Get total distance in meters
  double get distanceMeters => totalDistance.value;

  /// Get total distance in kilometers
  double get distanceKilometers => totalDistance.value / 1000;

  /// Get current speed in km/h
  double get speedKmh => currentSpeed.value;

  /// Check if currently tracking
  bool get isCurrentlyTracking => isTracking.value;

  /// Get current location
  LocationModel? get location => currentLocation.value;

  /// Clear tracking data (for new session)
  void clearTrackingData() {
    coordinates.clear();
    totalDistance.value = 0.0;
    currentSpeed.value = 0.0;
    currentLocation.value = null;
  }
}

/// Helper class for easy access
class ActivityGPS {
  static ActivityGPSService get instance => ActivityGPSService.instance;

  static Future<bool> startTracking() => instance.startTracking();
  static Future<void> stopTracking() => instance.stopTracking();
  static void clearData() => instance.clearTrackingData();

  static Map<String, dynamic> getStatus() => instance.getStatus();
  static Polyline get polyline => instance.polyline;
  static List<LatLng> get coordinates => instance.trackingCoordinates;
  static double get distanceKm => instance.distanceKilometers;
  static double get speedKmh => instance.speedKmh;
  static bool get isTracking => instance.isCurrentlyTracking;
  static LocationModel? get location => instance.location;
}
