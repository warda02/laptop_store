import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final double rating; // Update type to double
  final String imageUrl;

  CartItemWidget({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.rating = 0.0, // Default value for rating
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        )
            : SizedBox.shrink(),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ₹${price.toStringAsFixed(2)}'),
            SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.yellow[700],
                  size: 16,
                );
              }),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).decreaseQuantity(productId);
              },
            ),
            Text(quantity.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).increaseQuantity(productId);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).removeItem(productId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
