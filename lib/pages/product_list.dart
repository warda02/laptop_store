import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../pages/productdetails.dart';
import '../providers/cart_provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/productList';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedBrand = 'All'; // Default to 'All' to show all products

  // List of image paths for the carousel slider
  final List<String> imgList = [
    'assets/images/b1.jpg',
    'assets/images/b2.jpg',
    'assets/images/b3.jpg',
  ];

  // Map of brand names to their logo assets
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
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow button
        title: Text(
          'Products', // Title for the AppBar
          style: TextStyle(
            color: Color(0xFF275586), // Custom color
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Set background color of AppBar
        elevation: 0, // Remove shadow
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Carousel Slider
          Container(
            margin: EdgeInsets.only(bottom: 8.0), // Reduced bottom margin
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imgList.map((item) {
                return Container(
                  child: Center(
                    child: Image.asset(item, fit: BoxFit.cover, width: double.infinity),
                  ),
                );
              }).toList(),
            ),
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
          // Products Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                if (selectedBrand != 'All') {
                  products.removeWhere((product) => product.brand != selectedBrand);
                }

                return GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (ctx, index) {
                    return _buildProductCard(context, products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
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
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Color(0xFF275586)),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0,
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
                          icon: Icon(Icons.shopping_cart, color: Color(0xFF275586)),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(
                              product.id,
                              product.price,
                              product.title,
                              product.imageUrl,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Item added to cart')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite_border, color: Color(0xFF275586)),
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
