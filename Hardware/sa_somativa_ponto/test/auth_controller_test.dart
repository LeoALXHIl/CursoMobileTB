import 'package:flutter_test/flutter_test.dart';
import 'package:sa_somativa_ponto/controller/auth_controller.dart';

void main() {
  group('AuthController', () {
    late AuthController authController;

    setUp(() {
      authController = AuthController();
    });

    test('AuthController should be instantiated', () {
      expect(authController, isNotNull);
    });

    test('getCurrentUser should return null when no user is signed in', () {
      expect(authController.getCurrentUser(), isNull);
    });
  });
}
