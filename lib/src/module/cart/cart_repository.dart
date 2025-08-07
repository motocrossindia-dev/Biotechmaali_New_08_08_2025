// cart_repository.dart
import 'dart:developer';
import 'package:biotech_maali/core/network/app_end_url.dart';
import 'package:biotech_maali/src/module/cart/model/cart_item_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final dio = Dio();

  Future<bool> updateCartItemQuantity(int cartId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      // Changed from PATCH to PUT based on the error
      final response = await dio.patch(
        EndUrl.updateCartProductQuantityUrl, // Using full URL
        data: {
          'cart_id': cartId,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Update quantity success: ${response.data}");
        return true;
      } else {
        log("Update quantity failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Update quantity error: ${e.toString()}");
      throw Exception('Failed to update quantity: $e');
    }
  }

  Future<bool> deleteCartItem(int cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      final response = await dio.delete(
        '${EndUrl.deleteCartProductUrl}$cartId/', // Using full URL with trailing slash
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Delete cart item success: ${response.data}");
        return true;
      } else {
        log("Delete cart item failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Delete cart item error: ${e.toString()}");
      throw Exception('Failed to delete cart item: $e');
    }
  }

  Future<List<CartItemModel>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      final response = await dio.get(
        EndUrl.getCartProductListUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        log("cart items : ${response.data.toString()}");
        List<CartItemModel> cartItems = (response.data['data']['cart'] as List)
            .map((item) => CartItemModel.fromJson(item))
            .toList();
        return cartItems;
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      log("Get cart items error: ${e.toString()}");
      throw Exception('Failed to load cart items: $e');
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      final response = await dio.post(
        EndUrl.addToCartUrl,
        data: {
          'prod_id': productId,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response data added to cart : ${response.data.toString()}");
        return true;
      } else {
        log("Response allredy in cart : ${response.data.toString()}");
        return false;
      }
    } catch (e) {
      log("Add to cart error: ${e.toString()}");
      return false;
      // throw Exception('Failed to add to cart: $e');
    }
  }

  Future<bool> addToCartForMainProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      final response = await dio.post(
        EndUrl.addToCartUrl,
        data: {
          'main_prod_id': productId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response data added to cart : ${response.data.toString()}");
        return true;
      } else {
        log("Response allredy in cart : ${response.data.toString()}");
        return false;
      }
    } catch (e) {
      log("Add to cart error: ${e.toString()}");
      return false;
    }
  }

  Future<OrderResponseModel> placeOrderFromCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null) throw Exception('Authentication token is missing');

    try {
      final response = await dio.post(
        EndUrl.placeOrderUrl,
        data: {
          'order_source': 'cart',
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
      log("Response status : ${response.statusCode.toString()}");
      log("Response data : ${response.data.toString()}");

      if (response.statusCode == 200) {
        log("success");

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

      throw Exception('Unexpected error occurred');
    } catch (e) {
      log("Place order error: ${e.toString()}");
      if (e is ProfileNotUpdatedException || e is AddressNotUpdatedException) {
        rethrow;
      }
      throw Exception('Failed to place order: $e');
    }
  }
}
