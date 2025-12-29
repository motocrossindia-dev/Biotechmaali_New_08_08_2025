import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';

import '../../../../import.dart';

class PriceDetailsWidget extends StatelessWidget {
  final OrderData orderData;
  const PriceDetailsWidget({required this.orderData, super.key});

  @override
  Widget build(BuildContext context) {
    // Check if order data exists
    if (orderData.order == null) {
      return const Center(
        child: Text('Order details not available'),
      );
    }

    final order = orderData.order!;
    final shippingCharge = orderData.shippingInfo?.shippingCharge ?? 0.0;

    return Consumer<OrderSummaryProvider>(
      builder: (context, provider, child) {
        // If Pick Up Store is selected, shipping charge should be 0
        final displayShippingCharge =
            provider.selectedDeliveryOption == "Pick Up Store"
                ? 0.0
                : shippingCharge;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Price (${orderData.orderItems.length} items)',
                '₹${order.totalPrice.toInt()}'),
            _buildPriceRow('Discount', '-₹${order.totalDiscount.toInt()}',
                isGreen: true),
            _buildPriceRow(
                'Coupon Discount', '-₹${order.couponDiscount.toInt()}',
                isGreen: true),
            _buildPriceRow(
              'Delivery Charges',
              displayShippingCharge > 0
                  ? '₹${displayShippingCharge.toInt()}'
                  : 'Free',
              isGreen: displayShippingCharge == 0,
            ),
            // _buildPriceRow('secured Packaging Fee', ""), //'₹198',
            const Divider(thickness: 1),
            _buildPriceRow('Total Amount', '₹${order.grandTotal.toInt()}',
                isBold: true),
            const SizedBox(height: 8),
            Text(
              'You will save ₹${(order.totalDiscount + order.couponDiscount).toInt()} on this order',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isGreen = false, bool isStrike = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            amount,
            style: TextStyle(
              color: isGreen ? Colors.green : null,
              decoration: isStrike ? TextDecoration.lineThrough : null,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
