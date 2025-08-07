import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/model/franchise_model.dart';

class FranchiseRepository {
  final Dio _dio = Dio();

  Future<bool> submitFranchiseInquiry(FranchiseModel franchise) async {
    log("add Franchise : ${franchise.toJson()}");
    try {
      // Get token from secure storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");
      log("Token : ${token.toString()}");
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.post(
        EndUrl.addFranchiseEnquiryUrl,
        data: franchise.toJson(),
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timed out. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'No internet connection. Please try again when online.');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      }

      throw Exception('Network error: Please try again.');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}
