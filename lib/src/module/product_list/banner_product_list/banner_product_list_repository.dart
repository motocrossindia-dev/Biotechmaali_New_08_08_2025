import 'dart:developer';
import 'package:biotech_maali/src/module/product_list/banner_product_list/model/banner_product_model.dart';
import '../../../../import.dart';

class BannerProductListRepository {
  final Dio dio = Dio();

  Future<BannerProductResponse> getBannerProducts(int bannerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final String bannerProductUrl =
        '${BaseUrl.baseUrl}promotion/banner/$bannerId/';

    log("Fetching banner products from: $bannerProductUrl");
    log("Access token: $token");

    try {
      Response response;

      if (token != null && token.isNotEmpty) {
        response = await dio.get(
          bannerProductUrl,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
      } else {
        response = await dio.get(
          bannerProductUrl,
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
      }

      log("Banner products response status: ${response.statusCode}");
      log("Banner products response data: ${response.data}");

      if (response.statusCode == 200) {
        return BannerProductResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load banner products. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log("DioException in getBannerProducts: ${e.message}");
      log("DioException response: ${e.response?.data}");
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log("Error in getBannerProducts: $e");
      throw Exception('Failed to load banner products: $e');
    }
  }
}
