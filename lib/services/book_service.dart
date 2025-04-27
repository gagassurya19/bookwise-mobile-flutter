import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/book_detail.dart';

class BookService {
  static const String baseUrl = 'https://bookwise.azurewebsites.net/api';
  
  static const List<String> categories = [
    'fiction',
    'romance',
    'action',
    'memoir',
    'fantasy'
  ];

  static Future<List<Book>> getBooks({
    String? search,
    String? category,
    int? years,
  }) async {
    final queryParams = <String, String>{};
    if (search != null) queryParams['search'] = search;
    if (category != null) queryParams['category'] = category;
    if (years != null) queryParams['years'] = years.toString();

    final url = Uri.parse('$baseUrl/books').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        print('Error response: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
      throw Exception('Failed to load books: $e');
    }
  }

  Future<BookDetail> getBookDetail(String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$bookId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookDetail.fromJson(jsonData);
      } else {
        print('Error response: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load book details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching book details: $e');
      throw Exception('Failed to load book details: $e');
    }
  }
} 