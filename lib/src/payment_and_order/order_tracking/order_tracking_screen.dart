import 'package:biotech_maali/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryTrackingWidget extends StatefulWidget {
  final List<TrackingUpdate> trackingUpdates;

  const DeliveryTrackingWidget({
    super.key,
    required this.trackingUpdates,
  });

  @override
  State<DeliveryTrackingWidget> createState() => _DeliveryTrackingWidgetState();
}

class _DeliveryTrackingWidgetState extends State<DeliveryTrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _lineAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animation for the line progression
    _lineAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    );

    // Animation for the content fade-in
    _contentAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('E, dd MMM \'yy').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    // Define all possible statuses in correct order
    final List<String> allStatuses = [
      'Processing',
      'Order Confirmed',
      'Dispatched',
      'On the Way',
      'Out for Delivery',
      'Delivered',
    ];

    // Sort tracking updates by timestamp
    final sortedUpdates = List<TrackingUpdate>.from(widget.trackingUpdates)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Find the current status (most recent update)
    String currentStatus = 'Processing'; // Default
    if (sortedUpdates.isNotEmpty) {
      currentStatus = sortedUpdates.last.status;
    }

    // Get a map of completed statuses with their timestamps
    final Map<String, TrackingUpdate> statusMap = {};
    for (var update in sortedUpdates) {
      statusMap[update.status.toLowerCase()] = update;
    }

    // Find the index of the current status
    final currentStatusIndex = allStatuses
        .indexWhere((s) => s.toLowerCase() == currentStatus.toLowerCase());

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, top: 50),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Order Tracking',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allStatuses.length,
                  itemBuilder: (context, index) {
                    final status = allStatuses[index];
                    final statusLower = status.toLowerCase();

                    // Check if this status is completed
                    final isCompleted = statusMap.containsKey(statusLower);

                    // Get timestamp if available
                    final timestamp =
                        isCompleted ? statusMap[statusLower]!.timestamp : null;

                    // Determine if this status is active or past
                    final isActive = index <= currentStatusIndex;

                    // Calculate animation progress for this step
                    final stepProgress = (index + 1) / allStatuses.length;
                    final isLineAnimated = _lineAnimation.value >= stepProgress;
                    final isContentVisible =
                        _contentAnimation.value >= stepProgress;

                    final isFirst = index == 0;
                    final isLast = index == allStatuses.length - 1;

                    return TimelineTile(
                      alignment: TimelineAlign.start,
                      isFirst: isFirst,
                      isLast: isLast,
                      indicatorStyle: IndicatorStyle(
                        width: 28,
                        height: 28,
                        color: isCompleted
                            ? cButtonGreen
                            : isLineAnimated
                                ? Colors.grey.shade300
                                : cButtonGreen,
                        indicatorXY: 0.5,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData: _getStatusIcon(status),
                          fontSize: 14,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: isCompleted
                            ? cButtonGreen
                            : isLineAnimated
                                ? Colors.grey.shade300
                                : cButtonGreen,
                        thickness: 3,
                      ),
                      afterLineStyle: LineStyle(
                        color: index < currentStatusIndex
                            ? cButtonGreen
                            : isLineAnimated
                                ? Colors.grey.shade300
                                : cButtonGreen,
                        thickness: 3,
                      ),
                      endChild: Opacity(
                        opacity: isContentVisible ? 1.0 : 0.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                              isContentVisible ? 0 : 10, 0, 0),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isActive
                                              ? Colors.black
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    if (timestamp != null) ...[
                                      const SizedBox(width: 8),
                                      Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          '${_formatDate(timestamp)} - ${_formatTimestamp(timestamp)}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    _getStatusDescription(
                                        status, isCompleted, timestamp),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isActive
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade400,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (status == 'Dispatched' && isCompleted)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        "Tracking ID: ${widget.trackingUpdates[2].notes}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (status == 'On the Way' && isCompleted)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        "Your item has been received in the hub nearest to you",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDescription(
      String status, bool isCompleted, DateTime? timestamp) {
    final timeString =
        timestamp != null ? ' at ${_formatTimestamp(timestamp)}' : '';

    if (isCompleted) {
      switch (status.toLowerCase()) {
        case 'order confirmed':
          return 'Your order has been placed successfully$timeString.';
        case 'processing':
          return 'Seller has processed your order$timeString.';
        case 'dispatched':
          return 'Your item has been shipped with tracking$timeString.';
        case 'on the way':
          return 'Your item is in transit to your location$timeString.';
        case 'out for delivery':
          return 'Courier partner is delivering your item$timeString.';
        case 'delivered':
          return 'Your item has been successfully delivered$timeString.';
        default:
          return 'Status update$timeString.';
      }
    } else {
      switch (status.toLowerCase()) {
        case 'order confirmed':
          return 'Waiting for order confirmation.';
        case 'processing':
          return 'Seller is preparing your order.';
        case 'dispatched':
          return 'Item will be shipped soon.';
        case 'on the way':
          return 'Item will be in transit shortly.';
        case 'out for delivery':
          return 'Item will be delivered soon.';
        case 'delivered':
          return 'Item delivery pending.';
        default:
          return 'Status pending.';
      }
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check;
      case 'out for delivery':
        return Icons.local_shipping;
      case 'on the way':
        return Icons.directions_bus_filled;
      case 'dispatched':
        return Icons.airplanemode_active;
      case 'order confirmed':
        return Icons.assignment_turned_in;
      case 'processing':
        return Icons.inventory_2;
      default:
        return Icons.info;
    }
  }
}

class TrackingUpdate {
  final String status;
  final DateTime timestamp;
  final String? notes;

  TrackingUpdate({
    required this.status,
    required this.timestamp,
    this.notes,
  });
}

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TrackingUpdate> multipleUpdates = [
      TrackingUpdate(
        status: 'Processing',
        timestamp: DateTime.parse('2025-03-24T13:06:17.552955Z'),
        notes: null,
      ),
      TrackingUpdate(
        status: 'Order Confirmed',
        timestamp: DateTime.parse('2025-03-24T13:10:37.862257Z'),
        notes: '',
      ),
      TrackingUpdate(
        status: 'Dispatched',
        timestamp: DateTime.parse('2025-03-24T13:10:58.971833Z'),
        notes: 'SF1291398191F',
      ),
      TrackingUpdate(
        status: 'On the Way',
        timestamp: DateTime.parse('2025-03-24T13:11:21.485856Z'),
        notes: '',
      ),
      TrackingUpdate(
        status: 'Out for Delivery',
        timestamp: DateTime.parse('2025-03-24T13:11:32.627123Z'),
        notes: '',
      ),
      TrackingUpdate(
        status: 'Delivered',
        timestamp: DateTime.parse('2025-03-24T13:11:46.492016Z'),
        notes: '',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Order Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '4',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: DeliveryTrackingWidget(
            trackingUpdates: multipleUpdates,
          ),
        ),
      ),
    );
  }
}
