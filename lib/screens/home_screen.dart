import 'package:flutter/material.dart';
import '../widgets/avatar_row.dart';
import '../widgets/rating_display.dart';
// import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome text
                const Text(
                  'Book Wise',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                // Subtitle
                Text(
                  'Masuk atau daftar untuk mulai menjelajahi dunia!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Masuk / Daftar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Avatar row
                const AvatarRow(),
                const SizedBox(height: 20),

                // Rating
                const RatingDisplay(rating: 5.0, reviewCount: '200+'),

                const SizedBox(height: 60),

                // Lightbulb icon
                Icon(
                  Icons.lightbulb_outline,
                  size: 60,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
