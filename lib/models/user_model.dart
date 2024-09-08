import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String username;
  final String phone;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.username,
    required this.phone,
    required this.address,
  });

  // Create User object from Firestore
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      username: data['username'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
    );
  }

  // Convert User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'username': username,
      'phone': phone,
      'address': address,
    };
  }
}
