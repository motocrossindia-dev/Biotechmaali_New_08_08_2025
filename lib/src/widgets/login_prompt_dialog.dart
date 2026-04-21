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
    return AlertDialog(
      title: const Text('Not Logged In'),
      content: const Text('You are not logged in. Please login to continue.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
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
          child: const Text('Login'),
        ),
      ],
    );
  }
}
