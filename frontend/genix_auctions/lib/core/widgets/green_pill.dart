import 'package:flutter/material.dart';
import 'package:genix_auctions/core/theme/app_pallete.dart';

class GreenPill extends StatelessWidget {
  final String text;

  const GreenPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: AppPallete.pillColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppPallete.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
