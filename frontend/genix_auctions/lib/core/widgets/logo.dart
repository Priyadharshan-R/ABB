import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/themes.dart';
import 'package:go_router/go_router.dart';

class Logo extends StatelessWidget {
  final Color color;
  const Logo({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: InkWell(
        onTap: () => context.go('/home'),
        child: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 50,
            ),
            Text(
              'Genix Auctions',
              style: AppTheme.textStyle(size: 26, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
