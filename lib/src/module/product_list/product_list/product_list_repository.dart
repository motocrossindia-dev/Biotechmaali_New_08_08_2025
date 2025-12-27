import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

class ProductListRepository {
  Dio dio = Dio();

  Future<ProductListModel> getCotegoryProductList(String id,
      {String? nextPageUrl}) async {
    log("id : $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      Response? response;
      String url = nextPageUrl ?? "${EndUrl.categoryProductUrl}$id";

      if (token != null) {
        response = await dio.get(
          url,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await dio.get(url);
      }

      if (response.statusCode == 200) {
        log("data in repository category products : ${response.data.toString()}");
        dynamic responseData = response.data;

        ProductListModel productListModel =
            ProductListModel.fromJson(responseData);

        return productListModel;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching products: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  Future<ProductListModel> getSubCotegoryProductList(String id,
      {String? nextPageUrl}) async {

        
    log("id : $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      Response? response;
      String url = nextPageUrl ?? "${EndUrl.subCategoryProductUrl}$id";

      if (token != null) {
        response = await dio.get(
          url,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await dio.get(url);
      }

      if (response.statusCode == 200) {
        log("data in repository category products : ${response.data.toString()}");
        dynamic responseData = response.data;

        ProductListModel productListModel =
            ProductListModel.fromJson(responseData);

        return productListModel;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching products: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  Future<ProductListModel> getOfferProducts({String? nextPageUrl}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      Response? response;
      String url = nextPageUrl ?? EndUrl.getOfferproductList;

      if (token != null) {
        response = await dio.get(
          url,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await dio.get(url);
      }

      if (response.statusCode == 200) {
        log("data in repository category products : ${response.data.toString()}");
        dynamic responseData = response.data;

        ProductListModel productListModel =
            ProductListModel.fromJson(responseData);
        return productListModel;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching products: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching products: $e');
    }
  }
}
