import 'dart:developer';

import 'import.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if app was reinstalled and clear old data
  await _handleReinstallCleanup();

  // Initialize app lifecycle handler for data cleanup
  AppLifecycleHandler.initialize();

  runApp(const BiotechApp());
}

/// Detects app reinstall and clears SharedPreferences
Future<void> _handleReinstallCleanup() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String currentVersion = packageInfo.version;
    String? storedVersion = prefs.getString('app_version');
    bool? isFirstRun = prefs.getBool('is_first_run');

    // If no stored version OR first run after install, clear all data
    if (storedVersion == null || isFirstRun == null) {
      log('🔄 App reinstalled or first install detected - clearing old data...');
      await DataManager.clearAllAppData();

      // Mark as first run complete and store version
      await prefs.setBool('is_first_run', false);
      await prefs.setString('app_version', currentVersion);
      log('✅ Old data cleared successfully');
    } else if (storedVersion != currentVersion) {
      // Version changed - just update version, don't clear data
      log('📱 App updated from $storedVersion to $currentVersion');
      await prefs.setString('app_version', currentVersion);
    } else {
      log('✅ App already initialized - version $currentVersion');
    }
  } catch (e) {
    log('❌ Error in reinstall cleanup: $e');
  }
}
