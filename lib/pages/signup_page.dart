import 'package:flutter/material.dart';
import 'package:harbor_eproject/services/firebase_auth_service.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String username = '';
  String phone = '';
  String address = ''; // Add address variable
  String error = '';

  @override
  Widget build(BuildContext context) {
    final Color customBlue = Color(0xFF275586); // Updated color

    return Scaffold(
      backgroundColor: Colors.white, // Background color remains white

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/LH.png', // Replace with your logo image path
                height: 120,
              ),
              SizedBox(height: 20),
              Text(
                'Register Yourself',
                style: TextStyle(
                  color: customBlue, // Text color updated
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: customBlue), // Label color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Focused border color updated
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: customBlue), // Label color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Focused border color updated
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                      onChanged: (val) {
                        setState(() => username = val);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: customBlue), // Label color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Focused border color updated
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: customBlue), // Label color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Focused border color updated
                        ),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Enter a 6+ char password' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: customBlue), // Label color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlue), // Focused border color updated
                        ),
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter your phone number' : null,
                      onChanged: (val) {
                        setState(() => phone = val);
                      },
                    ),
                   
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue, // Button background color updated
                      ),
                      child: Text('Sign Up', style: TextStyle(color: Colors.white)), // Button text color remains white
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth.registerWithEmailAndPassword(
                            email: email,
                            password: password,
                            name: name,
                            username: username,
                            phone: phone,
                            address: address, // Pass address to the method
                          );
                          if (result == null) {
                            setState(() {
                              error = 'Registration failed. Please try again.';
                            });
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
                    ),
                    if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue, // Button background color updated
                      ),
                      child: Text('Login', style: TextStyle(color: Colors.white)), // Button text color remains white
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
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
