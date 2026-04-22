import 'dart:math' as math;
import 'package:flutter/material.dart';

class GdCoinWidget extends StatefulWidget {
  final double size;

  const GdCoinWidget({super.key, this.size = 50});

  @override
  State<GdCoinWidget> createState() => _GdCoinWidgetState();
}

class _GdCoinWidgetState extends State<GdCoinWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // We create a flipping effect by rotating along Y axis
        // We use sine wave for smooth back and forth or just a continuous rotation
        // For a coin, continuous rotation is good but might make text backwards.
        // Let's do a subtle shine + wobble effect instead of full flip to keep GD readable.
        
        final wobble = math.sin(_controller.value * math.pi * 2) * 0.15;
        final shineOffset = _controller.value * 2 - 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(wobble)
            ..rotateX(wobble * 0.5),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.3, -0.3),
                colors: [
                  Color(0xFFFFDF00), // Brilliant Gold
                  Color(0xFFD4AF37), // Metallic Gold
                  Color(0xFFDAA520), // Goldenrod
                  Color(0xFFB8860B), // Dark Goldenrod
                ],
                stops: [0.0, 0.4, 0.8, 1.0],
              ),
              border: Border.all(
                color: const Color(0xFFDAA520),
                width: widget.size * 0.04,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: widget.size * 0.25,
                  offset: Offset(0, widget.size * 0.1),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: widget.size * 0.15,
                  offset: Offset(widget.size * 0.05, widget.size * 0.05),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Inner rim
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(widget.size * 0.08),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFE066).withOpacity(0.5),
                        width: widget.size * 0.02,
                      ),
                    ),
                  ),
                ),
                // Moving shine effect
                Positioned.fill(
                  child: ClipOval(
                    child: FractionalTranslation(
                      translation: Offset(shineOffset, shineOffset),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.3, 0.5, 0.7],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // GD Text
                Center(
                  child: Text(
                    'GD',
                    style: TextStyle(
                      color: const Color(0xFF6B4200), // Deep rich brown-gold
                      fontSize: widget.size * 0.38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -widget.size * 0.02,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.4),
                          offset: const Offset(-1, -1),
                          blurRadius: 1,
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(widget.size * 0.02, widget.size * 0.02),
                          blurRadius: widget.size * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
