import 'dart:isolate';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

/// Location Callback Handler used for isolate communication when using geolocator
/// Handles location updates in background isolate (if using isolate-based forwarding)
class LocationCallbackHandler {
  static const String isolateName = 'LocatorIsolate';

  /// Main location update callback (used by geolocator stream)
  @pragma('vm:entry-point')
  static void callback(Position position) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // Convert Position to a simple map to send across isolates if needed
    final map = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'altitude': position.altitude,
      'speed': position.speed,
      'time': position.timestamp.millisecondsSinceEpoch,
      'heading': position.heading,
    };
    send?.send(map);
  }

  /// Initialize callback
  @pragma('vm:entry-point')
  static void initCallback(Map<dynamic, dynamic> params) async {
    print('*** Background location service initialized ***');
  }

  /// Dispose callback
  @pragma('vm:entry-point')
  static void disposeCallback() {
    print('*** Background location service disposed ***');
  }

  /// Convert Position or map to LocationModel with data sanitization
  static LocationModel convertToLocationModel(dynamic position) {
    if (position is Position) {
      // Direct Position object
      final timestamp = position.timestamp;
      final accuracy = _sanitizeAccuracy(position.accuracy);
      final speed = _sanitizeSpeed(position.speed);
      final altitude = _sanitizeAltitude(position.altitude);
      final bearing = _sanitizeBearing(position.heading);

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: timestamp,
        accuracy: accuracy,
        altitude: altitude,
        speed: speed,
        bearing: bearing,
      );
    }

    // Map from isolate communication
    final map = position as Map<dynamic, dynamic>;
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
        (map['time'] ?? DateTime.now().millisecondsSinceEpoch).toInt());
    final accuracy = _sanitizeAccuracy(map['accuracy']);
    final speed = _sanitizeSpeed(map['speed']);
    final altitude = _sanitizeAltitude(map['altitude']);
    final bearing = _sanitizeBearing(map['heading']);

    return LocationModel(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      timestamp: timestamp,
      accuracy: accuracy,
      altitude: altitude,
      speed: speed,
      bearing: bearing,
    );
  }

  /// Sanitize accuracy value
  static double _sanitizeAccuracy(dynamic a) {
    final v = (a is num) ? a.toDouble() : double.nan;
    if (v.isNaN || !v.isFinite || v <= 0) return 9999.0; // Very poor accuracy
    return v;
  }

  /// Sanitize speed value (ensure >= 0)
  static double _sanitizeSpeed(dynamic s) {
    final v = (s is num) ? s.toDouble() : 0.0;
    if (!v.isFinite || v < 0) return 0.0;
    return v;
  }

  /// Sanitize altitude value
  static double _sanitizeAltitude(dynamic a) {
    final v = (a is num) ? a.toDouble() : 0.0;
    return v.isFinite ? v : 0.0;
  }

  /// Sanitize bearing value (0-360 degrees or null)
  static double? _sanitizeBearing(dynamic h) {
    final v = (h is num) ? h.toDouble() : double.nan;
    if (v.isNaN || !v.isFinite || v < 0) return null;
    return v % 360.0;
  }
}
