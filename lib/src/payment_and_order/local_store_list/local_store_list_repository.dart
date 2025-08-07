import 'package:biotech_maali/core/network/app_end_url.dart';
import 'package:biotech_maali/src/payment_and_order/local_store_list/model/local_store_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStoreListRepository {
  final Dio _dio = Dio();

  Future<List<LocalStoreModel>> getStores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    try {
      final response = await _dio.get(
        EndUrl.storeListUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final storeResponse = StoreListResponse.fromJson(response.data);
        return storeResponse.stores;
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      throw Exception('Failed to load stores: $e');
    }
  }
}