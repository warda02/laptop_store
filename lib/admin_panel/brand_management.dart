import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/brand_provider.dart'; // Adjust import based on your project structure
import '../models/brand_model.dart'; // Adjust import based on your project structure

class BrandManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController _controller = TextEditingController();

                  return AlertDialog(
                    title: Text('Add Brand'),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Brand Name'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Add'),
                        onPressed: () {
                          String name = _controller.text.trim();
                          if (name.isNotEmpty) {
                            brandProvider.addBrand(name);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Brand>>(
        stream: brandProvider.fetchBrandsAsStream(),
        builder: (context, AsyncSnapshot<List<Brand>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Brand> brands = snapshot.data!;

          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              Brand brand = brands[index];
              return ListTile(
                title: Text(brand.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController _controller =
                            TextEditingController(text: brand.name);

                            return AlertDialog(
                              title: Text('Edit Brand'),
                              content: TextField(
                                controller: _controller,
                                decoration:
                                InputDecoration(labelText: 'Brand Name'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Update'),
                                  onPressed: () {
                                    String newName = _controller.text.trim();
                                    if (newName.isNotEmpty) {
                                      brandProvider.updateBrand(brand.id, newName);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this brand?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    brandProvider.deleteBrand(brand.id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
}
