import 'package:gaza_go/platform/firebase/remote_config.dart';

/// Unified GPS Configuration - Single source of truth for all GPS settings
/// Maximum accuracy and performance optimized settings - NO battery saving
/// Designed to eliminate GPS jumping and provide smooth tracking like Strava
class UnifiedGPSConfig {
  static final Map<String, dynamic> _defaultConfig = {
    // === URBAN WALKING OPTIMIZED SETTINGS ===
    // Optimized for weak GPS signals in urban environments - Faster updates for less delay
    'accuracy_threshold':
        25.0, // meters - Balanced threshold for urban environments
    'speed_threshold': 50.0, // km/h - Higher speed threshold to avoid false rejections
    'distance_filter': 2, // meters - Reduced for better sensitivity to movement
    'update_interval':
        900, // milliseconds - Faster updates to reduce delay (was 1200)
    'min_time_interval': 0.6, // seconds - Faster response (was 0.8)

    // === STATIONARY DETECTION (FIX FOR STANDING STILL JUMPING) ===
    'stationary_detection_enabled': true, // Re-enabled with lenient settings
    'stationary_speed_threshold':
        0.5, // m/s - Less sensitive to allow small movements in urban areas
    'stationary_distance_threshold':
        2.0, // meters - Allow more movement tolerance in urban areas
    'stationary_time_threshold':
        8.0, // seconds - Longer time before considering stationary to reduce filtering
    'stationary_accuracy_threshold':
        20.0, // meters - More lenient accuracy when stationary to accept weaker signals
    'stationary_filter_aggressive': false, // Less aggressive filtering for urban environments

    // === FILTERING & SMOOTHING - URBAN MULTIPATH RESISTANT ===
    'enable_filtering': true, // Enable advanced filtering
    'max_history_size': 25, // Increased for better smoothing/kalman context
    'smoothing_window': 2, // MINIMAL smoothing to preserve path accuracy
    'outlier_threshold': 1.8, // STRICTER outlier detection
    'smoothing_weight_new': 0.8, // Reduced weight for new location (80%)
    'smoothing_weight_history': 0.2, // Increased weight for history (20%)

    // === JUMP DETECTION - URBAN WALKING OPTIMIZED ===
    'jump_detection_enabled': true,
    'max_jump_distance': 35.0, // meters - Reasonable jump threshold for urban walking
    'jump_detection_time': 10.0, // seconds - Wide window to catch jumps
    'consecutive_jump_limit': 2, // Standard tolerance for consecutive jumps

    // === GPS ACCURACY ENFORCEMENT ===
    'force_high_accuracy': true, // Force bestForNavigation accuracy
    'reject_low_accuracy': false, // Accept positions with poorer accuracy in urban environments
    'accuracy_improvement_wait': 5.0, // Wait longer for accuracy improvement
    'gps_warmup_enabled':
        true, // Enable GPS warm-up for better initial accuracy
    'gps_warmup_duration': 15.0, // Longer warm-up period for better initial accuracy

    // === BATTERY OPTIMIZATION - DISABLED ===
    'enable_battery_optimization': false, // FORCE GPS at maximum performance
    'battery_threshold_high': 100, // Never reduce GPS performance
    'battery_threshold_low': 100, // Never reduce GPS performance
    'power_save_mode': false, // Always high performance mode

    // === ANDROID SPECIFIC ===
    'android_wait_for_accurate': true, // Wait for accurate location on Android

    // === ENHANCED DISTANCE FILTERING - URBAN OPTIMIZED ===
    'min_distance_fixed': 1.0, // Reasonable minimum distance to avoid noise (was 0.5)
    'min_distance_accuracy_factor':
        0.08, // Lower factor to reduce over-filtering (was 0.1)

    // === BACKGROUND TRACKING - FUSED PROVIDER ENABLED ===
    'enable_background_tracking': true,
    'foreground_notification_enabled': true,
    'wake_lock_enabled': true, // Keep CPU awake for GPS
    'use_network_fallback':
        true, // Enable fused provider for urban indoor/outdoor

    // === PERFORMANCE MONITORING ===
    'performance_monitoring_enabled': true,
    'performance_monitoring_interval': 15, // Check every 15 seconds
    'auto_gps_reset_enabled': true, // Auto reset GPS if performance degrades
    'gps_reset_threshold': 30.0, // Reset if accuracy > 30m for extended period

    // === ERROR RECOVERY ===
    'auto_fallback': true,
    'max_retry_attempts': 3, // More retries for accuracy
    'error_recovery_delay': 5000, // 5 second recovery delay
    'location_timeout': 15000, // 15 second timeout for location requests

    // === LEGACY COMPATIBILITY ===
    'abuse_radius': 50.0, // meters
    'abuse_inside_radius_ratio': 80.0, // percentage
    'abuse_report_time': 600.0, // seconds
  };

  // Current configuration (starts with defaults, updated by remote config)
  static Map<String, dynamic> _currentConfig =
      Map<String, dynamic>.from(_defaultConfig);

  // Remote config management
  static DateTime? _lastRemoteConfigFetch;
  static const int _remoteConfigCacheSeconds = 3600; // 1 hour cache

  /// Initialize GPS configuration
  static void initialize() {
    _currentConfig = Map<String, dynamic>.from(_defaultConfig);
    print('GPS Config initialized with maximum accuracy settings');
  }

  /// Update configuration from Firebase Remote Config
  static Future<void> loadFromRemoteConfig() async {
    try {
      final now = DateTime.now();

      // Check cache validity
      if (_lastRemoteConfigFetch != null &&
          now.difference(_lastRemoteConfigFetch!).inSeconds <
              _remoteConfigCacheSeconds) {
        print('Using cached remote GPS config');
        return;
      }

      print('Loading GPS config from Firebase Remote Config...');

      // Core GPS settings
      _updateConfigFromRemote(
          'gps_accuracy_threshold', 'accuracy_threshold', ConfigType.double);
      _updateConfigFromRemote(
          'gps_speed_threshold', 'speed_threshold', ConfigType.double);
      _updateConfigFromRemote(
          'gps_distance_filter', 'distance_filter', ConfigType.int);
      _updateConfigFromRemote(
          'gps_update_interval', 'update_interval', ConfigType.int);
      _updateConfigFromRemote('gps_filter_min_time_interval',
          'min_time_interval', ConfigType.double);

      // Stationary detection
      _updateConfigFromRemote('gps_stationary_detection',
          'stationary_detection_enabled', ConfigType.bool);
      _updateConfigFromRemote('gps_stationary_speed_threshold',
          'stationary_speed_threshold', ConfigType.double);
      _updateConfigFromRemote('gps_stationary_distance_threshold',
          'stationary_distance_threshold', ConfigType.double);
      _updateConfigFromRemote('gps_stationary_accuracy_threshold',
          'stationary_accuracy_threshold', ConfigType.double);

      // Advanced settings
      _updateConfigFromRemote(
          'enable_advanced_gps_filtering', 'enable_filtering', ConfigType.bool);
      _updateConfigFromRemote(
          'gps_filter_history_size', 'max_history_size', ConfigType.int);
      _updateConfigFromRemote(
          'gps_smoothing_window', 'smoothing_window', ConfigType.int);

      // Jump detection
      _updateConfigFromRemote('gps_jump_detection_enabled',
          'jump_detection_enabled', ConfigType.bool);
      _updateConfigFromRemote(
          'gps_max_jump_distance', 'max_jump_distance', ConfigType.double);

      // Battery optimization (should stay disabled)
      _updateConfigFromRemote('enable_battery_gps_optimization',
          'enable_battery_optimization', ConfigType.bool);

      _lastRemoteConfigFetch = now;
      print('Remote GPS config loaded successfully');
    } catch (e) {
      print('Failed to load remote GPS config, using defaults: $e');
      // Keep current config on error
    }
  }

  /// Helper to update config from remote with type safety
  static void _updateConfigFromRemote(
      String remoteKey, String localKey, ConfigType dataType,
      {dynamic Function(dynamic)? transform}) {
    try {
      final remoteValue = getConfig(dataType: dataType, configKey: remoteKey);
      if (remoteValue != null) {
        final finalValue =
            transform != null ? transform(remoteValue) : remoteValue;
        _currentConfig[localKey] = finalValue;
        print('Config updated: $localKey = $finalValue (from $remoteKey)');
      }
    } catch (e) {
      print('Failed to update config $localKey from $remoteKey: $e');
    }
  }

  /// Get configuration value with type safety
  static T get<T>(String key, {T? defaultValue}) {
    final value = _currentConfig[key] ?? defaultValue ?? _defaultConfig[key];
    if (value is T) {
      return value;
    }

    // Type conversion fallback
    if (T == double && value is num) {
      return value.toDouble() as T;
    }
    if (T == int && value is num) {
      return value.toInt() as T;
    }
    if (T == bool && value is bool) {
      return value as T;
    }

    throw ArgumentError('Cannot convert $value to type $T for key $key');
  }

  /// Update configuration programmatically
  static void updateConfig(Map<String, dynamic> updates) {
    _currentConfig.addAll(updates);
    print('GPS Config updated: ${updates.keys.join(', ')}');
  }

  /// Update all configuration
  static void updateAll(Map<String, dynamic> newConfig) {
    _currentConfig = Map<String, dynamic>.from(_defaultConfig);
    _currentConfig.addAll(newConfig);
    print('GPS Config completely updated with ${newConfig.length} settings');
  }

  /// Get current configuration
  static Map<String, dynamic> get currentConfig =>
      Map<String, dynamic>.from(_currentConfig);

  /// Reset to default configuration
  static void resetToDefaults() {
    _currentConfig = Map<String, dynamic>.from(_defaultConfig);
    print('GPS Config reset to maximum accuracy defaults');
  }

  /// Validate current configuration
  static List<String> validateConfig() {
    final errors = <String>[];

    if (get<double>('accuracy_threshold') <= 0 ||
        get<double>('accuracy_threshold') > 100) {
      errors.add('accuracy_threshold must be between 0 and 100 meters');
    }

    if (get<double>('speed_threshold') <= 0 ||
        get<double>('speed_threshold') > 200) {
      errors.add('speed_threshold must be between 0 and 200 km/h');
    }

    if (get<int>('update_interval') < 500 ||
        get<int>('update_interval') > 30000) {
      errors.add('update_interval must be between 500 and 30000 milliseconds');
    }

    if (get<double>('distance_filter') < 0 ||
        get<double>('distance_filter') > 100) {
      errors.add('distance_filter must be between 0 and 100 meters');
    }

    if (get<int>('max_history_size') < 3 ||
        get<int>('max_history_size') > 100) {
      errors.add('max_history_size must be between 3 and 100');
    }

    if (get<int>('smoothing_window') < 1 ||
        get<int>('smoothing_window') > get<int>('max_history_size')) {
      errors.add('smoothing_window must be between 1 and max_history_size');
    }

    return errors;
  }

  /// Get configuration optimized for specific activity type - MAXIMUM ACCURACY
  static Map<String, dynamic> getConfigForActivity(String activity) {
    final baseConfig = Map<String, dynamic>.from(_currentConfig);

    switch (activity.toLowerCase()) {
      case 'walking':
      case 'walk':
        // Walking: Optimized for urban environments with faster updates to reduce delay
        baseConfig.addAll({
          'distance_filter': 2, // Very sensitive to movement
          'update_interval': 2000,
          'speed_threshold': 50.0, // Higher threshold to avoid false rejections
          'smoothing_window': 2, // Minimal smoothing for accuracy
          'min_time_interval': 0.6, // Faster response timing (was 0.8)
          'accuracy_threshold': 25.0, // Accept moderate accuracy for walking
          'stationary_detection_enabled': true, // Enhanced stationary detection
          'stationary_speed_threshold': 0.5, // Less sensitive for urban noise
          'stationary_distance_threshold':
              2.0, // More tolerance for urban movement
          'max_jump_distance': 35.0, // Reasonable jump detection for urban walking
          'smoothing_weight_new': 0.8, // Balanced for responsiveness
          'smoothing_weight_history': 0.2, // Balanced history weight
          'min_distance_fixed': 1.0, // Reasonable distance detection (was 2.0)
          'min_distance_accuracy_factor': 0.08, // Lower to reduce filtering (was 0.1)
        });
        break;

      case 'running':
      case 'run':
        // Running: Maximum responsiveness with accuracy
        baseConfig.addAll({
          'distance_filter': 2, // 2m for running responsiveness
          'update_interval': 1500, // 1.5 seconds for fast running updates
          'speed_threshold': 30.0, // 30 km/h max running speed
          'smoothing_window': 2, // Minimal smoothing for running accuracy
          'min_time_interval': 1.0, // 1 second for running responsiveness
          'accuracy_threshold': 10.0, // Good accuracy for running
          'stationary_detection_enabled': true, // Detect running stops
          'stationary_speed_threshold': 0.5, // Detect running pauses
          'max_jump_distance': 20.0, // Moderate jump detection for running
        });
        break;

      case 'hiking':
      case 'famous':
        // Hiking: Balance of accuracy and battery (but still high performance)
        baseConfig.addAll({
          'distance_filter': 3, // 3m for hiking
          'update_interval': 3000, // 3 seconds for hiking
          'speed_threshold': 20.0, // 20 km/h max hiking speed
          'smoothing_window': 3, // Slightly more smoothing for hiking paths
          'min_time_interval': 2.5, // 2.5 seconds for hiking
          'accuracy_threshold': 12.0, // Good accuracy for hiking
          'stationary_detection_enabled': true, // Detect hiking stops
          'stationary_speed_threshold': 0.4, // Sensitive to hiking pauses
          'max_jump_distance':
              25.0, // Moderate jump detection for varied terrain
        });
        break;

      case 'cycling':
      case 'bike':
      case 'cycle':
        // Cycling: High speed with maximum accuracy
        baseConfig.addAll({
          'distance_filter': 5, // 5m for cycling speeds
          'update_interval': 1000, // 1 second for cycling responsiveness
          'speed_threshold': 60.0, // 60 km/h max cycling speed
          'smoothing_window': 2, // Minimal smoothing for cycling accuracy
          'min_time_interval': 0.8, // 0.8 seconds for fast cycling updates
          'accuracy_threshold': 8.0, // High accuracy for cycling paths
          'stationary_detection_enabled': true, // Detect cycling stops
          'stationary_speed_threshold':
              1.0, // 1 m/s threshold for cycling stops
          'max_jump_distance': 40.0, // Higher jump detection for cycling speeds
        });
        break;

      default:
        // Use running config as default for fitness activities
        baseConfig.addAll({
          'distance_filter': 2,
          'update_interval': 2000,
          'speed_threshold': 30.0,
          'smoothing_window': 2,
          'min_time_interval': 1.5,
          'accuracy_threshold': 10.0,
          'stationary_detection_enabled': true,
          'stationary_speed_threshold': 0.5,
          'max_jump_distance': 20.0,
        });
        print(
            'Unknown activity: $activity, using enhanced running config as default');
    }

    return baseConfig;
  }

  /// Get configuration for different GPS modes - MAXIMUM PERFORMANCE FOCUS
  static Map<String, dynamic> getConfigForMode(String mode) {
    final baseConfig = Map<String, dynamic>.from(_currentConfig);

    switch (mode.toLowerCase()) {
      case 'high_accuracy':
      case 'maximum':
      case 'high_performance':
        // High accuracy mode optimized for fast response and reduced delay
        baseConfig.addAll({
          'accuracy_threshold': 12.0, // Urban-friendly accuracy threshold
          'distance_filter': 3, // Sensitive distance filter for fast response (was 5)
          'update_interval': 1000, // Faster updates for high accuracy (was 1500)
          'min_time_interval': 0.7, // Faster minimum interval (was 1.0)
          'smoothing_window': 2, // Light smoothing for urban multipath
          'max_jump_distance': 25.0, // Urban jump detection
          'stationary_accuracy_threshold':
              10.0, // Urban-friendly when stationary
          'smoothing_weight_new': 0.8, // Balanced for urban multipath
          'smoothing_weight_history': 0.2, // Increased history consideration
          'min_distance_fixed': 1.0, // Reasonable filtering
          'min_distance_accuracy_factor': 0.08, // Lower to reduce over-filtering
        });
        break;

      case 'background':
        // Background mode - relaxed for stability when running in background
        baseConfig.addAll({
          'accuracy_threshold': 18.0, // More lenient for background
          'distance_filter': 9, // Wider filter for background stability
          'update_interval': 3500, // 3.5 second updates for background
          'min_time_interval': 2.5, // 2.5 second minimum interval
          'smoothing_window': 3, // More smoothing for background
          'max_jump_distance': 30.0, // More lenient jump detection
          'stationary_accuracy_threshold': 15.0, // More lenient when stationary
          'smoothing_weight_new': 0.7, // Reduced for background stability
          'smoothing_weight_history': 0.3, // Increased history weight
        });
        break;

      case 'power_saving':
        // Power saving mode - conservative settings
        baseConfig.addAll({
          'accuracy_threshold': 25.0, // Very lenient for power saving
          'distance_filter': 12, // Wide filter for power saving
          'update_interval': 5000, // 5 second updates for power saving
          'min_time_interval': 3.0, // 3 second minimum interval
          'smoothing_window': 4, // Heavy smoothing for power saving
          'max_jump_distance': 40.0, // Very lenient jump detection
          'stationary_accuracy_threshold': 20.0, // Very lenient when stationary
          'smoothing_weight_new': 0.6, // Reduced for power saving
          'smoothing_weight_history': 0.4, // Heavy history weight
        });
        break;

      case 'balanced':
      case 'activity_tracking':
      default:
        // Urban walking balanced mode (default) - Very lenient for weak signals
        baseConfig.addAll({
          'accuracy_threshold': 20.0, // Accept moderate accuracy for balanced mode
          'distance_filter': 4, // More sensitive to movement
          'update_interval': 1500, // Faster updates
          'min_time_interval': 0.8, // Shorter minimum interval
          'smoothing_window': 2, // Minimal smoothing
          'max_jump_distance': 45.0, // More lenient jump detection
          'stationary_accuracy_threshold':
              25.0, // More lenient when stationary
          'smoothing_weight_new': 0.8, // Balanced for urban multipath
          'smoothing_weight_history': 0.2, // History consideration
        });
        break;
    }

    return baseConfig;
  }

  /// Get debug information about current configuration
  static Map<String, dynamic> getDebugInfo() {
    final validationErrors = validateConfig();

    return {
      'current_config': _currentConfig,
      'default_config': _defaultConfig,
      'last_remote_fetch': _lastRemoteConfigFetch?.toIso8601String(),
      'validation_errors': validationErrors,
      'config_source': _lastRemoteConfigFetch != null ? 'remote' : 'default',
      'cache_expiry': _lastRemoteConfigFetch
          ?.add(const Duration(seconds: _remoteConfigCacheSeconds))
          .toIso8601String(),
    };
  }

  // Convenient getters for commonly used values
  static double get accuracyThreshold => get<double>('accuracy_threshold');
  static double get speedThreshold => get<double>('speed_threshold');
  static double get distanceFilter => get<double>('distance_filter');
  static int get updateInterval => get<int>('update_interval');
  static double get minTimeInterval => get<double>('min_time_interval');
  static bool get enableFiltering => get<bool>('enable_filtering');
  static int get maxHistorySize => get<int>('max_history_size');
  static int get smoothingWindow => get<int>('smoothing_window');
  static bool get jumpDetectionEnabled => get<bool>('jump_detection_enabled');
  static double get maxJumpDistance => get<double>('max_jump_distance');
  static bool get stationaryDetectionEnabled =>
      get<bool>('stationary_detection_enabled');
  static double get stationarySpeedThreshold =>
      get<double>('stationary_speed_threshold');
  static double get stationaryDistanceThreshold =>
      get<double>('stationary_distance_threshold');
  static double get stationaryAccuracyThreshold =>
      get<double>('stationary_accuracy_threshold');

  // Battery and distance filtering getters
  static int get batteryHighThreshold => get<int>('battery_threshold_high');
  static int get batteryLowThreshold => get<int>('battery_threshold_low');
  static double get minDistanceFixed => get<double>('min_distance_fixed');
  static double get minDistanceAccuracyFactor =>
      get<double>('min_distance_accuracy_factor');
  static double get smoothingWeightNew => get<double>('smoothing_weight_new');
  static double get smoothingWeightHistory =>
      get<double>('smoothing_weight_history');

  // Alias for backward compatibility
  static bool get filteringEnabled => enableFiltering;

  /// Print current configuration for debugging
  static void printConfig([String? context]) {
    print('=== GPS CONFIG ${context != null ? '($context)' : ''} ===');
    _currentConfig.forEach((key, value) {
      print('$key: $value');
    });
    print('=====================================');
  }
}
