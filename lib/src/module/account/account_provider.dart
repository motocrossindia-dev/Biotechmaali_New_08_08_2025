import 'dart:developer';

import 'package:biotech_maali/import.dart';

class AccountProvider extends ChangeNotifier {
  String? _userName;
  String? get userName => _userName;

  bool isMore = false;

  void toggleMore() {
    isMore = !isMore;
    notifyListeners();
  }

  Future<void> getUserName() async {
    try {
      // Ensure Flutter binding is initialized
      WidgetsFlutterBinding.ensureInitialized();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName');

      log("UserName: ${_userName ?? 'No username found'}");
      notifyListeners();
    } catch (e) {
      log('Error retrieving username', error: e);
    }
  }
}
