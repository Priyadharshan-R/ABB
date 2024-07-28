import 'package:flutter/material.dart';

class SubNavigationButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SubNavigationButton({required this.text, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          text,
          style: const TextStyle(fontFamily: "Outfit", fontSize: 14),
        ),
      ),
    );
  }
}
