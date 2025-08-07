import '../../../import.dart';

// Enum to track order status

enum OrderStatus {
  address,
  orderSummary,
  payment,
  completed,
}

class OrderTrackerTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderTrackerTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                indicator: _buildIndicator(0),
              ),
              beforeLineStyle: LineStyle(
                color: _getLineColor(0),
              ),
              endChild: _buildTitle('Address', 0),
            ),
          ),
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                indicator: _buildIndicator(1),
              ),
              beforeLineStyle: LineStyle(
                color: _getLineColor(1),
              ),
              afterLineStyle: LineStyle(
                color: _getLineColor(1),
              ),
              endChild: _buildTitle('Order Summary', 1),
            ),
          ),
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                indicator: _buildIndicator(2),
              ),
              beforeLineStyle: LineStyle(
                color: _getLineColor(2),
              ),
              endChild: _buildTitle('Payment', 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int stepIndex) {
    int currentStep = _getCurrentStep();
    return Container(
      decoration: BoxDecoration(
        color: stepIndex <= currentStep ? timeLineColor : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: stepIndex < currentStep
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stepIndex == currentStep ? Colors.white : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
    );
  }

  Widget _buildTitle(String title, int stepIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CommonTextWidget(
        title: title,
        color: stepIndex <= _getCurrentStep() ? timeLineColor : Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getLineColor(int stepIndex) {
    return stepIndex <= _getCurrentStep()
        ? timeLineColor
        : Colors.grey.shade300;
  }

  int _getCurrentStep() {
    switch (currentStatus) {
      case OrderStatus.address:
        return 0;
      case OrderStatus.orderSummary:
        return 1;
      case OrderStatus.payment:
        return 2;
      case OrderStatus.completed:
        return 3;
    }
  }
}
