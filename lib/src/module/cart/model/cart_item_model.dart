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
  final double? gst;
  final double? igst;
  final double? cgst;
  final double? sgst;

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
    this.gst,
    this.igst,
    this.cgst,
    this.sgst,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

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
      sellingPrice: _parseDouble(json['selling_price']) ?? 0,
      discount: _parseDouble(json['discount']) ?? 0,
      shortDescription: json['short_description'] ?? '',
      stockStatus: json['stock_status'] ?? '',
      gst: _parseDouble(json['gst']),
      igst: _parseDouble(json['igst']),
      cgst: _parseDouble(json['cgst']),
      sgst: _parseDouble(json['sgst']),
    );
  }

  double get effectiveGstRate {
    if (gst != null && gst! > 0) return gst!;
    if (igst != null && igst! > 0) return igst!;
    if ((cgst != null || sgst != null)) {
      return (cgst ?? 0) + (sgst ?? 0);
    }
    return 0.0;
  }

  double get mrpValue => double.tryParse(mrp) ?? 0.0;

  double get mrpWithGst => mrpValue;

  double get sellingPriceWithGst => sellingPrice;

  CartItemModel copyWith({
    int? id,
    String? name,
    String? mrp,
    int? quantity,
    String? image,
    double? discount,
    double? sellingPrice,
    double? gst,
    double? igst,
    double? cgst,
    double? sgst,
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
      gst: gst ?? this.gst,
      igst: igst ?? this.igst,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
    );
  }
}
