import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String _paymentMethod = '';
  String _paymentEvidence = '';

  List<CartItem> get items => _items;
  String get paymentMethod => _paymentMethod;
  String get paymentEvidence => _paymentEvidence;

  double get totalFee {
    return _items.fold(0, (sum, item) => sum + item.lateFee);
  }

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setPaymentEvidence(String evidence) {
    _paymentEvidence = evidence;
    notifyListeners();
  }

  void updateItemDate(String id, DateTime dateFrom, DateTime dateTo) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = CartItem(
        id: item.id,
        title: item.title,
        image: item.image,
        author: item.author,
        lateFee: item.lateFee,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      notifyListeners();
    }
  }

  Map<String, dynamic> toCheckoutJson(String userId) {
    return {
      'userId': userId,
      'items': _items.map((item) => item.toJson()).toList(),
      'totalFee': totalFee,
      'paymentMethod': _paymentMethod,
      'paymentEvidence': _paymentEvidence,
      'dateFrom': _items.first.dateFrom.toIso8601String().split('T')[0],
      'dateTo': _items.first.dateTo.toIso8601String().split('T')[0],
    };
  }
} 