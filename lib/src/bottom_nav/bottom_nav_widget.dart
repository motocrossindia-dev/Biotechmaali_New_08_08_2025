// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/bottom_nav/widgets/account_prompt_widget.dart';
import 'package:biotech_maali/src/bottom_nav/widgets/cart_login_prompt_widget.dart';
import 'package:biotech_maali/src/module/cart/cart_shimmer.dart';
import 'package:biotech_maali/src/module/location_popup/location_pincode_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:flutter/services.dart';
import '../../import.dart';

class BottomNavWidget extends StatefulWidget {
  final bool isProductDetailsScreen;
  final int productId;
  const BottomNavWidget(
      {this.productId = 0, this.isProductDetailsScreen = false, super.key});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  // At the class level, add this variable
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavProvider>().checkAccessTokenValidity(context);
      context
          .read<LocationPincodeProvider>()
          .getCurrentLocationFromBottomNav(context);
    });
    if (widget.isProductDetailsScreen) {
      // If this widget is created from ProductDetailsScreen, show the login dialog
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsScreen(productId: widget.productId),
            ),
          );
        },
      );
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (context.read<BottomNavProvider>().currentIndex != 0) {
      // If not on the home screen, go back to the home screen
      context.read<BottomNavProvider>().updateIndex(0);
      return false; // Prevents the app from exiting
    }

    // Check if this is the second back press within 2 seconds

    if (_lastBackPressTime != null &&
        DateTime.now().difference(_lastBackPressTime!) <=
            const Duration(seconds: 2)) {
      // If user pressed back button twice within 2 seconds, exit the app
      return true; // This will allow the app to exit
    } else {
      // First back press - save the time and show snackbar
      _lastBackPressTime = DateTime.now();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: cButtonGreen.withOpacity(0.7),
          duration: const Duration(
              seconds: 2), // Duration matches the back press window
          content: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exit App?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Press back again to exit',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'EXIT NOW',
            textColor: Colors.redAccent,
            onPressed: () {
              SystemNavigator.pop(); // This will exit the app immediately
            },
          ),
        ),
      );

      // Return false to prevent immediate exit on the first back press
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Consumer<BottomNavProvider>(
          builder: (context, bottomNavProvider, child) {
            switch (bottomNavProvider.currentIndex) {
              case 0:
                return const HomeScreen();
              case 1:
                return const ExploreScreen();
              // case 2:
              //   return const ScanScreen();
              case 2:
                log("message is token valid in screen **********: ${context.read<BottomNavProvider>().isTokenValid}");
                // if (context.read<BottomNavProvider>().isTokenValid != true) {
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     showLoginDialog(context);
                //   });
                //   return CartLoginPromptWidget(
                //     onLogin: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const MobileNumberScreen(),
                //         ),
                //       );
                //     },
                //   ); // Return an empty widget if not valid
                // }
                return FutureBuilder<bool>(
                  future: settingsProvider.checkAccessTokenValidity(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CartShimmer());
                    }

                    final isTokenValid = snapshot.data ?? false;
                    if (isTokenValid) {
                      return const CartScreen();
                    } else {
                      log("message is not token valid: $isTokenValid");
                      return CartLoginPromptWidget(
                        onLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MobileNumberScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              case 3:
                // if (context.read<BottomNavProvider>().isTokenValid != true) {
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     showLoginDialog(context);
                //   });
                //   return AccountPromptWidget(
                //     onLogin: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const MobileNumberScreen(),
                //         ),
                //       );
                //     },
                //   ); // Return an empty widget if not valid
                // }
                return FutureBuilder<bool>(
                  future: settingsProvider.checkAccessTokenValidity(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CartShimmer());
                    }

                    final isTokenValid = snapshot.data ?? false;
                    if (isTokenValid) {
                      return const AccountScreen();
                    } else {
                      log("message is not token valid: $isTokenValid");
                      return AccountPromptWidget(
                        onLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MobileNumberScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              default:
                return const HomeScreen();
            }
          },
        ),
        bottomNavigationBar: Consumer<BottomNavProvider>(
          builder: (context, bottomNavProvider, child) {
            return BottomNavigationBar(
              currentIndex: bottomNavProvider.currentIndex,
              onTap: (index) => bottomNavProvider.updateIndex(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: cBottomNav,
              unselectedItemColor: cBottomNav,
              selectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
              backgroundColor: cAppBackround,
              items: [
                BottomNavigationBarItem(
                  icon: bottomNavProvider.currentIndex == 0
                      ? Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/navbar_selected_line.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 4,
                              width: 31,
                            ),
                            sizedBoxHeight08,
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/icon_home_selected.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 24,
                              width: 24,
                            ),
                          ],
                        )
                      : SvgPicture.asset(
                          "assets/svg/bottom_nav_bar/icon_home_unselected.svg",
                          colorFilter:
                              ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                          height: 24,
                          width: 24,
                        ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: bottomNavProvider.currentIndex == 1
                      ? Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/navbar_selected_line.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 4,
                              width: 31,
                            ),
                            sizedBoxHeight08,
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/icon_category_selected.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 24,
                              width: 24,
                            ),
                          ],
                        )
                      : SvgPicture.asset(
                          "assets/svg/bottom_nav_bar/icon_category_unselected.svg",
                          colorFilter:
                              ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                          height: 24,
                          width: 24,
                        ),
                  label: 'Explore',
                ),
                // BottomNavigationBarItem(
                //   icon: bottomNavProvider.currentIndex == 2
                //       ? Column(
                //           children: [
                //             SvgPicture.asset(
                //               "assets/svg/bottom_nav_bar/navbar_selected_line.svg",
                //               colorFilter:
                //                   ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                //               height: 4,
                //               width: 31,
                //             ),
                //             sizedBoxHeight08,
                //             SvgPicture.asset(
                //               "assets/svg/bottom_nav_bar/icon_scan.svg",
                //               colorFilter:
                //                   ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                //               height: 24,
                //               width: 24,
                //             ),
                //           ],
                //         )
                //       : SvgPicture.asset(
                //           "assets/svg/bottom_nav_bar/icon_scan.svg",
                //           colorFilter:
                //               ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                //           height: 24,
                //           width: 24,
                //         ),
                //   label: 'Scan',
                // ),
                BottomNavigationBarItem(
                  icon: bottomNavProvider.currentIndex == 2
                      ? Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/navbar_selected_line.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 4,
                              width: 31,
                            ),
                            sizedBoxHeight08,
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/icon_cart_selected.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 24,
                              width: 24,
                            ),
                          ],
                        )
                      : SvgPicture.asset(
                          "assets/svg/bottom_nav_bar/icon_cart_unselected.svg",
                          colorFilter:
                              ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                          height: 24,
                          width: 24,
                        ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: bottomNavProvider.currentIndex == 3
                      ? Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/navbar_selected_line.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 4,
                              width: 31,
                            ),
                            sizedBoxHeight08,
                            SvgPicture.asset(
                              "assets/svg/bottom_nav_bar/icon_user_selected.svg",
                              colorFilter:
                                  ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                              height: 24,
                              width: 24,
                            ),
                          ],
                        )
                      : SvgPicture.asset(
                          "assets/svg/bottom_nav_bar/icon_user_unselected.svg",
                          colorFilter:
                              ColorFilter.mode(cBottomNav, BlendMode.srcIn),
                          height: 24,
                          width: 24,
                        ),
                  label: 'Account',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LoginPromptDialog();
    },
  );
}

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart'; // Add lottie package if you want animation


