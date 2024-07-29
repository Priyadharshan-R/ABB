import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

Future<void> logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.setBool('isLoggedIn', false);
  await prefs.remove('isLoggedIn');
  await prefs.remove('username');
  context.pop();
  context.go('/login');
}
