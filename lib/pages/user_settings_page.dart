import 'package:flutter/material.dart';
import 'package:harbor_eproject/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  String? _currentEmail;
  String? _currentPassword;
  String? _currentPhone;
  String? _currentAddress;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: user?.email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => _currentEmail = val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a 6+ char password' : null,
                onChanged: (val) {
                  setState(() => _currentPassword = val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (val) => val!.isEmpty ? 'Enter a phone number' : null,
                onChanged: (val) {
                  setState(() => _currentPhone = val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (val) => val!.isEmpty ? 'Enter an address' : null,
                onChanged: (val) {
                  setState(() => _currentAddress = val);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (_currentEmail != null && _currentEmail != user?.email) {
                        await user?.updateEmail(_currentEmail!);
                      }
                      if (_currentPassword != null && _currentPassword!.isNotEmpty) {
                        await user?.updatePassword(_currentPassword!);
                      }
                      if (_currentPhone != null || _currentAddress != null) {
                        await users.doc(user?.uid).update({
                          'phone': _currentPhone,
                          'address': _currentAddress,
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
                    } catch (e) {
                      setState(() => error = e.toString());
                    }
                  }
                },
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
