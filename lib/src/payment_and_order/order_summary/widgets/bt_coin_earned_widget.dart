import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import '../../../../import.dart';
import 'package:biotech_maali/src/widgets/gd_coin_widget.dart';

class BtCoinEarnedWidget extends StatefulWidget {
  final OrderData orderData;

  const BtCoinEarnedWidget({
    required this.orderData,
    super.key,
  });

  @override
  State<BtCoinEarnedWidget> createState() => _BtCoinEarnedWidgetState();
}

class _BtCoinEarnedWidgetState extends State<BtCoinEarnedWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _coinRotateController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;

  int _displayedCoins = 0;
  late int _totalCoins;

  @override
  void initState() {
    super.initState();

    // Use GD Coin directly from backend response
    final order = widget.orderData.order;
    _totalCoins = order?.gdCoin ?? 0;

    // Scale animation for the container
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Slide animation for the container
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Coin rotation animation
    _coinRotateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Shimmer effect animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(_shimmerController);

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _coinRotateController.forward();

    // Animate the coin count
    _animateCoinCount();
  }

  void _animateCoinCount() async {
    const duration = Duration(milliseconds: 1500);
    const steps = 30;
    final increment = _totalCoins / steps;

    for (int i = 0; i <= steps; i++) {
      await Future.delayed(duration ~/ steps);
      if (mounted) {
        setState(() {
          _displayedCoins = (increment * i).round();
        });
      }
    }

    // Ensure we show exact final value
    if (mounted) {
      setState(() {
        _displayedCoins = _totalCoins;
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _coinRotateController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_totalCoins <= 0) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF3F6331).withOpacity(0.1),
                const Color(0xFF3F6331).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF3F6331).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Shimmer effect
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment(_shimmerAnimation.value, -1),
                            end: Alignment(_shimmerAnimation.value + 0.5, 1),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Animated coin icon
                    const GdCoinWidget(size: 50),

                    const SizedBox(width: 16),

                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                '🎉 You Earned ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3F6331),
                                ),
                              ),
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: _displayedCoins),
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Text(
                                    '$value',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFD700),
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFFFFD700),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                ' GD Coins',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3F6331),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'GD Coins earned on this order! 💰',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sparkle icon
                    const GdCoinWidget(size: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
