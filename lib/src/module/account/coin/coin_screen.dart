import 'package:biotech_maali/src/module/account/coin/coin_history/coin_history_screen.dart';
import 'package:biotech_maali/src/module/account/coin/coin_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';

import '../../../../import.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  CoinProvider? _coinProvider;
  ReferFriendProvider? _referFriendProvider;
  bool _isProcessingRedeem = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget is fully built before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _coinProvider != null && _referFriendProvider != null) {
        _coinProvider!.fetchTransactions();
        _referFriendProvider!.getReferralDetails();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save references to providers to avoid unsafe context access
    _coinProvider = Provider.of<CoinProvider>(context, listen: false);
    _referFriendProvider =
        Provider.of<ReferFriendProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }

  // Safe method to dismiss loading dialogs
  void _dismissLoadingDialog() {
    if (mounted) {
      try {
        // Try to pop the loading dialog
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Ignore navigation errors - dialog might already be dismissed
      }
    }
  }

  // Utility method to safely navigate
  void _safeNavigate(VoidCallback navigationAction) {
    if (mounted) {
      navigationAction();
    }
  }

  // Utility method to safely show snackbar
  void _safeShowSnackBar(String message, {Color? backgroundColor}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor ?? Colors.red,
          duration: const Duration(
              seconds: 4), // Longer duration for success messages
          behavior: SnackBarBehavior.floating,
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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _safeNavigate(() => Navigator.pop(context)),
            ),
            title: const CommonTextWidget(
              title: 'Coins',
              fontSize: 16,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  if (mounted &&
                      _coinProvider != null &&
                      _referFriendProvider != null) {
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
              ? const Center(child: CircularProgressIndicator())
              : coinProvider.error != null
                  ? _buildErrorView(context, coinProvider)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Balance Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Total Coin Balance',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildBTCoinIcon(),
                                      const SizedBox(width: 8),
                                      Text(
                                        referFriendProvider.totalcoins
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: cBottomNav,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text('Earn More Coins',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 16),

                          // Ways to Earn Coins
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Complete Actions to Earn Coins:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildEarnOption(
                                    context,
                                    icon: Icons.shopping_cart,
                                    title: 'Complete a purchase',
                                    coins: '50',
                                  ),
                                  const Divider(),
                                  _buildEarnOption(
                                    context,
                                    icon: Icons.rate_review,
                                    title: 'Write a product review',
                                    coins: '20',
                                  ),
                                  const Divider(),
                                  _buildEarnOption(
                                    context,
                                    icon: Icons.share,
                                    title: 'Refer a friend',
                                    coins: '50',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Redeem Button
                          ElevatedButton(
                            onPressed: (referFriendProvider.totalcoins ?? 0) > 0
                                ? () => _showRedeemDialog(
                                    context, coinProvider, referFriendProvider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: cButtonGreen,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'REDEEM COINS',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Coin History Button
                          OutlinedButton(
                            onPressed: () => _safeNavigate(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CoinHistoryScreen(),
                                ),
                              );
                            }),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.history,
                                        color: Colors.blue[900]),
                                    const SizedBox(width: 8),
                                    Text(
                                      'COIN TRANSACTION HISTORY',
                                      style: TextStyle(color: Colors.blue[900]),
                                    ),
                                  ],
                                ),
                                Icon(Icons.chevron_right,
                                    color: Colors.blue[900]),
                              ],
                            ),
                          ),
                          sizedBoxHeight20,

                          // Coin Information Cards
                          _buildCoinInfoCard(
                            title: "Shop & Earn Coins",
                            subTitle: "Earn 1 Coin for every ₹10 spent",
                            totalAmount: "${coinProvider.earnRate} Coins/₹10",
                          ),
                          _buildCoinInfoCard(
                            title: "Coin Redemption Value",
                            subTitle: "100 Coins = ₹10 discount",
                            totalAmount:
                                "₹${coinProvider.redemptionRate}/100 Coins",
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, CoinProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load coin data',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.error ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (mounted && _referFriendProvider != null) {
                await Future.wait([
                  provider.refreshTransactions(),
                  _referFriendProvider!.getReferralDetails(),
                ]);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBTCoinIcon({double size = 28}) {
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
                // Restart animation
                if (mounted) {
                  setState(() {});
                }
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

  Widget _buildEarnOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String coins,
  }) {
    return Row(
      children: [
        Icon(icon, color: cBottomNav),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Row(
          children: [
            _buildBTCoinIcon(size: 16),
            const SizedBox(width: 4),
            Text(
              coins,
              style: TextStyle(
                color: cBottomNav,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoinInfoCard({
    required String title,
    required String subTitle,
    required String totalAmount,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        trailing: Text(
          totalAmount,
          style: TextStyle(
            fontSize: 15,
            color: cBottomNav,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, CoinProvider provider,
      ReferFriendProvider referFriendProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Coins'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How many coins would you like to redeem?'),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.redeemController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter coin amount',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${provider.redemptionRate} ₹ discount per 100 coins',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.redeemController.clear();
              _safeNavigate(() => Navigator.pop(context));
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              if (_isProcessingRedeem) return; // Prevent multiple submissions

              int redeemAmount =
                  int.tryParse(provider.redeemController.text) ?? 0;
              int totalCoins = referFriendProvider.totalcoins ?? 0;

              if (redeemAmount <= 0 || redeemAmount > totalCoins) {
                _safeShowSnackBar('Please enter a valid amount');
                return;
              }

              setState(() {
                _isProcessingRedeem = true;
              });

              // Close the dialog first
              _safeNavigate(() => Navigator.pop(context));

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Processing...'),
                    ],
                  ),
                ),
              );

              try {
                final success = await provider.redeemCoins(redeemAmount);

                // Always hide loading indicator first
                _dismissLoadingDialog();

                if (success) {
                  // Refresh both providers using saved references
                  if (mounted &&
                      _coinProvider != null &&
                      _referFriendProvider != null) {
                    await Future.wait([
                      _coinProvider!.fetchTransactions(),
                      _referFriendProvider!.getReferralDetails(),
                    ]);

                    // Calculate discount value
                    double discountValue =
                        (redeemAmount / 100) * provider.redemptionRate;

                    // Show success snackbar
                    _safeShowSnackBar(
                      '$redeemAmount coins redeemed successfully! ₹${discountValue.toStringAsFixed(2)} added to your wallet.',
                      backgroundColor: Colors.green,
                    );
                  }
                } else {
                  _safeShowSnackBar(provider.error ?? 'Failed to redeem coins');
                }
              } catch (e) {
                // Hide loading indicator if still showing
                _dismissLoadingDialog();
                _safeShowSnackBar('An error occurred: ${e.toString()}');
              } finally {
                // Reset processing state
                if (mounted) {
                  setState(() {
                    _isProcessingRedeem = false;
                  });
                }
              }

              provider.redeemController.clear();
            },
            child: Text(_isProcessingRedeem ? 'PROCESSING...' : 'REDEEM'),
          ),
        ],
      ),
    );
  }
}
