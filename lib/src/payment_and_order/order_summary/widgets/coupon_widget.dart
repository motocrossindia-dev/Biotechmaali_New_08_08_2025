import 'package:biotech_maali/src/payment_and_order/coupon/coupon_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/coupon/coupon_list_screen.dart';

import '../../../../import.dart';

class CouponWidget extends StatelessWidget {
  final double cartValue;
  final String orderId;
  const CouponWidget(
      {required this.cartValue, required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CouponProvider, OrderSummaryProvider>(
      builder: (context, couponProvider, orderProvider, child) {
        final order = orderProvider.orderData?.order;
        final isCouponApplied = order?.couponApplied ?? false;
        final appliedCouponCode = couponProvider.appliedCouponCode;
        final couponDiscount = order?.couponDiscount ?? 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              title: 'Apply Coupon',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),

            // Show Apply Coupon button or Applied Coupon based on state
            if (!isCouponApplied || appliedCouponCode == null) ...[
              // Apply Coupon Button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyCouponScreen(
                        cartValue: cartValue,
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer, color: cButtonGreen, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: CommonTextWidget(
                          title: 'Apply Coupon',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey.shade600, size: 16),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Applied Coupon Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appliedCouponCode,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You saved Rs.${couponDiscount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Remove coupon button (X icon)
                    InkWell(
                      onTap: () {
                        _showRemoveCouponDialog(
                            context, couponProvider, orderProvider);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Option to change coupon
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyCouponScreen(
                        cartValue: cartValue,
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Change Coupon',
                    style: TextStyle(
                      fontSize: 13,
                      color: cButtonGreen,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: cButtonGreen,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showRemoveCouponDialog(
    BuildContext context,
    CouponProvider couponProvider,
    OrderSummaryProvider orderProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Remove Coupon?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to remove the applied coupon? You will lose the discount.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Call API to remove coupon
                final result =
                    await couponProvider.removeCouponFromOrder(orderId);

                // Close loading dialog
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                // Update order data if successful
                if (result != null && context.mounted) {
                  orderProvider.setOrderSummaryData(result);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coupon removed successfully'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildOfferItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          const CommonTextWidget(title: '10% off on orders above Rs.1499'),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const CommonTextWidget(
              title: 'APPLY OFFER',
              color: Colors.grey,
              lineThrough: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
