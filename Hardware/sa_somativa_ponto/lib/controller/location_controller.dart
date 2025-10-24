import 'package:geolocator/geolocator.dart';

class LocationController {
  // Workplace coordinates (SENAI Luis Varga, Limeira, SP)
  static const double workplaceLatitude = -22.571;
  static const double workplaceLongitude = -47.404;

  // Request location permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await requestPermission();
      if (!hasPermission) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Add timeout to prevent infinite waiting
      );
    } catch (e) {
      return null;
    }
  }

  // Calculate distance to workplace
  double calculateDistance(double latitude, double longitude) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      workplaceLatitude,
      workplaceLongitude,
    );
  }

  // Check if within 100 meters of workplace
  bool isWithinWorkplace(double latitude, double longitude) {
    double distance = calculateDistance(latitude, longitude);
    return distance <= 100.0; // 100 meters
  }
}
