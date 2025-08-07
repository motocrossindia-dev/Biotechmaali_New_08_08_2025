class ProductSearchModel {
  final int id;
  final String name;
  bool isCart;
  bool isWishlist;
  final double mrp;
  final double sellingPrice; // Changed from price to sellingPrice
  final String image;
  final ProductRating productRating;

  ProductSearchModel({
    required this.id,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.mrp,
    required this.sellingPrice, // Changed parameter name
    required this.image,
    required this.productRating,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      name: json['name'] ?? '',
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      mrp: json['mrp'] is String
          ? double.parse(json['mrp'])
          : (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice:
          json['selling_price'] is String // Changed from price to selling_price
              ? double.parse(json['selling_price'])
              : (json['selling_price'] as num?)?.toDouble() ?? 0.0,
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
      avgRating: json['avg_rating'] is String
          ? double.parse(json['avg_rating'])
          : (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      numRatings: json['num_ratings'] is String
          ? int.parse(json['num_ratings'])
          : json['num_ratings'] ?? 0,
    );
  }
}

class SearchResponse {
  final List<ProductSearchModel> products;
  final int count;
  final String? nextPage;
  final String? previousPage;

  SearchResponse({
    required this.products,
    required this.count,
    this.nextPage,
    this.previousPage,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      products: (json['products'] as List)
          .map((product) => ProductSearchModel.fromJson(product))
          .toList(),
      count: json['count'] ?? 0,
      nextPage: json['next'],
      previousPage: json['previous'],
    );
  }
}
