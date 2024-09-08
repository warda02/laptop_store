import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/user_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import '../models/order_model.dart' as app;

class UserPortalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Portal'),
      ),

    );
  }
}
