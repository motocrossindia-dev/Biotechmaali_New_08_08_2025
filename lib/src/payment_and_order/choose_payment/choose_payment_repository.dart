import 'dart:developer';

import '../../../import.dart';

class ChoosePaymentRepository {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> proceedToPayment(
      {required int orderId,
      required String paymentMethod,
      required bool isGst}) async {
    log("Order id in repository: $orderId");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      log("isgst : $isGst");

      final response = await dio.patch(
        '${EndUrl.baseUrl}order/proceedToPayment/',
        data: {
          'order_id': orderId,
          'payment_method': paymentMethod,
          'is_gst': isGst
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        log("response in repository : ${response.data.toString()}");
        return response.data;
      } else if (response.statusCode == 400) {
        log("Error : ${response.data.toString()}");
      }
      throw Exception(response.data['message']);
    } catch (e) {
      log("Exception : ${e.toString()}");
      throw Exception('Error proceeding to payment: $e');
    }
  }

  Future<void> verifyPayment({
    required String? razorpayPaymentId,
    required String? razorpayOrderId,
    required String? razorpaySignature,
    required int? orderId,
    required String? paymentMethod,
  }) async {
    log("razorepay payment id: $razorpayOrderId \n, orderId : $razorpayOrderId,\n Signature : $razorpaySignature,\n OrderId : $orderId ,\n Payment method: $paymentMethod");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await dio.post(
        '${EndUrl.baseUrl}order/verifyPayment/',
        data: {
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_signature': razorpaySignature,
          'order_id': orderId,
          'payment_method': paymentMethod,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Status code = ${response.statusCode}");
      }

      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      log("Error Verifying payment: $e");
      throw Exception('Error verifying payment: $e');
    }
  }

  Future<void> rollbackWalletPayment({
    required int orderId,
    required String walletAmount,
  }) async {
    log("Rolling back wallet payment for order ID: $orderId with amount: $walletAmount");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await dio.post(
        '${EndUrl.baseUrl}order/payments/rollback-wallet/',
        data: {
          'order_id': orderId,
          'wallet_amount': walletAmount,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Wallet rollback successful: ${response.data.toString()}");
      } else {
        log("Error in wallet rollback: ${response.data.toString()}");
        throw Exception(response.data['message']);
      }
    } catch (e) {
      log("Error rolling back wallet payment: $e");

      throw Exception('Error rolling back wallet payment: $e');
    }
  }
}
