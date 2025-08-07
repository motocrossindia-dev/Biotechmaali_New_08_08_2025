import 'dart:developer';
import 'package:biotech_maali/import.dart';

class ChangeAddressRepository {
  Dio dio = Dio();

  Future<dynamic> getAllAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String url = EndUrl.getAddressUrl;

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return response.data['data']['address'];
      } else {
        log(response.data.toString());
        return response.data;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> deleteAddress(int id) async {
    log("id : $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    log("token : $token");
    String url = "${EndUrl.addOrEditAddressUrl}$id/";

    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return true;
      } else {
        log(response.data.toString());
        return response.data;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> changeDeliveryAddress(int addressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    String url = "${EndUrl.addOrEditAddressUrl}$addressId/";

    log("token: $token");
    log("id: $addressId");

    final response = await dio.patch(
      url,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    log("status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
