import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:harbor_eproject/pages/UserPortalPage.dart';
import 'package:harbor_eproject/pages/contact_support_page.dart';
import 'package:harbor_eproject/pages/feedback_page.dart';
import 'package:harbor_eproject/pages/f_password.dart';
import 'package:harbor_eproject/providers/user_provider.dart'; // Duplicate import, remove one
import 'package:harbor_eproject/services/support_request_service.dart';
import 'package:provider/provider.dart';
import 'admin_panel/admin_support_requests_page.dart';
import 'admin_panel/order_management.dart';
import 'firebase_options.dart';

// Providers and Pages imports
import './services/firebase_auth_service.dart';
import './providers/product_provider.dart';
import './providers/cart_provider.dart';
import './providers/wishlist_provider.dart';
import './providers/order_provider.dart';
import './providers/category_provider.dart';
import './providers/brand_provider.dart';
import './providers/Auth_provider.dart';
import './providers/admin_setting_provider.dart';
// import './providers/user_provider.dart'; // Already imported above, remove this line

import './pages/splash_screen.dart';
import './pages/login_page.dart';
import './pages/signup_page.dart';
import './pages/home_page.dart';
import './pages/user_settings_page.dart';
import './pages/accessories_page.dart';
import './pages/product_list.dart';
import './pages/cart_details.dart';
import './pages/checkout_page.dart';
import './pages/logout_page.dart'; // Import LogoutPage

import './admin_panel/admin_dashboard.dart';
import './admin_panel/admin_setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => BrandProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AdminSettingsProvider()),
        Provider(create: (_) => SupportRequestService()),
        Provider(create: (_) => FirebaseAuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Color customPurple = Color(0xFF691372);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF691372,
          <int, Color>{
            50: Color(0xFFE0B2FF),
            100: Color(0xFFB57AFC),
            200: Color(0xFF8E24AA),
            300: Color(0xFF691372),
            400: Color(0xFF4A0072),
            500: Color(0xFF691372),
            600: Color(0xFF4A0072),
            700: Color(0xFF3B0061),
            800: Color(0xFF2A0048),
            900: Color(0xFF1E0038),
          },
        ),
        primaryColor: customPurple,
        hintColor: customPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: customPurple,
          ),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: customPurple,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: customPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: customPurple),
          ),
          labelStyle: TextStyle(color: customPurple),
          hintStyle: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => UserSettingsPage(),
        '/user-portal': (context) => UserPortalPage(),
        '/accessories': (context) => AccessoriesPage(),
        '/support': (context) => ContactSupportPage(),
        '/feedback': (context) => FeedbackPage(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/admin_settings': (context) => AdminSettingsPage(),
        '/logout': (context) => LogoutPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        ProductListPage.routeName: (ctx) => ProductListPage(),
        CartDetails.routeName: (ctx) => CartDetails(),
        CheckoutPage.routeName: (ctx) => CheckoutPage(),
        '/order-management': (context) => OrderManagement(),
        // Avoid defining `home` here since it is already used in initialRoute
      },
    );
  }
}
