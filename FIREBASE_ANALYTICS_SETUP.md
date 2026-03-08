# Firebase Analytics Integration Guide

## 🔥 Quick Setup (5 minutes)

### Step 1: Create Firebase Project

1. **Go to** [Firebase Console](https://console.firebase.google.com/)
2. **Click** "Create a project" or "Add project"
3. **Enter project name:** `Biotechmaali`
4. **Enable Google Analytics:** YES (very important!)
5. **Select or create** a Google Analytics account
6. **Click** "Create project"

### Step 2: Add Android App

1. In Firebase Console, **click the Android icon**
2. **Enter package name:** `com.biotechmaali.app`
3. **Enter app nickname:** `Biotechmaali Android`
4. **Click** "Register app"
5. **Download** `google-services.json`
6. **Copy the file to:** `android/app/google-services.json`

```bash
# After downloading, move the file:
mv ~/Downloads/google-services.json android/app/
```

### Step 3: Add iOS App

1. In Firebase Console, **click "Add app" → iOS**
2. **Enter bundle ID:** `com.biotechmaali.app`
3. **Enter app nickname:** `Biotechmaali iOS`
4. **Click** "Register app"
5. **Download** `GoogleService-Info.plist`
6. **Copy the file to:** `ios/Runner/GoogleService-Info.plist`

```bash
# After downloading, move the file:
mv ~/Downloads/GoogleService-Info.plist ios/Runner/
```

7. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```
8. **Right-click** on `Runner` folder → "Add Files to Runner"
9. **Select** `GoogleService-Info.plist`
10. **Check** "Copy items if needed" and ensure "Runner" target is selected
11. **Click** "Add"

### Step 4: Install iOS Pods

```bash
cd ios && pod install && cd ..
```

### Step 5: Build and Run

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

---

## ✅ What's Already Integrated

```dart
import 'package:biotech_maali/core/services/analytics_service.dart';

// Get the singleton instance
final analytics = AnalyticsService();
```

### Track Screen Views

The app automatically tracks screen navigation via `FirebaseAnalyticsObserver`. 
For manual tracking:

```dart
// In any screen's initState or build
analytics.logScreenView(screenName: 'ProductDetailsScreen');
```

### Track User Login/Signup

```dart
// After successful login
analytics.logLogin(method: 'phone');

// After successful signup
analytics.logSignUp(method: 'phone');

// Set user ID for cross-session tracking
analytics.setUserId(userId);

// Set user type
analytics.setUserType('registered'); // or 'guest', 'premium'
```

### Track E-commerce Events

```dart
// When user views a product
analytics.logViewProduct(
  productId: product.id,
  productName: product.name,
  category: product.category,
  price: product.price,
);

// When user adds to cart
analytics.logAddToCart(
  productId: product.id,
  productName: product.name,
  category: product.category,
  price: product.price,
  quantity: 1,
);

// When user removes from cart
analytics.logRemoveFromCart(
  productId: product.id,
  productName: product.name,
);

// When user begins checkout
analytics.logBeginCheckout(
  items: cartItems.map((item) => {
    'id': item.id,
    'name': item.name,
    'category': item.category,
    'price': item.price,
    'quantity': item.quantity,
  }).toList(),
  totalValue: cartTotal,
);

// When purchase is complete
analytics.logPurchase(
  transactionId: orderId,
  totalValue: orderTotal,
  items: orderItems,
  paymentMethod: 'razorpay',
  shipping: shippingCost,
);
```

### Track Search

```dart
analytics.logSearch(searchTerm: 'organic fertilizer');

// With filters
analytics.logSearchWithFilters(
  searchTerm: 'fertilizer',
  filters: {
    'category': 'organic',
    'price_range': '100-500',
  },
);
```

### Track Wishlist

```dart
analytics.logAddToWishlist(
  productId: product.id,
  productName: product.name,
  price: product.price,
);

analytics.logRemoveFromWishlist(
  productId: product.id,
  productName: product.name,
);
```

### Track Custom Events

```dart
// Button clicks
analytics.logButtonClick(
  buttonName: 'apply_coupon',
  screenName: 'CartScreen',
);

// Banner clicks
analytics.logBannerClick(
  bannerId: banner.id,
  bannerName: banner.title,
  position: index,
);

// Coupon events
analytics.logCouponApplied(
  couponCode: 'SAVE10',
  discountValue: 100.0,
);

// Location events
analytics.logLocationSelected(
  pincode: '560001',
  city: 'Bangalore',
  state: 'Karnataka',
);

// Store selection
analytics.logStoreSelected(
  storeId: store.id,
  storeName: store.name,
  storeType: 'franchise',
);

// Wallet transactions
analytics.logWalletTransaction(
  type: 'credit',
  amount: 500.0,
  source: 'referral_bonus',
);

// Coins events
analytics.logCoinsEarned(coins: 50, source: 'purchase');
analytics.logCoinsRedeemed(coins: 100, value: 10.0);

// Referral events
analytics.logReferralShared(method: 'whatsapp');
analytics.logReferralApplied(referralCode: 'REF123');

// Any custom event
analytics.logEvent(
  name: 'custom_event_name',
  parameters: {
    'param1': 'value1',
    'param2': 123,
  },
);
```

### Track Errors

```dart
// App errors
analytics.logError(
  errorType: 'network_error',
  errorMessage: 'Connection timeout',
  screenName: 'HomeScreen',
);

// API errors
analytics.logApiError(
  endpoint: '/api/products',
  statusCode: 500,
  errorMessage: 'Internal server error',
);
```

---

## View Analytics Data

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click **"Analytics"** in the left sidebar
4. View dashboards:
   - **Dashboard** - Overview of app usage
   - **Events** - All tracked events
   - **Conversions** - Set up conversion events
   - **Audiences** - Create user segments
   - **User properties** - View user attributes
   - **DebugView** - Real-time event debugging (enable debug mode)

### Enable Debug Mode

To see events in real-time during development:

**Android:**
```bash
adb shell setprop debug.firebase.analytics.app com.biotechmaali.app
```

**iOS:**
Add `-FIRDebugEnabled` to scheme arguments in Xcode.

---

## Best Practices

1. **Use meaningful event names** - Keep them lowercase with underscores
2. **Don't over-track** - Focus on actionable metrics
3. **Set user properties wisely** - Max 25 custom properties
4. **Test in DebugView** - Verify events are being sent correctly
5. **Create audiences** - Segment users for targeted analysis
6. **Set up conversions** - Mark important events as conversions

---

## Files Modified

1. `pubspec.yaml` - Added firebase_core and firebase_analytics packages
2. `lib/main.dart` - Initialize Firebase and log app open
3. `lib/biotech_app.dart` - Added analytics observer for navigation
4. `android/build.gradle` - Added Google Services classpath
5. `android/app/build.gradle` - Added Google Services plugin
6. `lib/core/services/analytics_service.dart` - Created comprehensive analytics service

## Files to Add (from Firebase Console)

1. `android/app/google-services.json` - Download from Firebase Console
2. `ios/Runner/GoogleService-Info.plist` - Download from Firebase Console

---

## Troubleshooting

### Events not showing in Firebase Console
- Events can take up to 24 hours to appear
- Use DebugView for real-time testing
- Verify google-services.json/GoogleService-Info.plist are in correct locations

### Build errors
- Run `fvm flutter clean && fvm flutter pub get`
- For iOS: `cd ios && pod install --repo-update`

### Missing Google Services file
- Download from Firebase Console → Project Settings → Your Apps
