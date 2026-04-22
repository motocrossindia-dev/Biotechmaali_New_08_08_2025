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
  @override
  void initState() {
    super.initState();
    // Track order summary screen view
    AnalyticsService().logScreenView(screenName: ScreenNames.orderSummary);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Show confirmation dialog
        bool shouldPop = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Abandon Checkout?'),
                  content: const Text(
                      'Are you sure you want to leave without completing your order? Your cart items will be saved for later.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Stay'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Leave'),
                    ),
                  ],
                );
              },
            ) ??
            false; // Default to false if dialog is dismissed

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
        backgroundColor: orderSummaryBackground,
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const CommonTextWidget(
            title: 'Order Summary',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        body: Consumer<OrderSummaryProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  OrderTrackerTimeline(
                                      currentStatus: OrderStatus.address),
                                  sizedBoxHeight30,
                                  DeliveryAddressWidget(),
                                  // sizedBoxHeight20,
                                  // PickStoreWidget(),
                                ],
                              ),
                            ),
                          ),
                          sizedBoxHeight20,
                          Card(
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Items header
                                  Text(
                                    'ITEMS (${provider.orderData!.orderItems.length})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Column headers
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            'ITEMS DESCRIPTION',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            'QTY',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                            'SAVINGS',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
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
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 16),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        provider.orderData!.orderItems.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          provider.orderData!.orderItems[index];
                                      return OrderItemCard(item: item);
                                    },
                                  ),
                                  if (widget.isSingleProduct == false) ...[
                                    sizedBoxHeight05,
                                    ElevatedButton(
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
                                            // (route) => false,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        minimumSize:
                                            const Size(double.infinity, 45),
                                        backgroundColor: Colors.white,
                                        foregroundColor: cButtonGreen,
                                        side: BorderSide(color: cButtonGreen),
                                      ),
                                      child: const CommonTextWidget(
                                          title: 'Add More Products'),
                                    ),
                                  ],
                                  sizedBoxHeight10,
                                ],
                              ),
                            ),
                          ),
                          sizedBoxHeight20,
                          const Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DeliveryOptionsWidget(),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CouponWidget(
                                    cartValue:
                                        provider.orderData!.order?.grandTotal ??
                                            0,
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
                          ),
                          sizedBoxHeight20,
                          Card(
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PriceDetailsWidget(
                                orderData: provider.orderData!,
                              ),
                            ),
                          ),
                          sizedBoxHeight70,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      color: cWhiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Builder(
                                builder: (context) {
                                  final order =
                                      provider.orderData!.order!;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      CommonTextWidget(
                                        title:
                                            '₹${displayTotal.toInt()}',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      CommonTextWidget(
                                        title: isPickUp
                                            ? 'Total (Free Pickup)'
                                            : 'Total Amount',
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: provider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : CustomizableButton(
                                    title: 'CONFIRM',
                                    event: () async {
                                      if (provider.selectedAddressId == null) {
                                        Fluttertoast.showToast(
                                          msg: 'Please add delivery address',
                                          backgroundColor: Colors.red,
                                        );
                                        return;
                                      }

                                      // final success =
                                      await provider.updateOrderSummary(
                                        context: context,
                                        orderId:
                                            provider.orderData!.order?.id ?? 0,
                                        addressId: provider.selectedAddressId!,
                                      );

                                      // if (success && mounted) {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const PaymentScreen(),
                                      //     ),
                                      //   );
                                      // }
                                    },
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
}

class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    log("image :${item.image}");
    log("productId :${item.productId}");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: NetworkImageWidget(
              // Image may already be a full URL; only prepend base if it's a relative path
              imageUrl: item.image.startsWith('http')
                  ? item.image
                  : '${BaseUrl.baseUrlForImages}${item.image}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Name
          Expanded(
            child: Text(
              item.productName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),

          // Quantity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Savings (if any discount)
          SizedBox(
            width: 50,
            child: item.discount > 0
                ? Text(
                    '-₹${(item.discount * item.quantity).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: cButtonGreen,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    '—',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: 8),

          // Price Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                // Show selling_price (GST-inclusive)
                '₹${item.sellingPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
