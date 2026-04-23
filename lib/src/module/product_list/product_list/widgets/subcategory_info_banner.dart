import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/explore/model/subcategory_model.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryInfoBanner extends StatelessWidget {
  final Subcategory subcategory;

  const SubcategoryInfoBanner({required this.subcategory, super.key});

  @override
  Widget build(BuildContext context) {
    final info = subcategory.subCategoryInfo;
    if (info == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cButtonGreen,
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: LeafPatternPainter(color: Colors.white.withOpacity(0.08)),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heading
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                    children: [
                      if (info.headingBefore.isNotEmpty)
                        TextSpan(text: '${info.headingBefore}\n'),
                      if (info.italicText.isNotEmpty)
                        TextSpan(
                          text: '${info.italicText} ',
                          style: GoogleFonts.outfit(
                            fontStyle: FontStyle.italic,
                            color: cItalicGreen,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (info.headingAfter.isNotEmpty)
                        TextSpan(text: info.headingAfter),
                    ],
                  ),
                ),

                if (info.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    info.description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.4,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],

                if (info.tags.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: info.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                if (info.stats.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatItem(info.stats[0]),
                      if (info.stats.length > 1) ...[
                        const SizedBox(width: 16),
                        _buildStatItem(info.stats[1], isRating: true),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(Stat stat, {bool isRating = false}) {
    String number = stat.number;
    // Remove existing star from text if we're adding a custom yellow one
    if (isRating && number.contains('★')) {
      number = number.replaceAll('★', '').trim();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (isRating) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.yellow, size: 20),
              ],
            ],
          ),
          Text(
            stat.label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class LeafPatternPainter extends CustomPainter {
  final Color color;

  LeafPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double leafWidth = 20;
    const double leafHeight = 30;
    const double spacingX = 40;
    const double spacingY = 50;

    for (double y = 0; y < size.height + spacingY; y += spacingY) {
      for (double x = 0; x < size.width + spacingX; x += spacingX) {
        double currentX = x;
        if ((y / spacingY).round() % 2 != 0) {
          currentX += spacingX / 2;
        }
        
        final path = Path();
        path.moveTo(currentX, y);
        path.quadraticBezierTo(currentX + leafWidth / 2, y + leafHeight / 2, currentX, y + leafHeight);
        path.quadraticBezierTo(currentX - leafWidth / 2, y + leafHeight / 2, currentX, y);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
