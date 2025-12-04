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

  /// Return an order with reason and notes
  Future<Map<String, dynamic>> returnOrder({
    required int orderId,
    required String reason,
    required String notes,
  }) async {
    try {
      // Get access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        return {
          'success': false,
          'message': 'Authentication token not found. Please login again.',
        };
      }

      // Prepare request data
      final requestData = {
        'reason': reason,
        'notes': notes,
      };

      log('Return Order Request - Order ID: $orderId');
      log('Request Data: $requestData');

      // Make API call
      final response = await dio.post(
        '${EndUrl.baseUrl}order/return/$orderId',
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      log('Return Order Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'] ??
              'Order return request submitted successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message':
              response.data['message'] ?? 'Failed to submit return request',
        };
      }
    } on DioException catch (e) {
      log('DioException in returnOrder: ${e.message}');
      log('Response: ${e.response?.data}');

      return {
        'success': false,
        'message': e.response?.data['message'] ??
            e.message ??
            'Failed to submit return request. Please try again.',
      };
    } catch (e) {
      log('Error in returnOrder: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }
}
