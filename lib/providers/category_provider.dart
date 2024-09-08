import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('categories');

  Stream<List<Category>> fetchCategoriesAsStream() {
    return categoriesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList());
  }

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categoriesList = [];
      snapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Explicit type cast
        if (data != null && data['name'] != null) {
          categoriesList.add(data['name'] as String); // Access 'name' as String
        } else {
          categoriesList.add(''); // Handle null case or provide a default value
        }
      });
      return categoriesList;
    } catch (error) {
      print("Failed to fetch categories: $error");
      return []; // Return empty list or handle error as needed
    }
  }

  Future<void> addCategory(Category category) {
    return categoriesCollection
        .add(category.toMap())
        .then((value) => print("Category Added"))
        .catchError((error) => print("Failed to add category: $error"))
        .whenComplete(() => notifyListeners()); // Notify listeners after operation
  }

  Future<void> updateCategory(Category category) {
    return categoriesCollection
        .doc(category.id)
        .update(category.toMap())
        .then((value) => print("Category Updated"))
        .catchError((error) => print("Failed to update category: $error"))
        .whenComplete(() => notifyListeners()); // Notify listeners after operation
  }

  Future<void> deleteCategory(String categoryId) {
    return categoriesCollection
        .doc(categoryId)
        .delete()
        .then((value) => print("Category Deleted"))
        .catchError((error) => print("Failed to delete category: $error"))
        .whenComplete(() => notifyListeners()); // Notify listeners after operation
  }
}
