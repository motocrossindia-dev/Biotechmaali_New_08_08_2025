import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'model/filter_response_model.dart';

class FiltersRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'https://www.backend.biotechmaali.com';

  Future<FilterResponseModel> getFilters(String type) async {
    log("type : $type");
    try {
      final response = await _dio.get(
        '$baseUrl/filters/filters/',
        queryParameters: {'type': type},
      );
      log("Response data : ${response.data.toString()}");
      return FilterResponseModel.fromJson(response.data);
    } catch (e) {
      log("Error fetching filters: $e");
      throw Exception('Failed to load filters');
    }
  }

  Future<ProductListModel> applyFilters(
      String type, Map<String, dynamic> filters,
      {String? nextPageUrl}) async {
    String result =
        type.isNotEmpty ? type.toLowerCase().substring(0, type.length - 1) : '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      final queryParams = {
        'type': result.toString(),
        ...filters,
      };

      String url = nextPageUrl ?? '$baseUrl/filters/productsFilter/';

      log("Filter query URL: $url");
      log("Filter query params: $queryParams");

      Response? response;

      if (token != null) {
        response = await _dio.get(
          nextPageUrl ?? url,
          queryParameters: nextPageUrl != null ? null : queryParams,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await _dio.get(
          nextPageUrl ?? url,
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
