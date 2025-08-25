import 'package:gaza_go/platform/firebase/remote_config.dart';

/// Unified GPS Configuration - Single source of truth for all GPS settings
/// Replaces scattered GPS configs and provides centralized configuration management
class UnifiedGPSConfig {
  static final Map<String, dynamic> _defaultConfig = {
    // Core GPS Settings
    'accuracy_threshold': 30.0, // meters - maximum acceptable accuracy
    'speed_threshold': 50.0, // km/h - filter unrealistic speeds (teleportation)
    'distance_filter': 3, // meters (int) - minimum distance for location updates
    'update_interval': 2000, // milliseconds (int) - location update frequency
    'min_time_interval': 0.5, // seconds - minimum time between valid updates
    
    // Filtering & Smoothing
    'enable_filtering': true, // enable advanced GPS filtering
    'max_history_size': 10, // maximum location history to keep
    'smoothing_window': 3, // number of points for smoothing algorithm
    'outlier_threshold': 2.0, // standard deviations for outlier detection
    
    // Battery Optimization
    'battery_threshold_high': 50, // % - high performance threshold
    'battery_threshold_low': 20, // % - power saving threshold
    'enable_battery_optimization': true,
    
    // Performance & Recovery
    'auto_fallback': true, // enable automatic error recovery
    'max_retry_attempts': 3, // maximum recovery attempts
    'error_recovery_delay': 5000, // ms - delay before retry
    'performance_monitoring_interval': 10, // seconds
    
    // Advanced Settings
    'enable_background_tracking': true,
    'foreground_notification_enabled': true,
    'wake_lock_enabled': true,
    'use_network_fallback': true,
    
    // Abuse Detection (from legacy system)
    'abuse_radius': 50.0, // meters
    'abuse_inside_radius_ratio': 80.0, // percentage
    'abuse_report_time': 600.0, // seconds
    'max_coordinate_jump': 100.0, // meters - large jump detection
    'gps_jump_distance': 50.0, // meters - GPS jump detection
    'gps_jump_time': 5.0, // seconds - time threshold for jump detection
  };
  
  static Map<String, dynamic> _currentConfig = Map<String, dynamic>.from(_defaultConfig);
  static DateTime? _lastRemoteConfigFetch;
  static const int _remoteConfigCacheSeconds = 300; // 5 minutes

  /// Initialize configuration from remote config
  static Future<void> initialize() async {
    await _loadFromRemoteConfig();
    print('Unified GPS Config initialized: ${_currentConfig.toString()}');
  }

  /// Load configuration from Firebase Remote Config
  static Future<void> _loadFromRemoteConfig() async {
    try {
      // Check if we should fetch from remote (cache control)
      final now = DateTime.now();
      if (_lastRemoteConfigFetch != null &&
          now.difference(_lastRemoteConfigFetch!).inSeconds < _remoteConfigCacheSeconds) {
        print('Using cached remote config');
        return;
      }

      // Core GPS settings
      _updateConfigFromRemote('gps_accuracy_threshold', 'accuracy_threshold', ConfigType.double);
      _updateConfigFromRemote('gps_speed_threshold', 'speed_threshold', ConfigType.double);
      _updateConfigFromRemote('gps_distance_filter_meters', 'distance_filter', ConfigType.double);
      _updateConfigFromRemote('gps_update_interval_seconds', 'update_interval', ConfigType.double, 
          transform: (value) => (value * 1000).toInt()); // Convert to milliseconds
      _updateConfigFromRemote('gps_filter_min_time_interval', 'min_time_interval', ConfigType.double);
      
      // Advanced settings
      _updateConfigFromRemote('enable_advanced_gps_filtering', 'enable_filtering', ConfigType.bool);
      _updateConfigFromRemote('gps_filter_history_size', 'max_history_size', ConfigType.int);
      _updateConfigFromRemote('gps_smoothing_window', 'smoothing_window', ConfigType.int);
      
      // Battery optimization
      _updateConfigFromRemote('gps_battery_high_threshold', 'battery_threshold_high', ConfigType.int);
      _updateConfigFromRemote('gps_battery_low_threshold', 'battery_threshold_low', ConfigType.int);
      _updateConfigFromRemote('enable_battery_gps_optimization', 'enable_battery_optimization', ConfigType.bool);
      
      // Abuse detection (legacy)
      _updateConfigFromRemote('abuse_radius', 'abuse_radius', ConfigType.double);
      _updateConfigFromRemote('abuse_inside_radius_ratio', 'abuse_inside_radius_ratio', ConfigType.double);
      _updateConfigFromRemote('abuse_report_time', 'abuse_report_time', ConfigType.double);
      
      _lastRemoteConfigFetch = now;
      print('Remote GPS config loaded successfully');
      
    } catch (e) {
      print('Failed to load remote GPS config, using defaults: $e');
      // Keep current config on error
    }
  }

  /// Helper to update config from remote with type safety
  static void _updateConfigFromRemote(
    String remoteKey, 
    String localKey, 
    ConfigType dataType, 
    {dynamic Function(dynamic)? transform}
  ) {
    try {
      final remoteValue = getConfig(dataType: dataType, configKey: remoteKey);
      if (remoteValue != null) {
        final finalValue = transform != null ? transform(remoteValue) : remoteValue;
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
    if (T == bool && value is String) {
      return (value.toLowerCase() == 'true') as T;
    }
    
    throw ArgumentError('Config value $key has type ${value.runtimeType}, expected $T');
  }

  /// Set configuration value
  static void set(String key, dynamic value) {
    _currentConfig[key] = value;
    print('GPS Config updated: $key = $value');
  }

  /// Update multiple configuration values
  static void updateAll(Map<String, dynamic> updates) {
    _currentConfig.addAll(updates);
    print('GPS Config batch updated: $updates');
  }

  /// Get all current configuration
  static Map<String, dynamic> getAll() {
    return Map<String, dynamic>.from(_currentConfig);
  }

  /// Reset to default configuration
  static void resetToDefaults() {
    _currentConfig = Map<String, dynamic>.from(_defaultConfig);
    print('GPS Config reset to defaults');
  }

  /// Force refresh from remote config
  static Future<void> refresh() async {
    _lastRemoteConfigFetch = null; // Force refresh
    await _loadFromRemoteConfig();
  }

  /// Get configuration for specific GPS mode (high performance, balanced, power saving)
  static Map<String, dynamic> getConfigForMode(String mode) {
    final baseConfig = Map<String, dynamic>.from(_currentConfig);
    
    switch (mode.toLowerCase()) {
      case 'high_performance':
        final currentInterval = get<int>('update_interval');
        final currentDistanceFilter = get<int>('distance_filter');
        final currentAccuracyThreshold = get<double>('accuracy_threshold');
        
        baseConfig.addAll({
          'update_interval': (currentInterval * 0.7).round(), // 30% faster
          'distance_filter': (currentDistanceFilter * 0.7).round(), // 30% more sensitive
          'accuracy_threshold': currentAccuracyThreshold * 0.8, // Stricter accuracy
          'wake_lock_enabled': true,
          'use_network_fallback': false, // GPS only for best accuracy
        });
        break;
        
      case 'balanced':
        // Use default config
        break;
        
      case 'power_saving':
        final currentInterval = get<int>('update_interval');
        final currentDistanceFilter = get<int>('distance_filter');
        final currentAccuracyThreshold = get<double>('accuracy_threshold');
        final currentSmoothingWindow = get<int>('smoothing_window');
        
        baseConfig.addAll({
          'update_interval': (currentInterval * 1.5).round(), // 50% slower
          'distance_filter': (currentDistanceFilter * 1.5).round(), // 50% less sensitive
          'accuracy_threshold': currentAccuracyThreshold * 1.3, // More relaxed
          'wake_lock_enabled': false,
          'use_network_fallback': true, // Allow network location
          'smoothing_window': currentSmoothingWindow + 2, // More smoothing
        });
        break;
        
      default:
        print('Unknown GPS mode: $mode, using balanced config');
    }
    
    return baseConfig;
  }

  /// Validate configuration values
  static List<String> validateConfig() {
    final errors = <String>[];
    
    // Validate ranges
    if (get<double>('accuracy_threshold') <= 0 || get<double>('accuracy_threshold') > 1000) {
      errors.add('accuracy_threshold must be between 0 and 1000 meters');
    }
    
    if (get<double>('speed_threshold') <= 0 || get<double>('speed_threshold') > 200) {
      errors.add('speed_threshold must be between 0 and 200 km/h');
    }
    
    if (get<int>('update_interval') < 500 || get<int>('update_interval') > 30000) {
      errors.add('update_interval must be between 500 and 30000 milliseconds');
    }
    
    if (get<double>('distance_filter') < 0 || get<double>('distance_filter') > 100) {
      errors.add('distance_filter must be between 0 and 100 meters');
    }
    
    if (get<int>('max_history_size') < 3 || get<int>('max_history_size') > 100) {
      errors.add('max_history_size must be between 3 and 100');
    }
    
    if (get<int>('smoothing_window') < 1 || get<int>('smoothing_window') > get<int>('max_history_size')) {
      errors.add('smoothing_window must be between 1 and max_history_size');
    }
    
    return errors;
  }

  /// Get configuration optimized for specific activity type
  static Map<String, dynamic> getConfigForActivity(String activity) {
    final baseConfig = Map<String, dynamic>.from(_currentConfig);
    
    switch (activity.toLowerCase()) {
      case 'walking':
        baseConfig.addAll({
          'speed_threshold': 15.0, // km/h - walking speed limit
          'distance_filter': 2.0, // More sensitive for walking
          'update_interval': 3000, // Slightly slower updates
          'smoothing_window': 4, // More smoothing for stability
        });
        break;
        
      case 'running':
        baseConfig.addAll({
          'speed_threshold': 30.0, // km/h - running speed limit
          'distance_filter': 3.0, // Standard sensitivity
          'update_interval': 2000, // Standard updates
          'smoothing_window': 3, // Balanced smoothing
        });
        break;
        
      case 'cycling':
        baseConfig.addAll({
          'speed_threshold': 60.0, // km/h - cycling speed limit
          'distance_filter': 5.0, // Less sensitive for faster movement
          'update_interval': 1500, // Faster updates for cycling
          'smoothing_window': 2, // Less smoothing for responsiveness
        });
        break;
        
      case 'driving':
        baseConfig.addAll({
          'speed_threshold': 120.0, // km/h - driving speed limit
          'distance_filter': 10.0, // Much less sensitive
          'update_interval': 5000, // Slower updates
          'smoothing_window': 5, // More smoothing for stability
        });
        break;
        
      default:
        print('Unknown activity: $activity, using default config');
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
      'cache_expiry': _lastRemoteConfigFetch != null 
          ? _lastRemoteConfigFetch!.add(Duration(seconds: _remoteConfigCacheSeconds)).toIso8601String()
          : null,
    };
  }

  // Convenient getters for commonly used values
  static double get accuracyThreshold => get<double>('accuracy_threshold');
  static double get speedThreshold => get<double>('speed_threshold');
  static double get distanceFilter => get<double>('distance_filter');
  static int get updateInterval => get<int>('update_interval');
  static double get minTimeInterval => get<double>('min_time_interval');
  static bool get filteringEnabled => get<bool>('enable_filtering');
  static int get maxHistorySize => get<int>('max_history_size');
  static int get smoothingWindow => get<int>('smoothing_window');
  static bool get batteryOptimizationEnabled => get<bool>('enable_battery_optimization');
  static int get batteryHighThreshold => get<int>('battery_threshold_high');
  static int get batteryLowThreshold => get<int>('battery_threshold_low');
}
