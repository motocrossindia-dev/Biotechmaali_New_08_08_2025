import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/coin/coin_screen.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_screen.dart';
import 'package:biotech_maali/src/module/account/track_order/track_order_screen.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_screen.dart';
import 'package:biotech_maali/src/module/account/widgets/subtitle_widget.dart';
import 'package:biotech_maali/src/other_modules/carrers/carriers_screen.dart';
import 'package:biotech_maali/src/other_modules/contact_us/contact_us_screen.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_enquiry_screen.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_screen.dart';
import 'package:biotech_maali/src/other_modules/out_works/our_work_screen.dart';
import 'package:biotech_maali/src/other_modules/services/services_screen.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().fetchWalletDetails();
      context.read<AccountProvider>().getUserName();
      context.read<EditProfileProvider>().fetchProfileData();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AccountProvider>();
    return Scaffold(
      backgroundColor: cScaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/png/biotech_logo.png',
                height: 42,
                width: 80,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      sizedBoxHeight20,
                      Card(
                        // borderOnForeground: true,
                        shape: const Border(
                          bottom: BorderSide(style: BorderStyle.none),
                        ),
                        color: cWhiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/account_person.svg',
                                  height: 50,
                                  width: 50,
                                ),
                                sizedBoxWidth15,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CommonTextWidget(
                                      title: 'Hello',
                                      fontSize: 12,
                                    ),
                                    Consumer<AccountProvider>(
                                      builder:
                                          (context, accountProvider, child) {
                                        return CommonTextWidget(
                                          title: accountProvider.userName ??
                                              'No Name',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      sizedBoxHeight20,
                      Card(
                        shape: const Border(
                          bottom: BorderSide(style: BorderStyle.none),
                        ),
                        color: cWhiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderHistoryScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/icons/my_orders.svg',
                                          height: 25,
                                          width: 25,
                                        ),
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'MY ORDERS',
                                          color: cAccountText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: cAccountText,
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxHeight30,
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/icons/my_account_icon.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                  sizedBoxWidth20,
                                  CommonTextWidget(
                                    title: 'ACCOUNT SETTINGS',
                                    color: cAccountText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              sizedBoxHeight20,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'My Profile',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: cAccountText,
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxHeight10,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TrackOrderScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'Track Order',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: cAccountText,
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxHeight10,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddEditAddressScreen(
                                        isFromAccount: true,
                                        isAddAddress: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'Add Address',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: cAccountText,
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxHeight35,
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/icons/my_wallet.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                  sizedBoxWidth20,
                                  CommonTextWidget(
                                    title: 'PAYMENTS',
                                    color: cAccountText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              sizedBoxHeight20,
                              InkWell(
                                onTap: () {
                                  final walletProvider =
                                      context.read<WalletProvider>();
                                  walletProvider.fetchWalletDetails();
                                  walletProvider.fetchTransactions();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WalletScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'Wallet',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee,
                                          size: 16,
                                        ),
                                        CommonTextWidget(
                                          title:
                                              '${context.read<WalletProvider>().balance}',
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              sizedBoxHeight20,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CoinScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'Coin',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        buildBTCoinIcon(size: 16),
                                        sizedBoxWidth5,
                                        CommonTextWidget(
                                          title: (context
                                              .read<ReferFriendProvider>()
                                              .totalcoins
                                              .toString()),
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // sizedBoxHeight35,
                              // Row(
                              //   children: [
                              //     SvgPicture.asset(
                              //       'assets/svg/icons/my_account_icon.svg',
                              //       height: 25,
                              //       width: 25,
                              //     ),
                              //     sizedBoxWidth20,
                              //     CommonTextWidget(
                              //       title: 'MY STUFF',
                              //       color: cAccountText,
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w500,
                              //     ),
                              //   ],
                              // ),
                              sizedBoxHeight15,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ReferFriendScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        sizedBoxWidth25,
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'My Refferals',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: cAccountText,
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxHeight20,
                              InkWell(
                                onTap: () {
                                  context.read<AccountProvider>().toggleMore();
                                  Future.delayed(
                                      const Duration(milliseconds: 100), () {
                                    if (context
                                        .read<AccountProvider>()
                                        .isMore) {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      _scrollController.animateTo(
                                        0,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/icons/my_account_icon.svg',
                                          height: 25,
                                          width: 25,
                                        ),
                                        sizedBoxWidth20,
                                        CommonTextWidget(
                                          title: 'MORE',
                                          color: cAccountText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<AccountProvider>()
                                            .toggleMore();
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          if (context
                                              .read<AccountProvider>()
                                              .isMore) {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          } else {
                                            _scrollController.animateTo(
                                              0,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        context.watch<AccountProvider>().isMore
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_up,
                                        color: cAccountText,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             const GiftCardScreen(),
                              //       ),
                              //     );
                              //   },
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       const Row(
                              //         children: [
                              //           sizedBoxWidth25,
                              //           sizedBoxWidth20,
                              //           CommonTextWidget(
                              //             title: 'My Gift Card',
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ],
                              //       ),
                              //       Icon(
                              //         Icons.chevron_right,
                              //         size: 30,
                              //         color: cAccountText,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              context.watch<AccountProvider>().isMore
                                  ? Column(
                                      children: [
                                        sizedBoxHeight20,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FranchiseScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Franchise Enquiry',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const OurWorkScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Our Work',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ServicesScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Services',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CarrersScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Carriers',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const OurStoresScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Our Stores',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ContactScreen(),
                                              ),
                                            );
                                          },
                                          title: 'Contact Us',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {},
                                          title: 'Terms Of Services',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {},
                                          title: 'Privacy Policy',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {},
                                          title: 'Shipping Policy',
                                        ),
                                        sizedBoxHeight15,
                                        SubtitleWidget(
                                          onPressedCallBack: () {},
                                          title: 'Return Policy',
                                        ),
                                      ],
                                    )
                                  : sizedBoxHeight0,

                              // sizedBoxHeight15,
                              // SubtitleWidget(
                              //   onPressedCallBack: () {},
                              //   title: 'FAQ’s',
                              // ),
                              sizedBoxHeight20,
                            ],
                          ),
                        ),
                      ),
                      // sizedBoxHeight20,
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: MaterialButton(
                            color: cScaffoldBackground,
                            onPressed: () async {
                              // Show the bottom sheet when the button is pressed
                              bottmomSheetLogout(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Set the border radius here
                              side: const BorderSide(
                                color: Colors.red, // Set the border color here
                                width: 2, // Set the border width
                              ),
                            ),
                            child: CommonTextWidget(
                              fontWeight: FontWeight.w500,
                              title: 'LOGOUT',
                              color: cButtonRed,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      sizedBoxHeight05,
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 55,
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 8.0, right: 8),
          //       child: MaterialButton(
          //         color: cScaffoldBackground,
          //         onPressed: () async {
          //           // Show the bottom sheet when the button is pressed
          //           bottmomSheetLogout(context);
          //         },
          //         shape: RoundedRectangleBorder(
          //           borderRadius:
          //               BorderRadius.circular(5), // Set the border radius here
          //           side: const BorderSide(
          //             color: Colors.red, // Set the border color here
          //             width: 2, // Set the border width
          //           ),
          //         ),
          //         child: CommonTextWidget(
          //           fontWeight: FontWeight.w500,
          //           title: 'LOGOUT',
          //           color: cButtonRed,
          //           fontSize: 18,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildBTCoinIcon({double size = 28}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [
            Color(0xFFFFD700), // Gold color
            Color(0xFFFFA500), // Orange gold
            Color(0xFFFF8C00), // Dark orange
            Color(0xFFB8860B), // Dark goldenrod
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFFB8860B),
          width: size * 0.05,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.4),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
            spreadRadius: size * 0.05,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: size * 0.2,
            offset: Offset(size * 0.05, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner circle for coin depth effect
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(size * 0.1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFF8DC).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Shimmer effect overlay
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 6.28, // 2π for full rotation
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        startAngle: 0,
                        endAngle: 1.0,
                        colors: [
                          Colors.transparent,
                          const Color(0xFFFFFFFF).withOpacity(0.4),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.1, 0.2, 1.0],
                      ),
                    ),
                  ),
                );
              },
              onEnd: () {
                // Animation end callback (no-op here)
              },
            ),
          ),
          // BT Text
          Center(
            child: Text(
              'BT',
              style: TextStyle(
                color: const Color(0xFF8B4513), // Brown color for contrast
                fontSize: size * 0.35,
                fontWeight: FontWeight.w900,
                letterSpacing: size * 0.02,
                shadows: [
                  Shadow(
                    color: const Color(0xFFFFD700).withOpacity(0.8),
                    offset: Offset(size * 0.02, size * 0.02),
                    blurRadius: size * 0.05,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(size * 0.01, size * 0.01),
                    blurRadius: size * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Replace the existing onPressed handler with this:
void bottmomSheetLogout(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close bottom sheet

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Clear all user session data using DataManager
                    bool dataCleared = await DataManager.clearUserSession();

                    // Also clear any remaining cache
                    await DataManager.clearCacheDirectory();

                    // Hide loading indicator
                    Navigator.pop(context);

                    if (dataCleared) {
                      // Reset bottom navigation
                      final navProvider = context.read<BottomNavProvider>();
                      navProvider.updateIndex(0);

                      // Navigate to login screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileNumberScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      // Show error if data clearing failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Error during logout. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Yes, Logout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
