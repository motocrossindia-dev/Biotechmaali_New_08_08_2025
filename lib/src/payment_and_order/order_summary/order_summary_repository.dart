import 'dart:developer';

import 'package:biotech_maali/src/authentication/check_access_refresh/check_access_refresh.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_summary_response.dart';

import '../../../import.dart';

class OrderSummaryRepository {
  Dio dio = Dio();

  Future<dynamic> getAllAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String url = EndUrl.getAddressUrl;

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return response.data['data']['address'];
      } else {
        log(response.data.toString());
        return response.data;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<OrderSummaryResponse> updateOrderSummary(
      {required BuildContext context,
      required int orderId,
      required int addressId,
      required String deliveryOption,
      int? storeId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      log(
        "Request payload: orderId: $orderId, addressId: $addressId, deliveryOption: $deliveryOption, storeId: ${prefs.getString('store_id')}",
      );

      Response? response;

      if (deliveryOption == "Pick Up Store") {
        response = await dio.patch(
          EndUrl.orderSummaryUrl,
          data: {
            'order_id': orderId,
            'address_id': addressId,
            'delivery_option': deliveryOption,
            'store_id': storeId.toString(),
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
      } else {
        response = await dio.patch(
          EndUrl.orderSummaryUrl,
          data: {
            'order_id': orderId,
            'address_id': addressId,
            'delivery_option': deliveryOption,
            // 'store_id': storeId.toString(),
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ),
        );
      }

      if (response.statusCode == 200) {
        log("Response data: ${response.data}");
        return OrderSummaryResponse.fromJson(response.data);
      } else if (response.statusCode == 403) {
        // Check if token is expired and needs refresh
        bool isValid =
            await CheckAccessRefresh().checkAccessTokenValidity(context);
        if (!isValid) {
          throw Exception('Session expired. Please login again.');
        }
        // Retry the request with new token
        return updateOrderSummary(
          context: context,
          orderId: orderId,
          addressId: addressId,
          deliveryOption: deliveryOption,
        );
      }

      throw Exception(
          response.data['message'] ?? 'Failed to update order summary');
    } catch (e) {
      log("Error in updateOrderSummary: ${e.toString()}");
      if (e is DioException) {
        if (e.response?.statusCode == 403) {
          throw Exception('Access denied. Please check your login status.');
        }
      }
      throw Exception('Error updating order summary: $e');
    }
  }
}
