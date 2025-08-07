import 'dart:developer';

import '../../../import.dart';

class MobileNumberRepository {
  final Dio _dio = Dio();

  Future<dynamic> registerWithMobile(String mobileNumber) async {
    SharedPreferences prfs = await SharedPreferences.getInstance();
    String registerUrl = EndUrl.registerWithMobileUrl;
    log("Mobile : $mobileNumber");
    log("Url : $registerUrl");
    try {
      final response = await _dio.post(
        registerUrl,
        data: {'mobile': mobileNumber},
      );
      log("status code : ${response.statusCode}");

      if (response.statusCode == 200) {
        log("message: ${response.data.toString()}");
        prfs.setBool("isRegistered", true);
        // return 200;
      } else if (response.statusCode == 201) {
        log("statuscode in 201: ${response.statusCode}");
        prfs.setBool("isRegistered", false);
      }
      return response.data;
    } on DioException catch (e) {
      // Handle specific Dio errors
      if (e.response != null) {
        log(e.message.toString());
        throw Exception('Failed to register: ${e.response?.statusCode}');
      } else {
        log(e.message.toString());
        throw Exception('Network error: $e');
      }
    }
  }
}
