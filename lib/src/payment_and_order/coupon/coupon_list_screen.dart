// lib/screens/apply_coupon_screen.dart
import 'package:biotech_maali/src/payment_and_order/coupon/coupon_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/coupon/model/coupon_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/order_summary.dart';
import 'package:biotech_maali/src/widgets/all_message_popups.dart';
import 'package:biotech_maali/src/widgets/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyCouponScreen extends StatefulWidget {
  final double cartValue;
  final String orderId;
  const ApplyCouponScreen(
      {required this.cartValue, required this.orderId, super.key});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final couponProvider =
            Provider.of<CouponProvider>(context, listen: false);
        couponProvider.fetchCoupons(widget.orderId);
      },
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderSummaryScreen(),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderSummaryScreen(),
                ),
              );
            },
          ),
          title: const CommonTextWidget(
            title: 'APPLY COUPON',
            fontSize: 16,
          ),
          elevation: 0,
        ),
        body: Consumer<CouponProvider>(
          builder: (context, couponProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   color: Colors.white,
                //   child: Text(
                //     couponProvider.discountAmount > 0
                //         ? 'Your cart: ₹${((widget.cartValue) - couponProvider.discountAmount).toStringAsFixed(0)}'
                //         : 'Your cart: ₹${widget.cartValue.toStringAsFixed(0)}',
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: Colors.grey[700],
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _couponController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: 'Enter Coupon Code',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: TextButton(
                        onPressed: () {
                          // _isLoading ? null : _applyCoupon();
                        },
                        child: Text(
                          'APPLY',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'More offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Expanded(
                  child: couponProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : couponProvider.error != null
                          ? Center(child: Text(couponProvider.error!))
                          : ListView.builder(
                              itemCount: couponProvider.coupons.length,
                              itemBuilder: (ctx, index) {
                                Coupon coupon = couponProvider.coupons[index];
                                return CouponCard(
                                  coupon: couponProvider.coupons[index],
                                  cartValue: widget.cartValue,
                                  onApply: () async {
                                    final orderSummaryProvider =
                                        context.read<OrderSummaryProvider>();
                                    _couponController.text =
                                        couponProvider.coupons[index].code;
                                    OrderData? data =
                                        await Provider.of<CouponProvider>(
                                                context,
                                                listen: false)
                                            .applyCoupon(
                                                coupon.id.toString(),
                                                widget.orderId,
                                                coupon.code,
                                                context);

                                    if (data != null && data.success == true) {
                                      orderSummaryProvider
                                          .setOrderSummaryData(data);
                                      if (context.mounted) {
                                        showSuccessDialog(context,
                                            "Coupon applied successfully!");
                                      }
                                    } else if (data != null &&
                                        data.success == false) {
                                      orderSummaryProvider
                                          .setOrderSummaryData(data);
                                      if (context.mounted) {
                                        showErrorDialog(
                                            context, data.error.toString());
                                      }
                                    } else {
                                      if (context.mounted) {
                                        showErrorDialog(
                                            context, "Failed to apply coupon");
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                ),
                if (couponProvider.appliedCouponCode != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green[50],
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Coupon ${couponProvider.appliedCouponCode} applied',
                          style: TextStyle(color: Colors.green[700]),
                        ),
                        const Spacer(),
                        Text(
                          '- ₹${couponProvider.discountAmount.toInt()}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final double cartValue;
  final VoidCallback onApply;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.cartValue,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final minOrderValue = double.parse(coupon.minimumOrderValue);
    final remainingAmount = minOrderValue - cartValue;
    // final canApply = remainingAmount <= 0 && coupon.isApplicable;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: coupon.isApplicable
              ? Colors.green.shade300
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          // Left side with discount percentage
          Container(
            width: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: coupon.isApplicable
                  ? Colors.green.shade500
                  : Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  coupon.getDiscountText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          // Right side with coupon details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    // Changed from Row to Wrap
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8, // Horizontal spacing
                    runSpacing: 8, // Vertical spacing when wrapped
                    children: [
                      Text(
                        coupon.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (!coupon.isApplicable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.block,
                                color: Colors.red.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Not Applicable',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!coupon.isApplicable && coupon.isApplicable)
                    Text(
                      'Add ₹${remainingAmount.toInt()} more to avail this offer',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    coupon.getDiscountText(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: coupon.isApplicable
                          ? Colors.green.shade700
                          : Colors.grey,
                    ),
                  ),
                  const Divider(),
                  Text(
                    '${coupon.description}\n${coupon.getMinimumOrderText()}.\n${coupon.getMaxDiscountText()}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Apply button
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextButton(
              onPressed: coupon.isApplicable ? onApply : null,
              style: TextButton.styleFrom(
                foregroundColor:
                    coupon.isApplicable ? Colors.green : Colors.grey[300],
              ),
              child: const Text(
                'APPLY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
