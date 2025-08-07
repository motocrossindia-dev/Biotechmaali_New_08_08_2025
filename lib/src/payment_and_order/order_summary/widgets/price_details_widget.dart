import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';

import '../../../../import.dart';

class PriceDetailsWidget extends StatelessWidget {
  final OrderData orderData;
  const PriceDetailsWidget({required this.orderData, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderSummaryProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Price (${orderData.orderItems.length} items)',
                '₹${orderData.order.totalPrice}'),
            _buildPriceRow('Discount',
                '-₹${(orderData.order.totalDiscount).toStringAsFixed(1)}',
                isGreen: true),
            _buildPriceRow(
                'Coupon Discount', '-₹${orderData.order.couponDiscount}',
                isGreen: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceRow(
                  'Delivery Charges',
                  '',
                ),
                // const Row(
                //   children: [
                //     CommonTextWidget(
                //       title: '₹80',
                //       lineThrough: TextDecoration.lineThrough,
                //     ),
                //     sizedBoxWidth5,
                //     CommonTextWidget(
                //       title: 'Free',
                //       color: Colors.green,
                //     )
                //   ],
                // )
              ],
            ),
            _buildPriceRow('secured Packaging Fee', ""), //'₹198',
            const Divider(thickness: 1),
            _buildPriceRow('Total Amount', '₹${orderData.order.grandTotal}',
                isBold: true),
            const SizedBox(height: 8),
            Text(
              'You will save ₹${(orderData.order.totalDiscount + orderData.order.couponDiscount).toStringAsFixed(2)} on this order',
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
