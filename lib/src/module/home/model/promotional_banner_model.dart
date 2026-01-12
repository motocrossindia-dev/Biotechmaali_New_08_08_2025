class PromotionalBannerModel {
  final int id;
  final List<dynamic> productsList;
  final List<dynamic> productList;
  final String mobileBanner;
  final String webBanner;
  final String type;
  final bool isVisible;
  final String category;
  final String title;
  final String subtitle;
  final String buttonText;

  PromotionalBannerModel({
    required this.id,
    required this.productsList,
    required this.productList,
    required this.mobileBanner,
    required this.webBanner,
    required this.type,
    required this.isVisible,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  factory PromotionalBannerModel.fromJson(Map<String, dynamic> json) {
    return PromotionalBannerModel(
      id: json['id'] ?? 0,
      productsList: json['products_list'] ?? [],
      productList: json['product_list'] ?? [],
      mobileBanner: json['mobile_banner'] ?? '',
      webBanner: json['web_banner'] ?? '',
      type: json['type'] ?? '',
      isVisible: json['is_visible'] ?? false,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      buttonText: json['button_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products_list': productsList,
      'product_list': productList,
      'mobile_banner': mobileBanner,
      'web_banner': webBanner,
      'type': type,
      'is_visible': isVisible,
      'category': category,
      'title': title,
      'subtitle': subtitle,
      'button_text': buttonText,
    };
  }
}
