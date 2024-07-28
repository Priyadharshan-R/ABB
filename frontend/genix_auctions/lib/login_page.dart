import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genix_auctions/bloc/user_session_bloc.dart';
import 'package:genix_auctions/bloc/user_session_event.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // Import for json encoding

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepSignedIn = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await http.post(
        Uri.parse(
            'http://localhost:5000/api/auth/login'), // Replace with your Node.js endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Handle successful login, e.g., store token, navigate to another page

        print('Login successful: ${responseBody['token']}');
        final spref = await SharedPreferences.getInstance();
        spref.setString('user_id', email);
        // spref.setBool('isLoggedIn', true);
        // spref.setString('token', responseBody['token']);
        BlocProvider.of<UserSessionBloc>(context).add(LoggedIn());
        context.go('/home');
      } else {
        // Handle error response
        print('Login failed: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: ListView(
        children: [
          const NavBar(isWhite: true),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Welcome back. Enter your credentials to access your account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateEmail,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _keepSignedIn,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _keepSignedIn = value!;
                                      });
                                    },
                                  ),
                                  Text('Keep me signed in'),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text('Forgot Password'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _login, // Call the login method
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text('Continue'),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('or sign up with'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: Text('Google'),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                child: Text('Apple'),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                child: Text('Facebook'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an Account? ",
                                children: [
                                  TextSpan(
                                    text: 'Sign up here',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Image.asset(
                      'assets/login.png', // Replace with your illustration URL
                      width: 500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
