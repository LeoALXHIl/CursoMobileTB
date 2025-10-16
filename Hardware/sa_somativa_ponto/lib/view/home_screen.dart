import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../controller/location_controller.dart';
import '../controller/auth_controller.dart';
import '../model/checkin.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationController _locationController = LocationController();
  final AuthController _authController = AuthController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _currentPosition;
  bool _isLoading = false;
  String _statusMessage = 'Pressione o botão para fazer check-in';

  Future<void> _checkIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Obtendo localização...';
    });

    try {
      Position? position = await _locationController.getCurrentPosition();
      if (position == null) {
        setState(() {
          _statusMessage = 'Permissão de localização negada ou indisponível';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _currentPosition = position;
        _statusMessage = 'Verificando distância do local de trabalho...';
      });

      bool isWithinWorkplace = _locationController.isWithinWorkplace(
        position.latitude,
        position.longitude,
      );

      if (!isWithinWorkplace) {
        setState(() {
          _statusMessage = 'Você não está dentro de 100m do local de trabalho';
          _isLoading = false;
        });
        return;
      }

      // Save check-in to Firestore
      auth.User? user = _authController.getCurrentUser();
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

        await _firestore.collection('checkins').doc(checkInId).set(checkIn.toJson());

        setState(() {
          _statusMessage = 'Check-in realizado com sucesso!';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (_currentPosition != null)
              Text(
                'Localização Atual: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkIn,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Fazer Check-In'),
            ),
          ],
        ),
      ),
    );
  }
}
