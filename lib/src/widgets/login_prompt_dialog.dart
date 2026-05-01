import 'dart:developer';

import '../../import.dart';

class LoginPromptDialog extends StatelessWidget {
  final int productId;
  final String productSlug;
  const LoginPromptDialog(
      {this.productId = 0, this.productSlug = '', super.key});

  @override
  Widget build(BuildContext context) {
    String currentSlug = productSlug;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cButtonGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_rounded,
                size: 40,
                color: cButtonGreen,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              "Login Required",
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              "Please login to your account to continue adding items to your cart or wishlist.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.0,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      log("Product Slug: $currentSlug, Product ID: $productId");
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      Navigator.of(context).pop(); // Close dialog
                      // Persist slug for post-login redirect
                      if (currentSlug.isNotEmpty) {
                        await prefs.setString('productSlug', currentSlug);
                      } else if (productId != 0) {
                        // Legacy fallback: store as int for existing callers
                        await prefs.setInt('productId', productId);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileNumberScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cButtonGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
