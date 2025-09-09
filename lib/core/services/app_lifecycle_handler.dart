import 'package:flutter/material.dart';
import 'package:biotech_maali/core/services/data_manager.dart';
import 'dart:developer';

class AppLifecycleHandler extends WidgetsBindingObserver {
  static const String _tag = 'AppLifecycleHandler';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    log('$_tag: App lifecycle state changed to: $state');

    switch (state) {
      case AppLifecycleState.detached:
        // App is being terminated/uninstalled
        _handleAppTermination();
        break;
      case AppLifecycleState.paused:
        // App is in background
        log('$_tag: App paused');
        break;
      case AppLifecycleState.resumed:
        // App is in foreground
        log('$_tag: App resumed');
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        log('$_tag: App inactive');
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        log('$_tag: App hidden');
        break;
    }
  }

  void _handleAppTermination() {
    log('$_tag: App is being terminated - cleaning up data');
    // Note: This may not execute during uninstall as the process is killed
    // but it's good for normal app termination
    DataManager.clearCacheDirectory();
  }

  /// Initialize the lifecycle handler
  static void initialize() {
    WidgetsBinding.instance.addObserver(AppLifecycleHandler());
    log('$_tag: App lifecycle handler initialized');
  }

  /// Dispose the lifecycle handler
  static void dispose() {
    WidgetsBinding.instance.removeObserver(AppLifecycleHandler());
    log('$_tag: App lifecycle handler disposed');
  }
}
