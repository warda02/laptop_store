import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../providers/brand_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductForm extends StatefulWidget {
  final Product? product;

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late double _price;
  late String _imageUrl;
  late String _brand;
  late String _category;
  late double _rating;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _title = widget.product!.title;
      _description = widget.product!.description;
      _price = widget.product!.price;
      _imageUrl = widget.product!.imageUrl;
      _brand = widget.product!.brand;
      _category = widget.product!.category;
      _rating = widget.product!.rating ?? 0.0;
    } else {
      _title = '';
      _description = '';
      _price = 0.0;
      _imageUrl = '';
      _brand = '';
      _category = '';
      _rating = 0.0;
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final updatedProduct = Product(
      id: widget.product != null ? widget.product!.id : '',
      title: _title,
      description: _description,
      price: _price,
      imageUrl: _imageUrl,
      brand: _brand,
      category: _category,
      rating: _rating,
    );

    if (widget.product != null) {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.product!.id, updatedProduct);
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .addProduct(updatedProduct);
    }

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please pick an image first')),
      );
      return;
    }

    try {
      File file = File(_imageUrl);

      // Adjust the reference path and filename according to your Firebase Storage structure
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('products')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.UploadTask uploadTask = storageRef.putFile(file);

      // Handle the upload task asynchronously
      await uploadTask.whenComplete(() async {
        _imageUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = _imageUrl;
        });
      });
    } catch (error) {
      print('Error uploading image: $error');
      // Handle upload errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              if (_imageUrl.isNotEmpty) ...[
                Image.network(
                  _imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              // Dropdown for Brand
              FutureBuilder<List<String>>(
                future: brandProvider.fetchBrands(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButtonFormField<String>(
                      value: _brand.isEmpty ? null : _brand,
                      decoration: InputDecoration(labelText: 'Brand'),
                      onChanged: (value) {
                        setState(() {
                          _brand = value!;
                        });
                      },
                      items: snapshot.data!.map((String brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a brand';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              // Dropdown for Category
              FutureBuilder<List<String>>(
                future: categoryProvider.fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButtonFormField<String>(
                      value: _category.isEmpty ? null : _category,
                      decoration: InputDecoration(labelText: 'Category'),
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      items: snapshot.data!.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              // Rating field
              TextFormField(
                initialValue: _rating.toString(),
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
                onSaved: (value) {
                  _rating = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image to Firebase'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
