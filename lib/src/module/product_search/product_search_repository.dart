import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_search/model/product_search_model.dart';

class ProductSearchRepository {
  final Dio _dio = Dio();

  Future<SearchResponse> searchProducts(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await _dio.post(
        EndUrl.searchUrl,
        data: {'search': query},
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      log("Response : ${response.statusCode}, data: ${response.data}");

      if (response.data['message'] == 'success') {
        return SearchResponse.fromJson(response.data);
      }
      return SearchResponse(products: [], count: 0);
    } catch (e) {
      log("Error: ${e.toString()}");
      throw Exception('Failed to search products: $e');
    }
  }

  Future<SearchResponse> loadMoreProducts(
      String url, String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    try {
      final response = await _dio.post(
        url,
        data: {'search': searchQuery},
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      log("Response : ${response.statusCode}, data: ${response.data}");

      if (response.data['message'] == 'success') {
        return SearchResponse.fromJson(response.data);
      }
      return SearchResponse(products: [], count: 0);
    } catch (e) {
      log("Error: ${e.toString()}");
      throw Exception('Failed to search products: $e');
    }
  }
}
