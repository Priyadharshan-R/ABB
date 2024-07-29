// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NavItems extends StatelessWidget {
  final String text;
  final IconData? leadingIcon;
  final void Function()? onTap;

  const NavItems({
    super.key,
    required this.text,
    this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (leadingIcon != null) Icon(leadingIcon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
