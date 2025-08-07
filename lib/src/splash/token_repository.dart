import 'dart:developer';

import 'package:dio/dio.dart';

class TokenRepository {
  final Dio _dio;

  // Base URL for the API
  static const String _baseUrl =
      "https://www.backend.biotechmaali.com/api/token";

  TokenRepository()
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {"Content-Type": "application/json"},
        ));

  /// Verifies the token (access or refresh).
  Future<bool> verifyToken(String token) async {
    try {
      final response = await _dio.post(
        "/verify/",
        data: {"token": token},
      );

      if (response.statusCode == 200) {
        // Token is valid
        return true;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // Token is invalid or expired
        log("Token is invalid or expired: ${e.response?.data}");
      } else {
        // Handle other errors
        log("Error verifying token: ${e.message}");
      }
    }
    return false;
  }

  /// Refreshes the token if the refresh token is provided.
  Future<String?> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        "/refresh/",
        data: {"refresh": refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Return the new access token
        return response.data["access"];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // Refresh token is invalid or expired
        log("Refresh token is invalid or expired: ${e.response?.data}");
      } else {
        // Handle other errors
        log("Error refreshing token: ${e.message}");
      }
    }
    return null;
  }
}
