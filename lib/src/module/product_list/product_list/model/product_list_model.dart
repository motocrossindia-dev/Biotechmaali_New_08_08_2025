class ProductListModel {
  final String message;
  final List<Product> products;
  final String? nextPage;
  final String? previousPage;
  final int count;

  ProductListModel({
    required this.message,
    required this.products,
    this.nextPage,
    this.previousPage,
    required this.count,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'products' and 'results' keys
    List<dynamic> productsList = json['products'] ?? json['results'] ?? [];

    return ProductListModel(
      message: json['message']?.toString() ?? '',
      products: productsList
          .map((productJson) =>
              Product.fromJson(productJson as Map<String, dynamic>))
          .toList(),
      nextPage: json['next']?.toString(),
      previousPage: json['previous']?.toString(),
      count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'products': products.map((product) => product.toJson()).toList(),
      'next': nextPage,
      'previous': previousPage,
      'count': count,
    };
  }
}

class Product {
  final int id;
  final int prodId;
  final String name;
  bool isCart;
  bool isWishlist;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;
  final String? ribbon; // added based on JSON

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['id']),
      prodId: _parseInt(json['prod_id']),
      name: json['name']?.toString() ?? '',
      isCart: _parseBool(json['is_cart']),
      isWishlist: _parseBool(json['is_wishlist']),
      mrp: _parseDouble(json['mrp']),
      sellingPrice: _parseDouble(json['selling_price']),
      image: json['image']?.toString() ?? '',
      productRating: ProductRating.fromJson(
          (json['product_rating'] ?? {}) as Map<String, dynamic>),
      ribbon: json['ribbon']?.toString(),
    );
  }

  // Helper methods for parsing
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final v = value.toLowerCase().trim();
      return v == 'true' || v == '1' || v == 'yes';
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prod_id': prodId,
      'name': name,
      'is_cart': isCart,
      'is_wishlist': isWishlist,
      'mrp': mrp,
      'selling_price': sellingPrice,
      'image': image,
      'product_rating': productRating.toJson(),
      'ribbon': ribbon,
    };
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
      avgRating: Product._parseDouble(json['avg_rating']),
      numRatings: Product._parseInt(json['num_ratings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avg_rating': avgRating,
      'num_ratings': numRatings,
    };
  }
}
