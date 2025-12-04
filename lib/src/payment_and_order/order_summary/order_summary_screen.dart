import 'dart:developer';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                                children: [
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
                              child: CouponWidget(
                                cartValue: provider.orderData!.order.grandTotal,
                                orderId:
                                    provider.orderData!.order.id.toString(),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget(
                                    title:
                                        '₹${provider.orderData!.order.totalPrice.toInt()}',
                                    lineThrough: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                  CommonTextWidget(
                                    title:
                                        '₹${provider.orderData!.order.grandTotal.toInt()}',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
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
                                        orderId: provider.orderData!.order.id,
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
    return ListTile(
      onTap: () {
        // log("Navigating to product details for productId: ${item.productId}");
        // context.read<ProductDetailsProvider>().fetchProductDetails(
        //       item.productId,
        //     );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ProductDetailsScreen(
        //       productId: item.productId,

        //       // isFromCart: true,
        //     ),
        //   ),
        // );
      },
      leading: NetworkImageWidget(
        imageUrl: "${BaseUrl.baseUrlForImages}${item.image}",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      title: Text(item.productName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quantity: ${item.quantity}'),
          Row(
            children: [
              Text(
                '₹${(item.mrp * item.quantity).toInt()}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${(item.sellingPrice * item.quantity).toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
