import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIn {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final bool isValid; // true if within 100m of workplace

  CheckIn({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.isValid,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'],
      userId: json['userId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      isValid: json['isValid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'isValid': isValid,
    };
  }
}
