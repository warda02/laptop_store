import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String id;
  final String name; // Adjust based on your Firestore document structure

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Explicit type cast
    if (data == null) {
      throw Exception("Document data was null");
    }
    return Brand(
      id: doc.id,
      name: data['name'] ?? '', // Replace with actual field name in Firestore
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // Add more fields as needed
    };
  }
}
