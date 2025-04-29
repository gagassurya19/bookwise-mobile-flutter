class Transaction {
  final String id;
  final String invoiceCode;
  final String status;
  final String type;
  final double totalFee;
  final String dateStart;
  final String dateEnd;

  Transaction({
    required this.id,
    required this.invoiceCode,
    required this.status,
    required this.type,
    required this.totalFee,
    required this.dateStart,
    required this.dateEnd,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      invoiceCode: json['invoiceCode'],
      status: json['status'],
      type: json['type'],
      totalFee: json['totalFee'],
      dateStart: json['dateRange']['from'],
      dateEnd: json['dateRange']['to'],
    );
  }
}