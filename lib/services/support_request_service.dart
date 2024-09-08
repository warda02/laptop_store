import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/support_request_model.dart';

class SupportRequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<SupportRequest>> fetchAllSupportRequests() async {
    try {
      final snapshot = await _db.collection('support_requests').get();
      return snapshot.docs.map((doc) {
        return SupportRequest.fromMap(doc.data()..['id'] = doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching support requests: $e');
    }
  }
}
