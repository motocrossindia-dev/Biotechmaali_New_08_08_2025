import 'package:biotech_maali/src/payment_and_order/order_history/model.dart/order_history_model.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_shimmer.dart';
import 'package:biotech_maali/src/payment_and_order/order_history_detail/order_history_detail_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history_detail/order_history_detail_screen.dart';
import 'package:biotech_maali/src/payment_and_order/order_tracking/order_tracking_screen.dart';
import '../../../import.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryProvider>().fetchOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.read<BottomNavProvider>().updateIndex(0);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavWidget(),
          ),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'My Orders',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Consumer<OrderHistoryProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: OrderHistoryShimmer());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchOrderHistory(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final orders = provider.orderHistory?.data.orders ?? [];
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/png/images/no_order_history.jpg', // Add this image
                      height: 220,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start shopping to see your orders here',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BottomNavProvider>().updateIndex(0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavWidget(),
                          ),
                        );
                      },
                      child: const Text('Start Shopping'),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderHistoryCard(order: order);
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final OrderHistory order;
  static const Color themeColor = Color(0xFF749F09);

  const OrderHistoryCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistoryDetailScreen(
              orderId: order.id,
              orderNumber: order.orderId,
              orderDate: order.date,
              grandTotal: order.grandTotal,
              paymentMethod: order.paymentMethod ?? 'Not defined',
              deliveryAddress: order.deliveryAddress,
              customerName: order.customerName,
              totalPrice: order.totalPrice,
              totalDiscount: order.totalDiscount,
              deliveryOption: order.deliveryOption,
              orderStatus: order.status,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status chip and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 120,
                    width: 160,
                    child: Builder(
                      builder: (context) {
                        final images =
                            order.productDetails?.productImages ?? [];
                        final showImages = images.take(4).toList();
                        final extraCount =
                            images.length > 4 ? images.length - 4 : 0;

                        // Dynamic layout based on image count
                        if (images.isEmpty) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          );
                        } else if (images.length == 1) {
                          // Single image - use full space
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: NetworkImageWidget(
                              imageUrl:
                                  '${BaseUrl.baseUrlForImages}${images[0]}',
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        } else if (images.length == 2) {
                          // Two images - split vertically
                          return Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                  child: NetworkImageWidget(
                                    imageUrl:
                                        '${BaseUrl.baseUrlForImages}${images[0]}',
                                    fit: BoxFit.cover,
                                    height: 120,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                  child: NetworkImageWidget(
                                    imageUrl:
                                        '${BaseUrl.baseUrlForImages}${images[1]}',
                                    fit: BoxFit.cover,
                                    height: 120,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (images.length == 3) {
                          // Three images - one large on left, two small on right
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                  child: NetworkImageWidget(
                                    imageUrl:
                                        '${BaseUrl.baseUrlForImages}${images[0]}',
                                    fit: BoxFit.cover,
                                    height: 120,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(6),
                                        ),
                                        child: NetworkImageWidget(
                                          imageUrl:
                                              '${BaseUrl.baseUrlForImages}${images[1]}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                        ),
                                        child: NetworkImageWidget(
                                          imageUrl:
                                              '${BaseUrl.baseUrlForImages}${images[2]}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // 4+ images - original grid layout
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 37,
                            ),
                            itemCount: showImages.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, idx) {
                              final imgUrl = showImages[idx];
                              final isLast = idx == 3 && extraCount > 0;
                              return Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 55,
                                      width: 75,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: NetworkImageWidget(
                                          imageUrl:
                                              '${BaseUrl.baseUrlForImages}$imgUrl',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isLast)
                                    Center(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '+$extraCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  _buildStatusChip(order.status),
                                  Text(
                                    _formatDate(order.date),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Action buttons
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (order.trackingId != "0") ...[
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final orderHistoryProvider = context
                                        .read<OrderHistoryDetailProvider>();
                                    await orderHistoryProvider
                                        .fetchOrderDetails(order.id);

                                    final trackingUpdates =
                                        (orderHistoryProvider.orderDetails?.data
                                                    .trackingUpdates ??
                                                [])
                                            .map((update) => TrackingUpdate(
                                                  status: update.status,
                                                  timestamp: update.timestamp,
                                                  notes: update.notes,
                                                ))
                                            .toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryTrackingWidget(
                                          trackingUpdates: trackingUpdates,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.local_shipping_outlined,
                                      size: 16),
                                  label: const Text('Track'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 1,
                                    ),
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ],
                          ),
                        ],
                      ),
                      sizedBoxWidth30
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'initiated':
        chipColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
      case 'paid':
        chipColor = themeColor;
        backgroundColor = themeColor.withOpacity(0.1);
        break;
      case 'cancelled':
        chipColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      case 'delivered':
        chipColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      default:
        chipColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final DateTime orderDate = DateTime.parse(date);
    return '${orderDate.day} ${_getMonth(orderDate.month)} ${orderDate.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
