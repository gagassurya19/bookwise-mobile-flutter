import 'package:flutter/material.dart';
import '../widgets/book_list.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Koleksi Saya',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Sedang Dibaca'),
                    Tab(text: 'Selesai'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Tab content
              const Expanded(
                child: TabBarView(
                  children: [
                    BookList(isCurrentlyReading: true),
                    BookList(isCurrentlyReading: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

