import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final String name;
  final String date;
  final String review;
  final int rating;

  const ReviewWidget({
    super.key,
    required this.name,
    required this.date,
    required this.review,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            rating,
            (index) => const Icon(Icons.star, color: Colors.orange, size: 20),
          ),
        ),
        const SizedBox(height: 5),
        Text(review, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(date, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
      ],
    );
  }
}
