import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/recently_viewed_model.dart';

import '../../../../import.dart';

class ProductDetailsRepository {
  final Dio _dio = Dio();

  Future<ProductDetailModel> fetchProductDetails(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("tokenin home : $token");
    try {
      Response? response;

      if (token != null) {
        response = await _dio.get(
          '${EndUrl.getProductDetailsUrl}$productId',
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await _dio.get('${EndUrl.getProductDetailsUrl}$productId');
      }

      if (response.statusCode == 200) {
        log("Product details response: ${response.data}");
        return ProductDetailModel.fromJson(response.data);
      } else {
        log('Failed to get product details: ${response.statusMessage}');
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      log("Error fetching product details: $e");
      throw Exception('Error fetching product details: $e');
    }
  }

  Future<RecentlyViewedResponse> fetchRecentlyViewedProduts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("tokenin home : $token");
    try {
      Response? response;

      if (token != null) {
        response = await _dio.get(
          EndUrl.recentlyViewedProductUrl,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await _dio.get(EndUrl.recentlyViewedProductUrl);
      }
      if (response.statusCode == 200) {
        log("Product details response: ${response.data}");
        return RecentlyViewedResponse.fromJson(response.data);
      } else {
        log('Failed to get product details: ${response.statusMessage}');
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      log("Error fetching product details: $e");
      throw Exception('Error fetching product details: $e');
    }
  }

  Future<ProductDetailModel> filterProduct(
      {required int productId,
      int? sizeId,
      int? planterSizeId,
      int? planterId,
      int? litreId,
      int? colorId,
      int? weightId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("tokenin home : $token");
    try {
      final queryParams = {
        if (sizeId != null) 'size_id': sizeId.toString(),
        if (planterSizeId != null) 'planter_size_id': planterSizeId.toString(),
        if (planterId != null) 'planter_id': planterId.toString(),
        if (litreId != null) 'litre_id': litreId.toString(),
        if (colorId != null) 'color_id': colorId.toString(),
        if (weightId != null) 'weight_id': weightId.toString(),
      };

      log("Filter params: $queryParams");
      log("Product id: $productId");

      Response? response;

      if (token != null) {
        response = await _dio.get(
          '${EndUrl.filterProductUrl}$productId',
          queryParameters: queryParams,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await _dio.get(
          '${EndUrl.filterProductUrl}$productId',
          queryParameters: queryParams,
        );
      }

      if (response.statusCode == 200) {
        log("Filter response: ${response.data}");
        sizeId = null;
        planterSizeId = null;
        planterId = null;
        colorId = null;
        ProductDetailModel model = ProductDetailModel.fromJson(response.data);
        log("produt littre = ${model.data.productLitres}");
        return ProductDetailModel.fromJson(response.data);
      } else {
        throw Exception('Failed to filter product');
      }
    } catch (e) {
      log("Error filtering product: $e");
      throw Exception('Error filtering product: $e');
    }
  }

  Future<bool> addOrRemoveWhishlistCompinationProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    log("product id in remove wishist: $productId  Token: $token");
    try {
      final response = await _dio.post(
        EndUrl.addOrRemoveWishListUrl,
        data: {"prod_id": productId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Remove from Wishlist Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        dynamic status = response.data["data"]["in_wishlist"];
        log("Status : $status");
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

  Future<OrderResponseModel> buySingleProduct(
      int productId, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      if (token == null) throw Exception('Authentication token is missing');

      final response = await _dio.post(
        EndUrl.addSingleProductUrl,
        data: {
          'order_source': 'product',
          'prod_id': productId,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes below 500
          },
        ),
      );

      if (response.statusCode == 200) {
        log('Order response: ${response.data}');
        return OrderResponseModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final responseData = response.data;
        if (responseData['profile_status'] == false) {
          throw ProfileNotUpdatedException();
        } else if (responseData['address_status'] == false) {
          throw AddressNotUpdatedException();
        }
        throw Exception(responseData['message']);
      }

      throw Exception('Failed to place order');
    } catch (e) {
      log("Place order error: ${e.toString()}");
      if (e is ProfileNotUpdatedException || e is AddressNotUpdatedException) {
        rethrow;
      }
      throw Exception('Failed to place order: $e');
    }
  }

  Future<bool> increaseOrDecreaseQty(
      int qty, String productId, bool isIncrease) async {
    log("Qty : $qty, productId : $productId, Method : increment - $isIncrease");

    log("Url : ${EndUrl.increaseOrDecreaseQtyUrl}$productId/?quantity=$qty&action=${isIncrease ? "increment" : "decrement"}");
    try {
      Response response = await _dio.get(
        "${EndUrl.increaseOrDecreaseQtyUrl}$productId/?quantity=$qty&action=${isIncrease ? "increment" : "decrement"}",
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;
        log(" ${data.toString()}");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error in repository : $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> checkDeliveryPincode(String pincode) async {
    try {
      final response = await _dio.post(
        '${EndUrl.baseUrl}tracking/check-pincode/',
        data: {'pincode': pincode},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to check pincode');
    } catch (e) {
      log("Pincode check error: $e");
      throw Exception('Error checking pincode: $e');
    }
  }
}

class ProfileNotUpdatedException implements Exception {
  String message = 'User profile is not updated.';
}

class AddressNotUpdatedException implements Exception {
  String message = 'User address is not updated.';
}
