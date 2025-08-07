import 'dart:developer';
import '../../../import.dart';

class LoginRepository {
  final Dio _dio = Dio();

  Future<bool> accountRegister(
      String mobileNumber, String name, String referral) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accountRegisterUrl = EndUrl.accountRegister;
      log("Mobile: $mobileNumber");
      log("URL: $accountRegisterUrl");

      final response = await _dio.post(
        accountRegisterUrl,
        data: {'mobile': mobileNumber, "name": name, "referral_code": referral},
      );

      log("Status code: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The response structure has 'data' as the top level key
        final responseData = response.data['data'];

        // Save registration status
        await prefs.setBool("isRegistered", true);

        // Save tokens - tokens are inside data.token
        final token = responseData['token'];
        if (token != null) {
          await prefs.setString("access_token", token["access"] ?? "");
          await prefs.setString("refresh_token", token["refresh"] ?? "");
        }

        // Save user data - user data is inside data.user
        final user = responseData['user'];
        if (user != null) {
          await prefs.setString("user_id", user["id"].toString());
          await prefs.setString("user_name", user["first_name"] ?? "");
          await prefs.setString("user_mobile", user["mobile"] ?? "");
        }

        log("Data saved successfully to SharedPreferences");
        return true;
      } else {
        log("Registration failed with status code: ${response.statusCode}");
        await prefs.setBool("isRegistered", false);
        return false;
      }
    } on DioException catch (e) {
      log("DioException occurred: ${e.message}");
      if (e.response != null) {
        log("Error response data: ${e.response?.data}");
        log("Error response status code: ${e.response?.statusCode}");
      }
      log('OTP Validation Error: ${e.response?.data['message'] ?? "Something went wrong"}');
      throw Exception(e.response?.data['message'] ?? "Something went wrong");
    } catch (e) {
      log("Unexpected error occurred: $e");
      return false;
    }
  }
}
