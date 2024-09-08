import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => _wishlistItems;

  bool isInWishlist(Product product) {
    return _wishlistItems.any((item) => item.id == product.id);
  }

  void addItem(Product product) {
    if (!isInWishlist(product)) {
      _wishlistItems.add(product);
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    if (isInWishlist(product)) {
      _wishlistItems.removeWhere((item) => item.id == product.id);
      notifyListeners();
    }
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      removeItem(product);
    } else {
      addItem(product);
    }
  }

  Future<void> fetchWishlist(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wishlists')
          .doc(userId)
          .collection('items')
          .get();

      final List<Product> loadedWishlist = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        final product = Product(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          brand: data['brand'] ?? '',
          category: data['category'] ?? '',
          rating: (data['rating'] ?? 0.0).toDouble(),
        );

        loadedWishlist.add(product);
      }

      _wishlistItems.clear();
      _wishlistItems.addAll(loadedWishlist);
      notifyListeners();
    } catch (error) {
      print('Error fetching wishlist: $error');
      throw error;
    }
  }
}
