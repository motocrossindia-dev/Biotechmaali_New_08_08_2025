import 'package:biotech_maali/import.dart';

class DeleteAccountProvider extends ChangeNotifier {
  final TextEditingController _feedBackController = TextEditingController();
  TextEditingController get feedBackController => _feedBackController;

  bool _termsAndConditionsChecked = false;
  bool get termsAndConditionsChecked => _termsAndConditionsChecked;
  bool _giftCardBalanceChecked = false;
  bool get giftCardBalanceChecked => _giftCardBalanceChecked;
  bool _pastOrdersChecked = false;
  bool get pastOrdersChecked => _pastOrdersChecked;

  void setTermsAndConditionsChecked(bool value) {
    _termsAndConditionsChecked = value;
    notifyListeners();
  }

  void setGiftCardBalanceChecked(bool value) {
    _giftCardBalanceChecked = value;
    notifyListeners();
  }

  void setPastOrdersChecked(bool value) {
    _pastOrdersChecked = value;
    notifyListeners();
  }
}
