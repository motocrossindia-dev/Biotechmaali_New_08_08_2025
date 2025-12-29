import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/module/home/home_shimmer.dart';
import 'package:biotech_maali/src/module/home/widget/promotional_banner.dart';
import 'package:biotech_maali/src/module/home/widget/referral_popup.dart';
import 'package:biotech_maali/src/module/home/widget/our_store_widget.dart';
import 'package:biotech_maali/src/widgets/error_message_widget.dart';
import '../../../import.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final List<Widget> _lazyWidgets = [];
  final List<Widget> _allWidgets = [];

  @override
  void initState() {
    super.initState();

    _initializeWidgets();
    _setupScrollController();

    context.read<ReferFriendProvider>().getReferralDetails();

    // Move wallet fetch to post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Load location data first for immediate display
        context.read<HomeProvider>().getLocationPincode();
        context.read<HomeProvider>().getLocationName();

        // Fetch content blocks for dynamic content
        context.read<HomeProvider>().fetchContentBlocks();

        context.read<WalletProvider>().fetchWalletDetails();
        context.read<AccountProvider>().getUserName();
        context.read<EditProfileProvider>().fetchProfileData();
      }
    });
  }

  void _initializeWidgets() {
    // Initialize all widgets that will be lazy loaded
    _allWidgets.addAll([
      const HomeProductsTileWidget(title: 'Featured'),
      const CompoOfferWidget(),
      const HomeProductsTileWidget(title: 'Latest'),
      const HomeProductsTileWidget(title: 'Bestseller'),
      const ReferFriendWidget(),
      const HomeProductsTileWidget(title: 'Seasonal Collection'),
      const YoutubeVideoplayerWidget(),
      const OurStoreWidget(), // Our Store widget added after YouTube
      // const ExploreOurWorkWidget(),
    ]);

    // Initially load first few widgets
    _loadMoreWidgets();
  }

  void _setupScrollController() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500) {
          _loadMoreWidgets();
        }
      },
    );
  }

  void _loadMoreWidgets() {
    if (!_isLoadingMore && _lazyWidgets.length < _allWidgets.length) {
      setState(
        () {
          _isLoadingMore = true;
          final int nextIndex = _lazyWidgets.length;
          final int itemsToLoad = math.min(2, _allWidgets.length - nextIndex);

          _lazyWidgets
              .addAll(_allWidgets.getRange(nextIndex, nextIndex + itemsToLoad));
          _isLoadingMore = false;
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cScaffoldBackground,
      appBar: const CustomAppBarWithSearch(),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          // Show shimmer while loading
          if (provider.isLoading || provider.isBannersLoading) {
            return const HomeShimmer();
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorMessageWidget(
                    errorTitle: "Something went wrong",
                    errorSubTitle: provider.error!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      provider.refreshAll();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.refreshAll();
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics:
                  const AlwaysScrollableScrollPhysics(), // Ensure scrolling always works
              slivers: [
                // Always visible widgets
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const CategoryWidget(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.41,
                        child: const CarouselWidget(),
                      ),
                      const PromotionalBanner(),
                    ],
                  ),
                ),

                // Lazy loaded widgets
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _lazyWidgets.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _lazyWidgets[index],
                        );
                      }

                      if (_isLoadingMore) {
                        // Show shimmer for lazy loading items
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const ProductCardShimmer(),
                          ),
                        );
                      }

                      return null;
                    },
                    childCount: _lazyWidgets.length + (_isLoadingMore ? 1 : 0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showReferralPopup(BuildContext context, String referralCode) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ReferralPopup(
        referralCode: referralCode,
        rewardAmount: 50,
        onClose: () => Navigator.of(context).pop(),
      );
    },
  );
}
