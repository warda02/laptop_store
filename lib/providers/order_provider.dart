import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart' as app;
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(List<CartItem> cartItems, double totalAmount, String userId, String name, String address, String phone) async {
    try {
      app.Order newOrder = app.Order(
        id: '', // Firestore will generate this ID
        userId: userId,
        items: cartItems,
        totalAmount: totalAmount,
        orderedAt: DateTime.now(), // Ensure this is current
        name: name,
        address: address,
        phone: phone,
      );

      DocumentReference docRef = await _firestore.collection('orders').add(newOrder.toMap());
      newOrder = newOrder.copyWith(id: docRef.id); // Update order with Firestore-generated ID
      await docRef.update({'id': newOrder.id});
      print('Order successfully added: ${newOrder.id}');
    } catch (error) {
      print('Failed to add order: $error');
    }
  }

  Future<List<app.Order>> fetchAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      List<app.Order> orders = snapshot.docs.map((doc) {
        return app.Order.fromFirestore(doc);
      }).toList();
      return orders;
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      print("Order Deleted");
    } catch (error) {
      print("Failed to delete order: $error");
    }
  }
}
