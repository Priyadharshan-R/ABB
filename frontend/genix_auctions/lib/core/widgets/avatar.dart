import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    required this.imageUrl,
    this.radius = 15.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        // backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
