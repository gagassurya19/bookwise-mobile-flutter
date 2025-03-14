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
