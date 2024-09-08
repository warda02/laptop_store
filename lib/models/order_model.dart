import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderedAt;
  final String name;
  final String address;
  final String phone;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderedAt,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      orderedAt: (data['orderedAt'] as Timestamp).toDate(),
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderedAt': orderedAt,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }

  Order copyWith({String? id}) {
    return Order(
      id: id ?? this.id,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      orderedAt: orderedAt,
      name: name,
      address: address,
      phone: phone,
    );
  }
}
