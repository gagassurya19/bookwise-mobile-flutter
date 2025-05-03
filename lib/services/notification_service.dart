import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';

class NotificationService {
  final String baseUrl = 'https://bookwise.azurewebsites.net/api';

  Future<List<AppNotification>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        throw Exception('User ID not found in SharedPreferences');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/notifications?userId=$userId'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final notifications = data.map((json) => AppNotification.fromJson(json)).toList();
        
        // Sort notifications by date in descending order (newest to oldest)
        notifications.sort((a, b) => b.date.compareTo(a.date));
        
        return notifications;
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }
} 