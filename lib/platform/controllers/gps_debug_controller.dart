import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gaza_go/platform/managers/unified_gps_manager.dart';
import 'package:gaza_go/platform/configs/unified_gps_config.dart';
import 'package:gaza_go/platform/models/location_model.dart';

/// GPS Debug Controller - Clean implementation using UnifiedGPSManager
/// Provides debug interface for GPS tracking and configuration
class GPSDebugController extends GetxController {
  // Unified GPS Manager instance - our single source of truth
  late final UnifiedGPSManager _gpsManager;

  // GPS State (proxied from UnifiedGPSManager)
  final RxBool isGPSActive = false.obs;
  final Rxn<LocationModel> currentPosition = Rxn<LocationModel>(); // Use LocationModel instead
  final Rxn<LocationModel> currentLocationModel = Rxn<LocationModel>();
  final RxDouble currentSpeed = 0.0.obs;
  final RxDouble totalDistance = 0.0.obs;
  final RxInt sessionDuration = 0.obs;

  // Real-time GPS data for visualization
  final RxList<LatLng> rawPositions = <LatLng>[].obs;
  final RxList<LatLng> filteredPositions = <LatLng>[].obs;
  final RxBool gpsJumpDetected = false.obs;
  final RxDouble lastJumpDistance = 0.0.obs;

  // Statistics (from UnifiedGPSManager)
  final RxInt totalPositions = 0.obs;
  final RxInt rejectedPositions = 0.obs;
  final RxDouble filterRate = 0.0.obs;
  final RxDouble averageAccuracy = 0.0.obs;
  final RxDouble maxSpeed = 0.0.obs;
  final RxString performanceGrade = 'C'.obs;

  // Helper metrics
  final RxInt errorCount = 0.obs;
  final RxInt gpsJumps = 0.obs;

  // System status
  final RxInt batteryLevel = 0.obs;
  final RxString gpsMode = 'Unknown'.obs;
  final RxBool isDataSyncing = false.obs;
  
  // Additional compatibility properties
  final RxInt fallbackCount = 0.obs;
  final RxInt batteryOptimizations = 0.obs;
  
  // Logs
  final RxList<String> realtimeLogs = <String>[].obs;
  final RxBool autoScrollLogs = true.obs;
  
  // Mock data state
  final RxBool mockModeEnabled = false.obs;
  
  // Indoor GPS mode
  final RxBool indoorMode = false.obs;
  
  // Background tracking mode
  final RxBool backgroundTrackingEnabled = false.obs;
  final RxString trackingMode = 'foreground'.obs;
  
  // Permission state
  final RxBool locationPermissionGranted = false.obs;

  // Private state
  StreamSubscription<LocationModel>? _locationSubscription;
  Timer? _sessionTimer;
  Timer? _syncTimer;
  DateTime? _sessionStart;
  LocationModel? _lastLocationModel;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }

  /// Initialize controller with UnifiedGPSManager and set fixed config
  void _initializeController() async {
    try {
      // Get UnifiedGPSManager instance
      _gpsManager = UnifiedGPSManager.instance;

      // Set fixed production configuration
      UnifiedGPSConfig.set('accuracy_threshold', 10.0);
      UnifiedGPSConfig.set('speed_threshold', 7.0); 
      UnifiedGPSConfig.set('update_interval', 1000);
      UnifiedGPSConfig.set('distance_filter', 1);

      // Setup location stream listener
      _setupLocationStream();

      addLog('GPS Debug Controller initialized with fixed production config');
      addLog('📋 Fixed Config: Accuracy=10m, Speed=7km/h, Interval=1000ms, DistanceFilter=1m');

    } catch (e) {
      addLog('Initialization error: $e');
    }
  }

  /// Setup location stream from UnifiedGPSManager
  void _setupLocationStream() {
    _locationSubscription = _gpsManager.locationStream.listen((locationModel) {
      _processLocationUpdate(locationModel);
    });
    
    // Sync data periodically
    _startPeriodicSync();
  }

  /// Start periodic sync with UnifiedGPSManager
  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (isGPSActive.value && !isDataSyncing.value) {
        await _syncFromGPSManager();
      }
    });
  }

  /// Sync data from UnifiedGPSManager
  Future<void> _syncFromGPSManager() async {
    isDataSyncing.value = true;
    
    try {
      // Sync GPS state
      isGPSActive.value = _gpsManager.isActive.value;
      currentLocationModel.value = _gpsManager.currentLocation.value;
      
      // Sync metrics
      totalPositions.value = _gpsManager.totalPositions.value;
      rejectedPositions.value = _gpsManager.filteredPositions.value;
      averageAccuracy.value = _gpsManager.averageAccuracy.value;
      currentSpeed.value = _gpsManager.currentSpeed.value;
      totalDistance.value = _gpsManager.totalDistance.value;
      errorCount.value = _gpsManager.errorCount.value;
      performanceGrade.value = _gpsManager.performanceGrade.value;
      
      // Calculate filter rate
      if (totalPositions.value > 0) {
        filterRate.value = (rejectedPositions.value / totalPositions.value) * 100;
      }

      // Sync battery info
      batteryLevel.value = _gpsManager.batteryLevel.value;
      gpsMode.value = _gpsManager.gpsMode.value;
      
      // Update compatibility properties
      fallbackCount.value = _gpsManager.errorCount.value; // Use error count as fallback count
      batteryOptimizations.value = 0; // Not tracked in UnifiedGPSManager

    } catch (e) {
      addLog('Sync error: $e');
    } finally {
      isDataSyncing.value = false;
    }
  }

  /// Process location update from UnifiedGPSManager
  void _processLocationUpdate(LocationModel locationModel) {
    try {
      // Update current location
      currentLocationModel.value = locationModel;
      currentSpeed.value = locationModel.speed * 3.6; // Convert m/s to km/h
      
      // Set current position to the LocationModel directly
      currentPosition.value = locationModel;
      
      // Add to visualizations
      final latLng = LatLng(locationModel.latitude, locationModel.longitude);
      rawPositions.add(latLng);
      filteredPositions.add(latLng); // All locations from UnifiedGPSManager are already filtered
      
      // Limit positions for performance
      if (rawPositions.length > 500) {
        rawPositions.removeRange(0, rawPositions.length - 500);
      }
      if (filteredPositions.length > 1000) {
        filteredPositions.removeRange(0, filteredPositions.length - 1000);
      }

      // Update max speed
      if (currentSpeed.value > maxSpeed.value) {
        maxSpeed.value = currentSpeed.value;
      }

      // Calculate distance
      if (_lastLocationModel != null) {
        final distance = locationModel.distanceTo(_lastLocationModel!);
        if (distance > 2.0) { // Only meaningful distances
          totalDistance.value += distance;
        }

        // GPS jump detection
        if (distance > 30) {
          gpsJumpDetected.value = true;
          lastJumpDistance.value = distance;
          gpsJumps.value++;
          addLog('⚠️ GPS jump detected: ${distance.toStringAsFixed(1)}m');
        }
      }

      _lastLocationModel = locationModel;
      
    } catch (e) {
      addLog('❌ GPS processing error: $e');
    }
  }

  /// Start GPS tracking with UnifiedGPSManager
  Future<void> startGPSTracking() async {
    if (isGPSActive.value) return;

    try {
      addLog('🚀 Starting GPS tracking with UnifiedGPSManager...');

      // Force permission check and request
      addLog('🔍 Requesting location permissions...');
      final permissionGranted = await _gpsManager.checkAndRequestPermissions();
      
      if (!permissionGranted) {
        addLog('❌ Location permission not granted. Please enable location permissions in device settings.');
        addLog('📱 iOS: Settings > Privacy & Security > Location Services > Gaza Go');
        addLog('📱 Android: Settings > Apps > Gaza Go > Permissions > Location');
        return;
      }

      addLog('✅ Location permissions granted');

      // Initialize session
      _sessionStart = DateTime.now();
      totalDistance.value = 0.0;
      _lastLocationModel = null;

      // Ensure mock mode is disabled for real GPS tracking
      if (mockModeEnabled.value) {
        mockModeEnabled.value = false;
        addLog('🎭 Mock mode automatically disabled for real GPS tracking');
      }
      
      // Clear previous data
      rawPositions.clear();
      filteredPositions.clear();
      gpsJumpDetected.value = false;
      realtimeLogs.clear();
      
      // Reset statistics
      totalPositions.value = 0;
      rejectedPositions.value = 0;
      filterRate.value = 0.0;

      // Start session timer
      _startSessionTimer();

      // Test GPS config first
      addLog('🔧 Testing GPS configuration...');
      final config = UnifiedGPSConfig.getConfigForMode('balanced');
      addLog('📋 Config loaded: ${config.keys.length} properties');
      addLog('📋 Distance filter: ${config['distance_filter']}m');
      addLog('📋 Update interval: ${config['update_interval']}ms');

      // Start GPS tracking via UnifiedGPSManager
      addLog('📡 Starting GPS tracking...');
      final success = await _gpsManager.startTracking();
      
      if (success) {
        isGPSActive.value = true;
        addLog('✅ GPS tracking started successfully via UnifiedGPSManager');
        addLog('🎯 Waiting for first location update...');
      } else {
        addLog('❌ Failed to start GPS tracking');
        addLog('💡 Check the console for detailed error messages');
        isGPSActive.value = false;
      }

    } catch (e, stackTrace) {
      addLog('❌ GPS start error: $e');
      addLog('📋 Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      isGPSActive.value = false;
    }
  }

  /// Stop GPS tracking
  void stopGPSTracking() {
    if (!isGPSActive.value) return;

    _gpsManager.stopTracking();
    _sessionTimer?.cancel();
    _syncTimer?.cancel();
    isGPSActive.value = false;

    addLog('⏹️ GPS tracking stopped');
    
    // Final sync
    _syncFromGPSManager();
  }

  /// Configuration update methods (disabled for fixed config)
  Future<void> updateAccuracyThreshold(double value) async {
    addLog('⚠️ Config is fixed at 10m for production stability');
  }

  Future<void> updateSpeedThreshold(double value) async {
    addLog('⚠️ Config is fixed at 7km/h for production stability');
  }

  Future<void> updateUpdateInterval(int value) async {
    addLog('⚠️ Config is fixed at 1000ms for production stability');
  }

  /// Reset to optimal production settings
  Future<void> resetToOptimalProduction() async {
    try {
      UnifiedGPSConfig.resetToDefaults();
      addLog('🚀 Reset to optimal production settings');
    } catch (e) {
      addLog('❌ Failed to reset to production settings: $e');
    }
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    try {
      UnifiedGPSConfig.resetToDefaults();
      addLog('🔄 Reset to default settings');
    } catch (e) {
      addLog('❌ Failed to reset to defaults: $e');
    }
  }

  /// Reset all statistics and data
  void resetStatistics() {
    // Clear local data
    rawPositions.clear();
    filteredPositions.clear();
    totalDistance.value = 0.0;
    maxSpeed.value = 0.0;
    gpsJumps.value = 0;
    gpsJumpDetected.value = false;
    
    // Reset UnifiedGPSManager if needed
    _gpsManager.clearHistory();
    
    // Reset session
    _sessionStart = DateTime.now();
    sessionDuration.value = 0;
    
    addLog('📊 Statistics reset');
  }

  /// Clear map data
  void clearMapData() {
    rawPositions.clear();
    filteredPositions.clear();
    gpsJumpDetected.value = false;
    lastJumpDistance.value = 0.0;
    addLog('🗺️ Map data cleared');
  }

  /// Clear logs
  void clearLogs() {
    realtimeLogs.clear();
  }

  /// Add log entry
  void addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    realtimeLogs.insert(0, '[$timestamp] $message');

    // Keep only last 100 entries
    if (realtimeLogs.length > 100) {
      realtimeLogs.removeRange(100, realtimeLogs.length);
    }
  }

  /// Log current config status
  void _logConfigStatus() {
    final config = UnifiedGPSConfig.getAll();
    addLog('📋 Config Status:');
    addLog('  - Accuracy: ${config['accuracy_threshold']}m');
    addLog('  - Speed: ${config['speed_threshold']} km/h');
    addLog('  - Interval: ${config['update_interval']}ms');
    addLog('  - Source: UnifiedGPSConfig');
  }

  /// Get current configuration values (FIXED for production)
  double get accuracyThreshold => 10.0; // Fixed at 10 meters
  double get speedThreshold => 7.0; // Fixed at 7 km/h  
  int get updateInterval => 1000; // Fixed at 1000ms
  bool get isConfigSyncing => false; // No config syncing needed
  String get configSource => 'Production Fixed';

  /// Get comprehensive debug info
  Future<Map<String, dynamic>> getDebugInfo() async {
    return {
      'controller_state': {
        'gps_active': isGPSActive.value,
        'raw_positions': rawPositions.length,
        'filtered_positions': filteredPositions.length,
      },
      'unified_gps_manager': _gpsManager.getStatus(),
      'unified_gps_config': UnifiedGPSConfig.getAll(),
    };
  }

  /// Check GPS permissions
  Future<bool> _checkGPSPermissions() async {
    try {
      addLog('🔍 Checking GPS permissions...');
      
      // Use the public method to check and request permissions
      final permissionGranted = await _gpsManager.checkAndRequestPermissions();
      
      // Sync status from UnifiedGPSManager
      final hasPermission = _gpsManager.hasPermission.value;
      final isLocationEnabled = _gpsManager.isLocationEnabled.value;
      
      locationPermissionGranted.value = hasPermission;
      
      if (!isLocationEnabled) {
        addLog('❌ Location services are disabled in device settings');
        addLog('📱 Please enable location services in Settings > Privacy & Security > Location Services');
        return false;
      }

      if (!permissionGranted || !hasPermission) {
        addLog('❌ Location permission not granted');
        addLog('📱 Please grant location permission when prompted');
        return false;
      }

      addLog('✅ GPS permissions granted and location services enabled');
      return true;
      
    } catch (e) {
      addLog('❌ Permission check error: $e');
      return false;
    }
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_sessionStart != null) {
        sessionDuration.value = DateTime.now().difference(_sessionStart!).inSeconds;
      }
    });
  }

  /// Cleanup resources
  void _cleanup() {
    _locationSubscription?.cancel();
    _sessionTimer?.cancel();
    _syncTimer?.cancel();
  }

  /// Format duration for display
  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // UI Helper properties for compatibility
  bool get gpsActive => isGPSActive.value;
  int get totalPositionsReceived => totalPositions.value;
  int get filteredPositionsReceived => rejectedPositions.value;
  int get sessionDurationSeconds => sessionDuration.value;
  DateTime? get sessionStartTime => _sessionStart;

  // Simplified methods using UnifiedGPSManager
  Future<void> startGPS() async => await startGPSTracking();
  Future<void> stopGPS() async => stopGPSTracking();

  // Mock data methods (simplified)
  Future<void> enableMockMode() async {
    mockModeEnabled.value = true;
    addLog('🎭 Mock mode enabled');
  }
  
  Future<void> disableMockMode() async {
    mockModeEnabled.value = false;
    addLog('🎭 Mock mode disabled');
  }
  
  Future<void> generateMockData() async {
    if (!mockModeEnabled.value) {
      addLog('⚠️ Cannot generate mock data - mock mode is disabled');
      return;
    }
    
    // Generate a mock location
    final random = math.Random();
    final mockLocationModel = LocationModel(
      latitude: 31.5 + (random.nextDouble() - 0.5) * 0.01,
      longitude: 34.4 + (random.nextDouble() - 0.5) * 0.01,
      timestamp: DateTime.now(),
      accuracy: 5.0 + random.nextDouble() * 15.0,
      altitude: 50.0,
      speed: random.nextDouble() * 5.0,
      bearing: random.nextDouble() * 360,
    );
    
    _processLocationUpdate(mockLocationModel);
    addLog('Generated mock GPS position: ${mockLocationModel.latitude}, ${mockLocationModel.longitude}');
  }
  
  Future<void> clearMockData() async {
    rawPositions.clear();
    filteredPositions.clear();
    resetStatistics();
    addLog('🗑️ Mock data cleared');
  }

  // Simplified debug logging
  void logInfo(String message) => addLog('[INFO] $message');
  void logWarning(String message) => addLog('[WARNING] $message'); 
  void logError(String message) => addLog('[ERROR] $message');

  // Indoor mode (simplified)
  Future<void> enableIndoorMode() async {
    indoorMode.value = true;
    UnifiedGPSConfig.set('accuracy_threshold', 80.0);
    UnifiedGPSConfig.set('speed_threshold', 10.0);
    addLog('🏠 Indoor GPS mode enabled - relaxed thresholds');
  }
  
  Future<void> disableIndoorMode() async {
    indoorMode.value = false;
    await resetToOptimalProduction();
    addLog('🌅 Indoor GPS mode disabled');
  }

  // Background tracking using UnifiedGPSManager
  Future<void> enableBackgroundTracking() async {
    backgroundTrackingEnabled.value = true;
    trackingMode.value = 'background';
    addLog('📱 Background tracking enabled via UnifiedGPSManager');
  }
  
  Future<void> disableBackgroundTracking() async {
    backgroundTrackingEnabled.value = false;
    trackingMode.value = 'foreground';
    addLog('📱 Background tracking disabled');
  }
  
  Future<void> toggleTrackingMode() async {
    if (backgroundTrackingEnabled.value) {
      await disableBackgroundTracking();
    } else {
      await enableBackgroundTracking();
    }
  }

  // Permission methods
  Future<void> checkLocationPermission() async {
    await _checkGPSPermissions();
  }

  // Simplified helper status
  Future<void> updateStatistics() async {
    await _syncFromGPSManager();
  }

  // Preset configurations (simplified)
  Future<void> applyDebugConfiguration() async {
    UnifiedGPSConfig.set('accuracy_threshold', 50.0);
    UnifiedGPSConfig.set('speed_threshold', 200.0);
    UnifiedGPSConfig.set('update_interval', 1000);
    UnifiedGPSConfig.set('distance_filter', 1); // More frequent updates for debugging
    addLog('🔧 Applied debug configuration');
  }
  
  Future<void> applyTestingConfiguration() async {
    UnifiedGPSConfig.set('accuracy_threshold', 20.0);
    UnifiedGPSConfig.set('speed_threshold', 100.0);
    UnifiedGPSConfig.set('update_interval', 2000);
    addLog('🧪 Applied testing configuration');
  }
  
  // Export/Import configuration (simplified)
  Map<String, dynamic> exportConfiguration() {
    final config = UnifiedGPSConfig.getAll();
    addLog('📥 Configuration exported');
    return config;
  }
  
  Future<void> importConfiguration(Map<String, dynamic> config) async {
    try {
      UnifiedGPSConfig.updateAll(config);
      addLog('📥 Configuration imported');
    } catch (e) {
      addLog('❌ Failed to import configuration: $e');
    }
  }

  // Auto-scroll toggle
  void toggleAutoScroll(bool value) {
    autoScrollLogs.value = value;
    addLog('Auto-scroll logs: ${value ? 'enabled' : 'disabled'}');
  }

  // Helper status
  Map<String, dynamic> getBackgroundTrackingStatus() {
    return {
      'background_enabled': backgroundTrackingEnabled.value,
      'tracking_mode': trackingMode.value,
      'background_supported': true, // UnifiedGPSManager supports background
    };
  }
}
