import 'package:biotech_maali/import.dart';
import 'package:lottie/lottie.dart';

class CartLoginPromptWidget extends StatelessWidget {
  final VoidCallback onLogin;

  const CartLoginPromptWidget({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated graphic (Lottie or SVG/PNG)
            SizedBox(
              height: 300,
              child: Lottie.asset(
                'assets/animations/login_cart.json', // Replace with your Lottie file path
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Please login to access your cart!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Sign in to view and manage your cart items, checkout, and enjoy a seamless shopping experience.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onLogin,
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text("Login", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: cButtonGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
