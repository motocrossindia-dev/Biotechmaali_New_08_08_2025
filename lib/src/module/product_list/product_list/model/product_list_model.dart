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
  final bool inStock;
  final String stockWord;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;
  final String? ribbon;
  final double? gst; // GST percentage e.g. 18.0 means 18%
  final List<String>? flags;
  final bool? isStock;
  final int? stock;
  final String? subCategorySlug;

  Product({
    required this.id,
    required this.prodId,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.inStock,
    required this.stockWord,
    required this.mrp,
    required this.sellingPrice,
    required this.image,
    required this.productRating,
    this.ribbon,
    this.gst,
    this.flags,
    this.isStock,
    this.stock,
    this.subCategorySlug,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['id']),
      prodId: _parseInt(json['prod_id']),
      name: json['name']?.toString() ?? '',
      isCart: _parseBool(json['is_cart']),
      isWishlist: _parseBool(json['is_wishlist']),
      // If backend doesn't provide stock fields, assume in-stock so UI
      // doesn't disable actions incorrectly.
      inStock:
          json.containsKey('in_stock') ? (json['in_stock'] ?? false) : true,
      stockWord: json.containsKey('stock_word')
          ? (json['stock_word']?.toString() ?? '')
          : 'InStock',
      mrp: _parseDouble(json['mrp']),
      sellingPrice: _parseDouble(json['selling_price']),
      image: json['image']?.toString() ?? '',
      productRating: ProductRating.fromJson(
          (json['product_rating'] ?? {}) as Map<String, dynamic>),
      ribbon: json['ribbon']?.toString(),
      gst: _resolveGst(json),
      flags: json['flags'] != null ? List<String>.from(json['flags']) : null,
      isStock: json['is_stock'] != null ? _parseBool(json['is_stock']) : null,
      stock: json['stock'] != null ? _parseInt(json['stock']) : null,
      subCategorySlug: json['sub_category_slug']?.toString(),
    );
  }

  static double? _resolveGst(Map<String, dynamic> json) {
    double? parse(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    final gst = parse(json['gst']);
    if (gst != null && gst > 0) return gst;
    final igst = parse(json['igst']);
    if (igst != null && igst > 0) return igst;
    final cgst = parse(json['cgst']) ?? 0.0;
    final sgst = parse(json['sgst']) ?? 0.0;
    final combined = cgst + sgst;
    if (combined > 0) return combined;
    return null;
  }

  double get mrpWithGst {
    if (gst == null || gst == 0) return mrp;
    return mrp * (1 + gst! / 100);
  }

  double get sellingPriceWithGst {
    if (gst == null || gst == 0) return sellingPrice;
    return sellingPrice * (1 + gst! / 100);
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

  bool get isBuyable {
    return stockWord.trim().toLowerCase() == 'instock' || inStock == true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prod_id': prodId,
      'name': name,
      'is_cart': isCart,
      'is_wishlist': isWishlist,
      'in_stock': inStock,
      'stock_word': stockWord,
      'mrp': mrp,
      'selling_price': sellingPrice,
      'image': image,
      'product_rating': productRating.toJson(),
      'ribbon': ribbon,
      'flags': flags,
      'is_stock': isStock,
      'stock': stock,
      'sub_category_slug': subCategorySlug,
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
