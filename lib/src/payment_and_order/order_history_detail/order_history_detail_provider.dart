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

  // Return order state
  bool _isReturning = false;
  String? _returnSuccessMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  OrderHistoryDetailResponse? get orderDetails => _orderDetails;
  bool get isReturning => _isReturning;
  String? get returnSuccessMessage => _returnSuccessMessage;

  // Available return reasons
  final List<String> returnReasons = [
    'Product received is damaged',
    'Wrong product delivered',
    'Product quality is not satisfactory',
    'Product does not match description',
    'Changed my mind',
  ];

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

  /// Submit return order request
  Future<bool> returnOrder({
    required int orderId,
    required String reason,
    required String notes,
  }) async {
    _isReturning = true;
    _error = null;
    _returnSuccessMessage = null;
    notifyListeners();

    try {
      final result = await _repository.returnOrder(
        orderId: orderId,
        reason: reason,
        notes: notes,
      );

      _isReturning = false;

      if (result['success'] == true) {
        _returnSuccessMessage = result['message'];
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isReturning = false;
      _error = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Clear error and success messages
  void clearMessages() {
    _error = null;
    _returnSuccessMessage = null;
    notifyListeners();
  }
}
