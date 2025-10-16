import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart' as model;

class AuthController with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with NIF and password
  Future<auth.UserCredential?> signInWithNifAndPassword(String nif, String password) async {
    try {
      // Create email from NIF for Firebase Auth (since Firebase requires email format)
      String email = '$nif@company.com';

      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Register with NIF and password
  Future<auth.UserCredential?> registerWithNifAndPassword(String nif, String password, {String? name}) async {
    try {
      // Create email from NIF for Firebase Auth
      String email = '$nif@company.com';

      auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nif': nif,
        'email': email,
        'name': name,
      });

      notifyListeners();
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Get current user
  auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Get user data from Firestore
  Future<model.User?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return model.User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Check if user exists by NIF
  Future<bool> userExists(String nif) async {
    try {
      String email = '$nif@company.com';
      var methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
