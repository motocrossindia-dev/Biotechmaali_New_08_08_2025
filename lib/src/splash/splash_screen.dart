import 'package:biotech_maali/src/splash/splash_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
import '../../import.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  late AnimationController _contentController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  late AnimationController _progressController;

  bool _navigationTriggered = false;

  @override
  void initState() {
    super.initState();

    AnalyticsService().logScreenView(screenName: ScreenNames.splash);

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 750));
    _contentController.forward();
    _progressController.repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'v ${packageInfo.version}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        if (!_navigationTriggered) {
          _navigationTriggered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) splashProvider.navigateToHomeScreen(context);
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // ── Light green tint at the very top ──────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cButtonGreen.withOpacity(0.08),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Centre: logo + tagline ─────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo card
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, _) {
                        return Opacity(
                          opacity: _logoFade.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: cButtonGreen.withOpacity(0.12),
                                    blurRadius: 32,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/png/Gidan Logo.png',
                                height: 100,
                                width: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // Tagline
                    AnimatedBuilder(
                      animation: _contentController,
                      builder: (context, _) {
                        return FadeTransition(
                          opacity: _contentFade,
                          child: SlideTransition(
                            position: _contentSlide,
                            child: Column(
                              children: [
                                Text(
                                  'Fresh • Natural • Delivered',
                                  style: TextStyle(
                                    color: cButtonGreen.withOpacity(0.75),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: cButtonGreen.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Bottom: progress bar + version ────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 48,
                child: AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Slim progress bar
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 64),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: null,
                                minHeight: 3,
                                backgroundColor:
                                    cButtonGreen.withOpacity(0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    cButtonGreen),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Version
                          FutureBuilder<String>(
                            future: _getAppVersion(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                snapshot.data!,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
