import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:gaza_go/platform/helpers/gps_filter_helper.dart';
import 'package:gaza_go/platform/helpers/battery_aware_gps.dart';

/// Phase 2: GPS Performance Metrics System
/// Comprehensive tracking and monitoring of GPS performance
class GPSMetrics {
  static Map<String, dynamic> _metrics = {};
  static DateTime? _sessionStart;
  static List<double> _accuracyHistory = [];
  static List<double> _speedHistory = [];
  static int _totalPositions = 0;
  static int _filteredPositions = 0;
  static int _fallbackCount = 0;
  static int _errorCount = 0;
  static int _batteryOptimizations = 0;

  /// Start a new GPS metrics session
  static void startSession() {
    _sessionStart = DateTime.now();
    _metrics = {
      'session_start': _sessionStart!.toIso8601String(),
      'total_positions': 0,
      'filtered_positions': 0,
      'accuracy_sum': 0.0,
      'accuracy_count': 0,
      'fallback_count': 0,
      'error_count': 0,
      'battery_optimizations': 0,
      'min_accuracy': double.infinity,
      'max_accuracy': 0.0,
      'avg_speed': 0.0,
      'max_speed': 0.0,
    };

    // Reset counters
    _totalPositions = 0;
    _filteredPositions = 0;
    _fallbackCount = 0;
    _errorCount = 0;
    _batteryOptimizations = 0;
    _accuracyHistory.clear();
    _speedHistory.clear();

    print('GPS metrics session started');
  }

  /// Record a GPS position update
  static void recordPosition(Position position, bool wasFiltered) {
    if (_sessionStart == null) startSession();

    _totalPositions++;
    if (wasFiltered) _filteredPositions++;

    // Track accuracy
    _accuracyHistory.add(position.accuracy);
    _metrics['accuracy_sum'] += position.accuracy;
    _metrics['accuracy_count']++;

    // Update min/max accuracy
    if (position.accuracy < _metrics['min_accuracy']) {
      _metrics['min_accuracy'] = position.accuracy;
    }
    if (position.accuracy > _metrics['max_accuracy']) {
      _metrics['max_accuracy'] = position.accuracy;
    }

    // Track speed
    if (position.speed >= 0) {
      double speedKmh = position.speed * 3.6;
      _speedHistory.add(speedKmh);
      if (speedKmh > _metrics['max_speed']) {
        _metrics['max_speed'] = speedKmh;
      }
    }

    // Update counters
    _metrics['total_positions'] = _totalPositions;
    _metrics['filtered_positions'] = _filteredPositions;
  }

  /// Record a GPS fallback event
  static void recordFallback() {
    _fallbackCount++;
    _metrics['fallback_count'] = _fallbackCount;
    print('GPS fallback recorded (total: $_fallbackCount)');
  }

  /// Record a GPS error
  static void recordError(String error) {
    _errorCount++;
    _metrics['error_count'] = _errorCount;
    print('GPS error recorded: $error (total: $_errorCount)');
  }

  /// Record battery optimization event
  static void recordBatteryOptimization() {
    _batteryOptimizations++;
    _metrics['battery_optimizations'] = _batteryOptimizations;
    print('Battery optimization recorded (total: $_batteryOptimizations)');
  }

  /// Get current session metrics
  static Map<String, dynamic> getSessionMetrics() {
    if (_sessionStart == null) return {};

    double avgAccuracy = _metrics['accuracy_count'] > 0
        ? _metrics['accuracy_sum'] / _metrics['accuracy_count']
        : 0.0;

    double avgSpeed = _speedHistory.isNotEmpty
        ? _speedHistory.reduce((a, b) => a + b) / _speedHistory.length
        : 0.0;

    double filterRate = _totalPositions > 0
        ? (_filteredPositions / _totalPositions * 100)
        : 0.0;

    int sessionDuration = DateTime.now().difference(_sessionStart!).inMinutes;

    return {
      ..._metrics,
      'session_duration_minutes': sessionDuration,
      'average_accuracy': avgAccuracy,
      'average_speed': avgSpeed,
      'filter_rate': filterRate,
      'positions_per_minute':
          sessionDuration > 0 ? _totalPositions / sessionDuration : 0,
      'accuracy_std_dev': _calculateStandardDeviation(_accuracyHistory),
      'speed_std_dev': _calculateStandardDeviation(_speedHistory),
    };
  }

  /// Get comprehensive GPS performance report
  static Future<Map<String, dynamic>> getPerformanceReport() async {
    Map<String, dynamic> sessionMetrics = getSessionMetrics();
    Map<String, dynamic> filterStats = GPSFilterHelper.getFilteringStats();
    Map<String, dynamic> batteryInfo = await BatteryAwareGPS.getBatteryInfo();

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'session_metrics': sessionMetrics,
      'filter_stats': filterStats,
      'battery_info': batteryInfo,
      'performance_grade': _calculatePerformanceGrade(sessionMetrics),
    };
  }

  /// Calculate performance grade based on metrics
  static String _calculatePerformanceGrade(Map<String, dynamic> metrics) {
    double score = 100.0;

    // Accuracy score (0-40 points)
    double avgAccuracy = metrics['average_accuracy'] ?? 0.0;
    if (avgAccuracy <= 5) {
      score -= 0;
    } else if (avgAccuracy <= 10)
      score -= 10;
    else if (avgAccuracy <= 20)
      score -= 20;
    else
      score -= 40;

    // Filter rate score (0-30 points)
    double filterRate = metrics['filter_rate'] ?? 0.0;
    if (filterRate <= 5) {
      score -= 0;
    } else if (filterRate <= 15)
      score -= 10;
    else if (filterRate <= 30)
      score -= 20;
    else
      score -= 30;

    // Error rate score (0-20 points)
    int errors = metrics['error_count'] ?? 0;
    int total = metrics['total_positions'] ?? 1;
    double errorRate = (errors / total) * 100;
    if (errorRate <= 1) {
      score -= 0;
    } else if (errorRate <= 5)
      score -= 10;
    else
      score -= 20;

    // Fallback rate score (0-10 points)
    int fallbacks = metrics['fallback_count'] ?? 0;
    double fallbackRate = (fallbacks / total) * 100;
    if (fallbackRate <= 2) {
      score -= 0;
    } else if (fallbackRate <= 10)
      score -= 5;
    else
      score -= 10;

    if (score >= 90) {
      return 'A';
    } else if (score >= 80)
      return 'B';
    else if (score >= 70)
      return 'C';
    else if (score >= 60)
      return 'D';
    else
      return 'F';
  }

  /// Calculate standard deviation
  static double _calculateStandardDeviation(List<double> values) {
    if (values.isEmpty) return 0.0;

    double mean = values.reduce((a, b) => a + b) / values.length;
    double sumSquaredDiffs = values
        .map((value) => (value - mean) * (value - mean))
        .reduce((a, b) => a + b);

    return math.sqrt(sumSquaredDiffs / values.length);
  }

  /// Log metrics to console and Firebase
  static void logMetrics() {
    Map<String, dynamic> metrics = getSessionMetrics();
    print('GPS Session Metrics: $metrics');

    // Send to Firebase Crashlytics for monitoring
    FirebaseCrashlytics.instance.log('GPS_METRICS: $metrics');
  }

  /// Log performance report
  static Future<void> logPerformanceReport() async {
    Map<String, dynamic> report = await getPerformanceReport();
    print('GPS Performance Report: $report');

    // Send to Firebase Crashlytics
    FirebaseCrashlytics.instance.log('GPS_PERFORMANCE_REPORT: $report');
  }

  /// End current session and generate final report
  static Future<Map<String, dynamic>> endSession() async {
    if (_sessionStart == null) return {};

    Map<String, dynamic> finalReport = await getPerformanceReport();
    print('GPS session ended. Final report: $finalReport');

    // Reset session
    _sessionStart = null;
    _metrics.clear();

    return finalReport;
  }

  /// Check if metrics indicate GPS performance issues
  static bool hasPerformanceIssues() {
    Map<String, dynamic> metrics = getSessionMetrics();

    double avgAccuracy = metrics['average_accuracy'] ?? 0.0;
    double filterRate = metrics['filter_rate'] ?? 0.0;
    int errorCount = metrics['error_count'] ?? 0;
    int fallbackCount = metrics['fallback_count'] ?? 0;

    // Performance issues if:
    // - Average accuracy > 15m
    // - Filter rate > 25%
    // - More than 5 errors
    // - More than 3 fallbacks
    return avgAccuracy > 15 ||
        filterRate > 25 ||
        errorCount > 5 ||
        fallbackCount > 3;
  }

  /// Get real-time GPS status
  static Map<String, dynamic> getCurrentStatus() {
    return {
      'session_active': _sessionStart != null,
      'session_duration': _sessionStart != null
          ? DateTime.now().difference(_sessionStart!).inMinutes
          : 0,
      'total_positions': _totalPositions,
      'recent_accuracy':
          _accuracyHistory.isNotEmpty ? _accuracyHistory.last : null,
      'recent_speed': _speedHistory.isNotEmpty ? _speedHistory.last : null,
      'has_issues': hasPerformanceIssues(),
    };
  }
}
