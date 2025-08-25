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
      'time': position.timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
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

  /// Convert map or Position-like object to LocationModel
  static LocationModel convertToLocationModel(dynamic data) {
    if (data is Position) {
      return LocationModel.fromPosition(data);
    }
    // Expecting a Map sent from isolate
    final map = data as Map<dynamic, dynamic>;
    return LocationModel(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      accuracy: (map['accuracy'] ?? 0.0).toDouble(),
      altitude: (map['altitude'] ?? 0.0).toDouble(),
      speed: (map['speed'] ?? 0.0).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch((map['time'] ?? DateTime.now().millisecondsSinceEpoch).toInt()),
      bearing: (map['heading'] != null) ? (map['heading'] as num).toDouble() : null,
    );
  }
}
