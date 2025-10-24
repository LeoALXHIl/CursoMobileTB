import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:confetti/confetti.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/location_controller.dart';
import '../controller/auth_controller.dart';
import '../model/checkin.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final LocationController _locationController = LocationController();
  final AuthController _authController = AuthController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = 'Pressione o botão para fazer check-in';
  bool _showSuccessAnimation = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Start the bounce animation
    _bounceController.repeat(reverse: true);

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkIn() async {
    _scaleController.forward().then((_) => _scaleController.reverse());
    setState(() {
      _isLoading = true;
      _statusMessage = 'Obtendo localização...';
    });
    _fadeController.reset();
    _fadeController.forward();

    try {
      Position? position = await _locationController.getCurrentPosition();
      if (position == null) {
        setState(() {
          _statusMessage = 'Permissão de localização negada ou indisponível';
          _isLoading = false;
        });
        _fadeController.reset();
        _fadeController.forward();
        return;
      }

      setState(() {
        _currentPosition = position;
        _statusMessage = 'Verificando distância do local de trabalho...';
      });
      _fadeController.reset();
      _fadeController.forward();
      if (_currentPosition != null) {
        _slideController.reset();
        _slideController.forward();
      }

      double distance = _locationController.calculateDistance(
        position.latitude,
        position.longitude,
      );
      bool isWithinWorkplace = distance <= 500.0; // Increased to 500 meters for testing

      print('Current position: ${position.latitude}, ${position.longitude}');
      print('Workplace position: ${LocationController.workplaceLatitude}, ${LocationController.workplaceLongitude}');
      print('Distance: $distance meters');
      print('Is within workplace: $isWithinWorkplace');

      if (!isWithinWorkplace) {
        setState(() {
          _statusMessage = 'Você não está dentro de 500m do local de trabalho (distância: ${distance.toStringAsFixed(0)}m)';
          _isLoading = false;
        });
        _fadeController.reset();
        _fadeController.forward();
        return;
      }

      // Save check-in to Firestore
      print('Attempting to save check-in to Firestore...');
      auth.User? user = _authController.getCurrentUser();
      print('Current user: ${user?.uid}');
      if (user != null) {
        String checkInId = _firestore.collection('checkins').doc().id;
        CheckIn checkIn = CheckIn(
          id: checkInId,
          userId: user.uid,
          timestamp: DateTime.now(),
          latitude: position.latitude,
          longitude: position.longitude,
          isValid: true,
        );

        print('Saving check-in with ID: $checkInId');
        await _firestore.collection('checkins').doc(checkInId).set(checkIn.toJson());
        print('Check-in saved successfully!');

        setState(() {
          _statusMessage = '🎉 Check-in realizado com sucesso! 🎉';
          _isLoading = false;
          _showSuccessAnimation = true;
        });
        _fadeController.reset();
        _fadeController.forward();

        // Trigger confetti animation
        _confettiController.play();
      } else {
        print('No user logged in!');
        setState(() {
          _statusMessage = 'Erro: Usuário não autenticado';
          _isLoading = false;
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  void _navigateToHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  Future<void> _signOut() async {
    await _authController.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In de Funcionário'),
        backgroundColor: const Color(0xFF667eea),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToHistory,
            tooltip: 'Histórico',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.white70,
                            child: const Icon(Icons.business_center, size: 80, color: Colors.white),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Check-In de Funcionário',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Registre sua presença no local de trabalho',
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
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                _statusMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_currentPosition != null)
                              SlideTransition(
                                position: _slideAnimation,
                                child: Text(
                                  'Localização Atual: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            const SizedBox(height: 40),
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: _buildGradientButton(
                                _isLoading ? 'Processando...' : 'Fazer Check-In',
                                Icons.check_circle,
                                _isLoading ? null : _checkIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Confetti widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, IconData icon, VoidCallback? onPressed) {
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
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
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
}
