import 'package:geolocator/geolocator.dart';

class LocationController {
  // Workplace coordinates (hardcoded for now, e.g., São Paulo, Brazil)
  static const double workplaceLatitude = -23.5505;
  static const double workplaceLongitude = -46.6333;

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
