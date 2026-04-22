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
  final double taxableValue;
  final double totalDiscount;
  double grandTotal;
  final String email;
  final String mobile;
  final String? trackingId;
  final String deliveryOption;
  final String status;
  final String? razorpayOrderId;
  final double couponDiscount;
  // Shipping fields (from order object when shipping_info is null)
  final double shippingCharge;
  final double shippingCgst;
  final double shippingSgst;
  final double shippingGst;

  // GST summary map from backend e.g. {"18%": 305.33}
  final Map<String, double> gstSummary;

  // GD Coin from backend
  final int gdCoin;

  OrderSummaryDetails({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.totalPrice,
    required this.taxableValue,
    required this.totalDiscount,
    required this.grandTotal,
    required this.email,
    required this.mobile,
    this.trackingId,
    required this.deliveryOption,
    required this.status,
    this.razorpayOrderId,
    required this.couponDiscount,
    this.shippingCharge = 0.0,
    this.shippingCgst = 0.0,
    this.shippingSgst = 0.0,
    this.shippingGst = 0.0,
    this.gstSummary = const {},
    this.gdCoin = 0,
  });

  factory OrderSummaryDetails.fromJson(Map<String, dynamic> json) {
    return OrderSummaryDetails(
      id: json["id"] ?? 0,
      orderId: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      totalPrice: _parseDouble(json['total_price']) ?? 0.0,
      taxableValue: _parseDouble(json['taxable_value']) ?? 0.0,
      totalDiscount: _parseDouble(json['total_discount']) ?? 0.0,
      grandTotal: _parseDouble(json['grand_total']) ?? 0.0,
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      trackingId: json['tracking_id'],
      deliveryOption: json['delivery_option'] ?? '',
      status: json['status'] ?? '',
      razorpayOrderId: json['razorpay_order_id'],
      couponDiscount: _parseDouble(json['coupon_discount']) ?? 0.0,
      shippingCharge: _parseDouble(json['shipping_charge']) ?? 0.0,
      shippingCgst: _parseDouble(json['shipping_cgst']) ?? 0.0,
      shippingSgst: _parseDouble(json['shipping_sgst']) ?? 0.0,
      shippingGst: _parseDouble(json['shipping_gst']) ?? 0.0,
      gstSummary: _parseGstSummary(json['gst_breakdown'] ?? json['gst_summary']),
      gdCoin: (json['gd_coin'] as num?)?.toInt() ?? 0,
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
  // GST fields
  final double gstAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double taxableAmount;
  final double subtotal;
  final double couponDiscountPerItem;

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
    this.gstAmount = 0.0,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
    this.taxableAmount = 0.0,
    this.subtotal = 0.0,
    this.couponDiscountPerItem = 0.0,
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
      gstAmount: _parseDouble(json['total_gst_amount']) ?? 0.0,
      cgstAmount: _parseDouble(json['cgst_amount']) ?? 0.0,
      sgstAmount: _parseDouble(json['sgst_amount']) ?? 0.0,
      taxableAmount: _parseDouble(json['taxable_value']) ?? 0.0,
      subtotal: _parseDouble(json['subtotal']) ?? 0.0,
      couponDiscountPerItem:
          _parseDouble(json['coupon_discount_per_item']) ?? 0.0,
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
  // Shipping GST fields
  final double shippingCgst;
  final double shippingSgst;
  final double shippingGst;

  ShippingInfo({
    required this.totalAmount,
    required this.shippingCharge,
    required this.freeShipping,
    required this.totalActualWeight,
    required this.totalVolumetricWeight,
    required this.chargeableWeight,
    this.shippingCgst = 0.0,
    this.shippingSgst = 0.0,
    this.shippingGst = 0.0,
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
      shippingCgst: _parseDouble(json['shipping_cgst']) ?? 0.0,
      shippingSgst: _parseDouble(json['shipping_sgst']) ?? 0.0,
      shippingGst: _parseDouble(json['shipping_gst']) ?? 0.0,
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

// Parse gst_breakdown map from backend: {"gst_18": {"total": 305.33}} or {"18%": 305.33} -> {"18%": 305.33}
Map<String, double> _parseGstSummary(dynamic value) {
  if (value == null || value is! Map) return {};

  // Handle new nested 'summary' format
  if (value.containsKey('summary') && value['summary'] is Map) {
    value = value['summary'];
  }

  final result = <String, double>{};
  value.forEach((key, val) {
    if (val is Map) {
      final total = _parseDouble(val['total']) ?? 0.0;
      if (total > 0) {
        final formattedKey = key.toString().replaceFirst('gst_', '') + '%';
        result[formattedKey] = total;
      }
    } else {
      final parsed = _parseDouble(val);
      if (parsed != null && parsed > 0) result[key.toString()] = parsed;
    }
  });
  return result;
}
