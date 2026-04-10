class ProductSearchModel {
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

  ProductSearchModel({
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
      inStock:
          json.containsKey('in_stock') ? (json['in_stock'] ?? false) : true,
      stockWord: json.containsKey('stock_word')
          ? (json['stock_word']?.toString() ?? '')
          : 'InStock',
      mrp: json['mrp'] is String
          ? double.parse(json['mrp'])
          : (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: json['selling_price'] is String
          ? double.parse(json['selling_price'])
          : (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      ribbon: json['ribbon'],
      gst: _resolveGst(json),
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
