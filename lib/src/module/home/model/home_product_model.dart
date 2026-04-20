class HomeProductModel {
  final int id;
  final String name;
  final bool isFeatured;
  final bool isBestSeller;
  final bool isSeasonalCollection;
  final bool isTrending;
  bool isCart;
  bool isWishlist;
  final bool inStock;
  final String stockWord;
  final ProductRating productRating;
  final String? image;
  final double? sellingPrice;
  final double? mrp;
  final double? gst; // GST percentage e.g. 18.0 means 18%
  final String? ribbon; // Added ribbon field
  final String? categorySlug; // used to infer GST when API omits it
  final String? subCategorySlug;
  final List<String>? flags;
  final bool? isStock;
  final int? stock;

  HomeProductModel({
    required this.id,
    required this.name,
    required this.isFeatured,
    required this.isBestSeller,
    required this.isSeasonalCollection,
    required this.isTrending,
    required this.isCart,
    required this.isWishlist,
    required this.inStock,
    required this.stockWord,
    required this.productRating,
    this.image,
    this.sellingPrice,
    this.mrp,
    this.gst,
    this.ribbon, // Added ribbon parameter
    this.categorySlug,
    this.subCategorySlug,
    this.flags,
    this.isStock,
    this.stock,
  });

  String? getFullImageUrl() {
    if (image == null) return null;
    const baseUrl = 'https://www.https://backend.gidan.store';
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
      inStock:
          json.containsKey('in_stock') ? (json['in_stock'] ?? false) : true,
      stockWord: json.containsKey('stock_word')
          ? (json['stock_word']?.toString() ?? '')
          : 'InStock',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      image: json['image'],
      sellingPrice: json['selling_price']?.toDouble(),
      mrp: json['mrp']?.toDouble(),
      categorySlug: json['category_slug']?.toString(),
      subCategorySlug: json['sub_category_slug']?.toString(),
      gst: _resolveGst(json),
      ribbon: json['ribbon']?.toString(), // Added ribbon from JSON
      flags: json['flags'] != null ? List<String>.from(json['flags']) : null,
      isStock: json['is_stock'] != null ? _parseBool(json['is_stock']) : null,
      stock: json['stock'] != null ? _parseInt(json['stock']) : null,
    );
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

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Tries 'gst' → 'igst' → ('cgst' + 'sgst') → category-based fallback.
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

    // Home product API omits GST — infer from category_slug.
    // pots / seeds / plant-care accessories → 18%
    // growing-media (soil, fertiliser) → 5%
    // plants → 0%
    final category = json['category_slug']?.toString().toLowerCase() ?? '';
    final subCategory =
        json['sub_category_slug']?.toString().toLowerCase() ?? '';
    if (category == 'plants') return null; // 0% GST on live plants
    if (subCategory.contains('growing-media')) return 5.0;
    if (category == 'pots' || category == 'seeds' || category == 'plant-care') {
      return 18.0;
    }
    return null;
  }

  double get mrpWithGst {
    if (mrp == null) return 0.0;
    if (gst == null || gst == 0) return mrp!;
    return mrp! * (1 + gst! / 100);
  }

  double get sellingPriceWithGst {
    if (sellingPrice == null) return 0.0;
    if (gst == null || gst == 0) return sellingPrice!;
    return sellingPrice! * (1 + gst! / 100);
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
        'in_stock': inStock,
        'stock_word': stockWord,
        'product_rating': productRating.toJson(),
        'image': image,
        'selling_price': sellingPrice,
        'mrp': mrp,
        'ribbon': ribbon, // Added ribbon to JSON
        'sub_category_slug': subCategorySlug,
        'flags': flags,
        'is_stock': isStock,
        'stock': stock,
      };

  bool get isBuyable {
    return stockWord.trim().toLowerCase() == 'instock' || inStock == true;
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
      avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
      numRatings: json['num_ratings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'avg_rating': avgRating,
        'num_ratings': numRatings,
      };
}
