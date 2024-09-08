import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  final double rating; // Added this line

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.rating = 0.0, // Default value for rating
  });

  // Convert CartItem object to a map for Firestore or other purposes
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'rating': rating, // Include rating here
    };
  }

  // Create a CartItem object from a map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      title: map['title'],
      price: map['price'].toDouble(), // Ensure price is a double
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
      rating: (map['rating'] ?? 0.0).toDouble(), // Safely handle rating
    );
  }
}
