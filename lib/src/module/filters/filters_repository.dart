import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

class FiltersRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'https://backend.gidan.store';

  /// Fetches available filter options for the given category type
  Future<FilterResponseModel> getFilters(String type) async {
    log('Fetching filters — type: $type');
    try {
      final queryParams = type.isNotEmpty ? {'type': type} : null;
      final response = await _dio.get(
        '$baseUrl/filters/filters_n/',
        queryParameters: queryParams,
      );
      log('Filter response status: ${response.statusCode}');
      return FilterResponseModel.fromJson(response.data);
    } catch (e) {
      log('Error fetching filters: $e');
      throw Exception('Failed to load filters');
    }
  }

  /// Applies filters using main_productsFilter with the given params
  Future<ProductListModel> applyFilters(
    Map<String, dynamic> params, {
    String? nextPageUrl,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      final String url =
          nextPageUrl ?? '$baseUrl/filters/main_productsFilter/';

      log('Filter query URL: $url');
      log('Filter query params: $params');

      final options = token != null
          ? Options(headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            })
          : null;

      final response = await _dio.get(
        url,
        queryParameters: nextPageUrl != null ? null : params,
        options: options,
      );

      if (response.statusCode == 200) {
        log('Filter applied — products received');
        return ProductListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to apply filters: ${response.statusCode}');
      }
    } catch (e) {
      log('Error applying filters: $e');
      throw Exception('Error applying filters: $e');
    }
  }
}
