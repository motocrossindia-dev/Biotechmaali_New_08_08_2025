import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer';

class DataManager {
  static const String _tag = 'DataManager';

  /// Clear all SharedPreferences data
  static Future<bool> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.clear();
      log('$_tag: SharedPreferences cleared: $result');
      return result;
    } catch (e) {
      log('$_tag: Error clearing SharedPreferences: $e');
      return false;
    }
  }

  /// Clear specific preference keys
  static Future<bool> clearSpecificPreferences(List<String> keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool allCleared = true;

      for (String key in keys) {
        bool removed = await prefs.remove(key);
        if (!removed) allCleared = false;
        log('$_tag: Removed preference "$key": $removed');
      }

      return allCleared;
    } catch (e) {
      log('$_tag: Error clearing specific preferences: $e');
      return false;
    }
  }

  /// Clear all cached files and directories
  static Future<bool> clearCacheDirectory() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        log('$_tag: Cache directory cleared');
        return true;
      }
      return true;
    } catch (e) {
      log('$_tag: Error clearing cache directory: $e');
      return false;
    }
  }

  /// Clear application documents directory
  static Future<bool> clearDocumentsDirectory() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      if (await docsDir.exists()) {
        // Only clear specific app files, not the entire directory
        final files = docsDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
            log('$_tag: Deleted file: ${file.path}');
          }
        }
        return true;
      }
      return true;
    } catch (e) {
      log('$_tag: Error clearing documents directory: $e');
      return false;
    }
  }

  /// Get all stored preference keys for debugging
  static Future<Set<String>> getAllPreferenceKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getKeys();
    } catch (e) {
      log('$_tag: Error getting preference keys: $e');
      return <String>{};
    }
  }

  /// Log all stored data for debugging
  static Future<void> logAllStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      log('$_tag: === ALL STORED DATA ===');
      for (String key in keys) {
        final value = prefs.get(key);
        log('$_tag: $key = $value');
      }
      log('$_tag: === END STORED DATA ===');
    } catch (e) {
      log('$_tag: Error logging stored data: $e');
    }
  }

  /// Clear all app data (for logout or reset)
  static Future<bool> clearAllAppData() async {
    try {
      log('$_tag: Starting complete app data clear...');

      bool prefsCleared = await clearAllPreferences();
      bool cacheCleared = await clearCacheDirectory();
      bool docsCleared = await clearDocumentsDirectory();

      bool success = prefsCleared && cacheCleared && docsCleared;

      log('$_tag: Complete app data clear finished. Success: $success');
      return success;
    } catch (e) {
      log('$_tag: Error during complete app data clear: $e');
      return false;
    }
  }

  /// Clear user session data (for logout)
  static Future<bool> clearUserSession() async {
    try {
      log('$_tag: Clearing user session data...');

      List<String> userDataKeys = [
        'accessToken',
        'access_token',
        'refreshToken',
        'refresh_token',
        'user_id',
        'user_name',
        'user_mobile',
        'isLogin',
        'isRegistered',
        'user_current_address',
        'user_pincode',
        'user_locality',
        'permissionGranted',
      ];

      bool cleared = await clearSpecificPreferences(userDataKeys);
      log('$_tag: User session data cleared: $cleared');
      return cleared;
    } catch (e) {
      log('$_tag: Error clearing user session: $e');
      return false;
    }
  }

  /// Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isLogin = prefs.getBool('isLogin') ?? false;
      String? accessToken =
          prefs.getString('accessToken') ?? prefs.getString('access_token');

      return isLogin && accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      log('$_tag: Error checking login status: $e');
      return false;
    }
  }
}
