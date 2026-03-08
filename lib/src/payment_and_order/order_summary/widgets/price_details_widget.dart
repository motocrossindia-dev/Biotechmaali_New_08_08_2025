import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';

import '../../../../import.dart';

class PriceDetailsWidget extends StatefulWidget {
  final OrderData orderData;
  const PriceDetailsWidget({required this.orderData, super.key});

  @override
  State<PriceDetailsWidget> createState() => _PriceDetailsWidgetState();
}

class _PriceDetailsWidgetState extends State<PriceDetailsWidget> {
  bool _isProductGstExpanded = false;
  bool _isShippingGstExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Check if order data exists
    if (widget.orderData.order == null) {
      return const Center(
        child: Text('Order details not available'),
      );
    }

    final order = widget.orderData.order!;
    final shippingInfo = widget.orderData.shippingInfo;
    // Use shippingInfo values if available, otherwise fallback to order values
    // (API returns shipping data in order object after coupon is applied)
    final shippingCharge = shippingInfo?.shippingCharge ?? order.shippingCharge;
    final shippingCgst = shippingInfo?.shippingCgst ?? order.shippingCgst;
    final shippingSgst = shippingInfo?.shippingSgst ?? order.shippingSgst;
    final isFreeShippingFromApi = shippingInfo?.freeShipping ?? false;

    return Consumer<OrderSummaryProvider>(
      builder: (context, provider, child) {
        // Only Pick Up Store or explicit free_shipping flag makes delivery free
        final isPickUpStore =
            provider.selectedDeliveryOption == "Pick Up Store";
        final isFreeDelivery = isPickUpStore || isFreeShippingFromApi;
        final displayShippingCharge = isFreeDelivery ? 0.0 : shippingCharge;
        final displayShippingCgst = isFreeDelivery ? 0.0 : shippingCgst;
        final displayShippingSgst = isFreeDelivery ? 0.0 : shippingSgst;
        final displayShippingGst = displayShippingCgst + displayShippingSgst;

        // Calculate total product GST
        final totalProductGst = order.gstAmount5 + order.gstAmount18;

        final hasProductGst = totalProductGst > 0;
        final hasShippingGst = displayShippingGst > 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with dotted line
            Row(
              children: [
                const Text(
                  'PRICE DETAILS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomPaint(
                    painter: DottedLinePainter(),
                    size: const Size(double.infinity, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price row
            _buildPriceRow(
              'Price (${widget.orderData.orderItems.length} item${widget.orderData.orderItems.length > 1 ? 's' : ''})',
              '₹${order.totalPrice.toStringAsFixed(2)}',
            ),

            // Discount row
            _buildPriceRow(
              'Discount',
              '-₹${order.totalDiscount.toStringAsFixed(2)}',
              valueColor: order.totalDiscount > 0 ? cButtonGreen : null,
            ),

            // Delivery Charges
            _buildPriceRow(
              'Delivery Charges',
              displayShippingCharge > 0
                  ? '₹${displayShippingCharge.toStringAsFixed(2)}'
                  : 'Free',
              valueColor: displayShippingCharge == 0 ? cButtonGreen : null,
            ),

            // Coupon Discount (if applied)
            if (order.couponApplied && order.couponDiscount > 0) ...[
              _buildCouponRow(
                widget.orderData.couponCode ?? 'Coupon Applied',
                '-₹${order.couponDiscount.toStringAsFixed(2)}',
              ),
            ],

            // Product GST (expandable)
            if (hasProductGst) ...[
              _buildExpandableGstRow(
                label: 'Product GST',
                totalAmount: totalProductGst,
                isExpanded: _isProductGstExpanded,
                onTap: () {
                  setState(() {
                    _isProductGstExpanded = !_isProductGstExpanded;
                  });
                },
                children: [
                  // GST @ 5% breakdown
                  if (order.gstAmount5 > 0) ...[
                    _buildGstBreakdownRow(
                        'GST @ 5%', '₹${order.gstAmount5.toStringAsFixed(2)}'),
                    _buildGstBreakdownRow('  CGST 2.5%',
                        '₹${order.cgstAmount5.toStringAsFixed(2)}',
                        isSubItem: true),
                    _buildGstBreakdownRow('  SGST 2.5%',
                        '₹${order.sgstAmount5.toStringAsFixed(2)}',
                        isSubItem: true),
                  ],
                  // GST @ 18% breakdown
                  if (order.gstAmount18 > 0) ...[
                    _buildGstBreakdownRow('GST @ 18%',
                        '₹${order.gstAmount18.toStringAsFixed(2)}'),
                    _buildGstBreakdownRow('  CGST 9%',
                        '₹${order.cgstAmount18.toStringAsFixed(2)}',
                        isSubItem: true),
                    _buildGstBreakdownRow('  SGST 9%',
                        '₹${order.sgstAmount18.toStringAsFixed(2)}',
                        isSubItem: true),
                  ],
                ],
              ),
            ],

            // Subtotal (sum of item subtotals from API - before shipping)
            Builder(builder: (context) {
              // Calculate subtotal from order items
              final itemsSubtotal = widget.orderData.orderItems.fold<double>(
                0.0,
                (sum, item) =>
                    sum +
                    (item.subtotal > 0
                        ? item.subtotal
                        : item.total + item.gstAmount),
              );
              return _buildPriceRow(
                'Subtotal',
                '₹${itemsSubtotal.toStringAsFixed(2)}',
              );
            }),

            // Shipping GST (expandable)
            if (hasShippingGst && displayShippingCharge > 0) ...[
              _buildExpandableGstRow(
                label: 'Shipping GST',
                totalAmount: displayShippingGst,
                isExpanded: _isShippingGstExpanded,
                onTap: () {
                  setState(() {
                    _isShippingGstExpanded = !_isShippingGstExpanded;
                  });
                },
                children: [
                  _buildGstBreakdownRow(
                      'CGST 9%', '₹${displayShippingCgst.toStringAsFixed(2)}',
                      isSubItem: true),
                  _buildGstBreakdownRow(
                      'SGST 9%', '₹${displayShippingSgst.toStringAsFixed(2)}',
                      isSubItem: true),
                ],
              ),
            ],

            const Divider(thickness: 1, height: 24),

            // Total Amount - Recalculate based on delivery option
            // API grandTotal includes shipping, so subtract it when Pick Up Store is selected
            Builder(builder: (context) {
              // Calculate the shipping amount that was included in grandTotal
              final shippingInGrandTotal = shippingCharge;
              final shippingGstInGrandTotal = shippingCgst + shippingSgst;

              // If Pick Up Store, subtract shipping and shipping GST from grandTotal
              // If Door Step Delivery, use grandTotal as is (it already includes shipping)
              final calculatedTotal = isPickUpStore
                  ? order.grandTotal -
                      shippingInGrandTotal -
                      shippingGstInGrandTotal
                  : order.grandTotal;

              return _buildPriceRow(
                'Total Amount',
                '₹${calculatedTotal.toStringAsFixed(2)}',
                isBold: true,
                fontSize: 16,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponRow(String couponCode, String discountValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, size: 16, color: cButtonGreen),
              const SizedBox(width: 6),
              Text(
                'Coupon ($couponCode)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            discountValue,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: cButtonGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableGstRow({
    required String label,
    required double totalAmount,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Expanded content
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
      ],
    );
  }

  Widget _buildGstBreakdownRow(String label, String value,
      {bool isSubItem = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: isSubItem ? 8 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSubItem ? Colors.black54 : Colors.black87,
              fontWeight: isSubItem ? FontWeight.normal : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: isSubItem ? Colors.black54 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dotted line
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
