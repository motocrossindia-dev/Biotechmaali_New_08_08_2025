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

  Future<OrderResponseModel> buyComboProduct(int comboId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      if (token == null) throw Exception('Please login to continue');

      log('Buying combo - comboId: $comboId');

      final response = await _dio.post(
        EndUrl.addSingleProductUrl,
        data: {
          'order_source': 'combo',
          'combo_id': comboId,
          'quantity': 1,
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

      log('Combo order response status: ${response.statusCode}');
      log('Combo order response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderResponseModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final responseData = response.data;
        if (responseData['profile_status'] == false) {
          throw ProfileNotUpdatedException();
        } else if (responseData['address_status'] == false) {
          throw AddressNotUpdatedException();
        }
        // Extract error message from response
        String errorMsg =
            responseData['message'] ?? responseData['error'] ?? 'Order failed';
        throw Exception(errorMsg);
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Combo offer not found or no longer available.');
      }

      throw Exception('Failed to place order. Please try again.');
    } on DioException catch (e) {
      log("Dio error placing combo order: ${e.toString()}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      }
      throw Exception('Network error. Please try again.');
    } catch (e) {
      log("Error placing combo order: ${e.toString()}");
      if (e is ProfileNotUpdatedException || e is AddressNotUpdatedException) {
        rethrow;
      }
      rethrow;
    }
  }
}
