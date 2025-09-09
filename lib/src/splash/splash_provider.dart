import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/location_popup/location_pincode_provider.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_provider.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_screen.dart';
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

  navigateToHomeScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isInternetOn = await _checkInternetConnection(context);
    if (!isInternetOn) {
      return;
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const ComingSoonScreen(),
    //   ),
    // );
    // return;
    await context.read<PermissionHandleProvider>().checkAllPermissions();
    await loadData(context);
    bool permissionGranted = prefs.getBool("permissionGranted") ?? false;
    // await Future.delayed(const Duration(seconds: 3));

    //for getting user data
    context.read<EditProfileProvider>().fetchProfileData();

    if (!permissionGranted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionHandleScreen(),
        ),
        (route) => false,
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavWidget(),
      ),
      (route) => false,
    );
  }

  Future<void> loadData(BuildContext context) async {
    // context.read<LocationPincodeProvider>().getCurrentLocation(context);
    // await context.read<PermissionHandleProvider>().checkAllPermissions();
    context.read<LocationPincodeProvider>().getCurrentLocation(context);
    await context.read<HomeProvider>().refreshAll();
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
}
