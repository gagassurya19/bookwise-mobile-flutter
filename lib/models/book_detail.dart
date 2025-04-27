import 'book_review.dart';

class BookDetail {
  final String id;
  final String title;
  final String author;
  final String image;
  final String description;
  final String isbn;
  final String language;
  final int year;
  final String rackNumber;
  final double rating;
  final int availableCopies;
  final int quota;
  final double lateFee;
  final bool canBorrow;
  final String category;
  final List<BookReview> reviews;

  BookDetail({
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.isbn,
    required this.language,
    required this.year,
    required this.rackNumber,
    required this.rating,
    required this.availableCopies,
    required this.quota,
    required this.lateFee,
    required this.canBorrow,
    required this.category,
    required this.reviews,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isbn: json['isbn']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year']?.toString() ?? '0') ?? 0,
      rackNumber: json['rackNumber']?.toString() ?? '',
      rating: json['rating'] is double ? json['rating'] : (json['rating'] is int ? json['rating'].toDouble() : 0.0),
      availableCopies: json['availableCopies'] is int ? json['availableCopies'] : int.tryParse(json['availableCopies']?.toString() ?? '0') ?? 0,
      quota: json['quota'] is int ? json['quota'] : int.tryParse(json['quota']?.toString() ?? '0') ?? 0,
      lateFee: json['lateFee'] is double ? json['lateFee'] : (json['lateFee'] is int ? json['lateFee'].toDouble() : 0.0),
      canBorrow: json['canBorrow'] is bool ? json['canBorrow'] : false,
      category: json['category']?.toString() ?? '',
      reviews: (json['reviews'] as List?)?.map((review) => BookReview.fromJson(review)).toList() ?? [],
    );
  }
} 