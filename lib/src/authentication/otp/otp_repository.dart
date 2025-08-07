import 'dart:developer';
import '../../../import.dart';

class OtpRepository {
  final Dio _dio = Dio();

  Future<bool?> validateOtp(
      String mobile, String otp, BuildContext context) async {
    try {
      final response = await _dio.post(
        '${BaseUrl.baseUrl}account/validateOtp/',
        data: {
          'mobile': mobile,
          'otp': otp,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save tokens to SharedPreferences
        log("user data and token: ${response.data.toString()}");
        final prefs = await SharedPreferences.getInstance();
        bool? isRegistered = prefs.getBool("isRegistered");

        if (isRegistered == false) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                mobileNumber: mobile,
              ),
            ),
          );
          return false;
        } else if (isRegistered == true) {
          final responseData = response.data['data'];
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
        }
        return false;
      }
    } on DioException catch (e) {
      log('OTP Validation Error: ${e.response?.data['message'] ?? "Something went wrong"}');
      throw Exception(e.response?.data['message'] ?? "Something went wrong");
    }
    return null;
  }
}
