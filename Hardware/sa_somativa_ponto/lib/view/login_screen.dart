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
  final TextEditingController _nifController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _useBiometrics = false;
  bool _isLogin = true; // true for login, false for register

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

  Future<void> _authenticate() async {
    if (_nifController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos';
      });
      return;
    }

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

      if (_isLogin) {
        await _authController.signInWithNifAndPassword(
          _nifController.text,
          _passwordController.text,
        );
      } else {
        await _authController.registerWithNifAndPassword(
          _nifController.text,
          _passwordController.text,
        );
      }

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = _isLogin
            ? 'Erro no login. Verifique suas credenciais.'
            : 'Erro no registro. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Entrar' : 'Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin
                  ? 'Entre com seu NIF e senha'
                  : 'Registre-se com seu NIF e senha',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nifController,
              decoration: const InputDecoration(
                labelText: 'NIF',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
                  const Text('Usar Biometria'),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(_isLogin ? 'Entrar' : 'Registrar'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                  _errorMessage = '';
                });
              },
              child: Text(_isLogin
                  ? 'Não tem conta? Registre-se'
                  : 'Já tem conta? Faça login'),
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

  @override
  void dispose() {
    _nifController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
