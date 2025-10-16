import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import '../controller/auth_controller.dart';
import '../controller/biometric_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();
  final BiometricController _biometricController = BiometricController();
  String _errorMessage = '';
  bool _useBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = await _biometricController.canCheckBiometrics();
    if (canCheck) {
      List<BiometricType> availableBiometrics = await _biometricController.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        setState(() {
          _useBiometrics = true;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      if (_useBiometrics) {
        bool authenticated = await _biometricController.authenticateWithBiometrics();
        if (!authenticated) {
          setState(() {
            _errorMessage = 'Autenticação de biometria falhou';
          });
          return;
        }
      }

      await _authController.signInWithGoogle();

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign in with Google to access the Employee Check-In App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (_useBiometrics)
              Row(
                children: [
                  Checkbox(
                    value: _useBiometrics,
                    onChanged: (value) {
                      setState(() {
                        _useBiometrics = value ?? false;
                      });
                    },
                  ),
                  const Text('Use Biometrics'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.login),
              label: const Text('Entrar com o Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
