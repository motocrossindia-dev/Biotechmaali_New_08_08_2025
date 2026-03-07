import 'package:biotech_maali/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late Animation<double> _animation;

  // Define all possible statuses in correct order with their API keys
  static const List<Map<String, String>> allStatusDefinitions = [
    {'key': 'PROCESSING', 'label': 'Processing'},
    {'key': 'ORDER_CONFIRMED', 'label': 'Order Confirmed'},
    {'key': 'DISPATCHED', 'label': 'Dispatched'},
    {'key': 'ON_THE_WAY', 'label': 'On the Way'},
    {'key': 'OUT_FOR_DELIVERY', 'label': 'Out for Delivery'},
    {'key': 'DELIVERED', 'label': 'Delivered'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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

  // Normalize status string for comparison
  String _normalizeStatus(String status) {
    return status.toUpperCase().replaceAll(' ', '_');
  }

  @override
  Widget build(BuildContext context) {
    // Sort tracking updates by timestamp
    final sortedUpdates = List<TrackingUpdate>.from(widget.trackingUpdates)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Create a map of completed statuses with their data
    final Map<String, TrackingUpdate> completedStatusMap = {};
    for (var update in sortedUpdates) {
      completedStatusMap[_normalizeStatus(update.status)] = update;
    }

    // Find the highest completed status index
    int highestCompletedIndex = -1;
    for (int i = 0; i < allStatusDefinitions.length; i++) {
      if (completedStatusMap.containsKey(allStatusDefinitions[i]['key'])) {
        highestCompletedIndex = i;
      }
    }

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 8, top: 50),
                child: Text(
                  'Order Tracking',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allStatusDefinitions.length,
                    itemBuilder: (context, index) {
                      final statusDef = allStatusDefinitions[index];
                      final statusKey = statusDef['key']!;
                      final statusLabel = statusDef['label']!;

                      // Check if this status is completed
                      final isCompleted =
                          completedStatusMap.containsKey(statusKey);
                      final trackingUpdate = completedStatusMap[statusKey];

                      // Determine if this status should be colored (completed or current)
                      final isActive = index <= highestCompletedIndex;

                      final isFirst = index == 0;
                      final isLast = index == allStatusDefinitions.length - 1;

                      return _buildTimelineItem(
                        context: context,
                        statusLabel: statusLabel,
                        isCompleted: isCompleted,
                        isActive: isActive,
                        isFirst: isFirst,
                        isLast: isLast,
                        trackingUpdate: trackingUpdate,
                        animationValue: _animation.value,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String statusLabel,
    required bool isCompleted,
    required bool isActive,
    required bool isFirst,
    required bool isLast,
    TrackingUpdate? trackingUpdate,
    required double animationValue,
  }) {
    final bulletColor = isActive ? cButtonGreen : Colors.grey.shade300;
    final lineColor = isActive ? cButtonGreen : Colors.grey.shade300;

    return Opacity(
      opacity: animationValue,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline column with bullet and line
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Top line (not for first item)
                  if (!isFirst)
                    Container(
                      width: 3,
                      height: 8,
                      color: lineColor,
                    ),
                  // Bullet point
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: bulletColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? cButtonGreen : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  // Bottom line (not for last item)
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3,
                        color: lineColor,
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status title and timestamp
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.black87
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                        if (trackingUpdate != null)
                          Text(
                            _formatTimestamp(trackingUpdate.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Date
                    if (trackingUpdate != null)
                      Text(
                        _formatDate(trackingUpdate.timestamp),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      _getStatusDescription(statusLabel, isCompleted),
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive
                            ? Colors.grey.shade700
                            : Colors.grey.shade400,
                      ),
                    ),
                    // Notes if available
                    if (trackingUpdate?.notes != null &&
                        trackingUpdate!.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cButtonGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            trackingUpdate.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              color: cButtonGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDescription(String status, bool isCompleted) {
    if (isCompleted) {
      switch (status.toLowerCase()) {
        case 'processing':
          return 'Your order is being processed.';
        case 'order confirmed':
          return 'Your order has been confirmed successfully.';
        case 'dispatched':
          return 'Your order has been shipped.';
        case 'on the way':
          return 'Your order is in transit to your location.';
        case 'out for delivery':
          return 'Your order is out for delivery.';
        case 'delivered':
          return 'Your order has been delivered successfully.';
        default:
          return 'Status updated.';
      }
    } else {
      switch (status.toLowerCase()) {
        case 'processing':
          return 'Waiting for processing.';
        case 'order confirmed':
          return 'Waiting for confirmation.';
        case 'dispatched':
          return 'Waiting to be shipped.';
        case 'on the way':
          return 'Waiting for transit.';
        case 'out for delivery':
          return 'Waiting for delivery.';
        case 'delivered':
          return 'Pending delivery.';
        default:
          return 'Status pending.';
      }
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
    // Sample data matching API format
    final List<TrackingUpdate> multipleUpdates = [
      TrackingUpdate(
        status: 'PROCESSING',
        timestamp: DateTime.parse('2026-02-26T17:39:16Z'),
        notes: null,
      ),
      TrackingUpdate(
        status: 'ORDER_CONFIRMED',
        timestamp: DateTime.parse('2026-02-26T18:00:29Z'),
        notes: 'Payment verified and order confirmed by admin.',
      ),
      TrackingUpdate(
        status: 'DISPATCHED',
        timestamp: DateTime.parse('2026-02-26T18:04:42Z'),
        notes: 'Payment verified and order confirmed by admin.',
      ),
      TrackingUpdate(
        status: 'ON_THE_WAY',
        timestamp: DateTime.parse('2026-02-26T18:05:46Z'),
        notes: 'Payment verified and order confirmed by admin.',
      ),
      TrackingUpdate(
        status: 'OUT_FOR_DELIVERY',
        timestamp: DateTime.parse('2026-02-26T18:06:46Z'),
        notes: 'Payment verified and order confirmed by admin.',
      ),
      TrackingUpdate(
        status: 'DELIVERED',
        timestamp: DateTime.parse('2026-02-26T18:07:47Z'),
        notes: 'Payment verified and order confirmed by admin.',
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
