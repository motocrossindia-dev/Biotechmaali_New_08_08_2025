import 'dart:developer';
import '../../../../import.dart';

class ProductRatingRepository {
  final Dio _dio = Dio();
  final String baseUrl = 'YOUR_BASE_URL'; // Replace with your actual base URL

  Future<bool> submitProductRating({
    required int productId,
    required double rating,
    required String reviewTitle,
    required String productReview,
    required bool recommend,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      final response = await _dio.post(
        '${EndUrl.addRatingAndRiviewUrl}$productId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'main_product_id': productId,
          'product_rating': rating,
          'review_title': reviewTitle,
          'product_review': productReview,
          'recommend': recommend,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to submit rating: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioException when submitting rating: ${e.message}');
      if (e.response != null) {
        log('Status code: ${e.response?.statusCode}');
        log('Response data: ${e.response?.data}');
      }
      return false;
    } catch (e) {
      log('Error submitting product rating: $e');
      return false;
    }
  }

  // Method to get the authentication token
  // Future<String> getToken() async {
  //   // Replace with your actual implementation to retrieve the token
  //   // Example using shared preferences:
  //   // final prefs = await SharedPreferences.getInstance();
  //   // return prefs.getString('auth_token') ?? '';

  //   // Example using secure storage:
  //   // final storage = FlutterSecureStorage();
  //   // return await storage.read(key: 'auth_token') ?? '';

  //   return ''; // Replace with your actual token retrieval logic
  // }
}
