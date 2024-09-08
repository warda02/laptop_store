import 'package:flutter/material.dart';
import 'package:harbor_eproject/models/cart_item.dart';
import 'package:harbor_eproject/providers/order_provider.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {}; // Map to store cart items, keyed by product ID

  // Getter to return a copy of _items
  Map<String, CartItem> get items {
    return {..._items};
  }

  // Method to add an item to the cart
  void addItem(String productId, double price, String title, String imageUrl, {double rating = 0.0}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (CartItem) => CartItem,
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
          rating: rating, // Set initial rating
        ),
      );
    }
    notifyListeners();
  }

  // Method to increase the quantity of an item in the cart
  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (CartItem) => CartItem,
      );
      notifyListeners();
    }
  }

  // Method to decrease the quantity of an item in the cart
  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
              (CartItem) => CartItem,
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  // Method to remove an item from the cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Method to clear the entire cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  // Method to return the total number of items in the cart
  int get itemCount {
    return _items.length;
  }

  // Method to return the total cost of items in the cart
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Method to place an order
  Future<void> placeOrder(String name, String address, String phone) async {
    try {
      await OrderProvider().addOrder(
        _items.values.toList(),
        totalAmount,
        'user_id_here', // Replace with actual user ID
        name,
        address,
        phone,
      );
      clearCart(); // Clear cart after placing order
    } catch (error) {
      print('Failed to place order: $error');
      // Handle error as per your app's requirements
    }
  }
}
