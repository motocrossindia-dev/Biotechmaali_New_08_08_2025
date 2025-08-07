import 'dart:developer';

import 'package:biotech_maali/src/payment_and_order/order_history/model.dart/order_history_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_repository.dart';

import '../../../import.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final OrderHistoryRepository _repository = OrderHistoryRepository();
  bool _isLoading = false;
  String? _error;
  OrderHistoryResponse? _orderHistory;

  bool get isLoading => _isLoading;
  String? get error => _error;
  OrderHistoryResponse? get orderHistory => _orderHistory;

  Future<void> fetchOrderHistory() async {
    try {
      _isLoading = true;
      _error = null;

      _orderHistory = await _repository.getOrderHistory();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      log("Error in provider ${e.toString()}");
      notifyListeners();
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final result = await _repository.cancelOrder(orderId);
      log("Cancel Order Result: ${result.toString()}");
      if (result['success']?.contains(orderId) ?? false) {
        await fetchOrderHistory(); // Refresh order list
        return true;
      }
      return false;
    } catch (e) {
      log("Error cancelling order: ${e.toString()}");
      return false;
    }
  }
}
