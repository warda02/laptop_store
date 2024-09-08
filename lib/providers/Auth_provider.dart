import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harbor_eproject/models/user_model.dart'; // Import your User model

class AuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((authUser) async {
      if (authUser != null) {
        final userData = await _db.collection('users').doc(authUser.uid).get();
        _user = _userFromFirebaseUser(authUser, userData.data());
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  User? _userFromFirebaseUser(auth.User user, Map<String, dynamic>? userData) {
    return User(
      id: user.uid,
      name: userData?['name'] ?? '',
      email: user.email!,
      role: userData?['role'] ?? '',
      username: userData?['username'] ?? '',
      phone: userData?['phone'] ?? '',
      address: userData?['address'] ?? '', // Add address parameter
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        final userData = await _db.collection('users').doc(user.uid).get();
        _user = _userFromFirebaseUser(user, userData.data());
        notifyListeners();
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phone,
    required String address, // Add address parameter
  }) async {
    try {
      final auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'address': address, // Save address to Firestore
          'role': 'user', // Default role is user
        });

        _user = _userFromFirebaseUser(user, {
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'address': address, // Add address
          'role': 'user',
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error registering: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
