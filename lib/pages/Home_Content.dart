import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../pages/productdetails.dart';
import '../providers/cart_provider.dart'; // Import the ProductDetailsPage

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<String> imgList = [
    'assets/images/b1.jpg',
    'assets/images/b2.jpg',
    'assets/images/b3.jpg',
  ];

  String selectedBrand = 'All'; // Default to 'All' to show all products

  // Add a map of brand names to their logo assets
  final Map<String, String> brandLogos = {
    'All': 'assets/images/ALL.png', // Logo for 'All' products
    'Dell': 'assets/images/dell.png',
    'Apple': 'assets/images/apple.png',
    'Acer': 'assets/images/acer.png',
    'Lenovo': 'assets/images/lenovo.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: Column(
        children: [
          // Carousel Slider for images
          CarouselSlider(
            options: CarouselOptions(
              height: 100.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: imgList.map((item) => Container(
              child: Center(
                child: Image.asset(item, fit: BoxFit.cover, width: double.infinity),
              ),
            )).toList(),
          ),
          // Brand Logos Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: brandLogos.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBrand = entry.key;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20, // Adjust radius for smaller size
                    backgroundImage: AssetImage(entry.value),
                    backgroundColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          // Products Slider
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data!.docs.map((doc) {
                return Product.fromFirestore(doc);
              }).toList();

              // Apply brand filter
              if (selectedBrand != 'All') {
                products.removeWhere((product) => product.brand != selectedBrand);
              }

              return CarouselSlider(
                options: CarouselOptions(
                  height: 350.0, // Adjusted height for cards
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: products.map((product) => _buildProductCard(context, product)).toList(),
              );
            },
          ),
          // About Us Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFF275586), // Border color
                  width: 2, // Border width
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to LaptopHarbor! We provide the best deals on laptops and accessories. Explore our wide range of products and find what suits you best. Our mission is to offer the highest quality products at the best prices.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        color: Colors.white, // Set card color to white
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Color(0xFF275586)), // Border color
        ),
        child: Container(
          color: Colors.white, // Set the background color to white
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0, // Fixed height for image
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0), // Adjusted padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Color(0xFF275586)), // Your specified color
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(
                              product.id,
                              product.price,
                              product.title,
                                product.imageUrl
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Item added to cart')),
                            ); // Add to cart functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite_border, color: Color(0xFF275586)), // Your specified color
                          onPressed: () {
                            // Add to wishlist functionality
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < product.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
