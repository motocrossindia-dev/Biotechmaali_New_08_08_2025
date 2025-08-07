import 'dart:developer';
import 'package:biotech_maali/core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final Dio dio = Dio();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await dio.get(
        EndUrl.getOrUpdateProfileUrl,
        options: Options(headers: headers),
      );

      log("Fetch Profile Status Code: ${response.statusCode}");
      log("Fetch Profile Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return response.data['data']['profile'] ?? {};
      } else {
        log('Fetch Profile Error: Unexpected status code');
        return {};
      }
    } on DioException catch (e) {
      log('Dio Error in fetchProfile: ${e.response?.statusCode}');
      log('Error Details: ${e.response?.data}');
      return {};
    } catch (e) {
      log('Unexpected Error in fetchProfile: $e');
      return {};
    }
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String gender,
    required String gst,
    String? dateOfBirth,
  }) async {
    try {
      final headers = await _getHeaders();
      final payload = {
        "profile": {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          'gender': gender,
          'gst': gst,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        }
      };

      log("data from mobile: ${payload.toString()}");

      final response = await dio.patch(
        EndUrl.getOrUpdateProfileUrl,
        data: payload,
        options: Options(headers: headers),
      );

      log("Update Profile Status Code: ${response.statusCode}");
      log("Update Profile Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Show success toast
        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else {
        log('Update Profile Error: Unexpected status code');
        Fluttertoast.showToast(
          msg: "Failed to update profile. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } on DioException catch (e) {
      log('Dio Error in updateProfile: ${e.response?.statusCode}');
      log('Error Details: ${e.response?.data}');

      // Handle 400 status code validation errors
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;

          // Extract the first error message
          String errorMessage = "Validation error occurred";
          errors.forEach((field, messages) {
            if (messages is List && messages.isNotEmpty) {
              errorMessage = messages[0].toString();
              return; // Take the first error message
            }
          });

          // Show validation error toast
          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          // Show generic 400 error toast
          Fluttertoast.showToast(
            msg: "Invalid data provided. Please check your inputs.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        // Show network error toast
        Fluttertoast.showToast(
          msg: "Network error occurred. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      return false;
    } catch (e) {
      log('Unexpected Error in updateProfile: $e');

      // Show unexpected error toast
      Fluttertoast.showToast(
        msg: "An unexpected error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return false;
    }
  }
}
