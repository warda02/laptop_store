import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';// Adjust import based on your project structure

class BrandProvider extends ChangeNotifier {
  final CollectionReference brandsCollection =
  FirebaseFirestore.instance.collection('brands');

  // Stream method to fetch brands as a stream of lists
  Stream<List<Brand>> fetchBrandsAsStream() {
    return brandsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Brand.fromFirestore(doc)).toList());
  }

  // Method to fetch brands as a list of strings
  Future<List<String>> fetchBrands() async {
    try {
      QuerySnapshot snapshot = await brandsCollection.get();
      List<String> brandsList = [];
      snapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Explicit type cast
        if (data != null && data['name'] != null) {
          brandsList.add(data['name'] as String); // Access 'name' as String
        } else {
          brandsList.add(''); // Handle null case or provide a default value
        }
      });
      return brandsList;
    } catch (error) {
      print("Failed to fetch brands: $error");
      return []; // Return empty list or handle error as needed
    }
  }

  // Method to add a new brand
  Future<void> addBrand(String name) async {
    try {
      await brandsCollection.add({'name': name});
      print("Brand Added");
    } catch (error) {
      print("Failed to add brand: $error");
    }
  }

  // Method to update an existing brand
  Future<void> updateBrand(String brandId, String newName) async {
    try {
      await brandsCollection.doc(brandId).update({'name': newName});
      print("Brand Updated");
    } catch (error) {
      print("Failed to update brand: $error");
    }
  }

  // Method to delete a brand
  Future<void> deleteBrand(String brandId) async {
    try {
      await brandsCollection.doc(brandId).delete();
      print("Brand Deleted");
    } catch (error) {
      print("Failed to delete brand: $error");
    }
  }
}

