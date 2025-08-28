import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaza_go/platform/models/treasure_model.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/firebase/cloud_messaging.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

/// Treasure Geofencing Service
/// Implements UC-006: Push Notification for Nearby Treasure
/// Monitors user location and sends notifications when entering treasure geofences
class TreasureGeofencingService extends GetxService {
  static TreasureGeofencingService? _instance;
  static TreasureGeofencingService get instance {
    _instance ??= Get.put(TreasureGeofencingService(), permanent: true);
    return _instance!;
  }

  // Configuration
  static const double defaultGeofenceRadius = 10.0; // meters
  static const int notificationCooldownMinutes = 5; // prevent spam

  // State
  final RxList<TreasureModel> _activeTreasures = <TreasureModel>[].obs;
  final RxBool _isMonitoring = false.obs;
  final Map<int, DateTime> _lastNotificationTimes = {};

  StreamSubscription<LocationModel>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  @override
  void onClose() {
    stopMonitoring();
    _locationSubscription?.cancel();
    super.onClose();
  }

  /// Initialize the geofencing service
  void _initializeService() {
    // Listen to GPS location updates from UnifiedGPSManager
    _locationSubscription = GPS.locationStream.listen(
      _onLocationUpdate,
      onError: (error) {
        // Location stream errors are handled by UnifiedGPSManager
      },
    );
  }

  /// Start monitoring treasures for geofencing
  Future<void> startMonitoring(List<TreasureModel> treasures) async {
    if (_isMonitoring.value) {
      await stopMonitoring();
    }

    // Check GPS permissions first
    final hasPermissions = await GPS.checkAndRequestPermissions();
    if (!hasPermissions) {
      return;
    }

    _activeTreasures.assignAll(treasures);
    _isMonitoring.value = true;

    // Ensure GPS is active for background monitoring using UnifiedGPSManager
    if (!GPS.isActive) {
      final started =
          await GPS.startTracking(activityType: 'treasure_monitoring');
      if (!started) {
        _isMonitoring.value = false;
        return;
      }
    }
  }

  /// Stop monitoring treasures
  Future<void> stopMonitoring() async {
    _isMonitoring.value = false;
    _activeTreasures.clear();
    _lastNotificationTimes.clear();
  }

  /// Update treasure list without stopping monitoring
  void updateTreasures(List<TreasureModel> treasures) {
    _activeTreasures.assignAll(treasures);
  }

  /// Handle location updates and check for treasure geofences
  void _onLocationUpdate(LocationModel location) {
    if (!_isMonitoring.value || _activeTreasures.isEmpty) {
      return;
    }

    // Check each treasure for geofence entry
    for (final treasure in _activeTreasures) {
      _checkTreasureGeofence(location, treasure);
    }
  }

  /// Check if user has entered a treasure's geofence
  void _checkTreasureGeofence(
      LocationModel userLocation, TreasureModel treasure) {
    // Skip if treasure is already claimed
    if (treasure.status.toLowerCase() == 'claimed') {
      return;
    }

    // Calculate distance to treasure
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      treasure.latitude,
      treasure.longitude,
    );

    // Use server-provided pickup radius or default
    const geofenceRadius = defaultGeofenceRadius;

    // Check if user is within geofence
    if (distance <= geofenceRadius) {
      _handleTreasureGeofenceEntry(treasure, distance);
    }
  }

  /// Handle when user enters a treasure geofence
  void _handleTreasureGeofenceEntry(TreasureModel treasure, double distance) {
    // Check notification cooldown to prevent spam
    if (_isNotificationOnCooldown(treasure.id)) {
      return;
    }

    // Record notification time
    _lastNotificationTimes[treasure.id] = DateTime.now();

    // Send treasure notification
    _sendTreasureNotification(treasure, distance);
  }

  /// Check if notification is on cooldown
  bool _isNotificationOnCooldown(int treasureId) {
    final lastNotification = _lastNotificationTimes[treasureId];
    if (lastNotification == null) {
      return false;
    }

    final cooldownEnd = lastNotification
        .add(const Duration(minutes: notificationCooldownMinutes));
    return DateTime.now().isBefore(cooldownEnd);
  }

  /// Send treasure nearby notification
  void _sendTreasureNotification(TreasureModel treasure, double distance) {
    showLocalNotification(
      notificationType: NotificationType.treasure,
      title: 'Treasure Found!', // As per UC-006 requirement
      message:
          'Treasure nearby! Open the app to collect.', // As per UC-006 requirement
      payload: 'TREASURE_NEARBY:${treasure.id}', // For navigation handling
    );

    // Store notification for analytics
    _recordTreasureNotification(treasure, distance);
  }

  /// Record treasure notification for analytics
  void _recordTreasureNotification(TreasureModel treasure, double distance) {
    try {
      // Store notification record
      final notificationRecord = {
        'treasure_id': treasure.id,
        'distance': distance,
        'timestamp': DateTime.now().toIso8601String(),
        'treasure_name': treasure.name,
        'treasure_amount': treasure.amount,
      };

      // Save to local storage for analytics
      List<dynamic> notifications =
          HiveStore.load(key: 'treasure_notifications') ?? [];
      notifications.add(notificationRecord);

      // Keep only last 100 notifications
      if (notifications.length > 100) {
        notifications = notifications.sublist(notifications.length - 100);
      }

      HiveStore.save(key: 'treasure_notifications', value: notifications);
    } catch (e) {
      // Silently handle notification recording errors
      // Could be logged to analytics service if needed
    }
  }

  /// Get current monitoring status
  Map<String, dynamic> getStatus() {
    return {
      'is_monitoring': _isMonitoring.value,
      'active_treasures_count': _activeTreasures.length,
      'last_notification_times': _lastNotificationTimes.length,
      'gps_active': GPS.isActive,
      'location_permission': GPS.hasPermission,
      'gps_status': GPS.getStatus(),
    };
  }

  /// Get list of active treasures being monitored
  List<TreasureModel> get activeTreasures => _activeTreasures.toList();

  /// Check if monitoring is active
  bool get isMonitoring => _isMonitoring.value;

  /// Clear notification history (for testing)
  void clearNotificationHistory() {
    _lastNotificationTimes.clear();
    HiveStore.save(key: 'treasure_notifications', value: []);
  }
}

/// Helper class for easy access to treasure geofencing
class TreasureGeofencing {
  static TreasureGeofencingService get instance =>
      TreasureGeofencingService.instance;

  static Future<void> startMonitoring(List<TreasureModel> treasures) =>
      instance.startMonitoring(treasures);

  static Future<void> stopMonitoring() => instance.stopMonitoring();

  static void updateTreasures(List<TreasureModel> treasures) =>
      instance.updateTreasures(treasures);

  static Map<String, dynamic> getStatus() => instance.getStatus();

  static bool get isMonitoring => instance.isMonitoring;

  static List<TreasureModel> get activeTreasures => instance.activeTreasures;
}
