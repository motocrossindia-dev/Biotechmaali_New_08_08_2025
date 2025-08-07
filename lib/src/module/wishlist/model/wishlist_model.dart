class WishlistModel {
  final int id;
  final int userId;
  final int mainProductId;
  final int productId;
  final String name;
  final String image;
  final double sellingPrice;
  final double mrp;
  final String stockStatus;
  bool isCart; // <-- Add this field

  WishlistModel({
    required this.id,
    required this.userId,
    required this.mainProductId,
    required this.productId,
    required this.name,
    required this.image,
    required this.sellingPrice,
    required this.mrp,
    required this.stockStatus,
    required this.isCart, // <-- Add this to constructor
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      userId: json['user_id'] is String
          ? int.parse(json['user_id'])
          : json['user_id'] ?? 0,
      mainProductId: json['main_prod'] is String
          ? int.parse(json['main_prod'])
          : json['main_prod'] ?? 0,
      productId: json['product_id'] is String
          ? int.parse(json['product_id'])
          : json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      sellingPrice: json['selling_price'] is String
          ? double.parse(json['selling_price'])
          : (json['selling_price'] ?? 0).toDouble(),
      mrp: json['mrp'] is String
          ? double.parse(json['mrp'])
          : (json['mrp'] ?? 0).toDouble(),
      stockStatus: json['stock_status'] ?? '',
      isCart:
          json['is_cart'] == true || json['is_cart'] == 'true', // <-- Add this
    );
  }
}

class WishlistResponse {
  final String message;
  final List<WishlistModel> wishlists;

  WishlistResponse({
    required this.message,
    required this.wishlists,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    // Get the data object first
    final data = json['data'] as Map<String, dynamic>;

    // Now get the wishlists array from the data object
    final wishlistsJson = data['wishlists'] as List;

    return WishlistResponse(
      message: json['message'] ?? '',
      wishlists: wishlistsJson
          .map((wishlist) => WishlistModel.fromJson(wishlist))
          .toList(),
    );
  }
}
