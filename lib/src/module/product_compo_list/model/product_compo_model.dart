class ProductCompoResponse {
  final String message;
  final ProductCompoData data;

  ProductCompoResponse({
    required this.message,
    required this.data,
  });

  factory ProductCompoResponse.fromJson(Map<String, dynamic> json) {
    return ProductCompoResponse(
      message: json['message'] ?? '',
      data: ProductCompoData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductCompoData {
  final List<ComboOffer> comboOffers;

  ProductCompoData({
    required this.comboOffers,
  });

  factory ProductCompoData.fromJson(Map<String, dynamic> json) {
    return ProductCompoData(
      comboOffers: (json['combo_offers'] as List? ?? [])
          .map((e) => ComboOffer.fromJson(e))
          .toList(),
    );
  }

  /// Returns only active combo offers (not shop the look).
  List<ComboOffer> get activeComboOffers =>
      comboOffers.where((o) => o.isActive && !o.isShopTheLook).toList();

  /// Returns only active shop-the-look offers.
  List<ComboOffer> get shopTheLook =>
      comboOffers.where((o) => o.isActive && o.isShopTheLook).toList();
}

class ComboOffer {
  final int id;
  final String title;
  final String? description;
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final List<String> products;
  final String image;
  final bool isShopTheLook;
  final bool isActive;
  final String? dateCreated;

  ComboOffer({
    required this.id,
    required this.title,
    this.description,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.products,
    required this.image,
    this.isShopTheLook = false,
    this.isActive = true,
    this.dateCreated,
  });

  /// Percentage saved — guarded against division by zero / NaN.
  int get discountPercentage {
    if (totalPrice <= 0 || discount <= 0) return 0;
    final pct = (discount / totalPrice * 100);
    if (pct.isNaN || pct.isInfinite) return 0;
    return pct.round();
  }

  factory ComboOffer.fromJson(Map<String, dynamic> json) {
    return ComboOffer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['final_price'] as num?)?.toDouble() ?? 0.0,
      products:
          (json['products'] as List? ?? []).map((e) => e.toString()).toList(),
      image: json['image'] ?? '',
      isShopTheLook: json['is_shop_the_look'] ?? false,
      isActive: json['is_active'] ?? true,
      dateCreated: json['date_created'],
    );
  }
}
