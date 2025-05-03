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

  print('=== API Request ===');
  print('URL: $uri');
  print('Search Query: $search');
  print('Category: $category');
  print('Year: $year');

  try {
    final response = await http.get(uri);
    print('=== API Response ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('=== Parsed Data ===');
      print('Data Type: ${data.runtimeType}');
      print('Data Content: $data');

      List<Book> books = [];
      
      if (data is List) {
        print('Processing as List');
        books = data.map((book) {
          print('Processing book: $book');
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['books'] is List) {
        print('Processing as Map with books key');
        books = (data['books'] as List).map((book) {
          print('Processing book: $book');
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['data'] is List) {
        print('Processing as Map with data key');
        books = (data['data'] as List).map((book) {
          print('Processing book: $book');
          return Book.fromJson(book);
        }).toList();
      } else if (data is Map && data['items'] is List) {
        print('Processing as Map with items key');
        books = (data['items'] as List).map((book) {
          print('Processing book: $book');
          return Book.fromJson(book);
        }).toList();
      }

      print('=== Final Result ===');
      print('Number of books found: ${books.length}');
      return books;
    } else {
      print('=== Error Response ===');
      print('Status Code: ${response.statusCode}');
      print('Error Body: ${response.body}');
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  } catch (e) {
    print('=== Error ===');
    print('Error Type: ${e.runtimeType}');
    print('Error Message: $e');
    throw Exception('Failed to load books: $e');
  }
}
