class OrderHistoryDetailResponse {
  final String message;
  final OrderHistoryDetailData data;

  OrderHistoryDetailResponse({
    required this.message,
    required this.data,
  });

  factory OrderHistoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetailResponse(
      message: json['message'],
      data: OrderHistoryDetailData.fromJson(json['data']),
    );
  }
}

class OrderHistoryDetailData {
  final OrderHistoryOrder order;
  final List<OrderItem> orderItems;
  final List<TrackingUpdate> trackingUpdates;
  final DeliveryAddressDetail? deliveryAddress;

  OrderHistoryDetailData({
    required this.order,
    required this.orderItems,
    required this.trackingUpdates,
    this.deliveryAddress,
  });

  factory OrderHistoryDetailData.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetailData(
      order: OrderHistoryOrder.fromJson(json['order'] ?? {}),
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      trackingUpdates: (json['tracking_updates'] as List)
          .map((update) => TrackingUpdate.fromJson(update))
          .toList(),
      deliveryAddress: json['delivery_address'] != null
          ? DeliveryAddressDetail.fromJson(json['delivery_address'])
          : null,
    );
  }
}

// Order details with all GST and shipping information
class OrderHistoryOrder {
  final int id;
  final String orderId;
  final String date;
  final String customerName;
  final String email;
  final String mobile;
  final String? paymentMethod;
  final double totalPrice;
  final double totalDiscount;
  final double grandTotal;
  final String? trackingId;
  final String deliveryOption;
  final String? razorpayOrderId;
  final bool isComboPurchase;

  // Coupon details
  final bool couponApplied;
  final double couponDiscount;
  final double couponValue;
  final String? couponType;

  // Shipping details
  final double shippingCharge;
  final double shippingCgstValue;
  final double shippingCgst;
  final double shippingSgstValue;
  final double shippingSgst;
  final double shippingGst;

  // GST breakdown - 0%
  final double cgstAmount0;
  final double sgstAmount0;
  final double gstAmount0;

  // GST breakdown - 5%
  final double cgstAmount5;
  final double sgstAmount5;
  final double gstAmount5;

  // GST breakdown - 18%
  final double cgstAmount18;
  final double sgstAmount18;
  final double gstAmount18;

  // Discount details
  final double discountValue;
  final String? discountType;

  OrderHistoryOrder({
    required this.id,
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.email,
    required this.mobile,
    this.paymentMethod,
    required this.totalPrice,
    required this.totalDiscount,
    required this.grandTotal,
    this.trackingId,
    required this.deliveryOption,
    this.razorpayOrderId,
    required this.isComboPurchase,
    required this.couponApplied,
    required this.couponDiscount,
    this.couponValue = 0.0,
    this.couponType,
    this.shippingCharge = 0.0,
    this.shippingCgstValue = 0.0,
    this.shippingCgst = 0.0,
    this.shippingSgstValue = 0.0,
    this.shippingSgst = 0.0,
    this.shippingGst = 0.0,
    this.cgstAmount0 = 0.0,
    this.sgstAmount0 = 0.0,
    this.gstAmount0 = 0.0,
    this.cgstAmount5 = 0.0,
    this.sgstAmount5 = 0.0,
    this.gstAmount5 = 0.0,
    this.cgstAmount18 = 0.0,
    this.sgstAmount18 = 0.0,
    this.gstAmount18 = 0.0,
    this.discountValue = 0.0,
    this.discountType,
  });

  factory OrderHistoryOrder.fromJson(Map<String, dynamic> json) {
    return OrderHistoryOrder(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      date: json['date'] ?? '',
      customerName: json['customer_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      paymentMethod: json['payment_method'],
      totalPrice: _parseDouble(json['total_price']) ?? 0.0,
      totalDiscount: _parseDouble(json['total_discount']) ?? 0.0,
      grandTotal: _parseDouble(json['grand_total']) ?? 0.0,
      trackingId: json['tracking_id'],
      deliveryOption: json['delivery_option'] ?? '',
      razorpayOrderId: json['razorpay_order_id'],
      isComboPurchase: json['is_combo_purchase'] ?? false,
      couponApplied: json['coupon_applied'] ?? false,
      couponDiscount: _parseDouble(json['coupon_discount']) ?? 0.0,
      couponValue: _parseDouble(json['coupon_value']) ?? 0.0,
      couponType: json['coupon_type'],
      shippingCharge: _parseDouble(json['shipping_charge']) ?? 0.0,
      shippingCgstValue: _parseDouble(json['shipping_cgst_value']) ?? 0.0,
      shippingCgst: _parseDouble(json['shipping_cgst']) ?? 0.0,
      shippingSgstValue: _parseDouble(json['shipping_sgst_value']) ?? 0.0,
      shippingSgst: _parseDouble(json['shipping_sgst']) ?? 0.0,
      shippingGst: _parseDouble(json['shipping_gst']) ?? 0.0,
      cgstAmount0: _parseDouble(json['cgst_amount_0']) ?? 0.0,
      sgstAmount0: _parseDouble(json['sgst_amount_0']) ?? 0.0,
      gstAmount0: _parseDouble(json['gst_amount_0']) ?? 0.0,
      cgstAmount5: _parseDouble(json['cgst_amount_5']) ?? 0.0,
      sgstAmount5: _parseDouble(json['sgst_amount_5']) ?? 0.0,
      gstAmount5: _parseDouble(json['gst_amount_5']) ?? 0.0,
      cgstAmount18: _parseDouble(json['cgst_amount_18']) ?? 0.0,
      sgstAmount18: _parseDouble(json['sgst_amount_18']) ?? 0.0,
      gstAmount18: _parseDouble(json['gst_amount_18']) ?? 0.0,
      discountValue: _parseDouble(json['discount_value']) ?? 0.0,
      discountType: json['discount_type'],
    );
  }
}

// Delivery address from order history detail
class DeliveryAddressDetail {
  final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String state;
  final String city;
  final String pincode;
  final String addressType;

  DeliveryAddressDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.state,
    required this.city,
    required this.pincode,
    required this.addressType,
  });

  factory DeliveryAddressDetail.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressDetail(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode']?.toString() ?? '',
      addressType: json['address_type'] ?? '',
    );
  }
}

class OrderItem {
  final int id;
  final String productName; // Added product name
  final dynamic sku;
  final String image;
  final int quantity;
  final double mrp;
  final double sellingPrice;
  final double discount;
  final double total;
  final String? hsnCode;
  final int orderId;
  final int productId;
  final dynamic comboOffer;

  OrderItem({
    required this.id,
    required this.productName,
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
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productName: json['product_name'],
      sku: json['sku'],
      image: json['image'],
      quantity: json['quantity'],
      mrp: double.tryParse(json['mrp'].toString()) ?? 0.0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      hsnCode: json['hsn_code'],
      orderId: json['order_id'],
      productId: json['product_id'],
      comboOffer: json['combo_offer'],
    );
  }
}

class TrackingUpdate {
  final String status;
  final DateTime timestamp;
  final String? notes;

  TrackingUpdate({
    required this.status,
    required this.timestamp,
    this.notes,
  });

  factory TrackingUpdate.fromJson(Map<String, dynamic> json) {
    return TrackingUpdate(
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }
}

// Utility function to safely parse double values
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
