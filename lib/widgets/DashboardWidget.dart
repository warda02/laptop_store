import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCards(context),
          // Other sections like recent orders, top selling products, etc.
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildSummaryCard(context, 'Total Users', 'users', Colors.blue),
          _buildSummaryCard(context, 'Total Orders', 'orders', Colors.green),
          _buildSummaryCard(context, 'Total Products', 'products', Colors.orange),
          _buildSummaryCard(context, 'Total Brands', 'brands', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String collection, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(collection).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }
                return Text(
                  '${snapshot.data!.docs.length}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
