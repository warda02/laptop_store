import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/CartItemWidget.dart';

class CartDetails extends StatelessWidget {
  static const routeName = '/cart-details';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items.values.toList();
    final totalAmount = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow button
        title: Text(
          'CartDetails', // Title for the AppBar
          style: TextStyle(
            color: Color(0xFF275586), // Custom color
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Set background color of AppBar
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: <Widget>[
          // Display cart items with quantity adjustment and remove option
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CartItemWidget(
                  id: cartItems[index].id,
                  productId: cartItems[index].productId,
                  title: cartItems[index].title,
                  price: cartItems[index].price,
                  quantity: cartItems[index].quantity,
                  imageUrl: cartItems[index].imageUrl,
                  rating: cartItems[index].rating, // Pass the rating here
                ),
              ),
            ),
          ),
          // Total amount display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Checkout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF275586), // Button background color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
