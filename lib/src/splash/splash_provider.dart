import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:biotech_maali/src/splash/token_repository.dart';

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

    // Check if the widget is still mounted before proceeding
    if (!context.mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await Future.delayed(const Duration(seconds: 3)); // Add 3-second delay

      // Check if the widget is still mounted after delay
      if (!context.mounted) return;

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
    await Future.delayed(const Duration(seconds: 3));

    // Check if the widget is still mounted before proceeding
    if (!context.mounted) return;

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

      // Skip permission checks - always set as granted for Google Play compliance
      // if (shouldRequest) {
      //   // Check and request permissions
      //   await context.read<PermissionHandleProvider>().checkAllPermissions();
      // } else {
      //   log("All permissions are permanently denied, skipping permission requests");
      //   // Set permission as granted to allow user to continue with limited functionality
      //   await prefs.setBool("permissionGranted", true);
      // }

      // Always set permission as granted to bypass permission screen
      await prefs.setBool("permissionGranted", true);

      // Check if the widget is still mounted before proceeding
      if (!context.mounted) return;

      // Load other data
      await loadData(context);

      // Check if the widget is still mounted before accessing context
      if (!context.mounted) return;

      // Get user profile data
      context.read<EditProfileProvider>().fetchProfileData();

      // Check if permissions were granted
      bool permissionGranted = prefs.getBool("permissionGranted") ?? false;
      log("Permission granted status from SharedPreferences: $permissionGranted");

      // Permission is always granted now, so this block never executes
      // if (!permissionGranted && shouldRequest) {
      //   log("Navigating to permission screen");
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const PermissionHandleScreen(),
      //     ),
      //     (route) => false,
      //   );
      //   return;
      // }

      // Check if the widget is still mounted before navigation
      if (!context.mounted) return;

      log("Navigating to home screen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavWidget(),
        ),
      );
    } catch (e) {
      log("Error in navigateToHomeScreen: $e");
      // Check if the widget is still mounted before showing dialog
      if (!context.mounted) return;
      // Handle error - maybe show error screen or retry
      _showErrorDialog(
          context, "Permission Error", "Failed to check permissions: $e");
    }
  }

  // Simplified method - always return false since we're bypassing permissions
  Future<bool> shouldRequestPermissions() async {
    log("Permission requests bypassed for Google Play compliance");
    return false; // Always return false to skip permission requests
  }

  // Method to allow user to skip permissions and continue with limited functionality
  Future<void> skipPermissions(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("permissionGranted", true);
      log("Permissions skipped by user");

      // Check if the widget is still mounted before navigation
      if (!context.mounted) return;

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
      // Check if the widget is still mounted before showing dialog
      if (!context.mounted) return false;
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
                // openAppSettings(); // Commented out - permission handler removed
              },
            ),
          ],
        );
      },
    );
  }
}
