class Notification {
  final String id;
  final String message;
  final DateTime date;

  Notification({
    required this.id,
    required this.message,
    required this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      message: json['message'],
      date: DateTime.parse(json['date']),
    );
  }
} 