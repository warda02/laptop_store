import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSettingsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _adminSettingsCollection =
  FirebaseFirestore.instance.collection('admin_settings');

  Future<void> addAdminSettings(Map<String, dynamic> adminSettings) async {
    try {
      await _adminSettingsCollection.add(adminSettings);
      print("Admin Settings Added");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to add admin settings: $error");
    }
  }

  Future<void> updateAdminSettings(String adminSettingsId, Map<String, dynamic> updatedSettings) async {
    try {
      await _adminSettingsCollection.doc(adminSettingsId).update(updatedSettings);
      print("Admin Settings Updated");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to update admin settings: $error");
    }
  }

  Future<void> deleteAdminSettings(String adminSettingsId) async {
    try {
      await _adminSettingsCollection.doc(adminSettingsId).delete();
      print("Admin Settings Deleted");
      notifyListeners(); // Notify listeners after update
    } catch (error) {
      print("Failed to delete admin settings: $error");
    }
  }

  Stream<QuerySnapshot> fetchAdminSettingsAsStream() {
    return _adminSettingsCollection.snapshots();
  }
}
