import 'dart:developer';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginProvider extends ChangeNotifier {
  LoginRepository loginRepository = LoginRepository();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _referralCode = TextEditingController();
  final TextEditingController _emailId = TextEditingController();

  TextEditingController get name => _name;
  TextEditingController get referralCode => _referralCode;
  TextEditingController get emailId => _emailId;

  Future<void> accountRegister(
      BuildContext context, String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await loginRepository.accountRegister(
          mobileNumber, _name.text, _referralCode.text);
      // _isLoading = false;
      if (result) {
        prefs.setString("userName", "${name.text} ");
        prefs.setBool("isLogin", true);
        await context.read<EditProfileProvider>().fetchProfileData();
        await context.read<ReferFriendProvider>().getReferralDetails();
        await context.read<WalletProvider>().fetchWalletDetails();
        await context.read<AccountProvider>().getUserName();
        int productId = prefs.getInt("productId") ?? 0;
        log("Product ID: $productId");

        if (productId != 0) {
          prefs.remove("productId");
          context.read<BottomNavProvider>().updateIndex(0);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BottomNavWidget(
                isProductDetailsScreen: true,
                productId: productId,
              ),
            ),
            (route) => false,
          );

          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavWidget(),
          ),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
        return;
      }
    } catch (e) {
      log("Error : $e");

      // Extract clean error message without "Exception:" prefix
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11); // Remove "Exception: "
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: cDarkerRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
