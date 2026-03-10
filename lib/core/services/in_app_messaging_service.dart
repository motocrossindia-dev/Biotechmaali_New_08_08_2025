import 'dart:developer';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

/// Firebase In-App Messaging Service
///
/// This service manages in-app messages that appear while the user is
/// actively using the app. Messages are created in the Firebase Console
/// under Engage → In-App Messaging, and triggered by events below.
///
/// ─────────────────────────────────────────────────────────
/// HOW TO CREATE A CAMPAIGN IN FIREBASE CONSOLE:
/// 1. Go to console.firebase.google.com
/// 2. Select your project: gidanstore-439ef
/// 3. Left sidebar → Engage → In-App Messaging
/// 4. Click "Create your first campaign"
/// 5. Choose message style: Banner / Modal / Card / Image Only
/// 6. Add title, body, button text, button action (URL or deeplink)
/// 7. Under "Scheduling" → choose trigger event (e.g. app_open)
/// 8. Publish campaign
/// ─────────────────────────────────────────────────────────
///
/// TRIGGER EVENTS IN THIS APP:
///
/// Event Name              │ When Triggered
/// ────────────────────────┼──────────────────────────────────
/// app_open                │ Every time app is opened
/// cart_view               │ When user opens Cart screen
/// product_detail_view     │ When user opens any product
/// indoor_plants_view      │ When user taps indoor plant category
/// wallet_view             │ When user opens Wallet
/// order_complete          │ After successful order placement
/// offer_page_view         │ When user views OFFERS section
/// new_user_first_open     │ First time a new user opens the app
///
class InAppMessagingService {
  // Singleton
  InAppMessagingService._();
  static final InAppMessagingService _instance = InAppMessagingService._();
  factory InAppMessagingService() => _instance;

  final FirebaseInAppMessaging _fiam = FirebaseInAppMessaging.instance;

  /// Initialize In-App Messaging.
  /// Call this once in main.dart after Firebase.initializeApp()
  Future<void> initialize() async {
    try {
      // Enable automatic data collection (required for FIAM to work)
      await _fiam.setAutomaticDataCollectionEnabled(true);

      // Enable message suppression = false (messages will show)
      await _fiam.setMessagesSuppressed(false);

      log('📬 In-App Messaging: Initialized successfully');
    } catch (e) {
      log('📬 In-App Messaging: Init error - $e');
    }
  }

  /// ─── TRIGGER EVENTS ─────────────────────────────────────────────

  /// Trigger: App opened
  /// Campaign use: "🌿 Welcome! 15% OFF on Indoor Plants Today"
  Future<void> triggerAppOpen() async {
    await _triggerEvent('app_open');
  }

  /// Trigger: Cart screen opened
  /// Campaign use: "🌱 Don't forget your plants! Complete purchase → Free Delivery"
  Future<void> triggerCartView() async {
    await _triggerEvent('cart_view');
  }

  /// Trigger: Product detail page opened
  /// Campaign use: "Love this plant? Add to cart & get 10% off today only!"
  Future<void> triggerProductDetailView() async {
    await _triggerEvent('product_detail_view');
  }

  /// Trigger: User taps on any indoor plants category
  /// Campaign use: "🌿 New Indoor Plant Collection Just Arrived!"
  Future<void> triggerIndoorPlantsView() async {
    await _triggerEvent('indoor_plants_view');
  }

  /// Trigger: Wallet screen opened
  /// Campaign use: "💰 Recharge ₹500 and get 50 bonus coins!"
  Future<void> triggerWalletView() async {
    await _triggerEvent('wallet_view');
  }

  /// Trigger: Order placed successfully
  /// Campaign use: "🎉 Thank you! Rate your experience & earn 20 coins"
  Future<void> triggerOrderComplete() async {
    await _triggerEvent('order_complete');
  }

  /// Trigger: OFFERS / promotions section viewed
  /// Campaign use: "🔥 Limited Time Offer – Buy 2 Get 1 Free!"
  Future<void> triggerOfferPageView() async {
    await _triggerEvent('offer_page_view');
  }

  /// Trigger: First time user (new install, first open)
  /// Campaign use: "👋 Welcome to Biotech Maali! Get ₹100 OFF on first order"
  Future<void> triggerNewUserFirstOpen() async {
    await _triggerEvent('new_user_first_open');
  }

  /// Trigger: Search used
  /// Campaign use: "🔍 Can't find what you need? Chat with us!"
  Future<void> triggerSearchUsed() async {
    await _triggerEvent('search_used');
  }

  /// Trigger: Wishlist opened
  /// Campaign use: "💚 Your wishlist is waiting! Buy now before stock runs out"
  Future<void> triggerWishlistView() async {
    await _triggerEvent('wishlist_view');
  }

  /// Trigger: Order history opened
  /// Campaign use: "🌱 Loved your last order? Reorder now and save 5%"
  Future<void> triggerOrderHistoryView() async {
    await _triggerEvent('order_history_view');
  }

  /// ─── INTERNAL ────────────────────────────────────────────────────

  Future<void> _triggerEvent(String eventName) async {
    try {
      await _fiam.triggerEvent(eventName);
      log('📬 In-App Messaging: Triggered → $eventName');
    } catch (e) {
      log('📬 In-App Messaging: Error triggering $eventName - $e');
    }
  }
}
