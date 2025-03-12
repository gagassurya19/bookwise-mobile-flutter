class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;
  final int progress; // 0-100 percentage

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    this.progress = 0,
  });
}

