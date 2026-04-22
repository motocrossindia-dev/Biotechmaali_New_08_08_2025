import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/model.dart/order_history_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_history_detail/order_history_detail_shimmer.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'order_history_detail_provider.dart';
import 'widgets/order_actions_sheet.dart';
import 'model/order_history_detail_model.dart';

class OrderHistoryDetailScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;
  final String orderDate;
  final double grandTotal;
  final String? paymentMethod;
  final DeliveryAddress? deliveryAddress;
  final String customerName;
  final double totalPrice;
  final double totalDiscount;
  final String deliveryOption;
  final String orderStatus;

  const OrderHistoryDetailScreen({
    required this.orderStatus,
    required this.orderId,
    required this.orderNumber,
    required this.orderDate,
    required this.grandTotal,
    this.paymentMethod,
    this.deliveryAddress,
    required this.customerName,
    required this.totalPrice,
    required this.totalDiscount,
    required this.deliveryOption,
    super.key,
  });

  @override
  State<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  static const Color themeColor = Color(0xFF3F6331);

  @override
  void initState() {
    super.initState();
    context
        .read<OrderHistoryDetailProvider>()
        .fetchOrderDetails(widget.orderId);
    // Track order detail view with all order metadata
    AnalyticsService().logScreenView(screenName: 'Order Detail Screen');
    AnalyticsService().logOrderDetailViewed(
      orderId: widget.orderId.toString(),
      orderNumber: widget.orderNumber,
      grandTotal: widget.grandTotal,
      orderStatus: widget.orderStatus,
      paymentMethod: widget.paymentMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: themeColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () {
                OrderActionsSheet.show(
                  context: context,
                  orderId: widget.orderId,
                  orderNumber: widget.orderNumber,
                  orderStatus: widget.orderStatus,
                  deliveryDate: widget.orderDate,
                );
              },
              icon: const Icon(Icons.help_outline_rounded, size: 24),
              tooltip: 'Help & Actions',
              style: IconButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: themeColor),
      ),
      body: Consumer<OrderHistoryDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: OrderHistoryDetailShimmer());
          }
          if (provider.error != null) {
            return Center(
                child: Text(provider.error!,
                    style: const TextStyle(color: Colors.red)));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  icon: Icons.receipt_long,
                  title: 'Order Summary',
                  child: _buildOrderSummaryContent(),
                ),
                _buildSectionCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Shipping Information',
                  child: _buildShippingInformationContent(),
                ),
                _buildSectionCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Order Items',
                  child: _buildOrderItemsList(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: themeColor.withOpacity(0.15), width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: themeColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryContent() {
    // Get order details from provider
    final provider = context.read<OrderHistoryDetailProvider>();
    final order = provider.orderDetails?.data.order;

    // Calculate totals
    final totalProductGst =
        (order?.gstAmount5 ?? 0.0) + (order?.gstAmount18 ?? 0.0);
    final shippingGst = order?.shippingGst ?? 0.0;
    final hasProductGst = totalProductGst > 0;
    final hasShippingGst = shippingGst > 0;
    final isPickUpStore = order?.deliveryOption == 'Pick Up Store' ||
        order?.deliveryOption == 'PickUpStore';
    final displayShippingCharge =
        isPickUpStore ? 0.0 : (order?.shippingCharge ?? 0.0);
    final displayShippingGst = isPickUpStore ? 0.0 : shippingGst;

    return Column(
      children: [
        _buildInfoRow('Order Number', widget.orderNumber),
        _buildInfoRow('Order Date', widget.orderDate),
        _buildInfoRow('Payment Method', widget.paymentMethod ?? 'Not defined'),
        _buildInfoRow('Delivery Option', widget.deliveryOption),
        const Divider(height: 24),

        // Price
        _buildInfoRow(
            'Price (${provider.orderDetails?.data.orderItems.length ?? 0} items)',
            '₹${(order?.taxableValue ?? widget.totalPrice).toStringAsFixed(2)}'),

        // Discount
        if ((order?.totalDiscount ?? widget.totalDiscount) > 0)
          _buildInfoRow('Discount',
              '-₹${(order?.totalDiscount ?? widget.totalDiscount).toStringAsFixed(2)}',
              valueColor: Colors.green),

        // Delivery Charges
        _buildInfoRow(
          'Delivery Charges',
          displayShippingCharge > 0
              ? '₹${displayShippingCharge.toStringAsFixed(2)}'
              : 'Free',
          valueColor: displayShippingCharge == 0 ? Colors.green : null,
        ),

        // Coupon Discount
        if (order?.couponApplied == true && (order?.couponDiscount ?? 0) > 0)
          _buildInfoRow(
            'Coupon Discount',
            '-₹${order!.couponDiscount.toStringAsFixed(2)}',
            valueColor: Colors.green,
          ),

        // GST Summary from backend — single row sum
        Builder(builder: (context) {
          final totalGst = order?.gstSummary.values.fold<double>(0.0, (a, b) => a + b) ?? 0.0;
          if (totalGst > 0) {
            return _buildInfoRow('GST', '₹${totalGst.toStringAsFixed(2)}');
          } else if (totalProductGst > 0) {
            return _buildInfoRow('GST', '₹${totalProductGst.toStringAsFixed(2)}');
          }
          return const SizedBox.shrink();
        }),

        const Divider(height: 24),

        // Grand Total
        _buildInfoRow('Grand Total',
            '₹${(order?.grandTotal ?? widget.grandTotal).toStringAsFixed(2)}',
            isBold: true, valueColor: themeColor),
      ],
    );
  }

  Widget _buildShippingInformationContent() {
    return Column(
      children: [
        _buildInfoRow('Customer Name', widget.customerName),
        if (widget.deliveryAddress != null) ...[
          const Divider(height: 24),
          _buildInfoRow('Address', widget.deliveryAddress!.address),
          _buildInfoRow('City', widget.deliveryAddress!.city),
          _buildInfoRow('State', widget.deliveryAddress!.state),
          _buildInfoRow('Pincode', widget.deliveryAddress!.pincode.toString()),
        ] else
          const Center(
              child: Text('Delivery address not available',
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic))),
      ],
    );
  }

  Widget _buildOrderItemsList(OrderHistoryDetailProvider provider) {
    final orderItems = provider.orderDetails?.data.orderItems ?? [];
    return Column(
      children: orderItems.map((item) => _buildOrderItemCard(item)).toList(),
    );
  }

  Widget _buildOrderItemCard(OrderItem item) {
    return InkWell(
      onTap: () {
        // context
        //     .read<ProductDetailsProvider>()
        //     .fetchProductDetails(item.productId);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         ProductDetailsScreen(productId: item.productId),
        //   ),
        // );
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: themeColor.withOpacity(0.12), width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NetworkImageWidget(
                  imageUrl: item.image.startsWith('http') 
                      ? item.image 
                      : '${BaseUrl.baseUrlForImages}${item.image}',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                          fontSize: 15,
                        )),
                    const SizedBox(height: 2),
                    Text('Quantity: ${item.quantity}',
                        style: const TextStyle(fontSize: 13)),
                    Text('Price: ₹${item.mrp.toInt()}',
                        style: const TextStyle(fontSize: 13)),
                    if (item.discount > 0)
                      Text('Discount: ₹${item.discount.toInt()}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Total: ₹${item.total.toInt()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: themeColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor ?? Colors.black,
                  fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}
// This file is part of the Biotech Maali project.
