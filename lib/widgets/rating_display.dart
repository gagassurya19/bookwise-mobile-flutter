import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final String reviewCount;

  const RatingDisplay({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rating stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(5, (index) => 
              const Icon(Icons.star, color: Color(0xFFFFD700), size: 24)
            ),
            const SizedBox(width: 8),
            Text(
              rating.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        
        // Reviews count
        Text(
          'from $reviewCount reviews',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

