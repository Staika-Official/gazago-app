import 'package:gaza_go/platform/firebase/remote_config.dart';

/// Unified GPS Configuration - Single source of truth for all GPS settings
/// Maximum accuracy and performance optimized settings - NO battery saving
/// Designed to eliminate GPS jumping and provide smooth tracking like Strava
class UnifiedGPSConfig {
  static final Map<String, dynamic> _defaultConfig = {
    // === URBAN WALKING OPTIMIZED SETTINGS ===
    // Optimized for urban walking with multipath resistance
    'accuracy_threshold':
        15.0, // meters - Relaxed for urban multipath tolerance
    'speed_threshold': 7.0, // km/h - Maximum walking speed as requested
    'distance_filter': 6, // meters - Wider threshold to avoid multipath noise
    'update_interval':
        1750, // milliseconds - Balanced for urban walking smoothness
    'min_time_interval': 1.2, // seconds - Balanced update timing

    // === STATIONARY DETECTION (FIX FOR STANDING STILL JUMPING) ===
    'stationary_detection_enabled': true, // Enable stationary detection
    'stationary_speed_threshold':
        0.5, // m/s - if speed < 0.5 m/s consider stationary
    'stationary_distance_threshold':
        1.0, // meters - if distance < 1m consider stationary
    'stationary_time_threshold':
        5.0, // seconds - must be stationary for 5s before filtering
    'stationary_accuracy_threshold':
        8.0, // meters - when stationary, only accept very accurate positions
    'stationary_filter_aggressive': true, // Aggressively filter when stationary

    // === FILTERING & SMOOTHING - URBAN MULTIPATH RESISTANT ===
    'enable_filtering': true, // Enable advanced filtering
    'max_history_size': 15, // Keep recent history for better filtering
    'smoothing_window': 2, // MINIMAL smoothing to preserve path accuracy
    'outlier_threshold': 1.8, // STRICTER outlier detection
    'smoothing_weight_new': 0.8, // Reduced weight for new location (80%)
    'smoothing_weight_history': 0.2, // Increased weight for history (20%)

    // === JUMP DETECTION - URBAN WALKING OPTIMIZED ===
    'jump_detection_enabled': true,
    'max_jump_distance': 28.0, // meters - Urban walking jump threshold
    'jump_detection_time': 5.0, // seconds - 5 second window for jump detection
    'consecutive_jump_limit': 2, // max 2 consecutive jumps before GPS reset

    // === GPS ACCURACY ENFORCEMENT ===
    'force_high_accuracy': true, // Force bestForNavigation accuracy
    'reject_low_accuracy': true, // Reject positions with poor accuracy
    'accuracy_improvement_wait': 3.0, // Wait 3s for accuracy improvement
    'gps_warmup_enabled':
        true, // Enable GPS warm-up for better initial accuracy
    'gps_warmup_duration': 10.0, // 10 second warm-up period

    // === BATTERY OPTIMIZATION - DISABLED ===
    'enable_battery_optimization': false, // FORCE GPS at maximum performance
    'battery_threshold_high': 100, // Never reduce GPS performance
    'battery_threshold_low': 100, // Never reduce GPS performance
    'power_save_mode': false, // Always high performance mode

    // === ANDROID SPECIFIC ===
    'android_wait_for_accurate': true, // Wait for accurate location on Android

    // === ENHANCED DISTANCE FILTERING - URBAN OPTIMIZED ===
    'min_distance_fixed': 5.0, // Fixed minimum distance - wider for urban noise
    'min_distance_accuracy_factor':
        0.4, // Reduced factor for urban multipath tolerance

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
        // Walking: Urban optimized with multipath resistance
        baseConfig.addAll({
          'distance_filter': 7, // 7m for urban walking multipath tolerance
          'update_interval': 1750, // 1.75 seconds for urban walking
          'speed_threshold': 7.0, // 7 km/h max walking speed as requested
          'smoothing_window': 2, // Minimal smoothing for accuracy
          'min_time_interval': 1.2, // 1.2 seconds for urban walking
          'accuracy_threshold': 16.0, // Relaxed accuracy for urban multipath
          'stationary_detection_enabled': true, // Enhanced stationary detection
          'stationary_speed_threshold': 0.4, // Balanced stationary detection
          'stationary_distance_threshold':
              1.2, // Slightly wider distance when stationary
          'max_jump_distance': 28.0, // Urban walking jump threshold
          'smoothing_weight_new': 0.75, // Reduced new weight for urban
          'smoothing_weight_history': 0.25, // Increased history weight
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
        // Urban walking optimized maximum accuracy mode
        baseConfig.addAll({
          'accuracy_threshold': 12.0, // Urban-friendly accuracy threshold
          'distance_filter': 5, // Urban multipath resistant distance filter
          'update_interval': 1500, // 1.5 second updates for urban
          'min_time_interval': 1.0, // 1 second minimum interval
          'smoothing_window': 2, // Light smoothing for urban multipath
          'max_jump_distance': 25.0, // Urban jump detection
          'stationary_accuracy_threshold':
              10.0, // Urban-friendly when stationary
          'smoothing_weight_new': 0.8, // Balanced for urban multipath
          'smoothing_weight_history': 0.2, // Increased history consideration
        });
        break;

      case 'background':
        // Background mode - still high accuracy but slightly more conservative
        baseConfig.addAll({
          'accuracy_threshold': 15.0, // Accept 15m accuracy
          'distance_filter': 3, // 3m distance filter
          'update_interval': 3000, // 3 second updates
          'min_time_interval': 2.0, // 2 second minimum interval
          'smoothing_window': 3, // Light smoothing
          'max_jump_distance': 25.0, // Moderate jump detection
          'stationary_accuracy_threshold': 10.0, // Moderate when stationary
        });
        break;

      case 'balanced':
      case 'activity_tracking':
      default:
        // Urban walking balanced mode (default)
        baseConfig.addAll({
          'accuracy_threshold': 15.0, // Urban-friendly accuracy
          'distance_filter': 6, // Urban multipath resistant
          'update_interval': 1750, // Balanced urban walking updates
          'min_time_interval': 1.2, // Balanced minimum interval
          'smoothing_window': 2, // Minimal smoothing
          'max_jump_distance': 28.0, // Urban walking jump detection
          'stationary_accuracy_threshold':
              12.0, // Urban-friendly when stationary
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
  static double get smoothing_weight_new => get<double>('smoothing_weight_new');
  static double get smoothing_weight_history =>
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
