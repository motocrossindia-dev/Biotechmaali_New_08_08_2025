import 'dart:developer';

import 'package:biotech_maali/src/other_modules/services/model/service_enquery_model.dart';
import 'package:biotech_maali/src/other_modules/services/model/service_model.dart';

import '../../../import.dart';

class ServicesRepository {
  final Dio _dio = Dio();

  Future<List<ServiceModel>?> getServices() async {
    try {
      final response = await _dio.get(EndUrl.getServiceListUrl);
      if (response.statusCode == 200) {
        log("Service List Response : ${response.data}");
        final List<dynamic> data = response.data;
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        log("status code in else case : ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<bool> submitEnquiry(ServiceEnquiryModel enquiry) async {
    try {
      final response = await _dio.post(
        EndUrl.serviceEnquiryUrl,
        data: enquiry.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("Dio Exception : ${e.message}");
      throw _handleDioError(e);
    } catch (e) {
      log("Exception : $e");
      throw Exception('Failed to submit enquiry: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out');
      case DioExceptionType.badResponse:
        return Exception(
            'Server error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Network error occurred');
    }
  }
}
