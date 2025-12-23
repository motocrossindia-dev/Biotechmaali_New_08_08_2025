class OrderSummaryResponse {
  final String message;
  final OrderSummaryData data;

  OrderSummaryResponse({
    required this.message,
    required this.data,
  });

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) {
    return OrderSummaryResponse(
      message: json['message'] ?? '',
      data: OrderSummaryData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderSummaryData {
  final OrderSummaryDetails order;
  final List<OrderItem> orderItems;
  final ShippingInfo? shippingInfo;

  OrderSummaryData({
    required this.order,
    required this.orderItems,
    this.shippingInfo,
  });

  factory OrderSummaryData.fromJson(Map<String, dynamic> json) {
    return OrderSummaryData(
      order: OrderSummaryDetails.fromJson(json['order'] ?? {}),
      orderItems: (json['order_items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      shippingInfo: json['shipping_info'] != null
          ? ShippingInfo.fromJson(json['shipping_info'])
          : null,
    );
  }
}

class OrderSummaryDetails {
  final int id;
  final String orderId;
  final String customerName;
  final double totalPrice;
  final double totalDiscount;
  double grandTotal;
  final String email;
  final String mobile;
  final String? trackingId;
  final String deliveryOption;
  final String status;
  final String? razorpayOrderId;
  final double couponDiscount;

  OrderSummaryDetails({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.totalPrice,
    required this.totalDiscount,
    required this.grandTotal,
    required this.email,
    required this.mobile,
    this.trackingId,
    required this.deliveryOption,
    required this.status,
    this.razorpayOrderId,
    required this.couponDiscount,
  });

  factory OrderSummaryDetails.fromJson(Map<String, dynamic> json) {
    return OrderSummaryDetails(
      id: json["id"] ?? 0,
      orderId: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      totalPrice: _parseDouble(json['total_price']) ?? 0.0,
      totalDiscount: _parseDouble(json['total_discount']) ?? 0.0,
      grandTotal: _parseDouble(json['grand_total']) ?? 0.0,
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      trackingId: json['tracking_id'],
      deliveryOption: json['delivery_option'] ?? '',
      status: json['status'] ?? '',
      razorpayOrderId: json['razorpay_order_id'],
      couponDiscount: _parseDouble(json['coupon_discount']) ?? 0.0,
    );
  }
}

class OrderItem {
  final int id;
  final String sku;
  final String image;
  final int quantity;
  final double mrp;
  final double sellingPrice;
  final double discount;
  final double total;
  final String? hsnCode;
  final int orderId;
  final int productId;
  final String? comboOffer;
  final String productName;

  OrderItem({
    required this.id,
    required this.sku,
    required this.image,
    required this.quantity,
    required this.mrp,
    required this.sellingPrice,
    required this.discount,
    required this.total,
    this.hsnCode,
    required this.orderId,
    required this.productId,
    this.comboOffer,
    required this.productName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      sku: (json['sku'] ?? 0).toString(), // Convert int to String
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
      mrp: _parseDouble(json['mrp']) ?? 0.0,
      sellingPrice: _parseDouble(json['selling_price']) ?? 0.0,
      discount: _parseDouble(json['discount']) ?? 0.0,
      total: _parseDouble(json['total']) ?? 0.0,
      hsnCode: json['hsn_code']?.toString(),
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      comboOffer: json['combo_offer']?.toString(),
      productName: json['product_name'] ?? '',
    );
  }
}

class ShippingInfo {
  final double totalAmount;
  final double shippingCharge;
  final bool freeShipping;
  final double totalActualWeight;
  final double totalVolumetricWeight;
  final double chargeableWeight;

  ShippingInfo({
    required this.totalAmount,
    required this.shippingCharge,
    required this.freeShipping,
    required this.totalActualWeight,
    required this.totalVolumetricWeight,
    required this.chargeableWeight,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      totalAmount: _parseDouble(json['total_amount']) ?? 0.0,
      shippingCharge: _parseDouble(json['shipping_charge']) ?? 0.0,
      freeShipping: json['free_shipping'] ?? false,
      totalActualWeight: _parseDouble(json['total_actual_weight']) ?? 0.0,
      totalVolumetricWeight:
          _parseDouble(json['total_volumetric_weight']) ?? 0.0,
      chargeableWeight: _parseDouble(json['chargeable_weight']) ?? 0.0,
    );
  }
}

// Utility function to safely parse double values
double? _parseDouble(dynamic value) {
  if (value == null) return null;

  // If it's already a double, return it
  if (value is double) return value;

  // If it's an int, convert to double
  if (value is int) return value.toDouble();

  // If it's a string, parse it
  if (value is String) {
    return double.tryParse(value);
  }

  // If we can't parse it, return null
  return null;
}
