import 'package:biotech_maali/core/config/pallet.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AccountPromptWidget extends StatelessWidget {
  final VoidCallback onLogin;

  const AccountPromptWidget({super.key, required this.onLogin});

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
              height: 180,
              child: Lottie.asset(
                'assets/animations/account_login.json', // Replace with your Lottie file path
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Login to view your account!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Sign in to manage your profile, view orders, and access exclusive features.",
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
