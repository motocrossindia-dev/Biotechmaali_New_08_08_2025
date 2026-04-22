import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingSoonScreen extends StatefulWidget {
  final String title;

  const ComingSoonScreen({
    super.key,
    required this.title,
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();

    // Floating up-down animation for the gift icon
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse animation for the glow ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Sparkle rotation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _sparkleAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0D2164)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D2164),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Animated gift area with sparkles
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_floatAnimation, _pulseAnimation, _sparkleAnimation]),
              builder: (context, child) {
                return SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulsing glow ring
                      Container(
                        width: 200 + (_pulseAnimation.value * 20),
                        height: 200 + (_pulseAnimation.value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF3F6331).withValues(
                                  alpha: 0.08 * _pulseAnimation.value),
                              const Color(0xFF3F6331).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),

                      // Rotating sparkles
                      ...List.generate(6, (index) {
                        final angle =
                            _sparkleAnimation.value + (index * pi / 3);
                        final radius = 100 + (_pulseAnimation.value * 10);
                        return Positioned(
                          left: 140 + radius * cos(angle) - 6,
                          top: 140 +
                              radius * sin(angle) +
                              _floatAnimation.value -
                              6,
                          child: _buildSparkle(index),
                        );
                      }),

                      // Floating gift icon
                      Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3F6331),
                                Color(0xFF5C7F07),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3F6331)
                                    .withValues(alpha: 0.3),
                                blurRadius: 25,
                                spreadRadius: 5,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.card_giftcard_rounded,
                            size: 65,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // "Coming Soon" text with shimmer-like gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF0D2164),
                  Color(0xFF3F6331),
                  Color(0xFF0D2164),
                ],
              ).createShader(bounds),
              child: Text(
                'Coming Soon!',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We\'re crafting something special\njust for you! 🎁',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Feature cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildFeatureCard(
                    icon: Icons.local_florist_rounded,
                    title: 'Curated Gift Sets',
                    subtitle: 'Beautiful plant arrangements for every occasion',
                    color: const Color(0xFF3F6331),
                    delay: 0,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    icon: Icons.celebration_rounded,
                    title: 'Special Occasions',
                    subtitle: 'Birthdays, anniversaries & festive celebrations',
                    color: const Color(0xFF0D2164),
                    delay: 1,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    icon: Icons.favorite_rounded,
                    title: 'Personalized Gifts',
                    subtitle: 'Add a personal touch with custom messages',
                    color: const Color(0xFFC63E3E),
                    delay: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Notify me button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3F6331), Color(0xFF5C7F07)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F6331).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.explore_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Explore Other Categories',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkle(int index) {
    final colors = [
      const Color(0xFF3F6331),
      const Color(0xFFFFD700),
      const Color(0xFF0D2164),
      const Color(0xFFC63E3E),
      const Color(0xFF3F6331),
      const Color(0xFFFFD700),
    ];

    final sizes = [10.0, 7.0, 12.0, 8.0, 9.0, 6.0];

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: (0.3 + (_pulseAnimation.value * 0.7)).clamp(0.0, 1.0),
          child: Icon(
            Icons.auto_awesome,
            size: sizes[index % sizes.length] + (_pulseAnimation.value * 4),
            color: colors[index % colors.length],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (delay * 200)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
