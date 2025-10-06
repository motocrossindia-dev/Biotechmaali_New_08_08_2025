import 'dart:developer';
import 'dart:io';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_provider.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:biotech_maali/src/splash/token_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashProvider extends ChangeNotifier {
  SplashProvider({required BuildContext context});
  bool isLoading = true;
  String navigationTarget = "";

  final TokenRepository _tokenRepository = TokenRepository();

  Future<void> checkTokenAndNavigate(BuildContext context) async {
    bool isInternetOn = await _checkInternetConnection(context);
    if (!isInternetOn) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await Future.delayed(const Duration(seconds: 3)); // Add 3-second delay

      String? accessToken = prefs.getString("accessToken");
      String? refreshToken = prefs.getString("refreshToken");

      if (accessToken == null || refreshToken == null) {
        navigationTarget = "login";
      } else {
        bool isAccessTokenValid =
            await _tokenRepository.verifyToken(accessToken);

        if (isAccessTokenValid) {
          navigationTarget = "home";
        } else {
          String? newAccessToken =
              await _tokenRepository.refreshToken(refreshToken);

          if (newAccessToken != null) {
            await prefs.setString("accessToken", newAccessToken);
            navigationTarget = "home";
          } else {
            navigationTarget = "login";
          }
        }
      }
    } catch (e) {
      log("Error during token check: $e");
      navigationTarget = "error";
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners after state update
    }
  }

  Future<void> navigateToHomeScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isInternetOn = await _checkInternetConnection(context);
    if (!isInternetOn) {
      return;
    }

    log("Platform: ${Platform.operatingSystem}");
    log("Starting permission check and navigation flow...");

    try {
      // Check if we should request permissions (not permanently denied)
      bool shouldRequest = await shouldRequestPermissions();
      log("Should request permissions: $shouldRequest");

      if (shouldRequest) {
        // Check and request permissions
        await context.read<PermissionHandleProvider>().checkAllPermissions();
      } else {
        log("All permissions are permanently denied, skipping permission requests");
        // Set permission as granted to allow user to continue with limited functionality
        await prefs.setBool("permissionGranted", true);
      }

      // Load other data
      await loadData(context);

      // Get user profile data
      context.read<EditProfileProvider>().fetchProfileData();

      // Check if permissions were granted
      bool permissionGranted = prefs.getBool("permissionGranted") ?? false;
      log("Permission granted status from SharedPreferences: $permissionGranted");

      if (!permissionGranted && shouldRequest) {
        log("Navigating to permission screen");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PermissionHandleScreen(),
          ),
          (route) => false,
        );
        return;
      }

      log("Navigating to home screen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavWidget(),
        ),
      );
    } catch (e) {
      log("Error in navigateToHomeScreen: $e");
      // Handle error - maybe show error screen or retry
      _showErrorDialog(
          context, "Permission Error", "Failed to check permissions: $e");
    }
  }

  // Add this method to check if we should show permission requests
  Future<bool> shouldRequestPermissions() async {
    try {
      // If all permissions are permanently denied, don't try to request
      bool allPermanentlyDenied = true;

      if (Platform.isIOS) {
        bool locationDenied =
            await Permission.locationWhenInUse.isPermanentlyDenied;
        bool cameraDenied = await Permission.camera.isPermanentlyDenied;
        bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;
        bool photosDenied = await Permission.photos.isPermanentlyDenied;

        allPermanentlyDenied =
            locationDenied && cameraDenied && microphoneDenied && photosDenied;

        log("iOS Permission Status - Location: $locationDenied, Camera: $cameraDenied, Microphone: $microphoneDenied, Photos: $photosDenied");
      } else {
        bool locationDenied = await Permission.location.isPermanentlyDenied;
        bool cameraDenied = await Permission.camera.isPermanentlyDenied;
        bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;

        allPermanentlyDenied =
            locationDenied && cameraDenied && microphoneDenied;

        log("Android Permission Status - Location: $locationDenied, Camera: $cameraDenied, Microphone: $microphoneDenied");
      }

      log("All permissions permanently denied: $allPermanentlyDenied");
      return !allPermanentlyDenied;
    } catch (e) {
      log("Error checking permission status: $e");
      return true; // If error, try to request permissions
    }
  }

  // Method to allow user to skip permissions and continue with limited functionality
  Future<void> skipPermissions(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("permissionGranted", true);
      log("Permissions skipped by user");

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavWidget(),
        ),
      );
    } catch (e) {
      log("Error skipping permissions: $e");
    }
  }

  Future<void> loadData(BuildContext context) async {
    try {
      log("Loading app data...");
      await context.read<HomeProvider>().refreshAll();
      log("App data loaded successfully");
    } catch (e) {
      log("Error loading app data: $e");
    }
  }

  Future<bool> _checkInternetConnection(BuildContext context) async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();

    if (connectivityResults.isEmpty ||
        connectivityResults.first == ConnectivityResult.none) {
      // No internet connection, show a dialog or message
      _showNoInternetDialog(context);
      return false;
    }
    return true;
  }

  // Show dialog when there is no internet
  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text(
              "Please check your internet connection and try again."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show permissions permanently denied dialog
  void showPermissionsDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
              "Some permissions are permanently denied. You can either:\n\n"
              "1. Continue with limited functionality\n"
              "2. Go to Settings to enable permissions manually"),
          actions: <Widget>[
            TextButton(
              child: const Text("Continue with Limited Features"),
              onPressed: () {
                Navigator.of(context).pop();
                skipPermissions(context);
              },
            ),
            TextButton(
              child: const Text("Go to Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
