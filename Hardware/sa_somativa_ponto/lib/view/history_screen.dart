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
        title: const Text('Check-In History'),
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
            return const Center(child: Text('No check-ins found'));
          }

          return ListView.builder(
            itemCount: checkIns.length,
            itemBuilder: (context, index) {
              CheckIn checkIn = checkIns[index];
              return ListTile(
                title: Text('Check-In at ${checkIn.timestamp.toLocal()}'),
                subtitle: Text(
                  'Location: ${checkIn.latitude.toStringAsFixed(4)}, ${checkIn.longitude.toStringAsFixed(4)}\n'
                  'Valid: ${checkIn.isValid ? 'Yes' : 'No'}',
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
