import 'package:flutter/material.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';

/// Mixin to automatically track screen views when a screen becomes visible
///
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
///
/// class _MyScreenState extends State<MyScreen> with AnalyticsScreenMixin {
///   @override
///   String get screenName => 'MyScreen';
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(...);
///   }
/// }
/// ```
mixin AnalyticsScreenMixin<T extends StatefulWidget> on State<T> {
  /// Override this to provide the screen name for analytics
  String get screenName;

  /// Optional: Override to provide screen class name
  String? get screenClass => null;

  @override
  void initState() {
    super.initState();
    _trackScreen();
  }

  void _trackScreen() {
    AnalyticsService().logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }
}

/// Extension methods for easy analytics tracking in any widget
extension AnalyticsExtension on BuildContext {
  /// Track a screen view
  void trackScreen(String screenName, {String? screenClass}) {
    AnalyticsService().logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Track a button click
  void trackButtonClick(String buttonName, {String? screenName}) {
    AnalyticsService().logButtonClick(
      buttonName: buttonName,
      screenName: screenName,
    );
  }
}

/// Screen names constants for consistent tracking
class ScreenNames {
  ScreenNames._();

  // Splash & Auth
  static const String splash = 'SplashScreen';
  static const String login = 'LoginScreen';
  static const String mobileNumber = 'MobileNumberScreen';
  static const String otp = 'OtpScreen';

  // Main Navigation
  static const String home = 'HomeScreen';
  static const String explore = 'ExploreScreen';
  static const String cart = 'CartScreen';
  static const String wishlist = 'WishlistScreen';
  static const String account = 'AccountScreen';

  // Products
  static const String productDetails = 'ProductDetailsScreen';
  static const String productList = 'ProductListScreen';
  static const String productSearch = 'ProductSearchScreen';
  static const String productRating = 'ProductRatingScreen';
  static const String ratingAndReview = 'RatingAndReviewScreen';
  static const String bannerProductList = 'BannerProductListScreen';
  static const String productCompoList = 'ProductCompoListScreen';

  // Checkout & Orders
  static const String orderSummary = 'OrderSummaryScreen';
  static const String choosePayment = 'ChoosePaymentScreen';
  static const String orderHistory = 'OrderHistoryScreen';
  static const String orderHistoryDetail = 'OrderHistoryDetailScreen';
  static const String orderSuccess = 'OrderSuccessScreen';
  static const String orderFailed = 'OrderFailedScreen';

  // Address
  static const String changeAddress = 'ChangeAddressScreen';
  static const String addEditAddress = 'AddEditAddressScreen';
  static const String localStoreList = 'LocalStoreListScreen';

  // Account
  static const String editProfile = 'EditProfileScreen';
  static const String wallet = 'WalletScreen';
  static const String coins = 'CoinsScreen';
  static const String giftCard = 'GiftCardScreen';
  static const String referFriend = 'ReferFriendScreen';
  static const String deleteAccount = 'DeleteAccountScreen';

  // Coupon
  static const String couponList = 'CouponListScreen';

  // Location
  static const String locationPincode = 'LocationPincodeScreen';

  // Other Modules
  static const String aboutUs = 'AboutUsScreen';
  static const String contactUs = 'ContactUsScreen';
  static const String careers = 'CareersScreen';
  static const String ourWork = 'OurWorkScreen';
  static const String ourStore = 'OurStoreScreen';
  static const String services = 'ServicesScreen';
  static const String franchiseEnquiry = 'FranchiseEnquiryScreen';

  // Services
  static const String terraceGarden = 'TerraceGardenScreen';
  static const String verticalGarden = 'VerticalGardenScreen';
  static const String gardenMaintenance = 'GardenMaintenanceScreen';
  static const String landscaping = 'LandscapingServiceScreen';
  static const String dripIrrigation = 'DripIrrigationScreen';

  // Misc
  static const String scan = 'ScanScreen';
  static const String comingSoon = 'ComingSoonScreen';
  static const String filters = 'FiltersScreen';
}

/// Event names constants for consistent tracking
class AnalyticsEvents {
  AnalyticsEvents._();

  // User Actions
  static const String buttonClick = 'button_click';
  static const String bannerClick = 'banner_click';
  static const String categoryClick = 'category_click';
  static const String productClick = 'product_click';

  // Cart
  static const String addToCart = 'add_to_cart';
  static const String removeFromCart = 'remove_from_cart';
  static const String updateCartQuantity = 'update_cart_quantity';
  static const String viewCart = 'view_cart';
  static const String clearCart = 'clear_cart';

  // Wishlist
  static const String addToWishlist = 'add_to_wishlist';
  static const String removeFromWishlist = 'remove_from_wishlist';

  // Checkout
  static const String beginCheckout = 'begin_checkout';
  static const String addPaymentInfo = 'add_payment_info';
  static const String purchase = 'purchase';
  static const String purchaseFailed = 'purchase_failed';

  // Coupon
  static const String applyCoupon = 'apply_coupon';
  static const String removeCoupon = 'remove_coupon';

  // Search
  static const String search = 'search';
  static const String searchWithFilters = 'search_with_filters';

  // User
  static const String login = 'login';
  static const String signUp = 'sign_up';
  static const String logout = 'logout';
  static const String updateProfile = 'update_profile';

  // Wallet & Coins
  static const String walletTransaction = 'wallet_transaction';
  static const String coinsEarned = 'coins_earned';
  static const String coinsRedeemed = 'coins_redeemed';

  // Referral
  static const String referralShared = 'referral_shared';
  static const String referralApplied = 'referral_applied';

  // Rating
  static const String submitRating = 'submit_rating';
  static const String submitReview = 'submit_review';

  // Share
  static const String shareProduct = 'share_product';
  static const String shareApp = 'share_app';

  // Location
  static const String selectLocation = 'select_location';
  static const String selectStore = 'select_store';

  // Video
  static const String videoPlay = 'video_play';
  static const String videoPause = 'video_pause';
  static const String videoComplete = 'video_complete';
}
