class ProductListModel {
  final String message;
  final List<Product> products;
  final String? nextPage;
  final int count;

  ProductListModel({
    required this.message,
    required this.products,
    this.nextPage,
    required this.count,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'products' and 'results' keys
    List<dynamic> productsList = json['products'] ?? json['results'] ?? [];

    return ProductListModel(
      message: json['message']?.toString() ?? '',
      products: productsList
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      nextPage: json['next']?.toString(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'products': products.map((product) => product.toJson()).toList(),
      'next': nextPage,
      'count': count,
    };
  }
}

class Product {
  final int id;
  final String name;
  bool isCart;
  bool isWishlist;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;

  Product({
    required this.id,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.mrp,
    required this.sellingPrice,
    required this.image,
    required this.productRating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseId(json['id']),
      name: json['name']?.toString() ?? '',
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      mrp: _parseDouble(json['mrp']),
      sellingPrice: _parseDouble(json['selling_price']),
      image: json['image']?.toString() ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
    );
  }

  // Helper methods for parsing
  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_cart': isCart,
      'is_wishlist': isWishlist,
      'mrp': mrp,
      'selling_price': sellingPrice,
      'image': image,
      'product_rating': productRating.toJson(),
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
      numRatings: Product._parseId(json['num_ratings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avg_rating': avgRating,
      'num_ratings': numRatings,
    };
  }
}
