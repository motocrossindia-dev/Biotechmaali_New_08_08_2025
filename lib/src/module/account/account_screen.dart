import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/coin/coin_screen.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_screen.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_screen.dart';
import 'package:biotech_maali/src/module/account/widgets/subtitle_widget.dart';
import 'package:biotech_maali/src/other_modules/carrers/carriers_screen.dart';
import 'package:biotech_maali/src/other_modules/contact_us/contact_us_screen.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_enquiry_screen.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_screen.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_screen.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/src/module/account/faq_screen.dart';
import 'package:biotech_maali/src/module/account/returns_policy_screen.dart';
import 'package:biotech_maali/src/module/account/shipping_policy_screen.dart';
import 'package:biotech_maali/src/widgets/gd_coin_widget.dart';

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
      AnalyticsService().logScreenView(screenName: 'Account Screen');
      AnalyticsService().logAccountScreenViewed();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3B5226),
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          'assets/png/Gidan Logo.png',
          height: 35,
          color: Colors.white, // Styling logo for the dark header if possible
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Premium Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              decoration: const BoxDecoration(
                color: Color(0xFF3B5226),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(text: 'My '),
                        TextSpan(
                          text: 'Account',
                          style: GoogleFonts.playfairDisplay(
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFA6C13C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFA6C13C), width: 2),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/icons/account_person.svg',
                          height: 50,
                          width: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME BACK',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFA6C13C),
                              letterSpacing: 1,
                            ),
                          ),
                          Consumer<AccountProvider>(
                            builder: (context, accountProvider, child) {
                              return Text(
                                accountProvider.userName ?? 'Plant Lover',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Wallet & Coins Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3012),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AnalyticsService().logAccountMenuTap(menuItem: 'Wallet');
                              final walletProvider = context.read<WalletProvider>();
                              walletProvider.fetchWalletDetails();
                              walletProvider.fetchTransactions();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('WALLET BALANCE', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.currency_rupee, size: 14, color: Color(0xFFA6C13C)),
                                    Text(
                                      '${context.read<WalletProvider>().balance}',
                                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, height: 30, color: Colors.white10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AnalyticsService().logAccountMenuTap(menuItem: 'Coin');
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CoinScreen()));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('GIDAN COINS', style: GoogleFonts.poppins(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    buildBTCoinIcon(size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${context.read<ReferFriendProvider>().totalcoins}',
                                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Orders Section
                  _buildMenuSection(
                    title: 'ORDERS & TRACKING',
                    children: [
                      _buildMenuRow(
                        icon: SvgPicture.asset('assets/svg/icons/my_orders.svg', height: 20, width: 20, color: const Color(0xFF1B3012)),
                        title: 'My Orders',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'My Orders');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Account Settings Section
                  _buildMenuSection(
                    title: 'ACCOUNT SETTINGS',
                    children: [
                      _buildMenuRow(
                        icon: SvgPicture.asset('assets/svg/icons/account_person.svg', height: 20, width: 20, color: const Color(0xFF1B3012)),
                        title: 'My Profile',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'My Profile');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: SvgPicture.asset('assets/svg/icons/location_icon.svg', height: 20, width: 20, color: const Color(0xFF1B3012)),
                        title: 'My Addresses',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'Change Addresses');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeAddressScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'My Referrals',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'My Referrals');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferFriendScreen()));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // More Section
                  _buildMenuSection(
                    title: 'SUPPORT & POLICIES',
                    children: [
                      _buildMenuRow(
                        icon: const Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'Franchise Enquiry',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'Franchise Enquiry');
                          AnalyticsService().logFranchiseScreenOpened();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FranchiseScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.work_outline, size: 20, color: Color(0xFF1B3012)),
                        title: 'Careers',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'Careers');
                          AnalyticsService().logCareersOpened();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CarrersScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.storefront_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'Our Stores',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'Our Stores');
                          AnalyticsService().logOurStoresOpened();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OurStoresScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.headset_mic_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'Contact Us',
                        onTap: () {
                          AnalyticsService().logAccountMenuTap(menuItem: 'Contact Us');
                          AnalyticsService().logContactUsOpened();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.help_outline, size: 20, color: Color(0xFF1B3012)),
                        title: 'FAQ’s',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.assignment_return_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'Returns Policy',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReturnsPolicyScreen()));
                        },
                      ),
                      _buildMenuRow(
                        icon: const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF1B3012)),
                        title: 'Shipping Policy',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingPolicyScreen()));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => bottmomSheetLogout(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'LOGOUT',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFA6C13C),
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuRow({required Widget icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SizedBox(width: 20, height: 20, child: Center(child: icon)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.black12),
          ],
        ),
      ),
    );
  }

  Widget buildBTCoinIcon({double size = 28}) {
    return GdCoinWidget(size: size);
  }
}

// Replace the existing onPressed handler with this:
void bottmomSheetLogout(BuildContext context) {
  // Capture the parent/screen context BEFORE opening the bottom sheet
  final parentContext = context;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext sheetContext) {
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
                    Navigator.pop(sheetContext); // Close bottom sheet
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
                    // Close the bottom sheet first using its own context
                    Navigator.pop(sheetContext);

                    // Use parentContext for everything after the sheet is closed
                    if (!parentContext.mounted) return;

                    // Show loading indicator
                    showDialog(
                      context: parentContext,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Clear all user session data using DataManager
                    bool dataCleared = await DataManager.clearUserSession();

                    // Log logout analytics
                    AnalyticsService().logUserLogout();

                    // Also clear any remaining cache
                    await DataManager.clearCacheDirectory();

                    // Hide loading indicator
                    if (!parentContext.mounted) return;
                    Navigator.pop(parentContext);

                    if (dataCleared) {
                      if (!parentContext.mounted) return;

                      // Reset bottom navigation
                      final navProvider =
                          parentContext.read<BottomNavProvider>();
                      navProvider.updateIndex(0);

                      // Navigate to login screen
                      Navigator.pushAndRemoveUntil(
                        parentContext,
                        MaterialPageRoute(
                          builder: (context) => const MobileNumberScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      if (!parentContext.mounted) return;
                      // Show error if data clearing failed
                      ScaffoldMessenger.of(parentContext).showSnackBar(
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
