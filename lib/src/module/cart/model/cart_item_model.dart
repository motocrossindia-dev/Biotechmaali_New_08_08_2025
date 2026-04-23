class CartItemModel {
  final int id;
  final int userId;
  final int mainProd;
  final int productId;
  final int quantity;
  final String name;
  final String image;
  final double baseMrp;
  final double baseSellingPrice;
  final double discount;
  final String description;
  final String ribbon;
  final String slug;
  final String stockStatus;
  final int stock;
  final double? gst;
  final double? cgst;
  final double? sgst;
  final double mrp;
  final double sellingPrice;
  final List<String> flags;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.mainProd,
    required this.productId,
    required this.quantity,
    required this.name,
    required this.image,
    required this.baseMrp,
    required this.baseSellingPrice,
    required this.discount,
    required this.description,
    required this.ribbon,
    required this.slug,
    required this.stockStatus,
    required this.stock,
    this.gst,
    this.cgst,
    this.sgst,
    required this.mrp,
    required this.sellingPrice,
    required this.flags,
  });

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: _parseInt(json['id']) ?? 0,
      userId: _parseInt(json['user_id']) ?? 0,
      mainProd: _parseInt(json['main_prod']) ?? 0,
      productId: _parseInt(json['product_id']) ?? 0,
      quantity: _parseInt(json['quantity']) ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      baseMrp: _parseDouble(json['base_mrp']) ?? 0.0,
      baseSellingPrice: _parseDouble(json['base_selling_price']) ?? 0.0,
      discount: _parseDouble(json['discount']) ?? 0.0,
      description: json['description']?.toString() ?? '',
      ribbon: json['ribbon']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      stockStatus: json['stock_status']?.toString() ?? '',
      stock: _parseInt(json['stock']) ?? 0,
      gst: _parseDouble(json['gst']),
      cgst: _parseDouble(json['cgst']),
      sgst: _parseDouble(json['sgst']),
      sellingPrice: _parseDouble(json['selling_price']) ?? 0.0,
      mrp: _parseDouble(json['mrp']) ?? 0.0,
      flags: (json['flags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  double get mrpWithGst => mrp;
  double get sellingPriceWithGst => sellingPrice;

  CartItemModel copyWith({
    int? id,
    int? quantity,
    String? name,
    String? image,
    double? mrp,
    double? sellingPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId,
      mainProd: mainProd,
      productId: productId,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      image: image ?? this.image,
      baseMrp: baseMrp,
      baseSellingPrice: baseSellingPrice,
      discount: discount,
      description: description,
      ribbon: ribbon,
      slug: slug,
      stockStatus: stockStatus,
      stock: stock,
      gst: gst,
      cgst: cgst,
      sgst: sgst,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      flags: flags,
    );
  }
}

class CartRecommendationModel {
  final int id;
  /// The main product id used for adding to cart (maps to `prod_id` in the API response).
  final int prodId;
  final String name;
  final String slug;
  final double sellingPrice;
  final double mrp;
  final bool isCart;
  final String? image;

  CartRecommendationModel({
    required this.id,
    required this.prodId,
    required this.name,
    required this.slug,
    required this.sellingPrice,
    required this.mrp,
    required this.isCart,
    this.image,
  });

  factory CartRecommendationModel.fromJson(Map<String, dynamic> json) {
    return CartRecommendationModel(
      id: CartItemModel._parseInt(json['id']) ?? 0,
      // `prod_id` is the correct id to use when adding to cart.
      prodId: CartItemModel._parseInt(json['prod_id']) ??
          CartItemModel._parseInt(json['product_id']) ??
          CartItemModel._parseInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      sellingPrice: CartItemModel._parseDouble(json['selling_price']) ?? 0.0,
      mrp: CartItemModel._parseDouble(json['mrp']) ?? 0.0,
      isCart: json['is_cart'] ?? false,
      image: json['image']?.toString(),
    );
  }
}

class CartDataModel {
  final List<CartItemModel> cartItems;
  final double cartTotal;
  final int gdCoins;
  final List<CartRecommendationModel> recommendations;
  final dynamic pendingCoupon;

  CartDataModel({
    required this.cartItems,
    required this.cartTotal,
    required this.gdCoins,
    required this.recommendations,
    this.pendingCoupon,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CartDataModel(
      cartItems: (data['cart'] as List? ?? [])
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      cartTotal: CartItemModel._parseDouble(data['cart_total']) ?? 0.0,
      gdCoins: CartItemModel._parseInt(data['gd_coins']) ?? 0,
      recommendations: (data['complete_your_garden'] as List? ?? [])
          .map((item) => CartRecommendationModel.fromJson(item))
          .toList(),
      pendingCoupon: data['pending_coupon'],
    );
  }
}
