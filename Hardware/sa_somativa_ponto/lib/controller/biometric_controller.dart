import 'package:local_auth/local_auth.dart';

class BiometricController {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometrics are available
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // Get available biometrics
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
}
