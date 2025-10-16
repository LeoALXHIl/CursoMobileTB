import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sa_somativa_ponto/controller/location_controller.dart';

void main() {
  group('LocationController', () {
    late LocationController locationController;

    setUp(() {
      locationController = LocationController();
    });

    test('calculateDistance should return correct distance', () {
      // Test with known coordinates
      double distance = locationController.calculateDistance(-23.5505, -46.6333);
      expect(distance, greaterThan(0));
    });

    test('isWithinWorkplace should return true for workplace coordinates', () {
      bool within = locationController.isWithinWorkplace(-23.5505, -46.6333);
      expect(within, isTrue);
    });

    test('isWithinWorkplace should return false for far coordinates', () {
      bool within = locationController.isWithinWorkplace(-22.5505, -45.6333); // Far away
      expect(within, isFalse);
    });
  });
}
