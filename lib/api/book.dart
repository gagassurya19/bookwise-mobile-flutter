import 'dart:async';
import 'dart:convert';

import '../models/book.dart';
import 'package:http/http.dart' as http;

// TODO: should be private, move into .env or equivalent
const apiURL = "https://bookwise.azurewebsites.net";

Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse('$apiURL/api/books'));
  final data = jsonDecode(response.body) as List<dynamic>;
  return data.map((book) => Book.fromJson(book)).toList();
}

Future<List<Book>> fetchBooksFromApi({
  String search = '',
  String category = '',
  String year = '',
}) async {
  final Map<String, String> queryParams = {};
  
  if (search.isNotEmpty) {
    queryParams['search'] = search;
  }
  if (category.isNotEmpty && category != 'Semua') {
    queryParams['category'] = category;
  }
  if (year.isNotEmpty) {
    queryParams['year'] = year;
  }

  final uri = Uri.parse('$apiURL/api/books').replace(
    queryParameters: queryParams,
  );

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      List<Book> books = [];
      
      if (data is List) {
        books = data.map((book) {
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['books'] is List) {
        books = (data['books'] as List).map((book) {
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['data'] is List) {
        books = (data['data'] as List).map((book) {
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['items'] is List) {
        books = (data['items'] as List).map((book) {
          return Book.fromJson(book);
        }).toList();
      }

      return books;
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load books: $e');
  }
}
