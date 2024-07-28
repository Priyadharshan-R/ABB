import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _receiveEmails = false;
  bool _passwordVisible = false;

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

  Future<void> _signUp() async {
    final url = 'http://localhost:5000/api/auth/register'; // Your API endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        '': _firstNameController.text + ' ' + _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up successful!')),
      );
    } else {
      final errorMessage = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $errorMessage')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: ListView(
        children: [
          const NavBar(
            isWhite: true,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'New bidders, as soon as you have submitted your information you will be eligible to bid in the auction.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateEmail,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              errorText: _passwordController.text.length < 8
                                  ? 'Password criteria check'
                                  : null,
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
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _receiveEmails,
                                onChanged: (value) {
                                  setState(() {
                                    _receiveEmails = value!;
                                  });
                                },
                              ),
                              Text('Receive outbid emails'),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signUp();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text('Submit'),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(),
                              ),
                              Text('or sign up with'),
                              Expanded(
                                child: Divider(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.account_circle),
                                label: Text('Google'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.account_circle),
                                label: Text('Apple'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.account_circle),
                                label: Text('Facebook'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Want to know more? Auction rules',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                          'assets/sign_up.png'), // Replace with your asset path
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
