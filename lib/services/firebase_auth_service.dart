import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harbor_eproject/models/user_model.dart';

class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create user object based on FirebaseUser
  User? _userFromFirebaseUser(auth.User? user, Map<String, dynamic>? userData) {
    print('Creating User object from FirebaseUser');
    return user != null
        ? User(
      id: user.uid,
      name: userData?['name'] ?? '',
      email: user.email!,
      role: userData?['role'] ?? '',
      username: userData?['username'] ?? '',
      phone: userData?['phone'] ?? '',
      address: userData?['address'] ?? '', // Address added

    )
        : null;
  }

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        final userData = await _db.collection('users').doc(user.uid).get();
        print('User data fetched: ${userData.data()}');
        return _userFromFirebaseUser(user, userData.data());
      } catch (e) {
        print('Error fetching user data: $e');
        return null;
      }
    });
  }

  // Get current user
  auth.User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        final userData = await _db.collection('users').doc(user.uid).get();
        print('User data fetched: ${userData.data()}');
        return _userFromFirebaseUser(user, userData.data());
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Register with email, password, name, username, phone, and address
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phone,
    required String address, // Added address parameter
  }) async {
    try {
      final auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final auth.User? user = result.user;

      if (user != null) {
        // Create a new document for the user with their uid
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'address': address, // Save address to Firestore
          'role': 'user', // Default role is user
        });

        print('User registered and data saved');
        return _userFromFirebaseUser(user, {
          'name': name,
          'username': username,




          'email': email,
          'phone': phone,
          'address': address, // Added address
          'role': 'user',
        });
      }
      return null;
    } catch (e) {
      print('Error registering: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Fetch Users
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  // Update User
  Future<void> updateUser(String id, Map<String, dynamic> data) {
    return _db.collection('users').doc(id).update(data);
  }

  // Delete User
  Future<void> deleteUser(String id) {
    return _db.collection('users').doc(id).delete();
  }
}
