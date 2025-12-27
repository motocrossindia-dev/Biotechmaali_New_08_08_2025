import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

class FiltersRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'https://backend.biotechmaali.com';

  // New API endpoint for getting filters
  Future<FilterResponseModel> getFilters(String type) async {
    log("Fetching filters for type: $type");
    try {
      final response = await _dio.get(
        '$baseUrl/filters/filters_n/',
        queryParameters: {'type': type},
      );
      log("Filter response data: ${response.data.toString()}");
      return FilterResponseModel.fromJson(response.data);
    } catch (e) {
      log("Error fetching filters: $e");
      throw Exception('Failed to load filters');
    }
  }

  // New API endpoint for applying filters
  Future<ProductListModel> applyFilters(
    String type,
    Map<String, dynamic> filters, {
    String? nextPageUrl,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      String url = nextPageUrl ?? '$baseUrl/filters/main_productsFilter/';

      // Build query parameters - handle Lists for multiple values
      Map<String, dynamic> queryParams = {};

      filters.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          // For lists, Dio will automatically create multiple params
          // e.g., subcategory_id=28&subcategory_id=29
          queryParams[key] = value;
        } else if (value != null && value != '') {
          queryParams[key] = value;
        } else {
          // Send empty string for parameters that should be present
          queryParams[key] = '';
        }
      });

      log("Filter query URL: $url");
      log("Filter query params: $queryParams");

      Response? response;

      if (token != null) {
        response = await _dio.get(
          url,
          queryParameters: nextPageUrl != null ? null : queryParams,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            },
          ),
        );
      } else {
        response = await _dio.get(
          url,
          queryParameters: nextPageUrl != null ? null : queryParams,
        );
      }

      if (response.statusCode == 200) {
        log("Filter applied response: ${response.data}");
        return ProductListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to apply filters');
      }
    } catch (e) {
      log("Error applying filters: $e");
      throw Exception('Error applying filters: $e');
    }
  }
}
