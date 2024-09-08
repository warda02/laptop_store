

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category_model.dart';

class CategoryManagementPage extends StatelessWidget {
  static const routeName = '/category_management';

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Category Management'),
      ),
      body: StreamBuilder<List<Category>>(
        stream: categoryProvider.fetchCategoriesAsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    categoryProvider.deleteCategory(category.id);
                  },
                ),
                onTap: () {
                  // Implement update logic or navigate to detail page
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add category page or implement add logic
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
