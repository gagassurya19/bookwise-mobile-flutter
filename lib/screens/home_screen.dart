import 'package:flutter/material.dart';
import '../utils/dummy_data.dart';
import '../models/book.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan data buku dari DummyData
    final allBooks = DummyData.getBooks();
    final currentlyReadingBooks = DummyData.getCurrentlyReadingBooks();
    final finishedBooks = DummyData.getFinishedBooks();

    // Membuat list untuk rekomendasi (contoh: buku dengan rating tertinggi)
    final recommendedBooks = List<Book>.from(allBooks)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    // Membuat list untuk buku populer (contoh: menggunakan semua buku)
    final popularBooks = allBooks;

    // Membuat list untuk buku baru (contoh: menggunakan 3 buku pertama)
    final newBooks = allBooks.take(3).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              const Text(
                'Welcome to Book Wise',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover your next favorite book',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Currently Reading Section
              _buildSectionHeader('Currently Reading'),
              const SizedBox(height: 12),
              _buildHorizontalBookList(currentlyReadingBooks),
              const SizedBox(height: 24),

              // Popular Books Section
              _buildSectionHeader('Popular Books'),
              const SizedBox(height: 12),
              _buildHorizontalBookList(popularBooks),
              const SizedBox(height: 24),

              // Recommendations Section
              _buildSectionHeader('Recommendations For You'),
              const SizedBox(height: 12),
              _buildHorizontalBookList(recommendedBooks),
              const SizedBox(height: 24),

              // New Books Section
              _buildSectionHeader('New Books'),
              const SizedBox(height: 12),
              _buildHorizontalBookList(newBooks),
              const SizedBox(height: 24),

              // Finished Books Section
              _buildSectionHeader('Finished Books'),
              const SizedBox(height: 12),
              _buildHorizontalBookList(finishedBooks),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk header setiap bagian
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to see all books in this category
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('See All'),
        ),
      ],
    );
  }

  // Widget untuk daftar buku horizontal
  Widget _buildHorizontalBookList(List<Book> books) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildBookCard(books[index]);
        },
      ),
    );
  }

  // Widget untuk card buku
  // Widget untuk card buku
  Widget _buildBookCard(Book book) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.grey.shade500,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Book Title
          Text(
            book.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Author
          Text(
            book.author,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Rating and Progress
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                book.rating.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (book.progress != null && book.progress! < 100)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: book.progress! / 100,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (book.progress != null && book.progress! == 100)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
