import 'dart:math' as math;
import 'package:biotech_maali/src/splash/splash_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Increased from 1500
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 3000), // Increased from 2000
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Increased from 800
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Slightly longer initial delay
    _logoController.forward();

    await Future.delayed(
        const Duration(milliseconds: 1200)); // Longer delay before text
    _textController.forward();

    _loadingController
        .repeat(); // This will keep repeating throughout the loading
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.5; // Increased delay for slower sequence
            final animationValue =
                (_loadingController.value - delay).clamp(0.0, 1.0);
            final scale = 0.8 +
                (0.3 *
                    (1 +
                        math.sin(animationValue *
                            2 *
                            math.pi))); // Slightly more scale variation
            final float = math.sin(animationValue * 2 * math.pi) *
                4; // Increased float range

            // Ensure opacity is always between 0.0 and 1.0
            final opacity =
                (0.6 + (0.4 * scale)).clamp(0.0, 1.0); // More opacity variation

            return Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10), // Increased margin
              child: Transform.translate(
                offset: Offset(0, float),
                child: Transform.scale(
                  scale: scale.clamp(0.5, 1.8), // Allow more scale variation
                  child: Icon(
                    Icons.eco,
                    size: 22, // Slightly larger icon
                    color: cButtonGreen.withOpacity(opacity),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        final rotationValue = _loadingController.value * 2 * math.pi;
        final pulseValue =
            (1 + math.sin(_loadingController.value * 4 * math.pi) * 0.1);

        return Transform.scale(
          scale: pulseValue,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cButtonGreen.withOpacity(0.1),
                  cButtonGreen.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.6, 0.8, 1.0],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer decorative ring
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cButtonGreen.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),

                // Main progress indicator
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(cButtonGreen),
                    backgroundColor: cButtonGreen.withOpacity(0.1),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                // Inner rotating dots
                Transform.rotate(
                  angle: rotationValue * 0.5, // Slower rotation
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: List.generate(4, (index) {
                        final angle =
                            (index * math.pi * 0.5) + rotationValue * 0.3;
                        final x = math.cos(angle) * 15;
                        final y = math.sin(angle) * 15;

                        return Transform.translate(
                          offset: Offset(x, y),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: cButtonGreen.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Center dot with pulse
                Container(
                  width: 8 * pulseValue,
                  height: 8 * pulseValue,
                  decoration: BoxDecoration(
                    color: cButtonGreen.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cButtonGreen.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'Version - ${packageInfo.version}';
  }

  @override
  Widget build(BuildContext context) {
    SplashProvider(context: context);
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        splashProvider.navigateToHomeScreen(context);
        if (splashProvider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    // Main content
                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Add some top padding
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),

                            // Animated Logo
                            AnimatedBuilder(
                              animation: _logoAnimation,
                              builder: (context, child) {
                                final scale =
                                    _logoAnimation.value.clamp(0.0, 2.0);
                                final opacity =
                                    _logoAnimation.value.clamp(0.0, 1.0);

                                return Transform.scale(
                                  scale: scale,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            blurRadius: 25,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/png/biotech_logo.png',
                                        height: 101,
                                        width: 194,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 60),

                            // Loading section with animation
                            AnimatedBuilder(
                              animation: _fadeAnimation,
                              builder: (context, child) {
                                final opacity =
                                    _fadeAnimation.value.clamp(0.0, 1.0);

                                return Opacity(
                                  opacity: opacity,
                                  child: Column(
                                    children: [
                                      // Loading message
                                      CommonTextWidget(
                                        title:
                                            "Your green garden is loading...",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: cButtonGreen,
                                      ),

                                      const SizedBox(height: 30),

                                      // Leaf animation
                                      _buildLoadingDots(),

                                      const SizedBox(height: 30),

                                      // Circular progress indicator
                                      _buildCircularProgress(),
                                    ],
                                  ),
                                );
                              },
                            ),

                            // Add some bottom padding
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                          ],
                        ),
                      ),
                    ),

                    // Version at bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 32,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            final opacity =
                                _fadeAnimation.value.clamp(0.0, 1.0);

                            return Opacity(
                              opacity: opacity,
                              child: FutureBuilder<String>(
                                future: _getAppVersion(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return CommonTextWidget(
                                      title: snapshot.data!,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Decorative floating elements
                    ...List.generate(6, (index) {
                      return AnimatedBuilder(
                        animation: _loadingController,
                        builder: (context, child) {
                          final offset = _loadingController.value * 2 * math.pi;
                          final x = math.sin(offset + index) * 15;
                          final y = math.cos(offset + index * 0.7) * 20;

                          return Positioned(
                            left: MediaQuery.of(context).size.width * 0.15 +
                                x +
                                (index * 50),
                            top: MediaQuery.of(context).size.height * 0.25 +
                                y +
                                (index * 30),
                            child: Opacity(
                              opacity: 0.2,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: cButtonGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        }

        // Placeholder widget while navigationTarget is being determined
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/png/biotech_logo.png',
                  height: 101,
                  width: 194,
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(cButtonGreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
