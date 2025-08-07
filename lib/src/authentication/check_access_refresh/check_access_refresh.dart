import 'dart:developer';

import 'package:biotech_maali/import.dart';

class CheckAccessRefresh {
  final Dio _dio = Dio();
  Future<bool> checkAccessTokenValidity(BuildContext context) async {
    String tokenValidityUrl = EndUrl.checkTokenValidityUrl;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access = prefs.getString("access_token");

    try {
      final response =
          await _dio.post(tokenValidityUrl, data: {"token": access});

      if (response.statusCode == 200) {
        log("token is valid");
        return true;
      } else if (response.statusCode == 401) {
        bool result = await checkRefreshTokenValidity();

        if (result) {
          return true;
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileNumberScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkRefreshTokenValidity() async {
    String tokenValidityUrl = EndUrl.checkTokenValidityUrl;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? refresh = prefs.getString("refresh_token");

    try {
      final response =
          await _dio.post(tokenValidityUrl, data: {"token": refresh});

      if (response.statusCode == 200) {
        log("refresh data : ${response.data.toString()}");
        final newAccessToken = response.data['access'];
        if (newAccessToken != null) {
          await prefs.setString("access_token", newAccessToken);
          log("Access token updated successfully");
        }
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
