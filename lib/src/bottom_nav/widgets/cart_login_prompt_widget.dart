import 'package:biotech_maali/import.dart';
import 'package:lottie/lottie.dart';

class CartLoginPromptWidget extends StatelessWidget {
  final VoidCallback onLogin;

  const CartLoginPromptWidget({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing for different screen modes
    final isSmallScreen = screenHeight < 600 || screenWidth < 400;
    final animationHeight = isSmallScreen ? screenHeight * 0.25 : 300.0;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 32.0,
            vertical: isSmallScreen ? 12.0 : 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated graphic (Lottie or SVG/PNG)
              SizedBox(
                height: animationHeight,
                child: Lottie.asset(
                  'assets/animations/login_cart.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 32),
              Text(
                "Please login to access your cart!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: isSmallScreen ? 18 : null,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 8 : 16),
              Text(
                "Sign in to view and manage your cart items, checkout, and enjoy a seamless shopping experience.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      fontSize: isSmallScreen ? 12 : null,
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 16 : 32),
              ElevatedButton.icon(
                onPressed: onLogin,
                icon: const Icon(Icons.login, color: Colors.white),
                label:
                    const Text("Login", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 24 : 32,
                    vertical: isSmallScreen ? 12 : 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: cButtonGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
