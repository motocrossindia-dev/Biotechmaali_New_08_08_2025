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

        // Use the new OurStoreResponse model for better type safety
        final storeResponse = OurStoreResponse.fromJson(data);

        if (storeResponse.message == 'success') {
          log("store data parsed: ${storeResponse.data.stores.length} stores found");
          return storeResponse.data.stores;
        }
      }
      throw Exception('Failed to load stores');
    } on DioException catch (e) {
      log("Dio error: ${e.message}");
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log("Error loading stores: $e");
      throw Exception('Error loading stores: $e');
    }
  }
}
