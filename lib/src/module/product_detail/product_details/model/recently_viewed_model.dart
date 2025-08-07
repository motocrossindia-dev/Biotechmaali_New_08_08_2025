class RecentlyViewedResponse {
  final String message;
  final RecentlyViewedData data;

  RecentlyViewedResponse({
    required this.message,
    required this.data,
  });

  factory RecentlyViewedResponse.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedResponse(
      message: json['message'] ?? '',
      data: RecentlyViewedData.fromJson(json['data'] ?? {}),
    );
  }
}

class RecentlyViewedData {
  final List<RecentlyViewedProduct> products;

  RecentlyViewedData({
    required this.products,
  });

  factory RecentlyViewedData.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedData(
      products: (json['products'] as List? ?? [])
          .map((e) => RecentlyViewedProduct.fromJson(e))
          .toList(),
    );
  }
}

class RecentlyViewedProduct {
  final int id;
  final String name;
  bool isCart;
  bool isWishlist;
  final double mrp;
  final double price;
  final String image;
  final ProductRating productRating;

  RecentlyViewedProduct({
    required this.id,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.mrp,
    required this.price,
    required this.image,
    required this.productRating,
  });

  factory RecentlyViewedProduct.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
    );
  }
}

class ProductRating {
  final double avgRating;
  final int numRatings;

  ProductRating({
    required this.avgRating,
    required this.numRatings,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      numRatings: json['num_ratings'] ?? 0,
    );
  }
}
