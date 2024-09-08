import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:harbor_eproject/providers/cart_provider.dart';

import '../models/cart_item.dart'; // Import your cart provider

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot doc = await getUserDetails(user.uid);
      setState(() {
        _phoneController.text = doc['phone'];
        _nameController.text = doc['name'];
        _emailController.text = doc['email'];
      });
    }
  }

  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Access cart items from CartProvider
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        List<CartItem> cartItems = cartProvider.items.values.toList();

        // Convert cart items to the format needed for Firestore
        List<Map<String, dynamic>> orderItems = cartItems.map((item) {
          return {
            'id': item.id,
            'price': item.price,
            'productId': item.productId,
            'quantity': item.quantity,
            'title': item.title,
          };
        }).toList();

        // Calculate total amount dynamically
        int totalAmount = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity).toInt());

        await FirebaseFirestore.instance.collection('orders').add({
          'address': _addressController.text,
          'id': DateTime.now().toString(),
          'items': orderItems,
          'name': _nameController.text,
          'orderedAt': Timestamp.now(),
          'phone': _phoneController.text,
          'totalAmount': totalAmount,
          'userId': user.uid,
        });

        // Clear the cart after order is placed
        cartProvider.clearCart();

        _showOrderConfirmationDialog();
      }
    }
  }

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Confirmation'),
          content: Text('Your order has been placed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home'); // Replace with your home route
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Color(0xFF275586),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xFF275586)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF275586)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: Color(0xFF275586)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Color(0xFF275586)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF275586)),
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Enter your address' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF275586),
                ),
                child: Text('Place Order', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
