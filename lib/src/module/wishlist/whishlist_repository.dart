import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/wishlist/model/wishlist_model.dart';

class WishlistRepository {
  final Dio _dio = Dio();

  Future<WishlistResponse> getWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    log("access token : ${token.toString()}");
    try {
      final response = await _dio.get(
        EndUrl.getAllWhishListUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Wishlist Response: ${response.data}');

      if (response.statusCode == 200) {
        return WishlistResponse.fromJson(response.data);
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

  Future<bool> addToWishlist(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("product in in add to wishlist in repo: $productId");
    try {
      final response = await _dio.post(
        EndUrl.addOrRemoveWilistProduct,
        data: {'prod_id': productId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Add to Wishlist Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        getWishlist();
        return true;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access. Please login again.';
      } else if (response.statusCode == 403) {
        throw 'Access forbidden. You don\'t have permission.';
      } else {
        throw 'Failed to add to wishlist. Status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      log('Add to Wishlist Error: ${e.message}');
      log('Status code: ${e.response?.statusCode}');
      throw 'Failed to add to wishlist: ${e.message}';
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("product id in remove wishist: $productId");
    try {
      final response = await _dio.delete(
        '${EndUrl.addOrRemoveWilistProduct}$productId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Remove from Wishlist Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access. Please login again.';
      } else if (response.statusCode == 403) {
        throw 'Access forbidden. You don\'t have permission.';
      } else {
        throw 'Failed to remove from wishlist. Status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      log('Remove from Wishlist Error: ${e.message}');
      log('Status code: ${e.response?.statusCode}');
      throw 'Failed to remove from wishlist: ${e.message}';
    }
  }

  Future<bool> addOrRemoveWishListMainProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    log("product id in remove wishist: $productId  Token: $token");
    try {
      final response = await _dio.post(
        EndUrl.addOrRemoveWishListUrl,
        data: {"main_prod_id": productId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Remove from Wishlist Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        dynamic status = response.data["data"]["in_wishlist"];
        log("Status : $status");
        return status;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access. Please login again.';
      } else if (response.statusCode == 403) {
        throw 'Access forbidden. You don\'t have permission.';
      } else {
        throw 'Failed to remove from wishlist. Status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      log('Remove from Wishlist Error: ${e.message}');
      log('Status code: ${e.response?.statusCode}');
      throw 'Failed to remove from wishlist: ${e.message}';
    }
  }
}
