import 'package:flutter/material.dart';
import '../widgets/book_grid.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jelajahi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan buku-buku menarik untuk dibaca',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Semua',
                    'Fiksi',
                    'Non-Fiksi',
                    'Pendidikan',
                    'Bisnis',
                    'Teknologi',
                  ].map((category) => _buildCategoryChip(category)).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Book grid
              const Expanded(
                child: BookGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: label == 'Semua' ? Colors.black : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: label == 'Semua' ? Colors.white : Colors.black,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
