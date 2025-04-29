import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class ApiService {
  static const String baseUrl = 'https://bookwise.azurewebsites.net';

  static Future<List<Transaction>> fetchTransactions(String userId) async {
    // Pastikan userId diteruskan dengan benar ke URL
    final url = Uri.parse('$baseUrl/api/transactions?userId=$userId');
    try {
      final response = await http.get(url);

      // Log URL untuk memastikan permintaan benar
      print('Request URL: $url');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
