import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> fetchProductsAsStream() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (error) {
      print("Failed to add product: $error");
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection('products').doc(id).update(product.toMap());
    } catch (error) {
      print("Failed to update product: $error");
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (error) {
      print("Failed to delete product: $error");
    }
  }

  // Getter for products stream
  Stream<List<Product>> get products {
    return fetchProductsAsStream();
  }
}
