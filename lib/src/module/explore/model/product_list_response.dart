import 'package:biotech_maali/src/module/home/model/home_product_model.dart';

class ProductListResponse {
  final String message;
  final ProductListData data;

  ProductListResponse({
    required this.message,
    required this.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      message: json['message'],
      data: ProductListData.fromJson(json['data']),
    );
  }
}

class ProductListData {
  final List<HomeProductModel> products;

  ProductListData({
    required this.products,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    return ProductListData(
      products: (json['products'] as List)
          .map((item) => HomeProductModel.fromJson(item))
          .toList(),
    );
  }
}
