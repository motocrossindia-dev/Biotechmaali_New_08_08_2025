import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/refer_friend/model/referral_model.dart';

class ReferFriendRepository {
  final Dio _dio = Dio();

  Future<ReferralModel?> getReferral() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("Token : ${token.toString()}");

    try {
      final response = await _dio.get(
        EndUrl.getReferralDetailsUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Response : ${response.data.toString()}");

        return ReferralModel.fromJson(response.data);
      } else {
        log("Response : ${response.data.toString()}");
        return null;
      }
    } on DioException catch (e) {
      log("Dio Exception : ${e.response?.data['message'] ?? "Something went wrong"}");
      throw Exception('Error: ${e.toString()}');
    } catch (e) {
      log("Error : ${e.toString()}");
      // return null;
      throw Exception('Error: ${e.toString()}');
    }
  }
}
