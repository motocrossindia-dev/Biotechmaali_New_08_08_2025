class OrderResponseModel {
  final String message;
  final OrderData data;

  OrderResponseModel({
    required this.message,
    required this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      message: json['message'] ?? '',
      data: OrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderData {
  final OrderDetails order;
  final List<OrderItem> orderItems;

  final bool? success;
  final String? error;
  final double? discountAmount;
  final double? newTotal;
  final String? couponCode;
  final String? redemptionMessage;

  OrderData({
    required this.order,
    required this.orderItems,
    this.success,
    this.error,
    this.discountAmount,
    this.newTotal,
    this.couponCode,
    this.redemptionMessage,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      order: OrderDetails.fromJson(json['order'] ?? {}),
      orderItems: (json['order_items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      success: json['success'],
      error: json['error'],
      discountAmount: _parseDouble(json['discount_amount']),
      newTotal: _parseDouble(json['new_total']),
      couponCode: json['coupon_code'],
      redemptionMessage: json['redemption_message'],
    );
  }
}

class OrderDetails {
  final int id;
  final String orderId;
  final String date;
  final String customerName;
  final String email;
  final String mobile;
  final double totalPrice;
  final double totalDiscount;
  final double grandTotal;
  final String? trackingId;
  final String deliveryOption;
  final String? paymentMethod;
  final String status;
  final String? razorpayOrderId;
  final bool isComboPurchase;
  final bool couponApplied;
  final double couponDiscount;
  final int customerId;
  final dynamic appliedCoupon;

  OrderDetails({
    required this.id,
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.email,
    required this.mobile,
    required this.totalPrice,
    required this.totalDiscount,
    required this.grandTotal,
    this.trackingId,
    required this.deliveryOption,
    this.paymentMethod,
    required this.status,
    this.razorpayOrderId,
    required this.isComboPurchase,
    required this.couponApplied,
    required this.couponDiscount,
    required this.customerId,
    this.appliedCoupon,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      date: json['date'] ?? '',
      customerName: json['customer_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      totalPrice: _parseDouble(json['total_price']) ?? 0.0,
      totalDiscount: _parseDouble(json['total_discount']) ?? 0.0,
      grandTotal: _parseDouble(json['grand_total']) ?? 0.0,
      trackingId: json['tracking_id'],
      deliveryOption: json['delivery_option'] ?? 'Standard',
      paymentMethod: json['payment_method'],
      status: json['status'] ?? 'Initiated',
      razorpayOrderId: json['razorpay_order_id'],
      isComboPurchase: json['is_combo_purchase'] ?? false,
      couponApplied: json['coupon_applied'] ?? false,
      couponDiscount: _parseDouble(json['coupon_discount']) ?? 0.0,
      customerId: json['customer_id'] ?? 0,
      appliedCoupon: json['applied_coupon'],
    );
  }
}

class OrderItem {
  final int id;
  final dynamic sku; // Can be int or String
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
      sku: json['sku'], // Accept it as-is (int or String)
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
