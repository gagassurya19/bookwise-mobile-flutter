import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import '../models/invoice_model.dart';

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
        final transactions = data.map((json) => Transaction.fromJson(json)).toList();
        
        // Sort transactions by date in descending order (newest first)
        transactions.sort((a, b) {
          final dateA = DateTime.parse(a.dateStart);
          final dateB = DateTime.parse(b.dateStart);
          return dateB.compareTo(dateA);
        });
        
        return transactions;
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  static Future<Invoice> fetchInvoiceDetails(String invoiceCode) async {
    final response = await http.get(
      Uri.parse('https://bookwise.azurewebsites.net/api/transactions/invoice?invoiceCode=$invoiceCode'),
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return Invoice.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load invoice details');
    }
  }

  static Future<http.Response> createTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    return response;
  }
}
