import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:biotech_maali/core/config/pallet.dart';
import 'package:google_fonts/google_fonts.dart';

class NoProductsFoundWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const NoProductsFoundWidget({
    super.key,
    this.title = 'No Products Found',
    this.subtitle =
        'We couldn\'t find any products matching your criteria.\nTry adjusting your filters or search.',
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation with green tint overlay
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: cButtonGreen.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset(
                  'assets/animations/nodata.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: cButtonGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Decorative dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(cButtonGreen.withOpacity(0.3)),
                  const SizedBox(width: 8),
                  _buildDot(cButtonGreen.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  _buildDot(cButtonGreen),
                  const SizedBox(width: 8),
                  _buildDot(cButtonGreen.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  _buildDot(cButtonGreen.withOpacity(0.3)),
                ],
              ),

              // Optional Retry Button
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cButtonGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(
                    retryButtonText ?? 'Try Again',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
