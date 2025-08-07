import 'dart:developer';

import 'package:biotech_maali/src/payment_and_order/order_history/model.dart/order_history_model.dart';

import '../../../import.dart';

class OrderHistoryRepository {
  final Dio dio = Dio();

  Future<OrderHistoryResponse> getOrderHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await dio.get(
        '${EndUrl.baseUrl}order/orderHistory/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Delivery Address: ${response.data.toString()}");
        return OrderHistoryResponse.fromJson(response.data);
      }
      throw Exception('Failed to load order history');
    } catch (e) {
      throw Exception('Error getting order history: $e');
    }
  }

  Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await dio.post(
        '${EndUrl.baseUrl}tracking/shipway/cancel-orders/',
        data: {
          "order_ids": [orderId]
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to cancel order');
    } catch (e) {
      throw Exception('Error cancelling order: $e');
    }
  }
}
