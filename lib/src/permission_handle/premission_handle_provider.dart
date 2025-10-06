import 'dart:developer';
import 'dart:io';
import 'package:biotech_maali/import.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandleProvider with ChangeNotifier {
  bool _locationPermission = false;
  bool _cameraPermission = false;
  bool _microphonePermission = false;

  bool get locationPermission => _locationPermission;
  bool get cameraPermission => _cameraPermission;
  bool get microphonePermission => _microphonePermission;

  bool get allPermissionsGranted =>
      _locationPermission && _cameraPermission && _microphonePermission;

  Future<void> checkPermissions() async {
    _locationPermission = await _checkLocationPermission();
    _cameraPermission = await Permission.camera.isGranted;
    _microphonePermission = await Permission.microphone.isGranted;

    notifyListeners();
    log("Current permissions - Location: $_locationPermission, Camera: $_cameraPermission, Microphone: $_microphonePermission");
  }

  Future<bool> _checkLocationPermission() async {
    if (Platform.isIOS) {
      return await Permission.locationWhenInUse.isGranted;
    } else {
      return await Permission.location.isGranted;
    }
  }

  Future<void> checkAllPermissions() async {
    log("Starting permission check...");
    await checkPermissions();

    // Check if any permissions are permanently denied
    bool hasPermissionIssues = await _checkForPermanentlyDeniedPermissions();

    if (hasPermissionIssues) {
      log("Some permissions are permanently denied. User needs to enable them manually in Settings.");
      return;
    }

    if (!allPermissionsGranted) {
      log("Not all permissions granted, requesting...");
      await _requestAllPermissions();
      await checkPermissions();
    }

    if (allPermissionsGranted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("permissionGranted", true);
      log("All permissions granted and saved to SharedPreferences.");
    } else {
      log("Not all permissions granted after request.");
      await _logPermissionStatuses();
    }
  }

  Future<bool> _checkForPermanentlyDeniedPermissions() async {
    bool locationDenied = false;
    bool cameraDenied = false;
    bool microphoneDenied = false;

    if (Platform.isIOS) {
      locationDenied = await Permission.locationWhenInUse.isPermanentlyDenied;
    } else {
      locationDenied = await Permission.location.isPermanentlyDenied;
    }

    cameraDenied = await Permission.camera.isPermanentlyDenied;
    microphoneDenied = await Permission.microphone.isPermanentlyDenied;

    if (locationDenied || cameraDenied || microphoneDenied) {
      log("Permanently denied permissions found:");
      log("Location: $locationDenied, Camera: $cameraDenied, Microphone: $microphoneDenied");
      return true;
    }

    return false;
  }

  Future<void> _requestAllPermissions() async {
    if (Platform.isIOS) {
      await _requestIOSPermissions();
    } else {
      await _requestAndroidPermissions();
    }
  }

  Future<void> _requestIOSPermissions() async {
    log("Requesting iOS permissions...");

    if (!await Permission.locationWhenInUse.isPermanentlyDenied) {
      await requestLocationPermission();
    }

    if (!await Permission.camera.isPermanentlyDenied) {
      await requestCameraPermission();
    }

    if (!await Permission.microphone.isPermanentlyDenied) {
      await requestMicrophonePermission();
    }
  }

  Future<void> _requestAndroidPermissions() async {
    log("Requesting Android permissions...");

    if (!await Permission.location.isPermanentlyDenied) {
      await requestLocationPermission();
    }

    if (!await Permission.camera.isPermanentlyDenied) {
      await requestCameraPermission();
    }

    if (!await Permission.microphone.isPermanentlyDenied) {
      await requestMicrophonePermission();
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      PermissionStatus status;

      if (Platform.isIOS) {
        status = await Permission.locationWhenInUse.request();
        _locationPermission = status.isGranted;
        log("iOS Location permission status: $status");
      } else {
        status = await Permission.location.request();
        _locationPermission = status.isGranted;
        log("Android Location permission status: $status");
      }
    } catch (e) {
      log("Error requesting location permission: $e");
    }
    notifyListeners();
  }

  Future<void> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      _cameraPermission = status.isGranted;
      log("Camera permission status: $status");
    } catch (e) {
      log("Error requesting camera permission: $e");
    }
    notifyListeners();
  }

  Future<void> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      _microphonePermission = status.isGranted;
      log("Microphone permission status: $status");
    } catch (e) {
      log("Error requesting microphone permission: $e");
    }
    notifyListeners();
  }

  Future<void> _logPermissionStatuses() async {
    log("=== Permission Status Summary ===");
    log("Location: $_locationPermission");
    log("Camera: $_cameraPermission");
    log("Microphone: $_microphonePermission");
    log("All Granted: $allPermissionsGranted");
    log("Platform: ${Platform.operatingSystem}");
  }

  // FIXED: Method to open app settings
  Future<void> openSettings() async {
    await openAppSettings(); // This is the correct method from permission_handler
  }

  Future<void> resetPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("permissionGranted", false);
    await checkPermissions();
  }

  Future<void> skipPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("permissionGranted", true);
    log("Permissions skipped by user");
  }
}
