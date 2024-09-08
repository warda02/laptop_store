import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactSupportPage extends StatefulWidget {
  @override
  _ContactSupportPageState createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _complaintController = TextEditingController();

  void _submitSupportRequest() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final supportRequestData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'complaint': _complaintController.text,
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('support_requests').add(supportRequestData);

    _nameController.clear();
    _emailController.clear();
    _complaintController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Support request submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _complaintController,
              decoration: InputDecoration(labelText: 'Complaint'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitSupportRequest,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
