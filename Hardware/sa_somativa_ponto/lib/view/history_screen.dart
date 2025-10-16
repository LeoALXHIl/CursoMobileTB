import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../controller/auth_controller.dart';
import '../model/checkin.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AuthController _authController = AuthController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    auth.User? user = _authController.getCurrentUser();
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Check-In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            tooltip: 'Página Inicial',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('checkins')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<CheckIn> checkIns = snapshot.data!.docs.map((doc) {
            return CheckIn.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          if (checkIns.isEmpty) {
            return const Center(child: Text('Nenhum check-in encontrado'));
          }

          return ListView.builder(
            itemCount: checkIns.length,
            itemBuilder: (context, index) {
              CheckIn checkIn = checkIns[index];
              return ListTile(
                title: Text('Check-In em ${checkIn.timestamp.toLocal()}'),
                subtitle: Text(
                  'Localização: ${checkIn.latitude.toStringAsFixed(4)}, ${checkIn.longitude.toStringAsFixed(4)}\n'
                  'Válido: ${checkIn.isValid ? 'Sim' : 'Não'}',
                ),
                leading: Icon(
                  checkIn.isValid ? Icons.check_circle : Icons.error,
                  color: checkIn.isValid ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
