import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/dummy_data.dart';

class BookList extends StatelessWidget {
  final bool isCurrentlyReading;

  const BookList({
    super.key,
    required this.isCurrentlyReading,
  });

  @override
  Widget build(BuildContext context) {
    final books = isCurrentlyReading 
        ? DummyData.getCurrentlyReadingBooks()
        : DummyData.getFinishedBooks();
    
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCurrentlyReading ? Icons.book_outlined : Icons.check_circle_outline,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isCurrentlyReading 
                  ? 'Belum ada buku yang sedang dibaca'
                  : 'Belum ada buku yang selesai dibaca',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _buildBookListItem(book, isCurrentlyReading);
      },
    );
  }

  Widget _buildBookListItem(Book book, bool isCurrentlyReading) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book cover
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              book.coverUrl,
              height: 120,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.book, size: 30),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        book.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (isCurrentlyReading)
                        Text(
                          '${book.progress}%',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  if (isCurrentlyReading) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: book.progress / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

