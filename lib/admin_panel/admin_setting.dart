import 'package:flutter/material.dart';
import 'package:harbor_eproject/models/user_model.dart';
import 'package:harbor_eproject/services/firebase_auth_service.dart';

class AdminSettingsPage extends StatelessWidget {
  final FirebaseAuthService firestoreService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Settings'),
      ),
      body: StreamBuilder<List<User>>(
        stream: firestoreService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data;
          if (users == null || users.isEmpty) {
            return Center(child: Text('No admin found'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, user);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await firestoreService.deleteUser(user.id);
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

  void _showEditDialog(BuildContext context, User user) {
    final _nameController = TextEditingController(text: user.name);
    final _emailController = TextEditingController(text: user.email);
    final _roleController = TextEditingController(text: user.role);
    final _usernameController = TextEditingController(text: user.username);
    final _phoneController = TextEditingController(text: user.phone);
    final _addressController = TextEditingController(text: user.address); // Add address controller

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Admin'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _roleController,
                  decoration: InputDecoration(labelText: 'Role'),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'), // Add address input
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final updatedUser = User(
                  id: user.id,
                  name: _nameController.text,
                  email: _emailController.text,
                  role: _roleController.text,
                  username: _usernameController.text,
                  phone: _phoneController.text,
                  address: _addressController.text, // Add address
                );
                await firestoreService.updateUser(updatedUser.id, updatedUser.toMap());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
