import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harbor_eproject/providers/auth_provider.dart';

import 'package:harbor_eproject/pages/user_settings_page.dart';

import '../models/user_model.dart';
import '../pages/UserPortalPage.dart';
import '../pages/contact_support_page.dart';
import '../pages/feedback_page.dart';

class CustomDrawer extends StatelessWidget {
  // Constructor to accept user parameter
  final User? user;

  CustomDrawer({this.user});

  @override
  Widget build(BuildContext context) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF275586), // Set the drawer header color
            ),
            child: user != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Smaller header text
                Text(
                  'LaptopHarbor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Smaller font size
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Welcome, ${user!.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Smaller font size
                  ),
                ),
              ],
            )
                : Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          // Categories Dropdown


          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFF275586)), // Set icon color
            title: Text('User Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback, color: Color(0xFF275586)), // Set icon color
            title: Text('Feedback'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent, color: Color(0xFF275586)), // Set icon color
            title: Text('support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSupportPage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info, color: Color(0xFF275586)), // Set icon color
            title: Text('About Us'),
            onTap: () {
              // Handle About Us
            },
          ),
          if (user != null) // Show logout option only if user is logged in
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF275586)), // Set icon color
              title: Text('Logout'),
              onTap: () {
                // Call logout function from AuthProvider
                context.read<AuthProvider>().signOut();
              },
            ),
        ],
      ),
    );
  }
}
