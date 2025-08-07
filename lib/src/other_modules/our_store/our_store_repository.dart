import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/other_modules/our_store/model/our_store_model.dart';

class OurStoresRepository {
  final Dio _dio = Dio();

  Future<List<OurStoreModel>> getOurStoreModels() async {
    try {
      final response = await _dio.get(EndUrl.getStoreList);

      if (response.statusCode == 200) {
        final data = response.data;
        log("store data : ${data.toString()}");
        if (data['message'] == 'success' && data['data'] != null) {
          final stores = data['data']['stores'] as List;
          log("store data : ${stores.toString()}");
          return stores.map((store) => OurStoreModel.fromJson(store)).toList();
        }
      }
      throw Exception('Failed to load stores');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading stores: $e');
    }
  }
}
