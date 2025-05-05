import 'package:flutter/material.dart';
import '../models/book_detail.dart';
import '../models/book_review.dart';
import '../services/book_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart'; // Ensure CartItem is imported

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<BookDetail> _bookDetailFuture;
  final BookService _bookService = BookService();
  bool _showFullDescription = false;

  @override
  void initState() {
    super.initState();
    _bookDetailFuture = _bookService.getBookDetail(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<BookDetail>(
        future: _bookDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bookDetailFuture = _bookService.getBookDetail(widget.bookId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No book details found'));
          }

          final book = snapshot.data!;
          final availableText = '${book.availableCopies} of ${book.quota} available';
          final isAvailable = book.availableCopies > 0;
          final description = book.description;
          final showMore = description.length > 120 && !_showFullDescription;
          final displayedDescription = showMore ? '${description.substring(0, 120)}...' : description;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 380,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          book.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 80),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 24,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: List.generate(5, (i) => Icon(
                                Icons.star,
                                color: i < book.rating.round() ? Colors.amber : Colors.grey[300],
                                size: 28,
                              )),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              book.rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white, shadows: [Shadow(blurRadius: 2, color: Colors.black26)]),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${book.reviews.length} reviews)',
                              style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w400, shadows: [Shadow(blurRadius: 2, color: Colors.black26)]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${book.author}',
                        style: const TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildBadge(book.category),
                          const SizedBox(width: 8),
                          _buildBadge(book.language),
                          const SizedBox(width: 8),
                          _buildBadge(isAvailable ? 'Available' : 'Unavailable', isAvailable: isAvailable),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.numbers, 'ISBN: ${book.isbn}'),
                      _buildInfoRow(Icons.calendar_today, 'Publikasi: ${book.year}'),
                      _buildInfoRow(Icons.attach_money, 'Denda: Rp${book.lateFee.toStringAsFixed(0)}'),
                      _buildInfoRow(Icons.storage, 'Rak: ${book.rackNumber}'),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Abstract', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        displayedDescription,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      if (showMore)
                        GestureDetector(
                          onTap: () => setState(() => _showFullDescription = true),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text('Show more', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.menu_book_outlined, size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 8),
                          Text(
                            availableText,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          // OutlinedButton(
                          //   onPressed: () {},
                          //   style: OutlinedButton.styleFrom(
                          //     foregroundColor: Colors.black,
                          //     side: const BorderSide(color: Colors.black12),
                          //   ),
                          //   child: const Text('Review this book!'),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...book.reviews.map((review) => _buildReviewCard(review)).toList(),
                      if (book.reviews.isEmpty)
                        const Text('No reviews yet', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<BookDetail>(
        future: _bookDetailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final book = snapshot.data!;
          final isAvailable = book.availableCopies > 0;
          return SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isAvailable && book.canBorrow ? () {
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(
                      CartItem(
                        id: book.id,
                        title: book.title,
                        image: book.image,
                        author: book.author,
                        lateFee: book.lateFee,
                        dateFrom: DateTime.now(),
                        dateTo: DateTime.now().add(const Duration(days: 7)),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book added to cart')),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text, {bool isAvailable = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isAvailable ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BookReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Text(
              review.authorName.isNotEmpty ? review.authorName[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.authorName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(review.date),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) => Icon(
                    Icons.star,
                    size: 16,
                    color: i < review.rating.round() ? Colors.amber : Colors.grey[300],
                  )),
                ),
                const SizedBox(height: 4),
                Text(
                  review.content,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 