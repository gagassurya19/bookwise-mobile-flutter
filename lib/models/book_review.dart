class BookReview {
  final String id;
  final String bookTitle;
  final String authorName;
  final DateTime date;
  final double rating;
  final String content;

  BookReview({
    required this.id,
    required this.bookTitle,
    required this.authorName,
    required this.date,
    required this.rating,
    required this.content,
  });

  factory BookReview.fromJson(Map<String, dynamic> json) {
    return BookReview(
      id: json['id'],
      bookTitle: json['bookTitle'],
      authorName: json['authorName'],
      date: DateTime.parse(json['date']),
      rating: json['rating'].toDouble(),
      content: json['content'],
    );
  }
} 