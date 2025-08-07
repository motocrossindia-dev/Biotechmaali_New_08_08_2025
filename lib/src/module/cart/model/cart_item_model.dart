class CartItemModel {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final String name;
  final String image;
  final String mrp;
  final double sellingPrice;
  final double discount;
  final String shortDescription;
  final String stockStatus;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.name,
    required this.image,
    required this.mrp,
    required this.sellingPrice,
    required this.discount,
    required this.shortDescription,
    required this.stockStatus,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      userId: json['user_id'] is String
          ? int.parse(json['user_id'])
          : json['user_id'],
      productId: json['product_id'] is String
          ? int.parse(json['product_id'])
          : json['product_id'],
      quantity: json['quantity'] is String
          ? int.parse(json['quantity'])
          : json['quantity'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      mrp: json['mrp'].toString(),
      sellingPrice: json['selling_price'] is String
          ? double.parse(json['selling_price'])
          : (json['selling_price'] ?? 0).toDouble(),
      discount: json['discount'] is String
          ? double.parse(json['discount'])
          : (json['discount'] ?? 0).toDouble(),
      shortDescription: json['short_description'] ?? '',
      stockStatus: json['stock_status'] ?? '',
    );
  }

  CartItemModel copyWith({
    int? id,
    String? name,
    String? mrp,
    int? quantity,
    String? image,
    double? discount,
    double? sellingPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId,
      productId: productId,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      image: image ?? this.image,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
      shortDescription: shortDescription,
      stockStatus: stockStatus,
    );
  }
}
