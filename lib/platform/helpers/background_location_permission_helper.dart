import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// Background Location Permission Helper
/// Handles location permissions specifically for background location service
/// Uses permission_handler instead of geolocator for better control
class BackgroundLocationPermissionHelper {
  
  /// Check if location service is enabled
  static Future<bool> isLocationServiceEnabled() async {
    try {
      // On Android, we can check if location service is enabled
      if (Platform.isAndroid) {
        final status = await Permission.location.serviceStatus;
        return status == ServiceStatus.enabled;
      }
      
      // On iOS, we assume it's enabled and let the permission request handle it
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check current location permission status
  static Future<LocationPermissionStatus> checkPermission() async {
    try {
      final locationStatus = await Permission.location.status;
      final backgroundStatus = await Permission.locationAlways.status;
      
      if (locationStatus.isDenied || backgroundStatus.isDenied) {
        return LocationPermissionStatus.denied;
      }
      
      if (locationStatus.isPermanentlyDenied || backgroundStatus.isPermanentlyDenied) {
        return LocationPermissionStatus.deniedForever;
      }
      
      if (locationStatus.isGranted) {
        if (backgroundStatus.isGranted) {
          return LocationPermissionStatus.whileInUseAndBackground;
        } else {
          return LocationPermissionStatus.whileInUse;
        }
      }
      
      return LocationPermissionStatus.denied;
    } catch (e) {
      return LocationPermissionStatus.denied;
    }
  }

  /// Request location permissions
  static Future<LocationPermissionStatus> requestPermission() async {
    try {
      // First request basic location permission
      final locationStatus = await Permission.location.request();
      
      if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
        return locationStatus.isPermanentlyDenied 
            ? LocationPermissionStatus.deniedForever 
            : LocationPermissionStatus.denied;
      }
      
      // Then request background location permission
      final backgroundStatus = await Permission.locationAlways.request();
      
      if (backgroundStatus.isDenied || backgroundStatus.isPermanentlyDenied) {
        // Even if background is denied, we can still use foreground
        return LocationPermissionStatus.whileInUse;
      }
      
      if (backgroundStatus.isGranted) {
        return LocationPermissionStatus.whileInUseAndBackground;
      }
      
      return LocationPermissionStatus.whileInUse;
    } catch (e) {
      return LocationPermissionStatus.denied;
    }
  }

  /// Request precise location (Android 12+)
  static Future<bool> requestPreciseLocation() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.locationWhenInUse.request();
        return status.isGranted;
      }
      return true; // iOS always provides precise location if permission is granted
    } catch (e) {
      return false;
    }
  }

  /// Open app settings for manual permission configuration
  static Future<bool> openLocationSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      return false;
    }
  }

  /// Get detailed permission status for debugging
  static Future<Map<String, dynamic>> getDetailedPermissionStatus() async {
    try {
      final location = await Permission.location.status;
      final locationAlways = await Permission.locationAlways.status;
      final locationWhenInUse = await Permission.locationWhenInUse.status;
      
      return {
        'location': location.name,
        'location_always': locationAlways.name,
        'location_when_in_use': locationWhenInUse.name,
        'service_enabled': await isLocationServiceEnabled(),
        'can_request_background': !locationAlways.isPermanentlyDenied,
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }

  /// Check if background location is supported on this platform
  static bool get isBackgroundLocationSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if we have sufficient permissions for background tracking
  static Future<bool> hasBackgroundPermission() async {
    final status = await checkPermission();
    return status == LocationPermissionStatus.whileInUseAndBackground;
  }

  /// Check if we have at least foreground permission
  static Future<bool> hasForegroundPermission() async {
    final status = await checkPermission();
    return status == LocationPermissionStatus.whileInUse || 
           status == LocationPermissionStatus.whileInUseAndBackground;
  }

  /// Get permission status message for UI
  static String getPermissionStatusMessage(LocationPermissionStatus status) {
    switch (status) {
      case LocationPermissionStatus.denied:
        return 'Location permission denied. Please grant permission to continue.';
      case LocationPermissionStatus.deniedForever:
        return 'Location permission permanently denied. Please enable in settings.';
      case LocationPermissionStatus.whileInUse:
        return 'Location permission granted for foreground use.';
      case LocationPermissionStatus.whileInUseAndBackground:
        return 'Location permission granted for background use.';
    }
  }

  /// Validate that permissions are compatible with LocationModel usage
  static Future<bool> isCompatibleWithLocationModel() async {
    final hasService = await isLocationServiceEnabled();
    final hasPerm = await hasForegroundPermission();
    return hasService && hasPerm;
  }

  /// Get permission requirements for LocationModel
  static Future<Map<String, bool>> getLocationModelRequirements() async {
    return {
      'service_enabled': await isLocationServiceEnabled(),
      'foreground_permission': await hasForegroundPermission(),
      'background_permission': await hasBackgroundPermission(),
      'precise_location': Platform.isAndroid ? await requestPreciseLocation() : true,
      'compatible': await isCompatibleWithLocationModel(),
    };
  }
}

/// Custom permission status enum
enum LocationPermissionStatus {
  /// Permission is denied
  denied,
  
  /// Permission is permanently denied (user selected "Don't ask again")
  deniedForever,
  
  /// Permission granted only while app is in use
  whileInUse,
  
  /// Permission granted for background and foreground use
  whileInUseAndBackground,
}

/// Extension for better status checking
extension LocationPermissionStatusExtension on LocationPermissionStatus {
  bool get isDenied => this == LocationPermissionStatus.denied;
  bool get isDeniedForever => this == LocationPermissionStatus.deniedForever;
  bool get isGranted => this == LocationPermissionStatus.whileInUse || 
                        this == LocationPermissionStatus.whileInUseAndBackground;
  bool get hasBackgroundAccess => this == LocationPermissionStatus.whileInUseAndBackground;
}
