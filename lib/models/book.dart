class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;
  final int progress; // 0-100 percentage
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    this.progress = 0,
    required this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['image'],
      rating: json['rating'],
      category: json['category'],
    );
  }
}

