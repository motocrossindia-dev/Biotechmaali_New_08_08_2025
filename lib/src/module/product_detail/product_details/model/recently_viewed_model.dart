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
  final double sellingPrice;
  final double? gst; // GST percentage e.g. 18.0 means 18%
  final String image;
  final ProductRating productRating;
  final String? slug;

  RecentlyViewedProduct({
    required this.id,
    required this.name,
    required this.isCart,
    required this.isWishlist,
    required this.mrp,
    required this.sellingPrice,
    this.gst,
    required this.image,
    required this.productRating,
    this.slug,
  });

  factory RecentlyViewedProduct.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      gst: _resolveGst(json),
      image: json['image'] ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      slug: json['slug']?.toString(),
    );
  }

  double get mrpWithGst => mrp;

  double get sellingPriceWithGst => sellingPrice;

  /// Tries 'gst' → 'igst' → ('cgst' + 'sgst') in order.
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
