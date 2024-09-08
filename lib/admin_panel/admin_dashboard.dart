import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:harbor_eproject/admin_panel/user_management.dart';
import 'package:harbor_eproject/services/firebase_auth_service.dart';

import '../widgets/DashboardWidget.dart';
import 'Product_management.dart';
import 'admin_support_requests_page.dart';
import 'brand_management.dart';
import 'order_management.dart'; // Adjust based on your project structure

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardWidget(),
    BrandManagement(),
    ProductManagement(),
    UserManagement(),
    OrderManagement(),
    AdminSupportRequestsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);
    final auth.User? currentUser = authService.currentUser;

    String displayName = currentUser != null ? currentUser.email ?? 'Admin' : 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Welcome, $displayName'),
          ),
          IconButton(
            icon: Icon(Icons.logout), // Change the icon to logout icon
            onPressed: () async {
              await authService.signOut(); // Call signOut method from your FirebaseAuthService
              // Navigate to login screen or wherever you want after logout
              Navigator.pushNamed(context, '/login'); // Example route
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.branding_watermark),
            label: 'Brand Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Products Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Management',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'OrderManagement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Complaint Management',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        backgroundColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
