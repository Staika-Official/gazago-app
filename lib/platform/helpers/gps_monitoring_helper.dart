import 'dart:async';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gaza_go/platform/helpers/gps_filter_helper.dart';
import 'package:gaza_go/platform/helpers/gps_metrics.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

/// GPS Monitoring Helper for Phase 3 Deployment
/// Monitors GPS performance, accuracy improvements, and A/B test results
class GPSMonitoringHelper {
  static const String _monitoringKey = 'gps_monitoring_data';
  static const String _sessionKey = 'gps_session_data';
  static const String _alertsKey = 'gps_alerts';

  // Performance thresholds
  static const double _accuracyThreshold = 10.0; // meters
  static const double _batteryThreshold = 15.0; // percentage increase
  static const double _crashRateThreshold = 0.1; // percentage
  static const double _filterRateThreshold = 30.0; // percentage

  static Timer? _monitoringTimer;
  static DateTime? _sessionStart;
  static Map<String, dynamic> _currentSession = {};

  /// Initialize GPS monitoring system
  static Future<void> initializeMonitoring() async {
    try {
      _sessionStart = DateTime.now();
      _currentSession = {
        'session_id': _generateSessionId(),
        'start_time': _sessionStart!.toIso8601String(),
        'device_info': await _getDeviceInfo(),
        'initial_metrics': {},
      };

      // Start periodic monitoring
      _startPeriodicMonitoring();

      // Log session start
      FirebaseCrashlytics.instance.log(
          'GPS_MONITORING: Session started - ${_currentSession['session_id']}');
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  /// Start periodic monitoring with configurable interval
  static void _startPeriodicMonitoring() {
    _monitoringTimer?.cancel();

    _monitoringTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _collectPerformanceMetrics();
    });
  }

  /// Collect comprehensive GPS performance metrics
  static Future<void> _collectPerformanceMetrics() async {
    try {
      Map<String, dynamic> metrics = {
        'timestamp': DateTime.now().toIso8601String(),
        'session_id': _currentSession['session_id'],
        'gps_filter_stats': GPSFilterHelper.getFilteringStats(),
        'gps_metrics': GPSMetrics.getSessionMetrics(),
        'performance_grade': _calculatePerformanceGrade(),
        'alerts': _checkForAlerts(),
      };

      // Store metrics locally
      _storeMetrics(metrics);

      // Send to Firebase for monitoring
      FirebaseCrashlytics.instance
          .log('GPS_PERFORMANCE_METRICS: ${jsonEncode(metrics)}');

      // Check for critical alerts
      List<String> alerts = metrics['alerts'] as List<String>;
      if (alerts.isNotEmpty) {
        _handleCriticalAlerts(alerts, metrics);
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }

  /// Calculate overall GPS performance grade (A-F)
  static String _calculatePerformanceGrade() {
    try {
      Map<String, dynamic> filterStats = GPSFilterHelper.getFilteringStats();
      Map<String, dynamic> gpsMetrics = GPSMetrics.getSessionMetrics();

      double score = 100.0;

      // Accuracy score (40% weight)
      double avgAccuracy = gpsMetrics['average_accuracy'] ?? 20.0;
      if (avgAccuracy > 15.0) {
        score -= 30;
      } else if (avgAccuracy > 10.0) {
        score -= 15;
      } else if (avgAccuracy > 5.0) {
        score -= 5;
      }

      // Filter rate score (30% weight)
      double filterRate = filterStats['rejection_rate'] ?? 0.0;
      if (filterRate > 40.0) {
        score -= 25;
      } else if (filterRate > 25.0) {
        score -= 15;
      } else if (filterRate > 15.0) {
        score -= 5;
      }

      // Error rate score (20% weight)
      int errorCount = gpsMetrics['error_count'] ?? 0;
      int totalPositions = filterStats['total_positions'] ?? 1;
      double errorRate = (errorCount / totalPositions) * 100;
      if (errorRate > 5.0) {
        score -= 15;
      } else if (errorRate > 2.0) {
        score -= 8;
      }

      // Fallback rate score (10% weight)
      int fallbackCount = gpsMetrics['fallback_count'] ?? 0;
      double fallbackRate = (fallbackCount / totalPositions) * 100;
      if (fallbackRate > 20.0) {
        score -= 10;
      } else if (fallbackRate > 10.0) {
        score -= 5;
      }

      // Convert score to grade
      if (score >= 90) return 'A';
      if (score >= 80) return 'B';
      if (score >= 70) return 'C';
      if (score >= 60) return 'D';
      return 'F';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Check for performance alerts
  static List<String> _checkForAlerts() {
    List<String> alerts = [];

    try {
      Map<String, dynamic> filterStats = GPSFilterHelper.getFilteringStats();
      Map<String, dynamic> gpsMetrics = GPSMetrics.getSessionMetrics();

      // Check accuracy alert
      double avgAccuracy = gpsMetrics['average_accuracy'] ?? 0.0;
      if (avgAccuracy > _accuracyThreshold) {
        alerts.add(
            'ACCURACY_DEGRADED: Average accuracy ${avgAccuracy.toStringAsFixed(1)}m exceeds threshold ${_accuracyThreshold}m');
      }

      // Check filter rate alert
      double filterRate = filterStats['rejection_rate'] ?? 0.0;
      if (filterRate > _filterRateThreshold) {
        alerts.add(
            'HIGH_FILTER_RATE: ${filterRate.toStringAsFixed(1)}% positions filtered (threshold: $_filterRateThreshold%)');
      }

      // Check error rate alert
      int errorCount = gpsMetrics['error_count'] ?? 0;
      int totalPositions = filterStats['total_positions'] ?? 1;
      double errorRate = (errorCount / totalPositions) * 100;
      if (errorRate > 5.0) {
        alerts.add(
            'HIGH_ERROR_RATE: ${errorRate.toStringAsFixed(1)}% error rate detected');
      }

      // Check session duration for battery impact
      int sessionMinutes = gpsMetrics['session_duration_minutes'] ?? 0;
      if (sessionMinutes > 60) {
        alerts.add(
            'LONG_SESSION: GPS session running for $sessionMinutes minutes - monitor battery impact');
      }

      // Check battery optimization threshold
      int batteryOptimizations = gpsMetrics['battery_optimizations'] ?? 0;
      if (batteryOptimizations > 0 && sessionMinutes > 0) {
        double batteryOptimizationRate =
            (batteryOptimizations / sessionMinutes) * 100;
        if (batteryOptimizationRate > _batteryThreshold) {
          alerts.add(
              'HIGH_BATTERY_OPTIMIZATION: ${batteryOptimizationRate.toStringAsFixed(1)}% battery optimizations per minute (threshold: $_batteryThreshold%)');
        }
      }

      // Check crash/error rate threshold (reuse totalPositions from above)
      double crashRate = (errorCount / totalPositions) * 100;
      if (crashRate > _crashRateThreshold) {
        alerts.add(
            'HIGH_CRASH_RATE: ${crashRate.toStringAsFixed(2)}% crash/error rate detected (threshold: $_crashRateThreshold%)');
      }
    } catch (e) {
      alerts.add('MONITORING_ERROR: Failed to check alerts - $e');
    }

    return alerts;
  }

  /// Handle critical alerts that require immediate attention
  static void _handleCriticalAlerts(
      List<String> alerts, Map<String, dynamic> metrics) {
    for (String alert in alerts) {
      if (alert.contains('ACCURACY_DEGRADED') ||
          alert.contains('HIGH_ERROR_RATE') ||
          alert.contains('HIGH_CRASH_RATE') ||
          alert.contains('HIGH_BATTERY_OPTIMIZATION')) {
        // Critical alert - log with high priority
        FirebaseCrashlytics.instance.log('CRITICAL_GPS_ALERT: $alert');

        // Set custom keys for better monitoring
        FirebaseCrashlytics.instance.setCustomKey('gps_critical_alert', alert);
        FirebaseCrashlytics.instance
            .setCustomKey('performance_grade', metrics['performance_grade']);

        // Store alert for later analysis
        _storeAlert(alert, metrics);
      }
    }
  }

  /// Store performance metrics locally
  static void _storeMetrics(Map<String, dynamic> metrics) {
    try {
      List<dynamic> storedMetrics =
          HiveStore.load(key: _monitoringKey) as List<dynamic>? ?? [];
      storedMetrics.add(metrics);

      // Keep only last 100 entries to manage storage
      if (storedMetrics.length > 100) {
        storedMetrics = storedMetrics.sublist(storedMetrics.length - 100);
      }

      HiveStore.save(key: _monitoringKey, value: storedMetrics);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  /// Store critical alerts
  static void _storeAlert(String alert, Map<String, dynamic> context) {
    try {
      List<dynamic> storedAlerts =
          HiveStore.load(key: _alertsKey) as List<dynamic>? ?? [];

      Map<String, dynamic> alertData = {
        'timestamp': DateTime.now().toIso8601String(),
        'alert': alert,
        'context': context,
        'session_id': _currentSession['session_id'],
      };

      storedAlerts.add(alertData);

      // Keep only last 50 alerts
      if (storedAlerts.length > 50) {
        storedAlerts = storedAlerts.sublist(storedAlerts.length - 50);
      }

      HiveStore.save(key: _alertsKey, value: storedAlerts);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  /// Generate unique session ID
  static String _generateSessionId() {
    return 'gps_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }

  /// Get basic device information for monitoring
  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      return {
        'platform':
            'mobile', // Could be enhanced with actual platform detection
        'timestamp': DateTime.now().toIso8601String(),
        'app_version': '1.0.0', // Could be enhanced with actual version
      };
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
  }

  /// Get comprehensive monitoring report
  static Map<String, dynamic> getMonitoringReport() {
    try {
      List<dynamic> storedMetrics =
          HiveStore.load(key: _monitoringKey) as List<dynamic>? ?? [];
      List<dynamic> storedAlerts =
          HiveStore.load(key: _alertsKey) as List<dynamic>? ?? [];

      return {
        'session_info': _currentSession,
        'total_metrics_collected': storedMetrics.length,
        'total_alerts': storedAlerts.length,
        'latest_metrics': storedMetrics.isNotEmpty ? storedMetrics.last : null,
        'recent_alerts': storedAlerts.take(5).toList(),
        'current_performance_grade': _calculatePerformanceGrade(),
        'monitoring_status':
            _monitoringTimer?.isActive ?? false ? 'active' : 'inactive',
      };
    } catch (e) {
      return {'error': 'Failed to generate monitoring report: $e'};
    }
  }

  /// Stop monitoring and generate final report
  static Map<String, dynamic> stopMonitoring() {
    try {
      _monitoringTimer?.cancel();

      Map<String, dynamic> finalReport = {
        'session_id': _currentSession['session_id'],
        'session_duration': _sessionStart != null
            ? DateTime.now().difference(_sessionStart!).inMinutes
            : 0,
        'final_metrics': GPSMetrics.getSessionMetrics(),
        'final_filter_stats': GPSFilterHelper.getFilteringStats(),
        'final_performance_grade': _calculatePerformanceGrade(),
        'end_time': DateTime.now().toIso8601String(),
      };

      // Log final report
      FirebaseCrashlytics.instance
          .log('GPS_MONITORING: Session ended - ${jsonEncode(finalReport)}');

      return finalReport;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
      return {'error': 'Failed to stop monitoring: $e'};
    }
  }

  /// Clear stored monitoring data
  static void clearMonitoringData() {
    try {
      HiveStore.deleteKey(key: _monitoringKey);
      HiveStore.deleteKey(key: _alertsKey);
      HiveStore.deleteKey(key: _sessionKey);

      FirebaseCrashlytics.instance
          .log('GPS_MONITORING: Monitoring data cleared');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  /// Record custom GPS event for monitoring
  static void recordGPSEvent(String eventName, Map<String, dynamic> data) {
    try {
      Map<String, dynamic> eventData = {
        'event_name': eventName,
        'timestamp': DateTime.now().toIso8601String(),
        'session_id': _currentSession['session_id'],
        'data': data,
      };

      FirebaseCrashlytics.instance.log('GPS_EVENT: ${jsonEncode(eventData)}');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  /// Check if monitoring is currently active
  static bool isMonitoringActive() {
    return _monitoringTimer?.isActive ?? false;
  }

  /// Get current session information
  static Map<String, dynamic> getCurrentSession() {
    return Map<String, dynamic>.from(_currentSession);
  }
}
