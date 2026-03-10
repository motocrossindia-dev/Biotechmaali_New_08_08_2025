import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics Service for tracking user behavior across the app
///
/// This service provides comprehensive tracking for:
/// - Screen views (which screens users visit)
/// - User actions (button clicks, form submissions, etc.)
/// - E-commerce events (add to cart, purchase, etc.)
/// - Search analytics (search terms, filters, no results)
/// - User properties (user segments, preferences, etc.)
/// - Ads & Promotions tracking
/// - Wallet & Coins events
/// - Referral tracking
/// - Error & Performance monitoring
/// - Store/Franchise analytics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Initialize analytics - call this once at app startup
  Future<void> initialize() async {
    try {
      // Enable analytics collection
      await _analytics.setAnalyticsCollectionEnabled(true);
      log('📊 Analytics: Collection ENABLED');
    } catch (e) {
      log('❌ Analytics Error (Initialize): $e');
    }
  }

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

  /// Log profile update event
  Future<void> logProfileUpdate({
    required List<String> fieldsUpdated,
  }) async {
    await logEvent(
      name: 'profile_update',
      parameters: {
        'fields_updated': fieldsUpdated.join(','),
        'fields_count': fieldsUpdated.length,
      },
    );
  }

  /// Log address added event
  Future<void> logAddressAdded({
    required String addressType,
    String? city,
    String? pincode,
  }) async {
    await logEvent(
      name: 'address_added',
      parameters: {
        'address_type': addressType,
        if (city != null) 'city': city,
        if (pincode != null) 'pincode': pincode,
      },
    );
  }

  /// Log address deleted event
  Future<void> logAddressDeleted({
    required String addressType,
  }) async {
    await logEvent(
      name: 'address_deleted',
      parameters: {
        'address_type': addressType,
      },
    );
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
    String? brand,
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
            itemBrand: brand,
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
    String? category,
    double? price,
  }) async {
    await logEvent(
      name: 'remove_from_wishlist',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        if (category != null) 'category': category,
        if (price != null) 'price': price,
      },
    );
  }

  /// Log add shipping info event
  Future<void> logAddShippingInfo({
    required String shippingMethod,
    String? addressType,
    double? shippingCost,
    String? currency,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      await _analytics.logAddShippingInfo(
        currency: currency ?? 'INR',
        value: shippingCost,
        shippingTier: shippingMethod,
        items: items
            ?.map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                ))
            .toList(),
      );
      log('📊 Analytics: Add Shipping Info - $shippingMethod');
    } catch (e) {
      log('❌ Analytics Error (Add Shipping Info): $e');
    }
  }

  /// Log add payment info event
  Future<void> logAddPaymentInfo({
    required String paymentType,
    String? currency,
    double? value,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      await _analytics.logAddPaymentInfo(
        currency: currency ?? 'INR',
        value: value,
        paymentType: paymentType,
        items: items
            ?.map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                ))
            .toList(),
      );
      log('📊 Analytics: Add Payment Info - $paymentType');
    } catch (e) {
      log('❌ Analytics Error (Add Payment Info): $e');
    }
  }

  /// Log refund event
  Future<void> logRefund({
    required String transactionId,
    required double value,
    String? currency,
    List<Map<String, dynamic>>? items,
    String? reason,
  }) async {
    try {
      await _analytics.logRefund(
        transactionId: transactionId,
        currency: currency ?? 'INR',
        value: value,
        items: items
            ?.map((item) => AnalyticsEventItem(
                  itemId: item['id']?.toString() ?? '',
                  itemName: item['name']?.toString() ?? '',
                  quantity: item['quantity'] as int? ?? 1,
                ))
            .toList(),
      );
      // Log reason as custom parameter
      if (reason != null) {
        await logEvent(
          name: 'refund_reason',
          parameters: {
            'transaction_id': transactionId,
            'reason': reason,
          },
        );
      }
      log('📊 Analytics: Refund - Transaction: $transactionId, Value: $value');
    } catch (e) {
      log('❌ Analytics Error (Refund): $e');
    }
  }

  // ==================== SEARCH EVENTS ====================

  /// Log search event
  Future<void> logSearch({
    required String searchTerm,
    int? resultsCount,
  }) async {
    try {
      await _analytics.logSearch(searchTerm: searchTerm);
      if (resultsCount != null) {
        await logEvent(
          name: 'search_results',
          parameters: {
            'search_term': searchTerm,
            'results_count': resultsCount,
          },
        );
      }
      log('📊 Analytics: Search - "$searchTerm" (${resultsCount ?? 'unknown'} results)');
    } catch (e) {
      log('❌ Analytics Error (Search): $e');
    }
  }

  /// Log search with no results
  Future<void> logSearchNoResults({
    required String searchTerm,
  }) async {
    await logEvent(
      name: 'search_no_results',
      parameters: {
        'search_term': searchTerm,
      },
    );
    log('📊 Analytics: Search No Results - "$searchTerm"');
  }

  /// Log search result click
  Future<void> logSearchResultClick({
    required String searchTerm,
    required String productId,
    required String productName,
    required int position,
  }) async {
    await logEvent(
      name: 'search_result_click',
      parameters: {
        'search_term': searchTerm,
        'product_id': productId,
        'product_name': productName,
        'position': position,
      },
    );
  }

  /// Log voice search event
  Future<void> logVoiceSearch({
    required String searchTerm,
    int? resultsCount,
  }) async {
    await logEvent(
      name: 'voice_search',
      parameters: {
        'search_term': searchTerm,
        if (resultsCount != null) 'results_count': resultsCount,
      },
    );
    log('📊 Analytics: Voice Search - "$searchTerm"');
  }

  /// Log filter applied
  Future<void> logFilterApplied({
    required String filterType,
    required String filterValue,
    String? screenName,
  }) async {
    await logEvent(
      name: 'filter_applied',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
        if (screenName != null) 'screen_name': screenName,
      },
    );
  }

  /// Log sort applied
  Future<void> logSortApplied({
    required String sortType,
    String? screenName,
  }) async {
    await logEvent(
      name: 'sort_applied',
      parameters: {
        'sort_type': sortType,
        if (screenName != null) 'screen_name': screenName,
      },
    );
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
    String? parentCategory,
  }) async {
    await logEvent(
      name: 'select_category',
      parameters: {
        'category_id': categoryId,
        'category_name': categoryName,
        if (parentCategory != null) 'parent_category': parentCategory,
      },
    );
  }

  /// Log when user views a product list
  Future<void> logViewProductList({
    required String listName,
    List<Map<String, dynamic>>? items,
    int? itemsCount,
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
      if (itemsCount != null) {
        await logEvent(
          name: 'view_item_list_count',
          parameters: {
            'list_name': listName,
            'items_count': itemsCount,
          },
        );
      }
      log('📊 Analytics: View Product List - $listName');
    } catch (e) {
      log('❌ Analytics Error (View Product List): $e');
    }
  }

  /// Log banner view (impression)
  Future<void> logBannerView({
    required String bannerId,
    String? bannerName,
    int? position,
    String? bannerType,
  }) async {
    await logEvent(
      name: 'banner_view',
      parameters: {
        'banner_id': bannerId,
        if (bannerName != null) 'banner_name': bannerName,
        if (position != null) 'position': position,
        if (bannerType != null) 'banner_type': bannerType,
      },
    );
  }

  /// Log bottom navigation click
  Future<void> logBottomNavClick({
    required String tabName,
    String? fromTab,
  }) async {
    await logEvent(
      name: 'bottom_nav_click',
      parameters: {
        'tab_name': tabName,
        if (fromTab != null) 'from_tab': fromTab,
      },
    );
  }

  /// Log back button press
  Future<void> logBackButtonPress({
    required String fromScreen,
  }) async {
    await logEvent(
      name: 'back_button_press',
      parameters: {
        'from_screen': fromScreen,
      },
    );
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

  /// Log wallet screen opened
  Future<void> logWalletOpened({double? currentBalance}) async {
    await logEvent(
      name: 'wallet_opened',
      parameters: {
        if (currentBalance != null) 'current_balance': currentBalance,
      },
    );
    log('📊 Analytics: Wallet Opened - Balance: $currentBalance');
  }

  /// Log wallet recharge initiated
  Future<void> logWalletRechargeStarted({required double amount}) async {
    await logEvent(
      name: 'wallet_recharge_started',
      parameters: {'amount': amount},
    );
    log('📊 Analytics: Wallet Recharge Started - ₹$amount');
  }

  /// Log wallet recharge success
  Future<void> logWalletRechargeSuccess({required double amount}) async {
    await logEvent(
      name: 'wallet_recharge_success',
      parameters: {'amount': amount},
    );
    log('📊 Analytics: Wallet Recharge Success - ₹$amount');
  }

  /// Log wallet recharge failed
  Future<void> logWalletRechargeFailed({required double amount}) async {
    await logEvent(
      name: 'wallet_recharge_failed',
      parameters: {'amount': amount},
    );
    log('📊 Analytics: Wallet Recharge Failed - ₹$amount');
  }

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

  /// Log coin screen opened
  Future<void> logCoinScreenOpened({int? currentCoins}) async {
    await logEvent(
      name: 'coin_screen_opened',
      parameters: {
        if (currentCoins != null) 'current_coins': currentCoins,
      },
    );
    log('📊 Analytics: Coin Screen Opened - Coins: $currentCoins');
  }

  /// Log coin redeem initiated
  Future<void> logCoinRedeemStarted(
      {required int coins, required double value}) async {
    await logEvent(
      name: 'coin_redeem_started',
      parameters: {'coins': coins, 'value': value},
    );
    log('📊 Analytics: Coin Redeem Started - $coins coins (₹$value)');
  }

  /// Log coin redeem success
  Future<void> logCoinRedeemSuccess(
      {required int coins, required double value}) async {
    await logEvent(
      name: 'coin_redeem_success',
      parameters: {'coins': coins, 'value': value},
    );
    log('📊 Analytics: Coin Redeem Success - $coins coins (₹$value)');
  }

  /// Log order history screen opened
  Future<void> logOrderHistoryOpened({int? ordersCount}) async {
    await logEvent(
      name: 'order_history_opened',
      parameters: {
        if (ordersCount != null) 'orders_count': ordersCount,
      },
    );
    log('📊 Analytics: Order History Opened - $ordersCount orders');
  }

  /// Log order details viewed
  Future<void> logOrderDetailViewed({
    required String orderId,
    required String orderNumber,
    required double grandTotal,
    required String orderStatus,
    String? paymentMethod,
  }) async {
    await logEvent(
      name: 'order_detail_viewed',
      parameters: {
        'order_id': orderId,
        'order_number': orderNumber,
        'grand_total': grandTotal,
        'order_status': orderStatus,
        if (paymentMethod != null) 'payment_method': paymentMethod,
      },
    );
    log('📊 Analytics: Order Detail Viewed - #$orderNumber ($orderStatus)');
  }

  /// Log account menu item tapped
  Future<void> logAccountMenuTap({required String menuItem}) async {
    await logEvent(
      name: 'account_menu_tap',
      parameters: {'menu_item': menuItem},
    );
    log('📊 Analytics: Account Menu Tap - $menuItem');
  }

  /// Log profile screen opened
  Future<void> logProfileOpened() async {
    await logEvent(name: 'profile_opened');
    log('📊 Analytics: Profile Opened');
  }

  /// Log refer friend screen opened
  Future<void> logReferFriendOpened() async {
    await logEvent(name: 'refer_friend_opened');
    log('📊 Analytics: Refer Friend Opened');
  }

  /// Log product list viewed with category details
  Future<void> logProductListViewed({
    required String listName,
    required String listId,
    required bool isCategory,
    int? itemsCount,
  }) async {
    await logEvent(
      name: 'product_list_viewed',
      parameters: {
        'list_name': listName,
        'list_id': listId,
        'is_category': isCategory,
        if (itemsCount != null) 'items_count': itemsCount,
      },
    );
    log('📊 Analytics: Product List Viewed - $listName ($itemsCount items)');
  }

  /// Log product tapped from list
  Future<void> logProductTappedFromList({
    required String productId,
    required String productName,
    required String listName,
    required int position,
    double? price,
  }) async {
    await logEvent(
      name: 'product_tapped_from_list',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'list_name': listName,
        'position': position,
        if (price != null) 'price': price,
      },
    );
    log('📊 Analytics: Product Tapped - "$productName" from "$listName" at position $position');
  }

  /// Log category tapped from explore
  Future<void> logCategoryTapped({
    required String categoryId,
    required String categoryName,
  }) async {
    await logEvent(
      name: 'category_tapped',
      parameters: {
        'category_id': categoryId,
        'category_name': categoryName,
      },
    );
    log('📊 Analytics: Category Tapped - $categoryName');
  }

  /// Log sub-category tapped
  Future<void> logSubCategoryTapped({
    required String subCategoryId,
    required String subCategoryName,
    String? parentCategoryName,
  }) async {
    await logEvent(
      name: 'sub_category_tapped',
      parameters: {
        'sub_category_id': subCategoryId,
        'sub_category_name': subCategoryName,
        if (parentCategoryName != null) 'parent_category': parentCategoryName,
      },
    );
    log('📊 Analytics: Sub-Category Tapped - $subCategoryName');
  }

  /// Log pincode delivery check
  Future<void> logPincodeCheck({
    required String pincode,
    required bool isDeliverable,
  }) async {
    await logEvent(
      name: 'pincode_check',
      parameters: {
        'pincode': pincode,
        'is_deliverable': isDeliverable,
      },
    );
    log('📊 Analytics: Pincode Check - $pincode (${isDeliverable ? 'Deliverable' : 'Not Deliverable'})');
  }

  /// Log quantity changed on product detail
  Future<void> logQuantityChanged({
    required String productId,
    required String productName,
    required int newQuantity,
  }) async {
    await logEvent(
      name: 'quantity_changed',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'quantity': newQuantity,
      },
    );
    log('📊 Analytics: Quantity Changed - $productName x$newQuantity');
  }

  /// Log product image carousel swipe
  Future<void> logProductImageSwiped({
    required String productName,
    required int imageIndex,
  }) async {
    await logEvent(
      name: 'product_image_swiped',
      parameters: {
        'product_name': productName,
        'image_index': imageIndex,
      },
    );
  }

  /// Log logout
  Future<void> logUserLogout() async {
    await logEvent(name: 'user_logout');
    log('📊 Analytics: User Logout');
  }

  /// Log address screen opened
  Future<void> logAddressScreenOpened() async {
    await logEvent(name: 'address_screen_opened');
    log('📊 Analytics: Address Screen Opened');
  }

  /// Log track order screen opened
  Future<void> logTrackOrderOpened({String? orderId}) async {
    await logEvent(
      name: 'track_order_opened',
      parameters: {if (orderId != null) 'order_id': orderId},
    );
    log('📊 Analytics: Track Order Opened - $orderId');
  }

  /// Log franchise enquiry screen opened
  Future<void> logFranchiseScreenOpened() async {
    await logEvent(name: 'franchise_screen_opened');
    log('📊 Analytics: Franchise Screen Opened');
  }

  /// Log contact us screen opened
  Future<void> logContactUsOpened() async {
    await logEvent(name: 'contact_us_opened');
    log('📊 Analytics: Contact Us Opened');
  }

  /// Log our stores screen opened
  Future<void> logOurStoresOpened() async {
    await logEvent(name: 'our_stores_opened');
    log('📊 Analytics: Our Stores Opened');
  }

  /// Log careers screen opened
  Future<void> logCareersOpened() async {
    await logEvent(name: 'careers_opened');
    log('📊 Analytics: Careers Opened');
  }

  /// Log sort option applied on product list
  Future<void> logSortOptionApplied({
    required String sortOption,
    required String listName,
  }) async {
    await logEvent(
      name: 'sort_option_applied',
      parameters: {
        'sort_option': sortOption,
        'list_name': listName,
      },
    );
    log('📊 Analytics: Sort Applied - "$sortOption" on $listName');
  }

  /// Log account screen viewed
  Future<void> logAccountScreenViewed() async {
    await logEvent(name: 'account_screen_viewed');
    log('📊 Analytics: Account Screen Viewed');
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

  /// Log referral success
  Future<void> logReferralSuccess({
    String? referredUserId,
    double? rewardValue,
  }) async {
    await logEvent(
      name: 'referral_success',
      parameters: {
        if (referredUserId != null) 'referred_user_id': referredUserId,
        if (rewardValue != null) 'reward_value': rewardValue,
      },
    );
  }

  // ==================== ADS & PROMOTIONS EVENTS ====================

  /// Log ad impression
  Future<void> logAdImpression({
    required String adUnitId,
    required String adFormat,
    String? adSource,
    String? adPlacement,
  }) async {
    try {
      await _analytics.logAdImpression(
        adUnitName: adUnitId,
        adFormat: adFormat,
        adSource: adSource,
        adPlatform: 'firebase',
      );
      log('📊 Analytics: Ad Impression - $adFormat at $adUnitId');
    } catch (e) {
      log('❌ Analytics Error (Ad Impression): $e');
    }
  }

  /// Log ad click
  Future<void> logAdClick({
    required String adUnitId,
    required String adFormat,
    String? adSource,
  }) async {
    await logEvent(
      name: 'ad_click',
      parameters: {
        'ad_unit_id': adUnitId,
        'ad_format': adFormat,
        if (adSource != null) 'ad_source': adSource,
      },
    );
  }

  /// Log ad revenue
  Future<void> logAdRevenue({
    required double value,
    required String adUnitId,
    String? adFormat,
    String? currency,
  }) async {
    await logEvent(
      name: 'ad_revenue',
      parameters: {
        'value': value,
        'currency': currency ?? 'INR',
        'ad_unit_id': adUnitId,
        if (adFormat != null) 'ad_format': adFormat,
      },
    );
  }

  /// Log promotion view
  Future<void> logPromotionView({
    required String promotionId,
    required String promotionName,
    String? creativeName,
    String? creativeSlot,
  }) async {
    try {
      await _analytics.logViewPromotion(
        promotionId: promotionId,
        promotionName: promotionName,
        creativeName: creativeName,
        creativeSlot: creativeSlot,
      );
      log('📊 Analytics: Promotion View - $promotionName');
    } catch (e) {
      log('❌ Analytics Error (Promotion View): $e');
    }
  }

  /// Log promotion click
  Future<void> logPromotionClick({
    required String promotionId,
    required String promotionName,
    String? creativeName,
    String? creativeSlot,
  }) async {
    try {
      await _analytics.logSelectPromotion(
        promotionId: promotionId,
        promotionName: promotionName,
        creativeName: creativeName,
        creativeSlot: creativeSlot,
      );
      log('📊 Analytics: Promotion Click - $promotionName');
    } catch (e) {
      log('❌ Analytics Error (Promotion Click): $e');
    }
  }

  // ==================== STORE/FRANCHISE EVENTS ====================

  /// Log store view
  Future<void> logStoreView({
    required String storeId,
    required String storeName,
    String? storeType,
    String? city,
  }) async {
    await logEvent(
      name: 'store_view',
      parameters: {
        'store_id': storeId,
        'store_name': storeName,
        if (storeType != null) 'store_type': storeType,
        if (city != null) 'city': city,
      },
    );
  }

  /// Log franchise enquiry
  Future<void> logFranchiseEnquiry({
    String? location,
    String? city,
    String? state,
  }) async {
    await logEvent(
      name: 'franchise_enquiry',
      parameters: {
        if (location != null) 'location': location,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      },
    );
  }

  // ==================== USER ENGAGEMENT EVENTS ====================

  /// Log notification received
  Future<void> logNotificationReceived({
    required String notificationType,
    String? notificationId,
    String? title,
  }) async {
    await logEvent(
      name: 'notification_received',
      parameters: {
        'notification_type': notificationType,
        if (notificationId != null) 'notification_id': notificationId,
        if (title != null) 'title': title,
      },
    );
  }

  /// Log notification click
  Future<void> logNotificationClick({
    required String notificationType,
    String? notificationId,
    String? action,
  }) async {
    await logEvent(
      name: 'notification_click',
      parameters: {
        'notification_type': notificationType,
        if (notificationId != null) 'notification_id': notificationId,
        if (action != null) 'action': action,
      },
    );
  }

  /// Log app source (how user opened app)
  Future<void> logAppSource({
    required String source, // 'notification', 'direct', 'deeplink'
    String? deepLinkUrl,
  }) async {
    await logEvent(
      name: 'app_source',
      parameters: {
        'source': source,
        if (deepLinkUrl != null) 'deep_link_url': deepLinkUrl,
      },
    );
  }

  /// Log session start
  Future<void> logSessionStart() async {
    await logEvent(name: 'session_start');
    log('📊 Analytics: Session Start');
  }

  // ==================== PERFORMANCE EVENTS ====================

  /// Log screen load time
  Future<void> logScreenLoadTime({
    required String screenName,
    required int loadTimeMs,
  }) async {
    await logEvent(
      name: 'screen_load_time',
      parameters: {
        'screen_name': screenName,
        'load_time_ms': loadTimeMs,
      },
    );
  }

  /// Log payment failed
  Future<void> logPaymentFailed({
    required String paymentMethod,
    required String errorReason,
    double? amount,
    String? orderId,
  }) async {
    await logEvent(
      name: 'payment_failed',
      parameters: {
        'payment_method': paymentMethod,
        'error_reason': errorReason,
        if (amount != null) 'amount': amount,
        if (orderId != null) 'order_id': orderId,
      },
    );
  }

  // ==================== USER PROPERTIES ====================

  /// Set preferred payment method
  Future<void> setPreferredPayment(String paymentMethod) async {
    await setUserProperty(name: 'preferred_payment', value: paymentMethod);
  }

  /// Set preferred category
  Future<void> setPreferredCategory(String category) async {
    await setUserProperty(name: 'preferred_category', value: category);
  }

  /// Set total orders count
  Future<void> setTotalOrders(int count) async {
    await setUserProperty(name: 'total_orders', value: count.toString());
  }

  /// Set total spent amount
  Future<void> setTotalSpent(double amount) async {
    await setUserProperty(
        name: 'total_spent', value: amount.toStringAsFixed(2));
  }

  /// Set user city
  Future<void> setUserCity(String city) async {
    await setUserProperty(name: 'user_city', value: city);
  }

  /// Set app version
  Future<void> setAppVersion(String version) async {
    await setUserProperty(name: 'app_version', value: version);
  }

  /// Set user registration date
  Future<void> setRegistrationDate(String date) async {
    await setUserProperty(name: 'registration_date', value: date);
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
