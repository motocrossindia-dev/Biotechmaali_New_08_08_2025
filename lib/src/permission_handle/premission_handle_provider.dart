import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandleProvider with ChangeNotifier {
  bool _locationPermission = false;
  // bool _storagePermission = false;
  bool _cameraPermission = false;
  bool _microphonePermission = false;
  // bool _notificationPermission = false;

  bool get locationPermission => _locationPermission;
  // bool get storagePermission => _storagePermission;
  bool get cameraPermission => _cameraPermission;
  bool get microphonePermission => _microphonePermission;
  // bool get notificationPermission => _notificationPermission;

  bool get allPermissionsGranted =>
      _locationPermission &&
      // _storagePermission &&
      _cameraPermission &&
      _microphonePermission;
  // _notificationPermission;

  Future<void> checkPermissions() async {
    _locationPermission = await Permission.location.isGranted;
    // _storagePermission = await _checkStoragePermission();
    _cameraPermission = await Permission.camera.isGranted;
    _microphonePermission = await Permission.microphone.isGranted;
    // _notificationPermission = await Permission.notification.isGranted;
    notifyListeners();
  }

  Future<void> checkAllPermissions() async {
    await checkPermissions();
    log(
      "Checking all permissions: Location: $_locationPermission, Camera: $_cameraPermission, Microphone: $_microphonePermission, allPermissionsGranted: $allPermissionsGranted",
    );
    if (!allPermissionsGranted) {
      await requestLocationPermission();
      // await requestStoragePermission();
      await requestCameraPermission();
      await requestMicrophonePermission();
      // if (allPermissionsGranted) {
      //   // Save permission status to SharedPreferences
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setBool("permissionGranted", true);
      //   log("All permissions granted and saved to SharedPreferences.");
      // } else {
      //   log("Not all permissions granted.");
      // }
    }
    if (allPermissionsGranted) {
      // Save permission status to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("permissionGranted", true);
      log("All permissions granted and saved to SharedPreferences.");
    } else {
      log("Not all permissions granted.");
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    _locationPermission = status.isGranted;
    notifyListeners();
  }

  // Future<void> requestStoragePermission() async {
  //   try {
  //     PermissionStatus status;
  //     if (Platform.isAndroid) {
  //       // Android 13+ (API 33+)
  //       if (await Permission.photos.request().isGranted) {
  //         _storagePermission = true;
  //       } else {
  //         // Android < 13
  //         status = await Permission.storage.request();
  //         _storagePermission = status.isGranted;
  //       }
  //     } else {
  //       // For iOS or other platforms, adjust as needed
  //       _storagePermission = true;
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log('Error requesting storage permission: $e');
  //   }
  // }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    _cameraPermission = status.isGranted;
    notifyListeners();
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    _microphonePermission = status.isGranted;
    notifyListeners();
  }
}
