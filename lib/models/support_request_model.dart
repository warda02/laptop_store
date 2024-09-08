import 'package:cloud_firestore/cloud_firestore.dart';

class SupportRequest {
  final String id;
  final String complaint;
  final String email;
  final String name;
  final Timestamp timestamp;

  SupportRequest({
    required this.id,
    required this.complaint,
    required this.email,
    required this.name,
    required this.timestamp,
  });

  factory SupportRequest.fromMap(Map<String, dynamic> map) {
    return SupportRequest(
      id: map['id'],
      complaint: map['complaint'],
      email: map['email'],
      name: map['name'],
      timestamp: map['timestamp'],
    );
  }
}
