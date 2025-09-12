import '../../import.dart';

void showCartMessage(BuildContext context, bool isAdded) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated and Pulsating Icon
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.7, end: 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isAdded
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isAdded ? Icons.shopping_cart_checkout : Icons.info_outline,
                    color: isAdded ? Colors.white : Colors.orange,
                    size: 24,
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
                  isAdded ? 'Item Added to Cart' : 'Cart Update',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAdded
                      ? 'Your product is ready for checkout'
                      : 'This item is already in your cart',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),

      // Styling
      backgroundColor: isAdded ? Colors.green.shade700 : Colors.orange.shade700,

      // Layout and Behavior
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // Margins for better visual appeal
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      // Duration and Action - Extended duration for better UX
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'VIEW CART',
        textColor: Colors.white,
        onPressed: () {
          // Dismiss snackbar before navigation
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
      ),
    ),
  );
}
