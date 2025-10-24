import 'package:flutter/material.dart';
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
  // bool _useBiometrics = false; // Not used anymore
  bool _biometricsAvailable = false;
  bool? _authMethodBiometric; // null for selection, true for biometric, false for password
  bool _isLogin = true; // true for login, false for register

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    _biometricsAvailable = await _biometricController.canCheckBiometrics();
    if (_biometricsAvailable) {
      var availableBiometrics = await _biometricController.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        // Biometrics available, but we don't set _useBiometrics anymore
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

  Future<void> _authenticateBiometric() async {
    try {
      bool authenticated = await _biometricController.authenticateWithBiometrics();
      if (!authenticated) {
        setState(() {
          _errorMessage = 'Autenticação de biometria falhou';
        });
        return;
      }

      // For biometric, we assume the user is already registered and just authenticate
      // In a real app, you might need to associate biometric with a user account
      // For now, navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro na autenticação biométrica: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _authMethodBiometric == null
                ? _buildAuthMethodSelection()
                : _authMethodBiometric!
                    ? _buildBiometricAuth()
                    : _buildPasswordAuth(),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthMethodSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.business_center, size: 80, color: Colors.white),
        const SizedBox(height: 20),
        const Text(
          'Registro de Ponto',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Escolha seu método de autenticação',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        const SizedBox(height: 50),
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildGradientButton(
                  'Autenticar com Senha',
                  Icons.lock,
                  () => setState(() => _authMethodBiometric = false),
                ),
                if (_biometricsAvailable) const SizedBox(height: 20),
                _buildOutlineButton(
                  'Entrar com biometria',
                  Icons.skip_next,
                  () => Navigator.of(context).pushReplacementNamed('/home'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () => setState(() {
            _isLogin = !_isLogin;
            _errorMessage = '';
            _authMethodBiometric = null;
          }),
          child: Text(
            _isLogin ? 'Não tem conta? Registre-se' : 'Já tem conta? Faça login',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordAuth() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person, size: 60, color: Colors.white),
        const SizedBox(height: 20),
        Text(
          _isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _isLogin ? 'Entre com suas credenciais' : 'Registre-se para continuar',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 40),
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _nifController,
                  decoration: InputDecoration(
                    labelText: 'NIF',
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                _buildGradientButton(
                  _isLogin ? 'Entrar' : 'Registrar',
                  Icons.login,
                  _authenticate,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => setState(() {
                    _authMethodBiometric = null;
                    _errorMessage = '';
                  }),
                  child: const Text('Voltar', style: TextStyle(fontSize: 16)),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricAuth() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.fingerprint, size: 80, color: Colors.white),
        ),
        const SizedBox(height: 30),
        const Text(
          'Autenticação Biométrica',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Toque no sensor biométrico para autenticar',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 50),
        _buildGradientButton('Autenticar', Icons.touch_app, _authenticateBiometric),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () => setState(() {
            _authMethodBiometric = null;
            _errorMessage = '';
          }),
          child: const Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildGradientButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF667eea), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF667eea)),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18, color: Color(0xFF667eea))),
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
