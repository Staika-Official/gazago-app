import 'dart:math' as Math;

/// Location Model
/// Canonical in-app location model used across the app.
/// Compatible with geolocator Position, location package data, and legacy DTOs.
class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double accuracy;
  final double altitude;
  final double speed; // m/s
  final double? bearing;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    this.bearing,
  });

  /// Create LocationModel from legacy Location DTO (deprecated)
  factory LocationModel.fromLocationDto(dynamic locationDto) {
    return LocationModel(
      latitude: locationDto.latitude,
      longitude: locationDto.longitude,
      timestamp: DateTime.fromMillisecondsSinceEpoch(locationDto.time.toInt()),
      accuracy: locationDto.accuracy,
      altitude: locationDto.altitude ?? 0.0,
      speed: locationDto.speed ?? 0.0,
      bearing: locationDto.bearing,
    );
  }

  /// Create LocationModel from location package LocationData
  factory LocationModel.fromLocationData(dynamic locationData) {
    return LocationModel(
      latitude: locationData.latitude ?? 0.0,
      longitude: locationData.longitude ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        locationData.time?.toInt() ?? DateTime.now().millisecondsSinceEpoch
      ),
      accuracy: locationData.accuracy ?? 0.0,
      altitude: locationData.altitude ?? 0.0,
      speed: (locationData.speed ?? 0.0).abs(), // Ensure positive speed in m/s
      bearing: locationData.heading,
    );
  }

  /// Create LocationModel from geolocator Position (for backward compatibility)
  factory LocationModel.fromPosition(dynamic position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp ?? DateTime.now(),
      accuracy: position.accuracy,
      altitude: position.altitude,
      speed: position.speed >= 0 ? position.speed : 0.0,
      bearing: position.heading >= 0 ? position.heading : null,
    );
  }

  /// Calculate distance between two LocationModel points using Haversine formula
  static double distanceBetween(LocationModel from, LocationModel to) {
    return _haversineDistance(from.latitude, from.longitude, to.latitude, to.longitude);
  }

  /// Calculate speed in km/h
  double get speedKmh => speed * 3.6;

  /// Check if this location is more recent than another
  bool isMoreRecentThan(LocationModel other) {
    return timestamp.isAfter(other.timestamp);
  }

  /// Calculate time difference in seconds from another location
  double timeDifferenceInSeconds(LocationModel other) {
    return timestamp.difference(other.timestamp).inMilliseconds / 1000.0;
  }

  /// Calculate distance to another location
  double distanceTo(LocationModel other) {
    return distanceBetween(this, other);
  }

  /// Check if location has good accuracy (< 20 meters)
  bool get hasGoodAccuracy => accuracy < 20.0;

  /// Check if location has excellent accuracy (< 10 meters)
  bool get hasExcellentAccuracy => accuracy < 10.0;

  /// Check if this is a stationary position (speed < 0.5 m/s)
  bool get isStationary => speed < 0.5;

  /// Check if this is a moving position (speed >= 0.5 m/s)
  bool get isMoving => speed >= 0.5;

  @override
  String toString() {
    return 'LocationModel(lat: ${latitude.toStringAsFixed(6)}, lng: ${longitude.toStringAsFixed(6)}, '
           'acc: ${accuracy.toStringAsFixed(1)}m, speed: ${speedKmh.toStringAsFixed(1)}km/h)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.timestamp == timestamp &&
        other.accuracy == accuracy;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode ^ timestamp.hashCode;
  }

  /// Create a copy of this LocationModel with updated fields
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? speed,
    double? bearing,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      bearing: bearing ?? this.bearing,
    );
  }

  /// Convert to Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'bearing': bearing,
    };
  }

  /// Create LocationModel from Map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      accuracy: map['accuracy']?.toDouble() ?? 0.0,
      altitude: map['altitude']?.toDouble() ?? 0.0,
      speed: map['speed']?.toDouble() ?? 0.0,
      bearing: map['bearing']?.toDouble(),
    );
  }
}

/// Haversine formula to calculate distance between two points on Earth
double _haversineDistance(double lat1, double lng1, double lat2, double lng2) {
  const double earthRadiusKm = 6371.0;
  
  final double dLat = _degreesToRadians(lat2 - lat1);
  final double dLng = _degreesToRadians(lng2 - lng1);
  
  final double lat1Rad = _degreesToRadians(lat1);
  final double lat2Rad = _degreesToRadians(lat2);
  
  final double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.sin(dLng / 2) * Math.sin(dLng / 2) * 
                   Math.cos(lat1Rad) * Math.cos(lat2Rad);
  
  final double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  
  return earthRadiusKm * c * 1000; // Convert to meters
}

double _degreesToRadians(double degrees) {
  return degrees * (Math.pi / 180);
}

