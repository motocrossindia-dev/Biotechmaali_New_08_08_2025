import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/account/account_provider.dart';
import 'package:biotech_maali/src/module/account/coin/coin_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/location_popup/location_pincode_provider.dart';
import 'package:biotech_maali/src/module/product_compo_list/product_compo_list_provider.dart';
import 'package:biotech_maali/src/module/product_search/product_search_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/other_modules/carrers/carriers_provider.dart';
import 'package:biotech_maali/src/other_modules/contact_us/contact_us_provider.dart';
import 'package:biotech_maali/src/other_modules/franchise_enquiry/franchise_enquiry_provider.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_provider.dart';
import 'package:biotech_maali/src/other_modules/out_works/our_work_provider.dart';
import 'package:biotech_maali/src/other_modules/services/services_provider.dart';
import 'package:biotech_maali/src/payment_and_order/change_address/change_address_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_provider.dart';
import 'package:biotech_maali/src/payment_and_order/coupon/coupon_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/local_store_list/local_store_list_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history/order_history_provider.dart';
import 'package:biotech_maali/src/payment_and_order/order_history_detail/order_history_detail_provider.dart';
// import 'package:biotech_maali/src/permission_handle/premission_handle_provider.dart';
import 'package:biotech_maali/src/splash/splash_provider.dart';

import 'import.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class BiotechApp extends StatelessWidget {
  const BiotechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SplashProvider(context: context)),
        ChangeNotifierProvider(create: (context) => MobileNumberProvider()),
        ChangeNotifierProvider(create: (context) => OtpProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => ExploreProvider()),
        ChangeNotifierProvider(create: (context) => ProductDetailsProvider()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
        ChangeNotifierProvider(create: (context) => DeleteAccountProvider()),
        ChangeNotifierProvider(create: (context) => FiltersProvider()),
        ChangeNotifierProvider(create: (context) => ProductRatingProvider()),
        ChangeNotifierProvider(create: (context) => RatingAndReviewProvider()),
        ChangeNotifierProvider(create: (context) => AddEditAddressProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => FranchiseProvider()),
        ChangeNotifierProvider(create: (context) => OurWorkProvider()),
        ChangeNotifierProvider(create: (context) => ServicesProvider()),
        ChangeNotifierProvider(create: (context) => CarrersProvider()),
        ChangeNotifierProvider(create: (context) => OurStoreProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => ChangeAddressProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => OrderSummaryProvider()),
        ChangeNotifierProvider(
            create: (context) => ChoosePaymentProvider(context)),
        ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
        ChangeNotifierProvider(
            create: (context) => OrderHistoryDetailProvider()),
        ChangeNotifierProvider(create: (context) => ProductSearchProvider()),
        ChangeNotifierProvider(create: (context) => ProductListProdvider()),
        ChangeNotifierProvider(create: (context) => LocalStoreListProvider()),
        ChangeNotifierProvider(create: (context) => ProductCompoListProvider()),
        ChangeNotifierProvider(create: (context) => CouponProvider()),
        ChangeNotifierProvider(create: (context) => CoinProvider()),
        ChangeNotifierProvider(create: (context) => ReferFriendProvider()),
        ChangeNotifierProvider(create: (context) => LocationPincodeProvider()),
        // ChangeNotifierProvider(create: (context) => PermissionHandleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: orderSummaryBackground),
          primaryColor: cButtonGreen,
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}
