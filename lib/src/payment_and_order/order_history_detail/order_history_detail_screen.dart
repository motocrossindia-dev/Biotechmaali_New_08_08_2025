import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/model.dart/order_history_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/widgets/invoice_download_popup.dart';
import 'package:biotech_maali/src/payment_and_order/order_history_detail/order_history_detail_shimmer.dart';
import 'package:biotech_maali/src/permission_handle/pdf_viewer/pdf_viewer.dart';
import 'order_history_detail_provider.dart';
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
  static const Color themeColor = Color(0xFF749F09);

  @override
  void initState() {
    super.initState();
    context
        .read<OrderHistoryDetailProvider>()
        .fetchOrderDetails(widget.orderId);
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
            child: ElevatedButton.icon(
              onPressed: () {
                if (widget.orderStatus.toUpperCase() == "DELIVERED") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        pdfUrl: "${EndUrl.pdfInvoiceUrl}${widget.orderId}/",
                        title: "Invoice - ${widget.orderId}",
                        orderNumber: widget.orderNumber,
                      ),
                    ),
                  );
                } else {
                  InvoiceDownloadPopup.showInvoiceBottomSheet(context);
                }
              },
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: const Text('Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: themeColor,
                elevation: 0,
                side: const BorderSide(color: themeColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                if (widget.orderStatus.toLowerCase() != 'cancelled' &&
                    widget.orderStatus.toLowerCase() != 'delivered' &&
                    widget.orderStatus.toLowerCase() != 'ready_for_pickup' &&
                    widget.orderStatus.toLowerCase() != 'on_the_way')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        icon: const Icon(Icons.cancel, color: themeColor),
                        label: const Text(
                          'Cancel Order',
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: themeColor.withOpacity(0.08),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Order'),
                              content: const Text(
                                  'Are you sure you want to cancel this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final success = await context
                                .read<OrderHistoryProvider>()
                                .cancelOrder(widget.orderId.toString());
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Order cancelled successfully'
                                        : 'Failed to cancel order',
                                  ),
                                  backgroundColor:
                                      success ? Colors.green : Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
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
    return Column(
      children: [
        _buildInfoRow('Order Number', widget.orderNumber),
        _buildInfoRow('Order Date', widget.orderDate),
        _buildInfoRow('Payment Method', widget.paymentMethod ?? 'Not defined'),
        _buildInfoRow('Delivery Option', widget.deliveryOption),
        const Divider(height: 24),
        _buildInfoRow('Total Price', '₹${widget.totalPrice}'),
        _buildInfoRow('Discount', '- ₹${widget.totalDiscount}',
            valueColor: Colors.green),
        _buildInfoRow('Grand Total', '₹${widget.grandTotal}',
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
                  imageUrl: '${BaseUrl.baseUrlForImages}${item.image}',
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
                    Text('Price: ₹${item.mrp}',
                        style: const TextStyle(fontSize: 13)),
                    if (item.discount > 0)
                      Text('Discount: ₹${item.discount}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Total: ₹${item.total}',
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
