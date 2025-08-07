import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'carrier_model.dart';

class CarriersRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'https://backend.biotechmaali.com';

  Future<List<CarrierModel>> getCarriers() async {
    try {
      final response = await _dio.get('$baseUrl/carrier/publicCarrier/');
      if (response.data['message'] == 'success') {
        final carriers = (response.data['data']['carrier'] as List)
            .map((json) => CarrierModel.fromJson(json))
            .toList();
        return carriers;
      }
      throw Exception('Failed to load carriers');
    } catch (e) {
      throw Exception('Failed to load carriers: $e');
    }
  }

  Future<bool> applyForJob(int jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await _dio.post(
        '$baseUrl/carrier/carrier/$jobId/apply/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("response : ${response.statusCode}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to apply for job: $e');
    }
  }
}
