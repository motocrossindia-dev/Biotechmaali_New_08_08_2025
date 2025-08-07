import 'dart:developer';
import 'package:biotech_maali/src/authentication/otp/otp_repository.dart';
import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../import.dart';

class OtpProvider extends ChangeNotifier {
  final OtpRepository _repository = OtpRepository();
  bool _isLoading = false;
  String _errorMessage = '';
  String? _otp;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get otp => _otp;

  void setOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  Future<void> validateOtp(String mobile, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_otp == null || _otp!.length != 4) {
      log("Otp : $_otp");
      _errorMessage = 'Please enter a valid OTP';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _repository.validateOtp(mobile, _otp!, context);
      _isLoading = false;

      if (result == true) {
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
      } else if (result == false) {
        Fluttertoast.showToast(
          msg: "Please register first",
          backgroundColor: cButtonGreen,
          textColor: Colors.white,
        );
        return;
      } else {
        Fluttertoast.showToast(
          msg: "Invalid OTP. Please try again.",
          backgroundColor: cDarkerRed,
          textColor: Colors.white,
        );
      }

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      String errorMsg = e.toString();
      // If the error contains a colon, show only the part after it
      if (errorMsg.contains(':')) {
        errorMsg = errorMsg.split(':').last.trim();
      }
      Fluttertoast.showToast(
        msg: errorMsg,
        backgroundColor: cDarkerRed,
        textColor: Colors.white,
      );
      log("message:$e");
      notifyListeners();
    }
  }
}
