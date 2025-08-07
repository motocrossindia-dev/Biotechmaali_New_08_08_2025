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
  final List<ComboOffer> shopTheLook;

  ProductCompoData({
    required this.comboOffers,
    required this.shopTheLook,
  });

  factory ProductCompoData.fromJson(Map<String, dynamic> json) {
    return ProductCompoData(
      comboOffers: (json['combo_offers'] as List? ?? [])
          .map((e) => ComboOffer.fromJson(e))
          .toList(),
      shopTheLook: (json['shop_the_look'] as List? ?? [])
          .map((e) => ComboOffer.fromJson(e))
          .toList(),
    );
  }
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

  ComboOffer({
    required this.id,
    required this.title,
    this.description,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.products,
    required this.image,
  });

  factory ComboOffer.fromJson(Map<String, dynamic> json) {
    return ComboOffer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['final_price'] as num?)?.toDouble() ?? 0.0,
      products: (json['products'] as List? ?? []).map((e) => e.toString()).toList(),
      image: json['image'] ?? '',
    );
  }
}