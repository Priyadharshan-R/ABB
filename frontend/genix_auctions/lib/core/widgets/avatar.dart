import 'package:flutter/material.dart';
import 'package:genix_auctions/profile_page.dart';
import 'package:genix_auctions/service/logout.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const Avatar({
    super.key,
    required this.imageUrl,
    this.radius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      },
      child: CircleAvatar(
        radius: radius,
        // backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
