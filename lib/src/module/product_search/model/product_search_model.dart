class ProductSearchModel {
  final int id;
  final int prodId;
  final String name;
  bool isCart;
  bool isWishlist;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;
  final String? ribbon;

  ProductSearchModel({
    required this.id,
    required this.prodId,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.mrp,
    required this.sellingPrice,
    required this.image,
    required this.productRating,
    this.ribbon,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      prodId: json['prod_id'] is String
          ? int.parse(json['prod_id'])
          : json['prod_id'] ?? 0,
      name: json['name'] ?? '',
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      mrp: json['mrp'] is String
          ? double.parse(json['mrp'])
          : (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: json['selling_price'] is String
          ? double.parse(json['selling_price'])
          : (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      ribbon: json['ribbon'],
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
  final Map<String, dynamic>? filtersApplied;

  SearchResponse({
    required this.products,
    required this.count,
    this.nextPage,
    this.previousPage,
    this.filtersApplied,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      products: (json['results'] as List)
          .map((product) => ProductSearchModel.fromJson(product))
          .toList(),
      count: json['count'] ?? 0,
      nextPage: json['next'],
      previousPage: json['previous'],
      filtersApplied: json['filters_applied'],
    );
  }
}
