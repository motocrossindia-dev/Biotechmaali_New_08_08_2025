import 'dart:developer';

import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/import.dart';

class BottomNavProvider extends ChangeNotifier {
  bool isTokenValid = false;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // Tab names for analytics
  static const List<String> _tabNames = [
    'Home',
    'Explore',
    'Cart',
    'Wishlist',
    'Account'
  ];

  Future<bool> checkAccessTokenValidity(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    isTokenValid = await settingsProvider.checkAccessTokenValidity(context);

    log("Access token validity: $isTokenValid");

    notifyListeners();
    return isTokenValid;
  }

  void updateIndex(int index) {
    // Track bottom nav click analytics
    if (index != _currentIndex && index < _tabNames.length) {
      AnalyticsService().logBottomNavClick(
        tabName: _tabNames[index],
        fromTab:
            _currentIndex < _tabNames.length ? _tabNames[_currentIndex] : null,
      );
    }

    _currentIndex = index;
    notifyListeners();
  }
}
