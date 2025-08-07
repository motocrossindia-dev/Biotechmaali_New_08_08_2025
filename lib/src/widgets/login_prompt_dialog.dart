import 'dart:developer';

import '../../import.dart';

class LoginPromptDialog extends StatelessWidget {
  final int productId;
  const LoginPromptDialog({this.productId = 0, super.key});

  @override
  Widget build(BuildContext context) {
    int currentProductId = productId;
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
            log("Product ID: $currentProductId");
            SharedPreferences prefs = await SharedPreferences.getInstance();

            Navigator.of(context).pop(); // Close dialog
            if (currentProductId != 0) {
              await prefs.setInt("productId", currentProductId);
              currentProductId = 0; // Reset productId after setting
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MobileNumberScreen(),
              ),
            );
            // Add your login navigation logic here
            // For example:
            // Navigator.pushNamed(context, '/login');
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
