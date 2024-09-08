import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSupportRequestsPage extends StatelessWidget {
  // Function to delete a complaint from Firestore
  Future<void> _deleteComplaint(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('support_requests').doc(documentId).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Requests'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('support_requests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          final supportRequests = snapshot.data?.docs;

          if (supportRequests == null || supportRequests.isEmpty) {
            return Center(child: Text('No support requests available.'));
          }

          return ListView.builder(
            itemCount: supportRequests.length,
            itemBuilder: (context, index) {
              final request = supportRequests[index].data() as Map<String, dynamic>;
              final documentId = supportRequests[index].id; // Get document ID
              final name = request['name'] ?? 'No name provided';
              final email = request['email'] ?? 'No email provided';
              final complaint = request['complaint'] ?? 'No complaint provided';
              final timestamp = request['timestamp'];
              final formattedDate = timestamp is Timestamp
                  ? timestamp.toDate()
                  : DateTime.tryParse(timestamp.toString()) ?? DateTime.now();

              return ListTile(
                title: Text(name),
                subtitle: Text('Email: $email\nComplaint: $complaint'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formattedDate.toString()), // Use formattedDate here
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _deleteComplaint(documentId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
