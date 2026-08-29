import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Result wrapper for location operations.
class LocationResult {
  final Position? position;
  final String? errorMessage;

  const LocationResult({this.position, this.errorMessage});

  bool get isSuccess => position != null;
}

/// Service that provides access to the device's GPS location.
class LocationService {
  /// Checks if location services are enabled and permissions are granted.
  /// Returns a [LocationResult] with an error message if something is wrong,
  /// or null if everything is ready.
  static Future<String?> checkAndRequestPermissions() async {
    // 1. Check if location services are enabled on the device
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled. Please enable GPS in your device settings.';
    }

    // 2. Check current permission status
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permission was denied. Please allow location access to see your position on the map.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permission is permanently denied. Please enable it from your device settings.';
    }

    // All good
    return null;
  }

  /// Gets the current position once.
  static Future<LocationResult> getCurrentPosition() async {
    final error = await checkAndRequestPermissions();
    if (error != null) {
      return LocationResult(errorMessage: error);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LocationResult(position: position);
    } catch (e) {
      return LocationResult(
        errorMessage: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  /// Returns a stream of position updates.
  ///
  /// [distanceFilter] — minimum distance (meters) the device must move
  /// before an update is emitted. Defaults to 10m to save battery.
  static Stream<Position>? getPositionStream({int distanceFilter = 10}) {
    try {
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilter,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Opens the device's location settings (for when permission is permanently denied).
  static Future<bool> openSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Opens the app's permission settings page.
  static Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}
