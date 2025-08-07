import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';

import '../../import.dart';

void showWishlistMessage(BuildContext context, bool isAdded) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pulsating Animated Icon
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0.85, end: 1.1),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(
                      8), // Reduced padding for a compact look
                  decoration: BoxDecoration(
                    color: isAdded
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAdded
                        ? Icons.check_circle_outline
                        : Icons.remove_circle_outline,
                    color: isAdded
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                    size: 26,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 12),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAdded
                      ? 'Item Added to Wishlist'
                      : 'Item Removed from Wishlist',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Styling
      backgroundColor:
          isAdded ? Colors.blueGrey.shade300 : Colors.blueGrey.shade300,

      // Layout & Behavior
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // Margins for a better floating effect
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // Shorter Duration
      duration: const Duration(milliseconds: 900),

      // Action Button
      action: SnackBarAction(
        label: 'VIEW',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WishlistScreen()),
          );
        },
      ),
    ),
  );
}
