// Banner Product Model

class BannerProductResponse {
  final String message;
  final BannerProductData data;

  BannerProductResponse({
    required this.message,
    required this.data,
  });

  factory BannerProductResponse.fromJson(Map<String, dynamic> json) {
    return BannerProductResponse(
      message: json['message'] as String,
      data: BannerProductData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class BannerProductData {
  final int id;
  final List<BannerProduct> productList;
  final String mobileBanner;
  final String webBanner;
  final String type;
  final bool isVisible;
  final String category;
  final String? title;
  final String? subtitle;
  final String? buttonText;

  BannerProductData({
    required this.id,
    required this.productList,
    required this.mobileBanner,
    required this.webBanner,
    required this.type,
    required this.isVisible,
    required this.category,
    this.title,
    this.subtitle,
    this.buttonText,
  });

  factory BannerProductData.fromJson(Map<String, dynamic> json) {
    return BannerProductData(
      id: json['id'] as int,
      // Changed from 'product_list' to 'products_list' to match API response
      productList: (json['products_list'] as List<dynamic>)
          .map((e) => BannerProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      mobileBanner: json['mobile_banner'] as String,
      webBanner: json['web_banner'] as String,
      type: json['type'] as String,
      isVisible: json['is_visible'] as bool,
      category: json['category'] as String,
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString(),
      buttonText: json['button_text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_list': productList.map((e) => e.toJson()).toList(),
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

class BannerProduct {
  final int id;
  final int prodId;
  final String name;
  final bool isCart;
  final bool isWishlist;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;
  final String? ribbon;

  BannerProduct({
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

  factory BannerProduct.fromJson(Map<String, dynamic> json) {
    return BannerProduct(
      id: json['id'] as int,
      prodId: json['prod_id'] as int,
      name: json['name'] as String,
      isCart: json['is_cart'] as bool,
      isWishlist: json['is_wishlist'] as bool,
      mrp: (json['mrp'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      image: json['image'] as String,
      productRating: ProductRating.fromJson(
          json['product_rating'] as Map<String, dynamic>),
      ribbon: json['ribbon']?.toString(),
    );
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

  // Create a copy with updated values
  BannerProduct copyWith({
    bool? isCart,
    bool? isWishlist,
  }) {
    return BannerProduct(
      id: id,
      prodId: prodId,
      name: name,
      isCart: isCart ?? this.isCart,
      isWishlist: isWishlist ?? this.isWishlist,
      mrp: mrp,
      sellingPrice: sellingPrice,
      image: image,
      productRating: productRating,
      ribbon: ribbon,
    );
  }
}

class ProductRating {
  final int avgRating;
  final int numRatings;

  ProductRating({
    required this.avgRating,
    required this.numRatings,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      avgRating: json['avg_rating'] as int,
      numRatings: json['num_ratings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avg_rating': avgRating,
      'num_ratings': numRatings,
    };
  }
}
