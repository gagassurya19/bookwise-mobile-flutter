class Invoice {
  final double totalFee;
  final DateRange dateRange;
  final String invoiceCode;
  final User user;
  final String paymentEvidence;
  final String status;
  final String type;
  final String paymentMethod;
  final String id;
  final List<InvoiceItem> items;

  Invoice({
    required this.totalFee,
    required this.dateRange,
    required this.invoiceCode,
    required this.user,
    required this.paymentEvidence,
    required this.status,
    required this.type,
    required this.paymentMethod,
    required this.id,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      totalFee: json['totalFee'].toDouble(),
      dateRange: DateRange.fromJson(json['dateRange']),
      invoiceCode: json['invoiceCode'],
      user: User.fromJson(json['user']),
      paymentEvidence: json['paymentEvidence'],
      status: json['status'],
      type: json['type'],
      paymentMethod: json['paymentMethod'],
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
    );
  }
}

class DateRange {
  final String from;
  final String to;

  DateRange({required this.from, required this.to});

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      from: json['from'],
      to: json['to'],
    );
  }
}

class User {
  final String email;
  final String role;
  final String id;
  final String name;
  final String phone;

  User({
    required this.email,
    required this.role,
    required this.id,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      role: json['role'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class InvoiceItem {
  final String author;
  final String id;
  final String title;
  final String image;
  final double lateFee;

  InvoiceItem({
    required this.author,
    required this.id,
    required this.title,
    required this.image,
    required this.lateFee,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      author: json['author'],
      id: json['id'],
      title: json['title'],
      image: json['image'],
      lateFee: json['lateFee'].toDouble(),
    );
  }
} 