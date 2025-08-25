import 'dart:async';
import 'dart:math' as math;
import 'dart:isolate';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:gaza_go/platform/configs/unified_gps_config.dart';
import 'package:gaza_go/platform/handlers/location_callback_handler.dart';

/// Unified GPS Manager - Single source of truth for all GPS operations
/// Replaces previous GPS helpers and provides centralized GPS management
/// Uses the geolocator package for foreground/background tracking
class UnifiedGPSManager extends GetxController {
  static UnifiedGPSManager? _instance;
  static UnifiedGPSManager get instance {
    _instance ??= Get.put(UnifiedGPSManager(), permanent: true);
    return _instance!;
  }

  // Background locator instance
  final Battery _battery = Battery();

  // Isolate communication
  static const String isolateName = 'LocatorIsolate';
  ReceivePort? _port;
  StreamSubscription<Position>? _positionSubscription;

  // GPS State
  final RxBool isActive = false.obs;
  final Rxn<LocationModel> currentLocation = Rxn<LocationModel>();
  final RxList<LocationModel> locationHistory = <LocationModel>[].obs;
  final RxBool isLocationEnabled = false.obs;
  final RxBool hasPermission = false.obs;

  // Performance Metrics
  final RxInt totalPositions = 0.obs;
  final RxInt filteredPositions = 0.obs;
  final RxInt errorCount = 0.obs;
  final RxDouble averageAccuracy = 0.0.obs;
  final RxDouble totalDistance = 0.0.obs;
  final RxDouble currentSpeed = 0.0.obs;
  final RxString performanceGrade = 'A'.obs;

  // Battery Status
  final RxInt batteryLevel = 100.obs;
  final RxString gpsMode = 'balanced'.obs;

  // Streams
  StreamSubscription<BatteryState>? _batterySubscription;
  final StreamController<LocationModel> _locationStreamController =
      StreamController<LocationModel>.broadcast();

  // Internal state
  LocationModel? _currentLocation;
  LocationModel? _lastValidLocation;
  DateTime? _sessionStart;
  Timer? _performanceTimer;
  final List<double> _accuracyHistory = [];
  final List<double> _speedHistory = [];

  @override
  void onInit() {
    super.onInit();
    _initializeManager();
  }

  @override
  void onClose() {
    stopTracking();
    _batterySubscription?.cancel();
    _performanceTimer?.cancel();
    _locationStreamController.close();

    // Clean up isolate port
    if (_port != null) {
      IsolateNameServer.removePortNameMapping(
          LocationCallbackHandler.isolateName);
      _port!.close();
    }

    super.onClose();
  }

  /// Initialize GPS manager
  Future<void> _initializeManager() async {
    await UnifiedGPSConfig.initialize();
    _setupBatteryMonitoring();
    _startPerformanceMonitoring();
  }

  /// Setup battery monitoring for adaptive GPS settings
  void _setupBatteryMonitoring() {
    _batterySubscription = _battery.onBatteryStateChanged.listen((_) {
      _updateBatteryStatus();
    });
    _updateBatteryStatus();
  }

  /// Update battery status and adapt GPS mode
  void _updateBatteryStatus() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;

      batteryLevel.value = level;

      // Determine GPS mode based on battery
      if (level > UnifiedGPSConfig.batteryHighThreshold ||
          state == BatteryState.charging) {
        gpsMode.value = 'high_performance';
      } else if (level > UnifiedGPSConfig.batteryLowThreshold) {
        gpsMode.value = 'balanced';
      } else {
        gpsMode.value = 'power_saving';
      }

      // Apply changes if tracking is active
      if (isActive.value) {
        _configureLocationSettings();
      }
    } catch (e) {}
  }

  /// Start performance monitoring
  void _startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(
        Duration(
            seconds:
                UnifiedGPSConfig.get<int>('performance_monitoring_interval')),
        (_) => _updatePerformanceMetrics());
  }

  /// Public method to check and request permissions
  Future<bool> checkAndRequestPermissions() async {
    return await _checkPermissions();
  }

  /// Check and request permissions for background location
  Future<bool> _checkPermissions() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationEnabled.value = serviceEnabled;

      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          hasPermission.value = false;
          return false;
        }
      }

      // Check for denied forever
      if (permission == LocationPermission.deniedForever) {
        hasPermission.value = false;
        return false;
      }

      // For background tracking, prefer 'always' permission
      if (permission == LocationPermission.whileInUse) {
        // On iOS, try to request always permission for background
        if (GetPlatform.isIOS) {
          final newPermission = await Geolocator.requestPermission();
          if (newPermission == LocationPermission.always) {
            permission = newPermission;
          } else {}
        }
      }

      final granted = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      hasPermission.value = granted;

      if (granted) {
      } else {}

      return serviceEnabled && granted;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      hasPermission.value = false;
      return false;
    }
  }

  /// Configure location settings based on current GPS mode
  Future<void> _configureLocationSettings() async {
    try {
      // For geolocator we configure the stream settings in _startPositionStream()
      // This method is kept for compatibility with existing codepaths.
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  /// Get appropriate location accuracy based on GPS mode
  LocationAccuracy _getLocationAccuracy(String mode) {
    switch (mode) {
      case 'high_performance':
        return LocationAccuracy.bestForNavigation;
      case 'balanced':
        return LocationAccuracy.best;
      case 'power_saving':
        return LocationAccuracy.low;
      default:
        return LocationAccuracy.best;
    }
  }

  /// Start GPS tracking
  Future<bool> startTracking({String? activityType}) async {
    try {
      if (isActive.value) {
        return true;
      }

      // Check permissions
      if (!await _checkPermissions()) {
        return false;
      }

      // Apply activity-specific configuration if provided
      if (activityType != null) {
        final activityConfig =
            UnifiedGPSConfig.getConfigForActivity(activityType);
        UnifiedGPSConfig.updateAll(activityConfig);
      }

      // Start listening to Geolocator position stream
      await _startPositionStream();

      // Initialize session
      _sessionStart = DateTime.now();
      _resetMetrics();

      isActive.value = true;
      return true;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      errorCount.value++;
      return false;
    }
  }

  Future<void> _startPositionStream() async {
    try {
      final config = UnifiedGPSConfig.getConfigForMode(gpsMode.value);

      // Validate critical config values with safe type conversion
      final rawDistanceFilter = config['distance_filter'];
      final rawUpdateInterval = config['update_interval'];

      final distanceFilter =
          (rawDistanceFilter is num) ? rawDistanceFilter.toInt() : 3;
      final updateInterval =
          (rawUpdateInterval is num) ? rawUpdateInterval.toInt() : 1000;

      // Validate ranges
      if (distanceFilter < 0 || distanceFilter > 100) {}
      if (updateInterval < 100 || updateInterval > 60000) {}

      // Enhanced location settings for background tracking
      LocationSettings locationSettings;

      if (GetPlatform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: _getLocationAccuracy(gpsMode.value),
          distanceFilter: distanceFilter,
          forceLocationManager: false,
          intervalDuration: Duration(milliseconds: updateInterval),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Gaza Go is tracking your activity in the background",
            notificationTitle: "Location Tracking Active",
            enableWakeLock: true,
          ),
        );
      } else if (GetPlatform.isIOS) {
        locationSettings = AppleSettings(
          accuracy: _getLocationAccuracy(gpsMode.value),
          distanceFilter: distanceFilter,
          pauseLocationUpdatesAutomatically: false,
          activityType: ActivityType.fitness,
          allowBackgroundLocationUpdates: true,
          showBackgroundLocationIndicator: true,
        );
      } else {
        // Fallback for other platforms
        locationSettings = LocationSettings(
          accuracy: _getLocationAccuracy(gpsMode.value),
          distanceFilter: distanceFilter,
          timeLimit: null,
        );
      }

      _positionSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position pos) {
          try {
            // Convert Position to LocationModel and handle update
            final locationModel =
                LocationCallbackHandler.convertToLocationModel(pos);
            _handleLocationUpdate(locationModel);
          } catch (e) {
            errorCount.value++;
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          }
        },
        onError: (error) {
          errorCount.value++;
          _handleLocationError(error);
        },
      );
    } catch (e) {
      rethrow; // Re-throw to be caught by startTracking
    }
  }

  /// Stop GPS tracking
  Future<void> stopTracking() async {
    try {
      if (!isActive.value) return;

      // Stop geolocator subscription
      await _positionSubscription?.cancel();
      _positionSubscription = null;

      // Clean up isolate port
      if (_port != null) {
        IsolateNameServer.removePortNameMapping(
            LocationCallbackHandler.isolateName);
        _port!.close();
        _port = null;
      }

      isActive.value = false;

      // Generate final performance report
      _generatePerformanceReport();
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  /// Handle new location data
  void _handleLocationUpdate(LocationModel locationModel) {
    try {
      // Update current location
      _currentLocation = locationModel;
      currentLocation.value = locationModel;

      // Update position count
      totalPositions.value++;

      // Apply filtering
      LocationModel? filteredLocation;
      if (UnifiedGPSConfig.filteringEnabled) {
        filteredLocation = _applyLocationFiltering(locationModel);
        if (filteredLocation == null) {
          filteredPositions.value++;
          return;
        }
      } else {
        filteredLocation = locationModel;
      }

      // Process valid location
      _processValidLocation(filteredLocation);
    } catch (e) {
      _handleLocationError(e);
    }
  }

  /// Apply comprehensive location filtering using unified config
  LocationModel? _applyLocationFiltering(LocationModel location) {
    try {
      // 1. Accuracy filter
      if (location.accuracy > UnifiedGPSConfig.accuracyThreshold) {
        return null;
      }

      // 2. Speed validation (check for teleportation)
      if (_lastValidLocation != null) {
        final distance = location.distanceTo(_lastValidLocation!);
        final timeInterval =
            location.timeDifferenceInSeconds(_lastValidLocation!);

        if (timeInterval > 0) {
          final speed = (distance / timeInterval) * 3.6; // Convert to km/h

          if (speed > UnifiedGPSConfig.speedThreshold) {
            return null;
          }
        }
      }

      // 3. Time interval filter
      if (_lastValidLocation != null) {
        final timeSinceLastUpdate =
            location.timeDifferenceInSeconds(_lastValidLocation!);
        if (timeSinceLastUpdate.abs() < UnifiedGPSConfig.minTimeInterval) {
          return null;
        }
      }

      // 4. Apply smoothing if enabled
      if (UnifiedGPSConfig.smoothingWindow > 1 && locationHistory.isNotEmpty) {
        return _applySmoothingFilter(location);
      }

      return location;
    } catch (e) {
      return location; // Return original on error
    }
  }

  /// Public method for filtering locations (for backward compatibility)
  LocationModel? filterLocation(LocationModel location) {
    return _applyLocationFiltering(location);
  }

  /// Apply smoothing filter using weighted average
  LocationModel _applySmoothingFilter(LocationModel newLocation) {
    final window =
        math.min<int>(UnifiedGPSConfig.smoothingWindow, locationHistory.length);
    if (window < 2) return newLocation;

    // Calculate weighted average based on accuracy and recency
    double totalWeight = 0;
    double weightedLat = 0;
    double weightedLng = 0;

    // Include recent history
    final recentLocations = locationHistory.take(window).toList();

    for (int i = 0; i < recentLocations.length; i++) {
      final loc = recentLocations[i];

      // Weight based on accuracy (better accuracy = higher weight)
      double accuracyWeight = 1.0 / (loc.accuracy + 1.0);

      // Weight based on recency (newer = higher weight)
      double recencyWeight = (i + 1).toDouble() / recentLocations.length;

      double finalWeight = accuracyWeight * recencyWeight;

      weightedLat += loc.latitude * finalWeight;
      weightedLng += loc.longitude * finalWeight;
      totalWeight += finalWeight;
    }

    // Include new location with high weight
    double newLocationWeight = 1.0 / (newLocation.accuracy + 1.0) * 2.0;
    weightedLat += newLocation.latitude * newLocationWeight;
    weightedLng += newLocation.longitude * newLocationWeight;
    totalWeight += newLocationWeight;

    return newLocation.copyWith(
      latitude: weightedLat / totalWeight,
      longitude: weightedLng / totalWeight,
    );
  }

  /// Process valid location
  void _processValidLocation(LocationModel location) {
    // Update current location
    currentLocation.value = location;
    _lastValidLocation = location;

    // Add to history with size management
    locationHistory.insert(0, location);
    if (locationHistory.length > UnifiedGPSConfig.maxHistorySize) {
      locationHistory.removeLast();
    }

    // Update metrics
    _updateLocationMetrics(location);

    // Emit to stream
    _locationStreamController.add(location);

    // Update speed and distance
    _updateSpeedAndDistance(location);
  }

  /// Update location-based metrics
  void _updateLocationMetrics(LocationModel location) {
    // Accuracy tracking
    _accuracyHistory.add(location.accuracy);
    if (_accuracyHistory.length > 50) {
      _accuracyHistory.removeAt(0);
    }

    averageAccuracy.value = _accuracyHistory.isNotEmpty
        ? _accuracyHistory.reduce((a, b) => a + b) / _accuracyHistory.length
        : 0.0;

    // Speed tracking
    if (location.speed >= 0) {
      _speedHistory.add(location.speedKmh);
      if (_speedHistory.length > 50) {
        _speedHistory.removeAt(0);
      }
      currentSpeed.value = location.speedKmh;
    }
  }

  /// Update speed and distance calculations
  void _updateSpeedAndDistance(LocationModel location) {
    if (locationHistory.length >= 2) {
      final previousLocation = locationHistory[1];
      final distance = location.distanceTo(previousLocation);

      // Only add significant movements to total distance
      if (distance > 1.0) {
        // More than 1 meter
        totalDistance.value += distance;
      }
    }
  }

  /// Handle location errors with recovery
  void _handleLocationError(dynamic error) {
    errorCount.value++;
    FirebaseCrashlytics.instance.recordError(error, StackTrace.current);

    // Implement error recovery if enabled
    if (UnifiedGPSConfig.get<bool>('auto_fallback') &&
        errorCount.value < UnifiedGPSConfig.get<int>('max_retry_attempts')) {
      Timer(
          Duration(
              milliseconds: UnifiedGPSConfig.get<int>('error_recovery_delay')),
          () {
        if (isActive.value) {
          _recoverFromError();
        }
      });
    }
  }

  /// Attempt to recover from GPS error
  Future<void> _recoverFromError() async {
    try {
      // Restart position stream
      await _positionSubscription?.cancel();
      await Future.delayed(const Duration(seconds: 2));
      if (isActive.value) {
        await _startPositionStream();
      }
    } catch (e) {}
  }

  /// Reset metrics for new session
  void _resetMetrics() {
    totalPositions.value = 0;
    filteredPositions.value = 0;
    errorCount.value = 0;
    averageAccuracy.value = 0.0;
    totalDistance.value = 0.0;
    currentSpeed.value = 0.0;
    _accuracyHistory.clear();
    _speedHistory.clear();
    locationHistory.clear();
  }

  /// Update performance metrics
  void _updatePerformanceMetrics() {
    if (!isActive.value || totalPositions.value == 0) return;

    try {
      // Calculate filter rate
      final filterRate = totalPositions.value > 0
          ? (filteredPositions.value / totalPositions.value) * 100
          : 0.0;

      // Calculate performance grade
      String grade = _calculatePerformanceGrade(filterRate);
      performanceGrade.value = grade;
    } catch (e) {}
  }

  /// Calculate performance grade based on metrics
  String _calculatePerformanceGrade(double filterRate) {
    final avgAccuracy = averageAccuracy.value;
    final errorRate = totalPositions.value > 0
        ? (errorCount.value / totalPositions.value) * 100
        : 0.0;

    int score = 100;

    // Accuracy scoring (0-40 points)
    if (avgAccuracy > 20) {
      score -= 20;
    } else if (avgAccuracy > 10) {
      score -= 10;
    } else if (avgAccuracy > 5) {
      score -= 5;
    }

    // Filter rate scoring (0-30 points)
    if (filterRate > 50) {
      score -= 30;
    } else if (filterRate > 30) {
      score -= 20;
    } else if (filterRate > 15) {
      score -= 10;
    }
    // Error rate scoring (0-30 points)
    if (errorRate > 10) {
      score -= 30;
    } else if (errorRate > 5) {
      score -= 20;
    } else if (errorRate > 2) {
      score -= 10;
    }

    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  /// Generate comprehensive performance report
  void _generatePerformanceReport() {
    if (_sessionStart == null) return;

    final sessionDuration = DateTime.now().difference(_sessionStart!);
    final filterRate = totalPositions.value > 0
        ? (filteredPositions.value / totalPositions.value) * 100
        : 0.0;

    final report = {
      'session_duration_minutes': sessionDuration.inMinutes,
      'total_positions': totalPositions.value,
      'filtered_positions': filteredPositions.value,
      'filter_rate_percent': filterRate,
      'error_count': errorCount.value,
      'average_accuracy_meters': averageAccuracy.value,
      'total_distance_meters': totalDistance.value,
      'performance_grade': performanceGrade.value,
      'gps_mode': gpsMode.value,
      'battery_level': batteryLevel.value,
      'config_validation': UnifiedGPSConfig.validateConfig(),
    };

    // Log to Firebase Analytics if needed
    try {
      FirebaseCrashlytics.instance.log('GPS Performance Report: $report');
    } catch (e) {}
  }

  /// Get current location once
  Future<LocationModel?> getCurrentLocation() async {
    try {
      if (!await _checkPermissions()) return null;

      // Return last known location if available
      if (_currentLocation != null) {
        return _currentLocation;
      }

      // If not active, read a single current position via Geolocator
      if (!isActive.value) {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final loc = LocationCallbackHandler.convertToLocationModel(pos);
        _currentLocation = loc;
        currentLocation.value = loc;
        return loc;
      }

      return _currentLocation;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return null;
    }
  }

  /// Get location stream
  Stream<LocationModel> get locationStream => _locationStreamController.stream;

  /// Update configuration
  void updateConfig(Map<String, dynamic> newConfig) {
    UnifiedGPSConfig.updateAll(newConfig);

    // Apply changes immediately if tracking is active
    if (isActive.value) {
      _configureLocationSettings();
    }
  }

  /// Get current configuration
  Map<String, dynamic> get config => UnifiedGPSConfig.getAll();

  /// Get comprehensive status
  Map<String, dynamic> getStatus() {
    return {
      'is_active': isActive.value,
      'has_permission': hasPermission.value,
      'is_location_enabled': isLocationEnabled.value,
      'gps_mode': gpsMode.value,
      'battery_level': batteryLevel.value,
      'current_location': currentLocation.value?.toMap(),
      'total_positions': totalPositions.value,
      'filtered_positions': filteredPositions.value,
      'error_count': errorCount.value,
      'average_accuracy': averageAccuracy.value,
      'total_distance': totalDistance.value,
      'current_speed': currentSpeed.value,
      'performance_grade': performanceGrade.value,
      'session_duration_minutes': _sessionStart != null
          ? DateTime.now().difference(_sessionStart!).inMinutes
          : 0,
      'config': config,
      'config_validation': UnifiedGPSConfig.validateConfig(),
    };
  }

  /// Clear history and reset for new session
  void clearHistory() {
    locationHistory.clear();
    _lastValidLocation = null;
    _resetMetrics();
  }

  /// Force refresh configuration from remote config
  Future<void> refreshConfig() async {
    await UnifiedGPSConfig.refresh();
    _updateBatteryStatus();
  }

  /// Set specific activity type (walking, running, cycling, driving)
  Future<void> setActivityType(String activityType) async {
    final activityConfig = UnifiedGPSConfig.getConfigForActivity(activityType);
    UnifiedGPSConfig.updateAll(activityConfig);

    if (isActive.value) {
      await _configureLocationSettings();
    }
  }

  /// Enable/disable battery optimization
  void setBatteryOptimization(bool enabled) {
    UnifiedGPSConfig.set('enable_battery_optimization', enabled);

    if (enabled) {
      _updateBatteryStatus();
    } else {
      gpsMode.value = 'balanced';
      if (isActive.value) {
        _configureLocationSettings();
      }
    }
  }
}

/// Helper class for easy access to GPS functionality
class GPS {
  static UnifiedGPSManager get instance => UnifiedGPSManager.instance;

  static Future<bool> startTracking({String? activityType}) =>
      instance.startTracking(activityType: activityType);
  static Future<void> stopTracking() => instance.stopTracking();
  static Future<LocationModel?> getCurrentLocation() =>
      instance.getCurrentLocation();
  static Stream<LocationModel> get locationStream => instance.locationStream;
  static Map<String, dynamic> getStatus() => instance.getStatus();
  static void clearHistory() => instance.clearHistory();
  static void updateConfig(Map<String, dynamic> config) =>
      instance.updateConfig(config);
  static Map<String, dynamic> get config => instance.config;
  static Future<void> refreshConfig() => instance.refreshConfig();
  static Future<void> setActivityType(String activityType) =>
      instance.setActivityType(activityType);
  static void setBatteryOptimization(bool enabled) =>
      instance.setBatteryOptimization(enabled);
  static Future<bool> checkAndRequestPermissions() =>
      instance.checkAndRequestPermissions();

  // Quick access to status
  static bool get isActive => instance.isActive.value;
  static bool get hasPermission => instance.hasPermission.value;
  static LocationModel? get currentLocation => instance.currentLocation.value;
  static String get performanceGrade => instance.performanceGrade.value;
  static String get gpsMode => instance.gpsMode.value;
  static int get batteryLevel => instance.batteryLevel.value;
  static double get totalDistance => instance.totalDistance.value;
  static double get currentSpeed => instance.currentSpeed.value;
}
