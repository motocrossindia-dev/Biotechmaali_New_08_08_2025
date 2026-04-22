import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
import '../../../import.dart';

class OrderSummaryScreen extends StatefulWidget {
  // final OrderData orderData;
  final bool? isSingleProduct;

  const OrderSummaryScreen(
      {
      // required this.orderData,
      this.isSingleProduct,
      super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _limeAccent = Color(0xFFA6C13C);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: ScreenNames.orderSummary);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        bool shouldPop = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'Abandon Checkout?',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: _darkGreen),
                  ),
                  content: Text(
                    'Are you sure you want to leave without completing your order? Your cart items will be saved for later.',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey.shade600),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Stay',
                          style: GoogleFonts.poppins(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Leave',
                          style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (shouldPop) {
          if (context.mounted) {
            context.read<BottomNavProvider>().updateIndex(0);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavWidget(),
              ),
              (route) => false,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _darkGreen, size: 20),
            onPressed: () async {
              // Same pop logic as back button
              bool shouldPop = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Text('Abandon Checkout?',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: _darkGreen)),
                      content: Text(
                          'Leave without completing your order?',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.grey.shade600)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Stay',
                              style: GoogleFonts.poppins(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Leave',
                              style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (shouldPop && context.mounted) {
                context.read<BottomNavProvider>().updateIndex(0);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavWidget()),
                  (route) => false,
                );
              }
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
              Text(
                'Review before confirming',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        body: Consumer<OrderSummaryProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress tracker
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: const OrderTrackerTimeline(
                              currentStatus: OrderStatus.address),
                        ),
                        const SizedBox(height: 12),

                        // Delivery Address Section
                        _buildSectionCard(
                          icon: Icons.location_on_outlined,
                          title: 'Delivery Address',
                          child: const DeliveryAddressWidget(),
                        ),
                        const SizedBox(height: 12),

                        // Order Items Section
                        _buildSectionCard(
                          icon: Icons.shopping_bag_outlined,
                          title:
                              'Items (${provider.orderData!.orderItems.length})',
                          child: Column(
                            children: [
                              // Column headers
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'PRODUCT',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        'QTY',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 55,
                                      child: Text(
                                        'SAVINGS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        'PRICE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 20, color: Colors.grey.shade100),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    provider.orderData!.orderItems.length,
                                separatorBuilder: (_, __) =>
                                    Divider(height: 16, color: Colors.grey.shade50),
                                itemBuilder: (context, index) {
                                  final item =
                                      provider.orderData!.orderItems[index];
                                  return OrderItemCard(item: item);
                                },
                              ),
                              if (widget.isSingleProduct == false) ...[
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    if (context.mounted) {
                                      context
                                          .read<BottomNavProvider>()
                                          .updateIndex(1);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavWidget(),
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    side: BorderSide(color: _limeAccent),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  icon: Icon(Icons.add,
                                      size: 18, color: _primaryGreen),
                                  label: Text(
                                    'Add More Products',
                                    style: GoogleFonts.poppins(
                                        color: _primaryGreen,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Delivery Options
                        _buildSectionCard(
                          icon: Icons.local_shipping_outlined,
                          title: 'Delivery Options',
                          child: const DeliveryOptionsWidget(),
                        ),
                        const SizedBox(height: 12),

                        // Coupon & BT Coins
                        _buildSectionCard(
                          icon: Icons.local_offer_outlined,
                          title: 'Offers & Rewards',
                          child: Column(
                            children: [
                              CouponWidget(
                                cartValue:
                                    provider.orderData!.order?.grandTotal ?? 0,
                                orderId: provider.orderData!.order?.id
                                        .toString() ??
                                    '',
                              ),
                              BtCoinEarnedWidget(
                                orderData: provider.orderData!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Price Details
                        _buildSectionCard(
                          icon: Icons.receipt_long_outlined,
                          title: 'Price Details',
                          child: PriceDetailsWidget(
                              orderData: provider.orderData!),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Bottom Action Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Total display
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final order = provider.orderData!.order!;
                                final shippingInfo =
                                    provider.orderData!.shippingInfo;
                                final shippingCharge =
                                    shippingInfo?.shippingCharge ??
                                        order.shippingCharge;
                                final shippingCgst =
                                    shippingInfo?.shippingCgst ??
                                        order.shippingCgst;
                                final shippingSgst =
                                    shippingInfo?.shippingSgst ??
                                        order.shippingSgst;
                                final isPickUp =
                                    provider.selectedDeliveryOption ==
                                        'Pick Up Store';
                                final displayTotal = isPickUp
                                    ? order.grandTotal -
                                        shippingCharge -
                                        shippingCgst -
                                        shippingSgst
                                    : order.grandTotal;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₹${displayTotal.toInt()}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _darkGreen,
                                      ),
                                    ),
                                    Text(
                                      isPickUp
                                          ? 'Total (Free Pickup)'
                                          : 'Total Amount',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey.shade500),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Confirm button
                          SizedBox(
                            height: 52,
                            width: 160,
                            child: provider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: _primaryGreen))
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (provider.selectedAddressId == null) {
                                        Fluttertoast.showToast(
                                          msg: 'Please add delivery address',
                                          backgroundColor: Colors.red,
                                        );
                                        return;
                                      }
                                      await provider.updateOrderSummary(
                                        context: context,
                                        orderId:
                                            provider.orderData!.order?.id ?? 0,
                                        addressId: provider.selectedAddressId!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryGreen,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'CONFIRM',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.arrow_forward,
                                            size: 16),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5226).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF3B5226)),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B3012),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    log("image :${item.image}");
    log("productId :${item.productId}");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: NetworkImageWidget(
            imageUrl: item.image.startsWith('http')
                ? item.image
                : '${BaseUrl.baseUrlForImages}${item.image}',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image_not_supported,
                  color: Colors.grey, size: 24),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Product Name
        Expanded(
          flex: 3,
          child: Text(
            item.productName,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B3012),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),

        // Quantity
        SizedBox(
          width: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3B5226).withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.quantity}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B5226),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Savings
        SizedBox(
          width: 55,
          child: item.discount > 0
              ? Text(
                  '-₹${(item.discount * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  '—',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                ),
        ),

        // Price
        SizedBox(
          width: 70,
          child: Text(
            '₹${item.sellingPrice.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3012),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
