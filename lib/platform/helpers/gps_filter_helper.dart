import 'package:geolocator/geolocator.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/firebase/remote_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// GPS Filtering Helper - Phase 1 Implementation
/// Provides Kalman-like filtering for GPS positions with comprehensive validation
class GPSFilterHelper {
  static final List<Position> _positionHistory = [];
  static int _rejectedCount = 0;
  static int _totalCount = 0;
  static DateTime? _lastLogTime;
  
  /// Kalman-like filtering for GPS positions with comprehensive validation
  static Position? filterPosition(Position newPosition) {
    _totalCount++;
    
    try {
      // 1. Accuracy validation with configurable threshold
      if (newPosition.accuracy > maxGpsAccuracy) {
        _logRejection('Position rejected: poor accuracy ${newPosition.accuracy}m (max: ${maxGpsAccuracy}m)');
        return null;
      }
      
      // 2. Speed validation with time interval check
      if (_positionHistory.isNotEmpty) {
        Position lastPosition = _positionHistory.last;
        
        double distance = Geolocator.distanceBetween(
            lastPosition.latitude,
            lastPosition.longitude,
            newPosition.latitude,
            newPosition.longitude);
        
        double timeInterval = newPosition.timestamp
            .difference(lastPosition.timestamp)
            .inSeconds
            .toDouble();
        
        // Avoid division by zero and too small intervals
        if (timeInterval > gpsFilterMinTimeInterval) {
          double speed = (distance / timeInterval) * 3.6; // km/h
          if (speed > gpsFilterMaxSpeed) {
            _logRejection('Position rejected: excessive speed ${speed.toStringAsFixed(1)} km/h (max: $gpsFilterMaxSpeed km/h)');
            return null;
          }
        } else if (timeInterval > 0 && distance > 50) {
          // Very short time interval with large distance = likely GPS jump
          _logRejection('Position rejected: GPS jump detected (${distance.toStringAsFixed(1)}m in ${timeInterval.toStringAsFixed(1)}s)');
          return null;
        }
      }
      
      // 3. Add to history with size management
      _positionHistory.add(newPosition);
      if (_positionHistory.length > gpsFilterHistorySize) {
        _positionHistory.removeAt(0);
      }
      
      // 4. Apply smoothing if we have enough history
      if (_positionHistory.length >= 3) {
        return _applySmoothingFilter(newPosition);
      }

      return newPosition;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _logRejection('Position filtering error: $e');
      return newPosition; // Return original position on error
    }
  }
  
  /// Apply weighted average smoothing with outlier detection
  static Position _applySmoothingFilter(Position currentPosition) {
    if (_positionHistory.length < 2) return currentPosition;
    
    // Detect outliers using median distance
    List<double> distances = [];
    for (int i = 1; i < _positionHistory.length; i++) {
      double distance = Geolocator.distanceBetween(
          _positionHistory[i-1].latitude, _positionHistory[i-1].longitude,
          _positionHistory[i].latitude, _positionHistory[i].longitude);
      distances.add(distance);
    }
    
    distances.sort();
    double medianDistance = distances[distances.length ~/ 2];
    
    double totalWeight = 0;
    double weightedLat = 0;
    double weightedLng = 0;
    
    for (int i = 0; i < _positionHistory.length; i++) {
      Position pos = _positionHistory[i];
      
      // Base weight based on accuracy (better accuracy = higher weight)
      double weight = 1.0 / (pos.accuracy + 1.0);
      
      // Recent positions get higher weight
      double timeWeight = (i + 1).toDouble() / _positionHistory.length;
      weight *= timeWeight;
      
      // Reduce weight for outliers
      if (i > 0) {
        double distance = Geolocator.distanceBetween(
            _positionHistory[i-1].latitude, _positionHistory[i-1].longitude,
            pos.latitude, pos.longitude);
        if (distance > medianDistance * 3) {
          weight *= 0.3; // Reduce weight for outliers
        }
      }
      
      weightedLat += pos.latitude * weight;
      weightedLng += pos.longitude * weight;
      totalWeight += weight;
    }
    
    double smoothedLat = weightedLat / totalWeight;
    double smoothedLng = weightedLng / totalWeight;
    
    return Position(
      latitude: smoothedLat,
      longitude: smoothedLng,
      timestamp: currentPosition.timestamp,
      accuracy: currentPosition.accuracy,
      altitude: currentPosition.altitude,
      heading: currentPosition.heading,
      speed: currentPosition.speed,
      speedAccuracy: currentPosition.speedAccuracy,
      altitudeAccuracy: currentPosition.altitudeAccuracy,
      headingAccuracy: currentPosition.headingAccuracy,
    );
  }
  
  /// Clear history and reset counters (call when starting new exercise)
  static void clearHistory() {
    _positionHistory.clear();
    _rejectedCount = 0;
    _totalCount = 0;
    _lastLogTime = null;
  }
  
  /// Get filtering statistics
  static Map<String, dynamic> getFilteringStats() {
    return {
      'total_positions': _totalCount,
      'rejected_positions': _rejectedCount,
      'rejection_rate': _totalCount > 0 ? (_rejectedCount / _totalCount * 100) : 0,
      'history_size': _positionHistory.length,
    };
  }
  
  /// Log rejection with rate limiting
  static void _logRejection(String message) {
    _rejectedCount++;
    
    // Rate limit logging to avoid spam
    DateTime now = DateTime.now();
    if (_lastLogTime == null || now.difference(_lastLogTime!).inSeconds > 10) {
      print(message);
      _lastLogTime = now;
    }
  }
  
  /// Check if GPS filtering is enabled via remote config
  static bool get isFilteringEnabled {
    try {
      return getConfig(dataType: ConfigType.bool, configKey: 'enable_advanced_gps_filtering') ?? true;
    } catch (e) {
      return true; // Default to enabled if remote config fails
    }
  }
  
  /// Get current position history for debugging
  static List<Position> get positionHistory => List.unmodifiable(_positionHistory);
  
  /// Get last known good position
  static Position? get lastGoodPosition => _positionHistory.isNotEmpty ? _positionHistory.last : null;
}
