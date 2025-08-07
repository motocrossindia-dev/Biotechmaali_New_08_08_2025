import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_model.dart';

class WalletRepository {
  final Dio dio = Dio();

  Future<WalletDetailsResponse> getWalletDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await dio.get(
        EndUrl.getWalletUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return WalletDetailsResponse.fromJson(response.data);
      }
      throw Exception('Failed to fetch wallet details: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Failed to fetch wallet details: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch wallet details: $e');
    }
  }

  Future<TransactionsResponse> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await dio.get(
        EndUrl.getWalletTransactionUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        log("wallet transaction response: ${response.data}");
        return TransactionsResponse.fromJson(response.data);
      }
      log("Error fetching transactions: ${response.statusCode}");
      throw Exception('Failed to fetch transactions: ${response.statusCode}');
    } on DioException catch (e) {
      log("Error fetching transactions: ${e.message}");
      throw Exception('Failed to fetch transactions: ${e.message}');
    } catch (e) {
      log("Error fetching transactions: $e");
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<Map<String, dynamic>> createWalletOrder(String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await dio.post(
        '${EndUrl.baseUrl}wallet/create-order/',
        data: {'amount': amount},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      log("Create Wallet Order Response: ${response.data}");
      log("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          throw Exception('Null response from server');
        }
        return response.data;
      }
      throw Exception('Failed to create wallet order: ${response.statusCode}');
    } catch (e) {
      log("Create Wallet Order Error: $e");
      throw Exception('Failed to create wallet order: $e');
    }
  }

  Future<void> verifyWalletPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await dio.post(
        '${EndUrl.baseUrl}wallet/verify-payment/',
        data: {
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_signature': razorpaySignature,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Payment verification failed: ${response.statusCode}');
      }

      log("Payment verification successful");
    } catch (e) {
      log("Payment verification error: $e");
      throw Exception('Failed to verify wallet payment: $e');
    }
  }
}
