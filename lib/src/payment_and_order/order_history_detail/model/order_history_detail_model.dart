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
  final List<OrderItem> orderItems;
  final List<TrackingUpdate> trackingUpdates;

  OrderHistoryDetailData({
    required this.orderItems,
    required this.trackingUpdates,
  });

  factory OrderHistoryDetailData.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetailData(
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      trackingUpdates: (json['tracking_updates'] as List)
          .map((update) => TrackingUpdate.fromJson(update))
          .toList(),
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
