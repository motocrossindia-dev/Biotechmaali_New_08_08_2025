import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/module/home/home_shimmer.dart';
import 'package:biotech_maali/src/module/home/widget/promotional_banner.dart';
import 'package:biotech_maali/src/module/home/widget/referral_popup.dart';
import 'package:biotech_maali/src/module/home/widget/our_store_widget.dart';
import 'package:biotech_maali/src/widgets/error_message_widget.dart';
import '../../../import.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ReferFriendProvider>().getReferralDetails();

    // Move wallet fetch to post-frame callback
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          // Load location data first for immediate display
          context.read<HomeProvider>().getLocationPincode();
          context.read<HomeProvider>().getLocationName();

          // Fetch content blocks for dynamic content
          context.read<HomeProvider>().fetchContentBlocks();

          // Fetch promotional banner (ID: 33)
          context.read<HomeProvider>().fetchPromotionalBanner(33);

          context.read<WalletProvider>().fetchWalletDetails();
          context.read<AccountProvider>().getUserName();
          context.read<EditProfileProvider>().fetchProfileData();
        }
      },
    );
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
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const CategoryWidget(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.41,
                    child: const CarouselWidget(),
                  ),
                  const PromotionalBanner(),
                  const SizedBox(height: 10),
                  const HomeProductsTileWidget(title: 'Featured'),
                  const SizedBox(height: 10),
                  const CompoOfferWidget(),
                  const SizedBox(height: 10),
                  const HomeProductsTileWidget(title: 'Latest'),
                  const SizedBox(height: 10),
                  const HomeProductsTileWidget(title: 'Bestseller'),
                  const SizedBox(height: 10),
                  const ReferFriendWidget(),
                  const SizedBox(height: 10),
                  const HomeProductsTileWidget(title: 'Seasonal Collection'),
                  const SizedBox(height: 10),
                  const YoutubeVideoplayerWidget(),
                  const SizedBox(height: 10),
                  const OurStoreWidget(),
                  const SizedBox(height: 20),
                ],
              ),
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
