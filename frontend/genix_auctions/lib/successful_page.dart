import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';
import 'package:genix_auctions/core/widgets/nav_bar.dart';
import 'package:go_router/go_router.dart';

class SuccessfulPage extends StatelessWidget {
  const SuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.white,
      body: ListView(
        children: [
          const NavBar(isWhite: true),
          Center(
            child: Image.asset(
              'assets/successful_signup.png',
              height: MediaQuery.of(context).size.height,
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text(
              'Login now',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
