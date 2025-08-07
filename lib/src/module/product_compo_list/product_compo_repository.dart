import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_compo_list/model/product_compo_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_repository.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';

class ProductCompoRepository {
  final Dio _dio = Dio();

  Future<ProductCompoResponse> getComboOffers() async {
    try {
      final response = await _dio.get(EndUrl.comboOffersUrl);

      if (response.statusCode == 200) {
        return ProductCompoResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load combo offers');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<OrderResponseModel> buyComboProduct(int productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      if (token == null) throw Exception('Authentication token is missing');

      final response = await _dio.post(
        EndUrl.addSingleProductUrl,
        data: {
          'order_source': 'combo',
          'combo_id': productId,
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
}
