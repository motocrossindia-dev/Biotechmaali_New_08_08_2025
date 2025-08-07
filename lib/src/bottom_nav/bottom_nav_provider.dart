import 'dart:developer';

import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/import.dart';

class BottomNavProvider extends ChangeNotifier {
  bool isTokenValid = false;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Future<bool> checkAccessTokenValidity(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    isTokenValid = await settingsProvider.checkAccessTokenValidity(context);

    log("Access token validity: $isTokenValid");

    notifyListeners();
    return isTokenValid;
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
