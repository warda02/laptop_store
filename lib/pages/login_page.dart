import 'package:flutter/material.dart';
import 'package:harbor_eproject/services/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/LH.png',
                height: 120,
              ),
              SizedBox(height: 20),
              Text(
                'Login to your account',
                style: TextStyle(
                  color: Color(0xFF275586), // Text color updated to custom blue
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
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: Color(0xFF275586)), // Label color updated
                        hintStyle: TextStyle(color: Color(0xFF275586)), // Hint color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF275586)), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF275586)), // Border color updated
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
                        hintText: 'Enter your password',
                        labelStyle: TextStyle(color: Color(0xFF275586)), // Label color updated
                        hintStyle: TextStyle(color: Color(0xFF275586)), // Hint color updated
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF275586)), // Border color updated
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF275586)), // Border color updated
                        ),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? 'Enter a 6+ char password' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF275586), // Button background color updated
                      ),
                      child: Text('Log In', style: TextStyle(color: Colors.white)), // Button text color remains white
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final user = await _auth.signInWithEmailAndPassword(email, password);
                          if (user == null) {
                            setState(() {
                              error = 'Could not sign in with those credentials';
                            });
                          } else {
                            if (user.role == 'admin') {
                              Navigator.pushReplacementNamed(context, '/adminDashboard');
                            } else {
                              Navigator.pushReplacementNamed(context, '/home');
                            }
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
                        backgroundColor: Color(0xFF275586), // Button background color updated
                      ),
                      child: Text('Sign Up', style: TextStyle(color: Colors.white)), // Button text color remains white
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Forgot your login details?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF275586), // Text color updated
                          ),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: Text(
                            'Get help logging in.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF275586), // Link color updated
                            ),
                          ),
                        ),
                      ],
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
