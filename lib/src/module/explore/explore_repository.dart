import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/explore/model/subcategory_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExploreRepository {
  Dio dio = Dio();

  final String mainCategoriesUrl = EndUrl.getMainCategoriesUrl;

  Future<CategoryModel> getMainCategories() async {
    try {
      final response = await dio.get(mainCategoriesUrl);
      log('Category Response: ${response.data}'); // Add this for debugging

      if (response.statusCode == 200 && response.data != null) {
        // Parse the entire response as CategoryModel
        return CategoryModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching categories: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<SubcategoryModel?> getSubcategories(int categoryId) async {
    if (categoryId == 0) {
      Fluttertoast.showToast(msg: "Category id is missing");
      return null;
    }

    try {
      final response = await dio.get(
        "${EndUrl.getCategoryWiseSubCategoryUrl}$categoryId",
        options: Options(
          // headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Wishlist Response: ${response.data}');

      if (response.statusCode == 200) {
        return SubcategoryModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access. Please login again.';
      } else if (response.statusCode == 403) {
        throw 'Access forbidden. You don\'t have permission.';
      } else {
        throw 'Failed to fetch wishlist. Status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      log('Wishlist Error: ${e.message}');
      log('Status code: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');

      switch (e.response?.statusCode) {
        case 401:
          throw 'Unauthorized access. Please login again.';
        case 403:
          throw 'Access forbidden. You don\'t have permission.';
        case 404:
          throw 'Wishlist not found.';
        case 500:
          throw 'Server error. Please try again later.';
        default:
          throw 'Failed to fetch wishlist: ${e.message}';
      }
    }
  }

  
}
