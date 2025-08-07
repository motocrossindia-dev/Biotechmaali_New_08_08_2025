import 'dart:developer';
import 'package:biotech_maali/core/network/app_end_url.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/order_history_detail_model.dart';

class OrderHistoryDetailRepository {
  final Dio dio = Dio();

  Future<OrderHistoryDetailResponse> getOrderDetails(int orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      log('Fetching order details for orderId: $orderId');
      final response = await dio.get(
        '${EndUrl.baseUrl}order/orderHistoryItems/$orderId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // log('Order details response: ${response.data}');

      if (response.statusCode == 200) {
        log("order history details: ${response.data.toString()}");
        return OrderHistoryDetailResponse.fromJson(response.data);
      }
      throw Exception('Failed to load order details');
    } catch (e) {
      log('Error fetching order details: $e');
      throw Exception('Error getting order details: $e');
    }
  }
}
