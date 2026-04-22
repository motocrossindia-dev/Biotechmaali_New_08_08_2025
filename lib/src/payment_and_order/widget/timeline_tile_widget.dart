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

  static const Color _activeGreen = Color(0xFF3B5226);
  static const Color _limeAccent = Color(0xFFA6C13C);

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

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStep();
    final steps = [
      {'label': 'Address', 'icon': Icons.location_on_outlined},
      {'label': 'Summary', 'icon': Icons.receipt_long_outlined},
      {'label': 'Payment', 'icon': Icons.lock_outline},
    ];

    return SizedBox(
      height: 72,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          // Even indices → step circles; Odd indices → connector lines
          if (index.isOdd) {
            final lineStep = (index + 1) ~/ 2;
            final isCompleted = lineStep <= currentStep;
            return Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [_activeGreen, _limeAccent],
                        )
                      : null,
                  color: isCompleted ? null : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isDone = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          final isFuture = stepIndex > currentStep;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 40 : 34,
                height: isActive ? 40 : 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? _activeGreen
                      : isActive
                          ? Colors.white
                          : Colors.grey.shade100,
                  border: Border.all(
                    color: isDone || isActive
                        ? _activeGreen
                        : Colors.grey.shade300,
                    width: isActive ? 2.5 : 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: _activeGreen.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : Icon(
                        steps[stepIndex]['icon'] as IconData,
                        size: isActive ? 20 : 16,
                        color: isActive
                            ? _activeGreen
                            : isFuture
                                ? Colors.grey.shade400
                                : Colors.white,
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIndex]['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive || isDone
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isDone
                      ? _activeGreen
                      : isActive
                          ? const Color(0xFF1B3012)
                          : Colors.grey.shade400,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
