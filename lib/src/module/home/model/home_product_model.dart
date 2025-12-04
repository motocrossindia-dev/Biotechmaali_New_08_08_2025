class HomeProductModel {
  final int id;
  final String name;
  final bool isFeatured;
  final bool isBestSeller;
  final bool isSeasonalCollection;
  final bool isTrending;
  bool isCart;
  bool isWishlist;
  final ProductRating productRating;
  final String? image;
  final double? sellingPrice;
  final double? mrp;
  final String? ribbon; // Added ribbon field

  HomeProductModel({
    required this.id,
    required this.name,
    required this.isFeatured,
    required this.isBestSeller,
    required this.isSeasonalCollection,
    required this.isTrending,
    required this.isCart,
    required this.isWishlist,
    required this.productRating,
    this.image,
    this.sellingPrice,
    this.mrp,
    this.ribbon, // Added ribbon parameter
  });

  String? getFullImageUrl() {
    if (image == null) return null;
    const baseUrl = 'https://www.backend.biotechmaali.com';
    return '$baseUrl$image';
  }

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      isBestSeller: json['is_best_seller'] ?? false,
      isSeasonalCollection: json['is_seasonal_collection'] ?? false,
      isTrending: json['is_trending'] ?? false,
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      image: json['image'],
      sellingPrice: json['selling_price']?.toDouble(),
      mrp: json['mrp']?.toDouble(),
      ribbon: json['ribbon']?.toString(), // Added ribbon from JSON
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_featured': isFeatured,
        'is_best_seller': isBestSeller,
        'is_seasonal_collection': isSeasonalCollection,
        'is_trending': isTrending,
        'is_cart': isCart,
        'is_wishlist': isWishlist,
        'product_rating': productRating.toJson(),
        'image': image,
        'selling_price': sellingPrice,
        'mrp': mrp,
        'ribbon': ribbon, // Added ribbon to JSON
      };
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
      avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
      numRatings: json['num_ratings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'avg_rating': avgRating,
        'num_ratings': numRatings,
      };
}
