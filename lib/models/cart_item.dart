class CartItem {
  final String id;
  final String title;
  final String image;
  final String author;
  final double lateFee;
  final DateTime dateFrom;
  final DateTime dateTo;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.lateFee,
    required this.dateFrom,
    required this.dateTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'author': author,
    };
  }
} 