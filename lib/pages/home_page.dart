import 'package:flutter/material.dart';
import 'package:harbor_eproject/pages/Home_Content.dart';
import 'package:harbor_eproject/pages/login_page.dart';
import 'package:harbor_eproject/pages/cart_details.dart';
import 'package:harbor_eproject/pages/product_list.dart';
import 'package:harbor_eproject/pages/user_settings_page.dart';
import 'package:harbor_eproject/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:harbor_eproject/providers/Auth_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    ProductListPage(),
    CartDetails(),
    UserSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: _selectedIndex == 0
          ? PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu, color: Color(0xFF275586)),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      Image.asset(
                        'assets/images/LH.png',
                        height: 40,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.shopping_cart, color: Color(0xFF2D5F94)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CartDetails()),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Color(0xFF275586)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF275586)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF275586)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF275586)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF275586)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : null,
      drawer: _selectedIndex == 0 ? CustomDrawer(user: authProvider.user) : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24, color: Color(0xFF275586)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop, size: 24, color: Color(0xFF275586)),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 24, color: Color(0xFF275586)),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 24, color: Color(0xFF275586)),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF275586),
        unselectedItemColor: Color(0xFF275586),
        onTap: _onTabChanged,
      ),
    );
  }
}
