import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics Service for tracking user behavior across the app
///
/// This service provides methods to track:
/// - Screen views (which screens users visit)
/// - User actions (button clicks, form submissions, etc.)
/// - E-commerce events (add to cart, purchase, etc.)
/// - User properties (user segments, preferences, etc.)
/// - Custom events for specific business logic
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Get the analytics observer for navigation tracking
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ==================== SCREEN TRACKING ====================

  /// Log when user views a screen
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      log('📊 Analytics: Screen View - $screenName');
    } catch (e) {
      log('❌ Analytics Error (Screen View): $e');
    }
  }

  // ==================== USER PROPERTIES ====================

  /// Set user ID for tracking across sessions
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      log('📊 Analytics: User ID set - $userId');
    } catch (e) {
      log('❌ Analytics Error (Set User ID): $e');
    }
  }

  /// Set custom user property
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      log('📊 Analytics: User Property - $name: $value');
    } catch (e) {
      log('❌ Analytics Error (User Property): $e');
    }
  }

  /// Set user type (guest, registered, premium, etc.)
  Future<void> setUserType(String userType) async {
    await setUserProperty(name: 'user_type', value: userType);
  }

  // ==================== AUTHENTICATION EVENTS ====================

  /// Log user login event
  Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method ?? 'phone');
      log('📊 Analytics: Login - Method: $method');
    } catch (e) {
      log('❌ Analytics Error (Login): $e');
    }
  }

  /// Log user sign up event
  Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method ?? 'phone');
      log('📊 Analytics: Sign Up - Method: $method');
    } catch (e) {
      log('❌ Analytics Error (Sign Up): $e');
    }
  }

  /// Log user logout event
  Future<void> logLogout() async {
    await logEvent(name: 'logout');
  }

  // ==================== E-COMMERCE EVENTS ====================

  /// Log when user views a product
  Future<void> logViewProduct({
    required String productId,
    required String productName,
    String? category,
    double? price,
    String? currency,
  }) async {
    try {
      await _analytics.logViewItem(
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: productName,
            itemCategory: category,
            price: price,
            currency: currency ?? 'INR',
          ),
        ],
        currency: currency ?? 'INR',
        value: price,
      );
      log('📊 Analytics: View Product - $productName');
    } catch (e) {
      log('❌ Analytics Error (View Product): $e');
    }
  }

  /// Log when user adds item to cart
  Future<void> logAddToCart({
    required String productId,
    required String productName,
    String? category,
    double? price,
    int quantity = 1,
    String? currency,
  }) async {
    try {
      await _analytics.logAddToCart(
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: productName,
            itemCategory: category,
            price: price,
            quantity: quantity,
            currency: currency ?? 'INR',
          ),
        ],
        currency: currency ?? 'INR',
        value: (price ?? 0) * quantity,
      );
      log('📊 Analytics: Add to Cart - $productName x$quantity');
    } catch (e) {
      log('❌ Analytics Error (Add to Cart): $e');
    }
  }

  /// Log when user removes item from cart
  Future<void> logRemoveFromCart({
    required String productId,
    required String productName,
    String? category,
    double? price,
    int quantity = 1,
    String? currency,
  }) async {
    try {
      await _analytics.logRemoveFromCart(
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: productName,
            itemCategory: category,
            price: price,
            quantity: quantity,
            currency: currency ?? 'INR',
          ),
        ],
        currency: currency ?? 'INR',
        value: (price ?? 0) * quantity,
      );
      log('📊 Analytics: Remove from Cart - $productName');
    } catch (e) {
      log('❌ Analytics Error (Remove from Cart): $e');
    }
  }

  /// Log when user views their cart
  Future<void> logViewCart({
    required List<Map<String, dynamic>> items,
    required double totalValue,
    String? currency,
  }) async {
    try {
      await _analytics.logViewCart(
        items: items
            .map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                  itemCategory: item['category']?.toString(),
                  price: (item['price'] as num?)?.toDouble(),
                  quantity: item['quantity'] as int? ?? 1,
                ))
            .toList(),
        currency: currency ?? 'INR',
        value: totalValue,
      );
      log('📊 Analytics: View Cart - Total: $totalValue');
    } catch (e) {
      log('❌ Analytics Error (View Cart): $e');
    }
  }

  /// Log when user begins checkout
  Future<void> logBeginCheckout({
    required List<Map<String, dynamic>> items,
    required double totalValue,
    String? couponCode,
    String? currency,
  }) async {
    try {
      await _analytics.logBeginCheckout(
        items: items
            .map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                  itemCategory: item['category']?.toString(),
                  price: (item['price'] as num?)?.toDouble(),
                  quantity: item['quantity'] as int? ?? 1,
                ))
            .toList(),
        currency: currency ?? 'INR',
        value: totalValue,
        coupon: couponCode,
      );
      log('📊 Analytics: Begin Checkout - Total: $totalValue');
    } catch (e) {
      log('❌ Analytics Error (Begin Checkout): $e');
    }
  }

  /// Log when user completes a purchase
  Future<void> logPurchase({
    required String transactionId,
    required double totalValue,
    required List<Map<String, dynamic>> items,
    String? couponCode,
    double? shipping,
    double? tax,
    String? currency,
    String? paymentMethod,
  }) async {
    try {
      await _analytics.logPurchase(
        transactionId: transactionId,
        items: items
            .map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                  itemCategory: item['category']?.toString(),
                  price: (item['price'] as num?)?.toDouble(),
                  quantity: item['quantity'] as int? ?? 1,
                ))
            .toList(),
        currency: currency ?? 'INR',
        value: totalValue,
        coupon: couponCode,
        shipping: shipping,
        tax: tax,
      );

      // Also log payment method as custom event
      if (paymentMethod != null) {
        await logEvent(
          name: 'payment_method_used',
          parameters: {'method': paymentMethod},
        );
      }

      log('📊 Analytics: Purchase - Transaction: $transactionId, Total: $totalValue');
    } catch (e) {
      log('❌ Analytics Error (Purchase): $e');
    }
  }

  /// Log when user adds item to wishlist
  Future<void> logAddToWishlist({
    required String productId,
    required String productName,
    String? category,
    double? price,
    String? currency,
  }) async {
    try {
      await _analytics.logAddToWishlist(
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: productName,
            itemCategory: category,
            price: price,
            currency: currency ?? 'INR',
          ),
        ],
        currency: currency ?? 'INR',
        value: price,
      );
      log('📊 Analytics: Add to Wishlist - $productName');
    } catch (e) {
      log('❌ Analytics Error (Add to Wishlist): $e');
    }
  }

  /// Log when user removes item from wishlist
  Future<void> logRemoveFromWishlist({
    required String productId,
    required String productName,
  }) async {
    await logEvent(
      name: 'remove_from_wishlist',
      parameters: {
        'product_id': productId,
        'product_name': productName,
      },
    );
  }

  // ==================== SEARCH EVENTS ====================

  /// Log search event
  Future<void> logSearch({required String searchTerm}) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
      log('📊 Analytics: Search - "$searchTerm"');
    } catch (e) {
      log('❌ Analytics Error (Search): $e');
    }
  }

  /// Log search with filters
  Future<void> logSearchWithFilters({
    required String searchTerm,
    Map<String, dynamic>? filters,
  }) async {
    await logEvent(
      name: 'search_with_filters',
      parameters: {
        'search_term': searchTerm,
        if (filters != null) ...filters,
      },
    );
  }

  // ==================== CATEGORY & NAVIGATION EVENTS ====================

  /// Log when user selects a category
  Future<void> logSelectCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    await logEvent(
      name: 'select_category',
      parameters: {
        'category_id': categoryId,
        'category_name': categoryName,
      },
    );
  }

  /// Log when user views a product list
  Future<void> logViewProductList({
    required String listName,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      await _analytics.logViewItemList(
        itemListName: listName,
        items: items
            ?.map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                  itemCategory: item['category']?.toString(),
                  price: (item['price'] as num?)?.toDouble(),
                ))
            .toList(),
      );
      log('📊 Analytics: View Product List - $listName');
    } catch (e) {
      log('❌ Analytics Error (View Product List): $e');
    }
  }

  // ==================== ENGAGEMENT EVENTS ====================

  /// Log when user shares content
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    try {
      await _analytics.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method ?? 'unknown',
      );
      log('📊 Analytics: Share - $contentType: $itemId');
    } catch (e) {
      log('❌ Analytics Error (Share): $e');
    }
  }

  /// Log when user submits a rating/review
  Future<void> logRating({
    required String productId,
    required String productName,
    required double rating,
    bool hasReview = false,
  }) async {
    await logEvent(
      name: 'product_rating',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'rating': rating,
        'has_review': hasReview,
      },
    );
  }

  /// Log coupon usage
  Future<void> logCouponApplied({
    required String couponCode,
    double? discountValue,
  }) async {
    await logEvent(
      name: 'coupon_applied',
      parameters: {
        'coupon_code': couponCode,
        if (discountValue != null) 'discount_value': discountValue,
      },
    );
  }

  /// Log coupon removed
  Future<void> logCouponRemoved({required String couponCode}) async {
    await logEvent(
      name: 'coupon_removed',
      parameters: {'coupon_code': couponCode},
    );
  }

  // ==================== LOCATION EVENTS ====================

  /// Log location selection
  Future<void> logLocationSelected({
    String? pincode,
    String? city,
    String? state,
  }) async {
    await logEvent(
      name: 'location_selected',
      parameters: {
        if (pincode != null) 'pincode': pincode,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      },
    );
  }

  /// Log store selected
  Future<void> logStoreSelected({
    required String storeId,
    required String storeName,
    String? storeType,
  }) async {
    await logEvent(
      name: 'store_selected',
      parameters: {
        'store_id': storeId,
        'store_name': storeName,
        if (storeType != null) 'store_type': storeType,
      },
    );
  }

  // ==================== WALLET & COINS EVENTS ====================

  /// Log wallet transaction
  Future<void> logWalletTransaction({
    required String type, // 'credit' or 'debit'
    required double amount,
    String? source,
  }) async {
    await logEvent(
      name: 'wallet_transaction',
      parameters: {
        'type': type,
        'amount': amount,
        if (source != null) 'source': source,
      },
    );
  }

  /// Log coins earned
  Future<void> logCoinsEarned({
    required int coins,
    required String source,
  }) async {
    await logEvent(
      name: 'coins_earned',
      parameters: {
        'coins': coins,
        'source': source,
      },
    );
  }

  /// Log coins redeemed
  Future<void> logCoinsRedeemed({
    required int coins,
    required double value,
  }) async {
    await logEvent(
      name: 'coins_redeemed',
      parameters: {
        'coins': coins,
        'value': value,
      },
    );
  }

  // ==================== REFERRAL EVENTS ====================

  /// Log referral share
  Future<void> logReferralShared({String? method}) async {
    await logEvent(
      name: 'referral_shared',
      parameters: {
        if (method != null) 'method': method,
      },
    );
  }

  /// Log referral code applied
  Future<void> logReferralApplied({required String referralCode}) async {
    await logEvent(
      name: 'referral_applied',
      parameters: {'referral_code': referralCode},
    );
  }

  // ==================== ERROR & EXCEPTION EVENTS ====================

  /// Log app errors for tracking
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screenName,
  }) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage.length > 100
            ? errorMessage.substring(0, 100)
            : errorMessage,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  /// Log API errors
  Future<void> logApiError({
    required String endpoint,
    required int statusCode,
    String? errorMessage,
  }) async {
    await logEvent(
      name: 'api_error',
      parameters: {
        'endpoint': endpoint,
        'status_code': statusCode,
        if (errorMessage != null)
          'error_message': errorMessage.length > 100
              ? errorMessage.substring(0, 100)
              : errorMessage,
      },
    );
  }

  // ==================== CUSTOM EVENTS ====================

  /// Log any custom event with parameters
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      log('📊 Analytics: Custom Event - $name ${parameters ?? ''}');
    } catch (e) {
      log('❌ Analytics Error (Custom Event): $e');
    }
  }

  /// Log button click
  Future<void> logButtonClick({
    required String buttonName,
    String? screenName,
  }) async {
    await logEvent(
      name: 'button_click',
      parameters: {
        'button_name': buttonName,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  /// Log banner click
  Future<void> logBannerClick({
    required String bannerId,
    String? bannerName,
    int? position,
  }) async {
    await logEvent(
      name: 'banner_click',
      parameters: {
        'banner_id': bannerId,
        if (bannerName != null) 'banner_name': bannerName,
        if (position != null) 'position': position,
      },
    );
  }

  /// Log video play
  Future<void> logVideoPlay({
    required String videoId,
    String? videoTitle,
  }) async {
    await logEvent(
      name: 'video_play',
      parameters: {
        'video_id': videoId,
        if (videoTitle != null) 'video_title': videoTitle,
      },
    );
  }

  // ==================== APP LIFECYCLE EVENTS ====================

  /// Log app open
  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      log('📊 Analytics: App Open');
    } catch (e) {
      log('❌ Analytics Error (App Open): $e');
    }
  }

  /// Log tutorial begin
  Future<void> logTutorialBegin() async {
    try {
      await _analytics.logTutorialBegin();
      log('📊 Analytics: Tutorial Begin');
    } catch (e) {
      log('❌ Analytics Error (Tutorial Begin): $e');
    }
  }

  /// Log tutorial complete
  Future<void> logTutorialComplete() async {
    try {
      await _analytics.logTutorialComplete();
      log('📊 Analytics: Tutorial Complete');
    } catch (e) {
      log('❌ Analytics Error (Tutorial Complete): $e');
    }
  }

  // ==================== SETTINGS ====================

  /// Enable/disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      log('📊 Analytics: Collection ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      log('❌ Analytics Error (Set Collection Enabled): $e');
    }
  }

  /// Reset analytics data
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
      log('📊 Analytics: Data Reset');
    } catch (e) {
      log('❌ Analytics Error (Reset Data): $e');
    }
  }

  /// Set session timeout duration (in milliseconds)
  Future<void> setSessionTimeoutDuration(Duration duration) async {
    try {
      await _analytics.setSessionTimeoutDuration(duration);
      log('📊 Analytics: Session Timeout set to ${duration.inMinutes} minutes');
    } catch (e) {
      log('❌ Analytics Error (Set Session Timeout): $e');
    }
  }
}
