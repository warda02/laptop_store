import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Adjust import based on your project structure

class UserProvider extends ChangeNotifier {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) async {
    try {
      await usersCollection.doc(user.id).set(user.toMap());
      print("User Added");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await usersCollection.doc(user.id).update(user.toMap());
      print("User Updated");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to update user: $error");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
      print("User Deleted");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to delete user: $error");
    }
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return usersCollection.snapshots();
  }
}
