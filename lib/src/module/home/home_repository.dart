import 'dart:developer';

import 'package:biotech_maali/src/module/home/model/banner_model.dart';
import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/home/model/content_block_model.dart';
import 'package:biotech_maali/src/module/home/model/home_product_model.dart';
import '../../../import.dart';

class HomeRepository {
  final dio = Dio();
  final String productUrl = EndUrl.homeProductsUrl;
  final String bannerUrl = EndUrl.promotionBannerUrl;
  final String mainCategoriesUrl = EndUrl.getMainCategoriesUrl;

  Future<List<HomeProductModel>> getHomeProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    log("tokenin home : $token");
    try {
      Response? response;

      if (token != null) {
        response = await dio.get(
          productUrl,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "Application/json"
            },
          ),
        );
      } else {
        response = await dio.get(productUrl);
      }

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['data'] == null ||
            responseData['data']['products'] == null) {
          throw Exception('Invalid response format: missing data or products');
        }

        final List<dynamic> productsData = responseData['data']['products'];
        log("Home Product Data ============== ${productsData.toString()}");
        return productsData
            .map((product) =>
                HomeProductModel.fromJson(product as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching products: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await dio.get(bannerUrl);

      log('Banner Response: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        log('Banner URL: $bannerUrl');
        log('Product URL: $productUrl');
        final Map<String, dynamic> responseData = response.data;

        // Check if the response has the expected structure
        if (responseData['data'] == null ||
            responseData['data']['banners'] == null) {
          throw Exception('Invalid response format: missing data or banners');
        }

        final List<dynamic> bannersData = responseData['data']['banners'];

        log("Banner Data ============== ${bannersData.toString()}");

        return bannersData
            .map((banner) =>
                BannerModel.fromJson(banner as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error fetching banners: ${e.message}');
      }
      throw Exception('Error fetching banners: $e');
    }
  }

  Future<CategoryModel> getMainCategories() async {
    try {
      final response = await dio.get(mainCategoriesUrl);
      log('Category Response: ${response.data}'); // Add this for debugging

      if (response.statusCode == 200 && response.data != null) {
        // Parse the entire response as CategoryModel
        log('Main Categories  : ${response.data.toString()}');
        return CategoryModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        log('Dio error: ${e.message}');
        throw Exception('Network error fetching categories: ${e.message}');
      }
      log('General error: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<bool> addToCartForMainProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    try {
      final response = await dio.post(
        EndUrl.addToCartUrl,
        data: {
          'main_prod_id': productId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("response data added to cart : ${response.data.toString()}");
        return true;
      } else {
        log("Response allredy in cart : ${response.data.toString()}");
        return false;
      }
    } catch (e) {
      log("Add to cart error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> addOrRemoveWishListMainProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    log("product id in remove wishist: $productId  Token: $token");
    try {
      final response = await dio.post(
        EndUrl.addOrRemoveWishListUrl,
        data: {"main_prod_id": productId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      log('Remove from Wishlist Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        dynamic status = response.data["data"]["in_wishlist"];
        log("Status : $status");
        return true;
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access. Please login again.';
      } else if (response.statusCode == 403) {
        throw 'Access forbidden. You don\'t have permission.';
      } else {
        throw 'Failed to remove from wishlist. Status code: ${response.statusCode}';
      }
    } on DioError catch (e) {
      log('Remove from Wishlist Error: ${e.message}');
      log('Status code: ${e.response?.statusCode}');
      throw 'Failed to remove from wishlist: ${e.message}';
    }
  }

  // Fetch content blocks
  Future<List<ContentBlock>> getContentBlocks() async {
    final String contentBlocksUrl = '${BaseUrl.baseUrl}utils/content-blocks/';

    try {
      log("Fetching content blocks from: $contentBlocksUrl");

      Response response = await dio.get(
        contentBlocksUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      log("Content blocks response status: ${response.statusCode}");
      log("Content blocks response data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> contentBlocksData = response.data;
        return contentBlocksData
            .map(
                (block) => ContentBlock.fromJson(block as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load content blocks. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log("DioException in getContentBlocks: ${e.message}");
      log("DioException response: ${e.response?.data}");
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log("Error in getContentBlocks: $e");
      throw Exception('Failed to load content blocks: $e');
    }
  }
}
