class ProductDetailModel {
  final String message;
  final ProductData data;

  ProductDetailModel({
    required this.message,
    required this.data,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductData {
  final String productType;
  final Product product;
  final List<ProductSize> productSizes;
  final List<ProductPlanterSize> productPlanterSizes;
  final List<ProductWeight> productWeights;
  final List<ProductPlanter> productPlanters;
  final List<ProductLitre> productLitres;
  final List<ProductColor> productColors;
  final ProductRating? productRating;
  final List<ProductReview>? productReviews;
  final List<ProductAddOn> productAddOns; // New field

  ProductData({
    required this.productType,
    required this.product,
    required this.productSizes,
    required this.productPlanterSizes,
    required this.productWeights,
    required this.productPlanters,
    required this.productLitres,
    required this.productColors,
    this.productRating,
    this.productReviews,
    required this.productAddOns, // New parameter
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productType: json['product_type'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      productSizes: (json['product_sizes'] as List? ?? [])
          .map((e) => ProductSize.fromJson(e))
          .toList(),
      productPlanterSizes: (json['product_planter_sizes'] as List? ?? [])
          .map((e) => ProductPlanterSize.fromJson(e))
          .toList(),
      productWeights: (json['product_weights'] as List? ?? [])
          .map((e) => ProductWeight.fromJson(e))
          .toList(),
      productPlanters: (json['product_planters'] as List? ?? [])
          .map((e) => ProductPlanter.fromJson(e))
          .toList(),
      productLitres: (json['product_litres'] as List? ?? [])
          .map((e) => ProductLitre.fromJson(e))
          .toList(),
      productColors: (json['product_colors'] as List? ?? [])
          .map((e) => ProductColor.fromJson(e))
          .toList(),
      productRating: json['product_rating'] != null
          ? ProductRating.fromJson(json['product_rating'])
          : null,
      productReviews: json['product_reviews'] != null
          ? (json['product_reviews'] as List)
              .map((e) => ProductReview.fromJson(e))
              .toList()
          : null,
      productAddOns: (json['product_add_ons'] as List? ?? [])
          .map((e) => ProductAddOn.fromJson(e))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final double mrp;
  final double sellingPrice;
  final bool isCart;
  bool isWishlist;
  final List<ProductImage> images;
  final String shortDescription;
  final String mainProductName;
  final int? sizeId;
  final int? planterSizeId;
  final int? planterId;
  final int? weightId;
  final int? litreId;
  final int? colorId;
  final String? whatsIncluded;
  final String? videoLink;
  final bool isPurchased;

  Product({
    required this.id,
    required this.mrp,
    required this.sellingPrice,
    required this.isCart,
    required this.isWishlist,
    required this.images,
    required this.shortDescription,
    required this.mainProductName,
    this.sizeId,
    this.planterSizeId,
    this.planterId,
    this.weightId,
    this.litreId,
    this.colorId,
    this.whatsIncluded,
    this.videoLink,
    required this.isPurchased,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseId(json['id']),
      mrp: _parseDouble(json['mrp']),
      sellingPrice: _parseDouble(json['selling_price']),
      isCart: json['is_cart'] ?? false,
      isWishlist: json['is_wishlist'] ?? false,
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      shortDescription: json['short_description'] ?? '',
      mainProductName: json['main_product_name'] ?? '',
      sizeId: _parseNullableId(json['size_id']),
      planterSizeId: _parseNullableId(json['planter_size_id']),
      planterId: _parseNullableId(json['planter_id']),
      weightId: _parseNullableId(json['weight_id']),
      litreId: _parseNullableId(json['litre_id']),
      colorId: _parseNullableId(json['color_id']),
      whatsIncluded: json['whats_included'],
      videoLink: json['vedio_link'], // API uses 'vedio_link'
      isPurchased: json['is_purchased'] ?? false,
    );
  }

  // Creating a copy with updated wishlist status
  Product copyWithWishlistStatus(bool isWishlist) {
    return Product(
      id: id,
      mrp: mrp,
      sellingPrice: sellingPrice,
      isCart: isCart,
      isWishlist: isWishlist,
      images: images,
      shortDescription: shortDescription,
      mainProductName: mainProductName,
      sizeId: sizeId,
      planterSizeId: planterSizeId,
      planterId: planterId,
      weightId: weightId,
      litreId: litreId,
      colorId: colorId,
      whatsIncluded: whatsIncluded,
      videoLink: videoLink,
      isPurchased: isPurchased,
    );
  }

  // Creating a copy with updated cart status
  Product copyWithCartStatus(bool isCart) {
    return Product(
      id: id,
      mrp: mrp,
      sellingPrice: sellingPrice,
      isCart: isCart,
      isWishlist: isWishlist,
      images: images,
      shortDescription: shortDescription,
      mainProductName: mainProductName,
      sizeId: sizeId,
      planterSizeId: planterSizeId,
      planterId: planterId,
      weightId: weightId,
      litreId: litreId,
      colorId: colorId,
      whatsIncluded: whatsIncluded,
      videoLink: videoLink,
      isPurchased: isPurchased,
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseNullableId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class ProductLitre {
  final int id;
  final String name;

  ProductLitre({
    required this.id,
    required this.name,
  });

  factory ProductLitre.fromJson(Map<String, dynamic> json) {
    return ProductLitre(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductImage {
  final String image;

  ProductImage({required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(image: json['image'] ?? '');
  }
}

class ProductWeight {
  final int id;
  final int sizeGrams;
  final bool status;

  ProductWeight({
    required this.id,
    required this.sizeGrams,
    required this.status,
  });

  factory ProductWeight.fromJson(Map<String, dynamic> json) {
    return ProductWeight(
      id: _parseId(json['id']),
      sizeGrams: _parseIntValue(json['size_grams']),
      status: json['status'] ?? false,
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class ProductSize {
  final int id;
  final String name;
  final String size;

  ProductSize({
    required this.id,
    required this.name,
    required this.size,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
      size: json['size'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductPlanterSize {
  final int id;
  final String name;
  final String size;

  ProductPlanterSize({
    required this.id,
    required this.name,
    required this.size,
  });

  factory ProductPlanterSize.fromJson(Map<String, dynamic> json) {
    return ProductPlanterSize(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
      size: json['size'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductPlanter {
  final int id;
  final String name;

  ProductPlanter({
    required this.id,
    required this.name,
  });

  factory ProductPlanter.fromJson(Map<String, dynamic> json) {
    return ProductPlanter(
      id: _parseId(json['id']),
      name: json['name'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductColor {
  final int id;
  final String colorName;
  final String colorCode;

  ProductColor({
    required this.id,
    required this.colorName,
    required this.colorCode,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: _parseId(json['id']),
      colorName: json['color_name'] ?? '',
      colorCode: json['color_code'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductRating {
  final double avgRating;
  final int numRatings;
  final List<StarRating> starsGiven;

  ProductRating({
    required this.avgRating,
    required this.numRatings,
    required this.starsGiven,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      numRatings: json['num_ratings'] ?? 0,
      starsGiven: (json['stars_given'] as List? ?? [])
          .map((e) => StarRating.fromJson(e))
          .toList(),
    );
  }
}

class StarRating {
  final double roundedRating;
  final int count;

  StarRating({
    required this.roundedRating,
    required this.count,
  });

  factory StarRating.fromJson(Map<String, dynamic> json) {
    return StarRating(
      roundedRating: (json['rounded_rating'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }
}

class ProductReview {
  final int id;
  final int userId;
  final String userName;
  final String productReview;
  final String date;
  final double latestRating;

  ProductReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productReview,
    required this.date,
    required this.latestRating,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: _parseId(json['id']),
      userId: _parseId(json['user_id']),
      userName: json['user_name'] ?? '',
      productReview: json['product_review'] ?? '',
      date: json['date_created'] ?? '',
      latestRating: (json['latest_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ProductAddOn {
  final int id;
  final String name;
  final int productId;
  final double mrp;
  final double sellingPrice;
  final String image;
  final ProductRating productRating;
  bool isCart;
  bool isWishlist;

  ProductAddOn(
      {required this.id,
      required this.name,
      required this.productId,
      required this.mrp,
      required this.sellingPrice,
      required this.image,
      required this.productRating,
      required this.isCart,
      required this.isWishlist});

  factory ProductAddOn.fromJson(Map<String, dynamic> json) {
    return ProductAddOn(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      productId: json['product_id'] ?? 0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      productRating: ProductRating.fromJson(json['product_rating'] ?? {}),
      isCart: json['is_cart'] ?? '',
      isWishlist: json['is_wishlist'],
    );
  }
}
