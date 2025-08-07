import 'dart:developer';

import 'package:biotech_maali/import.dart';

class SettingsProvider extends ChangeNotifier {
  final Dio _dio = Dio()
    ..options = BaseOptions(
      validateStatus: (status) {
        return status! < 500; // Accept any status code less than 500
      },
    );

  Future<bool> checkAccessTokenValidity(BuildContext context) async {
    try {
      String tokenValidityUrl = EndUrl.checkTokenValidityUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? access = prefs.getString("access_token");
      log("Access Token: ${access.toString()}");

      if (access == null) {
        log("No access token found");
        return false;
      }

      final response = await _dio.post(
        tokenValidityUrl,
        data: {"token": access},
      );

      log("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        log("Token is valid");
        return true;
      } else if (response.statusCode == 401) {
        log("Access token expired, checking refresh token");
        bool refreshResult = await checkRefreshTokenValidity();

        if (refreshResult) {
          log("Successfully refreshed token");
          return true;
        } else {
          log("Refresh token also invalid, redirecting to login");
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MobileNumberScreen(),
              ),
              (route) => false,
            );
          }
          return false;
        }
      } else {
        log("Unexpected status code: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      log("DioException occurred: ${e.message}");
      if (e.response != null) {
        log("Error response data: ${e.response?.data}");
      }
      return false;
    } catch (e) {
      log("Unexpected error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> checkRefreshTokenValidity() async {
    String tokenRefreshValidityUrl = EndUrl.checkRefreshTokenUrl;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? refresh = prefs.getString("refresh_token");
    log("Refresh token : $refresh");

    try {
      final response =
          await _dio.post(tokenRefreshValidityUrl, data: {"refresh": refresh});

      if (response.statusCode == 200) {
        log("refresh data : ${response.data.toString()}");
        final access = response.data;

        if (access != null) {
          await prefs.setString("access_token", access["access"] ?? "");
          log("Access : $access");
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
