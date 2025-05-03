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
    print('=== Parsing Book ===');
    print('Raw JSON: $json');
    
    // Handle different API response formats
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final title = json['title']?.toString() ?? json['name']?.toString() ?? '';
    final author = json['author']?.toString() ?? json['writer']?.toString() ?? '';
    final coverUrl = json['image']?.toString() ?? 
                    json['coverUrl']?.toString() ?? 
                    json['cover']?.toString() ?? 
                    json['thumbnail']?.toString() ?? '';
    final rating = json['rating'] is double 
        ? json['rating'] 
        : (json['rating'] is int 
            ? json['rating'].toDouble() 
            : 0.0);
    final category = json['category']?.toString() ?? 
                    json['genre']?.toString() ?? 
                    json['type']?.toString() ?? '';
    
    print('Parsed values:');
    print('- ID: $id');
    print('- Title: $title');
    print('- Author: $author');
    print('- Cover URL: $coverUrl');
    print('- Rating: $rating');
    print('- Category: $category');

    return Book(
      id: id,
      title: title,
      author: author,
      coverUrl: coverUrl,
      rating: rating,
      category: category,
    );
  }
}

