import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/payment_and_order/add_edit_address/model/add_or_edit_address_model.dart';

class AddEditAddressRepository {
  Dio dio = Dio();

  Future<bool> addAddress(AddOrEditAddressModel address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String url = EndUrl.addOrEditAddressUrl;

    try {
      final response = await dio.post(
        url,
        data: address.toJson(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return true;
      } else {
        log(response.data.toString());
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> editAddress(AddOrEditAddressModel address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String url = EndUrl.addOrEditAddressUrl;

    try {
      final response = await dio.patch(
        url,
        data: address.toJson(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      log("response : ${response.data}");

      if (response.statusCode == 200) {
        log(response.data.toString());
        return true;
      } else {
        log(response.data.toString());
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
