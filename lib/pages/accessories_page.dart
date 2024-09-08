import 'package:flutter/material.dart';
import 'package:harbor_eproject/models/accessory.dart'; // Adjust import path based on your project structure

void main() {
  runApp(MaterialApp(
    home: AccessoriesPage(),
  ));
}

class AccessoriesPage extends StatelessWidget {
  static const routeName = '/accessories'; // Define routeName for AccessoriesPage

  final List<Accessory> accessories = [
    Accessory(
      name: 'Accessory 1',
      image: 'assets/images/drive.jpeg',
      price: 49.99,
      description: 'Description of Accessory 1',
    ),
    Accessory(
      name: 'Accessory 2',
      image: 'assets/images/images.jpeg',
      price: 29.99,
      description: 'Description of Accessory 2',
    ),
    // Add more accessories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accessories'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75, // Adjust aspect ratio as needed
        ),
        itemCount: accessories.length,
        itemBuilder: (context, index) {
          Accessory accessory = accessories[index];
          return _buildProductCard(context, accessory);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Accessory accessory) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigate to product details page if needed
              },
              child: Image.asset(
                accessory.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accessory.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Price: \$${accessory.price.toStringAsFixed(2)}'),
                SizedBox(height: 4),
                Text(
                  accessory.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Add to cart logic
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // Add to wishlist logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
