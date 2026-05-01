import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';

import '../../import.dart';

void showWishlistMessage(BuildContext context, bool isAdded) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isAdded ? Icons.favorite_rounded : Icons.heart_broken_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAdded ? 'Added to Wishlist' : 'Removed from Wishlist',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isAdded ? cButtonGreen : Colors.grey.shade700,
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      duration: const Duration(seconds: 2),
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
