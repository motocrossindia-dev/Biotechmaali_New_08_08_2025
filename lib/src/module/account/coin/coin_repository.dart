import 'dart:developer';

import 'package:biotech_maali/src/module/account/coin/model/coin_model.dart';
import 'package:biotech_maali/import.dart';

class CoinRepository {
  final Dio _dio = Dio();

  Future<List<CoinTransaction>> fetchCoinTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      if (token == null) {
        throw Exception('Auth token not found');
      }

      final response = await _dio.get(
        EndUrl.getBtCoinUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;
        log("data in repository : ${data.toString()}");
        final coinTransaction = CoinTransactionResponse.fromJson(data);

        return coinTransaction.data;
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  // This method would be expanded to include redeeming coins
  Future<bool> redeemCoins(int coins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    try {
      if (token == null) {
        throw Exception('Auth token not found');
      }

      final response = await _dio.post(
        '${EndUrl.baseUrl}wallet/redeem-btcoins/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'coins': coins,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to redeem coins: ${response.statusCode}');
      }
    } catch (e) {
      log("error :$e");
      throw Exception('Error redeeming coins: $e');
    }
  }
}
