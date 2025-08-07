import 'dart:developer';
import 'package:flutter/material.dart';
import 'model/order_history_detail_model.dart';
import 'order_history_detail_repository.dart';

class OrderHistoryDetailProvider extends ChangeNotifier {
  final OrderHistoryDetailRepository _repository =
      OrderHistoryDetailRepository();
  bool _isLoading = false;
  String? _error;
  OrderHistoryDetailResponse? _orderDetails;

  bool get isLoading => _isLoading;
  String? get error => _error;
  OrderHistoryDetailResponse? get orderDetails => _orderDetails;

  Future<void> fetchOrderDetails(int orderId) async {
    try {
      _isLoading = true;
      _error = null;

      log('Fetching order details in provider for orderId: $orderId');
      _orderDetails = await _repository.getOrderDetails(orderId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error in provider: $e');
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
