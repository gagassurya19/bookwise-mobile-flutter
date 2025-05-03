class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime date;
  final bool read;
  final User user;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.read,
    required this.user,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      read: json['read'] ?? false,
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String phone;
  final String nim;
  final String? nip;
  final String year;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
    required this.nim,
    this.nip,
    required this.year,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      nim: json['nim']?.toString() ?? '',
      nip: json['nip']?.toString(),
      year: json['year']?.toString() ?? '',
    );
  }
} 