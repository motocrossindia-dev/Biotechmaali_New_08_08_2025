import 'package:biotech_maali/src/module/account/coin/coin_history/coin_history_screen.dart';
import 'package:biotech_maali/src/module/account/coin/coin_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';

import '../../../../import.dart';
import 'package:biotech_maali/src/widgets/gd_coin_widget.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  CoinProvider? _coinProvider;
  ReferFriendProvider? _referFriendProvider;
  bool _isProcessingRedeem = false;

  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _limeAccent = Color(0xFFA6C13C);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _coinProvider != null && _referFriendProvider != null) {
        _coinProvider!.fetchTransactions();
        _referFriendProvider!.getReferralDetails();
        final currentCoins = _referFriendProvider!.totalcoins;
        AnalyticsService().logScreenView(screenName: 'Coin Screen');
        AnalyticsService().logCoinScreenOpened(currentCoins: currentCoins);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _coinProvider = Provider.of<CoinProvider>(context, listen: false);
    _referFriendProvider = Provider.of<ReferFriendProvider>(context, listen: false);
  }

  void _dismissLoadingDialog() {
    if (mounted) {
      try {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      } catch (e) {}
    }
  }

  void _safeNavigate(VoidCallback navigationAction) {
    if (mounted) {
      navigationAction();
    }
  }

  void _safeShowSnackBar(String message, {Color? backgroundColor}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: backgroundColor ?? Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CoinProvider, ReferFriendProvider>(
      builder: (context, coinProvider, referFriendProvider, _) {
        return Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _darkGreen, size: 20),
              onPressed: () => _safeNavigate(() => Navigator.pop(context)),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BT Coins',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
                Text(
                  'Your rewards & benefits',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: _primaryGreen),
                onPressed: () async {
                  if (mounted && _coinProvider != null && _referFriendProvider != null) {
                    await Future.wait([
                      _coinProvider!.refreshTransactions(),
                      _referFriendProvider!.getReferralDetails(),
                    ]);
                  }
                },
              ),
            ],
          ),
          body: coinProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: _primaryGreen))
              : coinProvider.error != null
                  ? _buildErrorView(context, coinProvider)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Balance Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_darkGreen, _primaryGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: _darkGreen.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Total Coin Balance',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const GdCoinWidget(size: 32),
                                    const SizedBox(width: 12),
                                    Text(
                                      referFriendProvider.totalcoins?.toString() ?? '0',
                                      style: GoogleFonts.poppins(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'WORTH ₹${((referFriendProvider.totalcoins ?? 0) / 100 * coinProvider.redemptionRate).toInt()}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _limeAccent,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Ways to Earn Section
                          _buildSectionCard(
                            icon: Icons.auto_awesome_outlined,
                            title: 'Earn More Coins',
                            child: Column(
                              children: [
                                _buildEarnOption(
                                  icon: Icons.shopping_bag_outlined,
                                  title: 'Complete a purchase',
                                  coins: '50',
                                ),
                                Divider(height: 24, color: Colors.grey.shade100),
                                _buildEarnOption(
                                  icon: Icons.rate_review_outlined,
                                  title: 'Write a product review',
                                  coins: '20',
                                ),
                                Divider(height: 24, color: Colors.grey.shade100),
                                _buildEarnOption(
                                  icon: Icons.person_add_outlined,
                                  title: 'Refer a friend',
                                  coins: '50',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Redeem Button
                          ElevatedButton(
                            onPressed: (referFriendProvider.totalcoins ?? 0) >= 100
                                ? () => _showRedeemDialog(context, coinProvider, referFriendProvider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: Colors.grey.shade200,
                            ),
                            child: Text(
                              (referFriendProvider.totalcoins ?? 0) < 100
                                  ? 'MIN 100 COINS TO REDEEM'
                                  : 'REDEEM COINS NOW',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // History Button
                          OutlinedButton(
                            onPressed: () => _safeNavigate(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CoinHistoryScreen(),
                                ),
                              );
                            }),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: BorderSide(color: Colors.grey.shade200),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.history, color: Colors.blue.shade700, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Transaction History',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: _darkGreen,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Info Cards Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Earning Rate',
                                  '${coinProvider.earnRate} Coins per ₹10',
                                  Icons.trending_up_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  'Value',
                                  '₹${coinProvider.redemptionRate} per 100 Coins',
                                  Icons.monetization_on_outlined,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: _primaryGreen),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildEarnOption({
    required IconData icon,
    required String title,
    required String coins,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryGreen, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 13, color: _darkGreen, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _limeAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const GdCoinWidget(size: 14),
              const SizedBox(width: 4),
              Text(
                '+$coins',
                style: GoogleFonts.poppins(
                  color: _primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: _primaryGreen),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CoinProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text('Failed to load coin data', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(provider.error ?? 'Unknown error', style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => provider.refreshTransactions(),
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, CoinProvider provider,
      ReferFriendProvider referFriendProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Redeem Coins',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: _darkGreen),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How many coins would you like to redeem?',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: provider.redeemController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                hintText: 'Enter amount (min 100)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: GdCoinWidget(size: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '₹${provider.redemptionRate} discount per 100 coins',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.redeemController.clear();
              Navigator.pop(context);
            },
            child: Text('CANCEL', style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isProcessingRedeem) return;

              int redeemAmount = int.tryParse(provider.redeemController.text) ?? 0;
              int totalCoins = referFriendProvider.totalcoins ?? 0;

              if (redeemAmount < 100) {
                _safeShowSnackBar('Minimum 100 coins required to redeem');
                return;
              }
              if (redeemAmount > totalCoins) {
                _safeShowSnackBar('Insufficient coin balance');
                return;
              }

              setState(() => _isProcessingRedeem = true);
              Navigator.pop(context);

              // Show custom loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: const CircularProgressIndicator(color: _primaryGreen),
                  ),
                ),
              );

              try {
                final success = await provider.redeemCoins(redeemAmount);
                _dismissLoadingDialog();

                if (success) {
                  if (mounted && _coinProvider != null && _referFriendProvider != null) {
                    await Future.wait([
                      _coinProvider!.fetchTransactions(),
                      _referFriendProvider!.getReferralDetails(),
                    ]);
                    double discountValue = (redeemAmount / 100) * provider.redemptionRate;
                    _safeShowSnackBar(
                      'Successfully redeemed! ₹${discountValue.toInt()} added to wallet.',
                      backgroundColor: Colors.green,
                    );
                  }
                } else {
                  _safeShowSnackBar(provider.error ?? 'Failed to redeem coins');
                }
              } catch (e) {
                _dismissLoadingDialog();
                _safeShowSnackBar('An error occurred');
              } finally {
                if (mounted) setState(() => _isProcessingRedeem = false);
              }
              provider.redeemController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(_isProcessingRedeem ? '...' : 'REDEEM', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
