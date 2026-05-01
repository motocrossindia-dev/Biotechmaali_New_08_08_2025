import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/home/home_repository.dart';
import 'package:biotech_maali/src/module/home/model/banner_model.dart';
import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/home/model/content_block_model.dart';
import 'package:biotech_maali/src/module/home/model/public_flag_model.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/src/module/home/model/promotional_banner_model.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../import.dart';

class HomeProvider extends ChangeNotifier {
  // HomeProvider() {
  //   refreshAll();
  // }
  final HomeRepository _repository = HomeRepository();

  bool _isLoading = false;

  String pinCode = "560001"; // Default pincode instead of "Searching..."
  String placeName = "Getting location...";
  String fullAddress = ""; // New property for full address

  final bool _isCartLoading = false;
  String? _error;
  List<MainCategoryModel> _mainCategories = [];
  List<PublicFlagModel> _publicFlags = [];
  Map<int, ProductListModel> _flagProductsList = {};

  // Getters
  bool get isLoading => _isLoading;

  bool get isCartLoading => _isCartLoading;
  String? get error => _error;
  List<MainCategoryModel> get maincategories => _mainCategories;
  
  List<PublicFlagModel> get publicFlags => _publicFlags;
  Map<int, ProductListModel> get flagProductsList => _flagProductsList;

  bool _isBannersLoading = false;

  // Separate error states
  String? _bannersError;
  String? _productsError;

  List<BannerModel> _banners = [];

  // Content blocks state
  List<ContentBlock> _contentBlocks = [];
  bool _isContentBlocksLoading = false;
  String? _contentBlocksError;

  // Promotional banner state
  PromotionalBannerModel? _promotionalBanner;
  bool _isPromotionalBannerLoading = false;
  String? _promotionalBannerError;

  // Carousel related code (keeping existing functionality)
  bool get isBannersLoading => _isBannersLoading;

  String? get bannersError => _bannersError;
  String? get productsError => _productsError;
  List<BannerModel> get banners => _banners;
  int _caroucelIndex = 0;
  int get caroucelIndex => _caroucelIndex;

  // Content blocks getters
  List<ContentBlock> get contentBlocks => _contentBlocks;
  bool get isContentBlocksLoading => _isContentBlocksLoading;
  String? get contentBlocksError => _contentBlocksError;

  // Promotional banner getters
  PromotionalBannerModel? get promotionalBanner => _promotionalBanner;
  bool get isPromotionalBannerLoading => _isPromotionalBannerLoading;
  String? get promotionalBannerError => _promotionalBannerError;

  // Get content blocks by section
  ContentBlock? get comboOfferContent => _contentBlocks
              .firstWhere(
                (block) => block.section == 'combo_offers' && block.isActive,
                orElse: () => ContentBlock(
                  id: 0,
                  section: '',
                  title: '',
                  subtitle: '',
                  buttonText: '',
                  order: 0,
                  isActive: false,
                ),
              )
              .id !=
          0
      ? _contentBlocks.firstWhere(
          (block) => block.section == 'combo_offers' && block.isActive,
        )
      : null;

  ContentBlock? get bannerContent => _contentBlocks
              .firstWhere(
                (block) => block.section == 'banner' && block.isActive,
                orElse: () => ContentBlock(
                  id: 0,
                  section: '',
                  title: '',
                  subtitle: '',
                  buttonText: '',
                  order: 0,
                  isActive: false,
                ),
              )
              .id !=
          0
      ? _contentBlocks.firstWhere(
          (block) => block.section == 'banner' && block.isActive,
        )
      : null;

  ContentBlock? get homeScreenVideoContent => _contentBlocks
              .firstWhere(
                (block) =>
                    block.section == 'home_screen_video' && block.isActive,
                orElse: () => ContentBlock(
                  id: 0,
                  section: '',
                  title: '',
                  subtitle: '',
                  buttonText: '',
                  order: 0,
                  isActive: false,
                ),
              )
              .id !=
          0
      ? _contentBlocks.firstWhere(
          (block) => block.section == 'home_screen_video' && block.isActive,
        )
      : null;

  List<ContentBlock> get offersRewardsContent => _contentBlocks
      .where((block) => block.section == 'offers_rewards' && block.isActive)
      .toList();

  List<Map<String, String>> get visibleHomeBanners {
    return _banners
        .where((banner) =>
            banner.isVisible &&
            (banner.type == 'Home' || banner.type == 'Hero'))
        .map((banner) => {
              'image': banner.mobileBanner,
              'productId': banner.productId?.toString() ?? '0',
              'bannerId': banner.id.toString(), // Add banner ID
            })
        .toList();
  }

  Future<void> getLocationPincode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPincode = prefs.getString('user_pincode');
    String? savedAddress = prefs.getString('user_current_address');
    String? savedLocality = prefs.getString('user_locality');

    if (savedPincode != null && savedPincode.isNotEmpty) {
      pinCode = savedPincode;
    }

    if (savedAddress != null && savedAddress.isNotEmpty) {
      fullAddress = savedAddress;
    } else if (savedLocality != null && savedLocality.isNotEmpty) {
      fullAddress = savedLocality;
    }

    if (savedLocality != null && savedLocality.isNotEmpty) {
      placeName = savedLocality;
    }

    notifyListeners();
  }

  Future<void> setLocationPincode(String pincode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pincode', pincode);
    log("Pincode set: $pincode");
    pinCode = pincode;
    notifyListeners();
  }

  Future<void> updateFullAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_current_address', address);
    fullAddress = address;
    notifyListeners();
  }

  Future<void> getLocationName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocality = prefs.getString('user_locality');
    String? savedAddress = prefs.getString('user_current_address');

    if (savedLocality != null && savedLocality.isNotEmpty) {
      placeName = savedLocality;
    }

    if (savedAddress != null && savedAddress.isNotEmpty) {
      fullAddress = savedAddress;
    }

    notifyListeners();
  }

  void onCaroucelIndexChange(int current) {
    _caroucelIndex = current;
    notifyListeners();
  }

  Future<void> validateToken(BuildContext context) async {
    final settingsProvider = context.read<SettingsProvider>();
    bool isAuth = await settingsProvider.checkAccessTokenValidity(context);

    if (!isAuth) {
      showLoginDialog(context);

      return;
    }
  }

  Future addOrRemoveToWishlist(
      int productId, bool isWishlist, BuildContext context) async {
    log("iswishList : $isWishlist");

    try {
      bool result = await _repository.addOrRemoveWishListMainProduct(productId);
      if (result) {
        // Wishlist toggle manually on flagProductsList if needed
        // This is simplified, or can be implemented dynamically.
        // But standard interaction on Home screen updates local State in Tile directly since it uses standard List model.
        notifyListeners();
      }
    } catch (e) {
      _error =
          "Failed to add or remove item from wishlist, something went wrong.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> addToCartMainProduct(
      int productId, bool isCart, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _repository.addToCartForMainProduct(productId);
      log("Success : ${success.toString()}");

      if (success) {
        final cartProvider = context.read<CartProvider>();
        await cartProvider
            .fetchCartItems(); // Refresh cart items after successful addition

        // Again, standard cart interaction on home screen grid will be handled if needed,
        // but typically cart refresh is handled via CartProvider anyway.
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = "Failed to add item to cart, something went wrong.";
      Fluttertoast.showToast(
        msg: "Error adding item to cart",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        fetchPublicFlags(),
        fetchMainCategories(),
        fetchBanners(),
        getLocationPincode(),
        getLocationName()
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error =
          "Failed to load data, please check your internet connection or try again later.";
      notifyListeners();
    }
  }

  // Fetch banners
  Future<void> fetchBanners() async {
    try {
      _isBannersLoading = true;
      _bannersError = null;
      // notifyListeners();

      _banners = await _repository.getBanners();
      _bannersError = null;
    } catch (e) {
      _bannersError = e.toString();
      log('Banner fetch error: $e');
    } finally {
      _isBannersLoading = false;
      notifyListeners();
    }
  }

  // Fetch dynamic flags
  Future<void> fetchPublicFlags() async {
    try {
      _isLoading = true;
      _error = null;

      _publicFlags = await _repository.getPublicFlags();

      // Concurrently fetch products for all flags to populate the home grids.
      await Future.wait(
        _publicFlags.map((flag) => fetchProductsForFlag(flag.id))
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error =
          "Failed to load products, please check your internet connection or try again later.";
      notifyListeners();
    }
  }

  Future<void> fetchProductsForFlag(int flagId) async {
    try {
      final response = await _repository.getProductsForFlag(flagId);
      _flagProductsList[flagId] = response;
    } catch (e) {
      log('Error populating products for flag: $flagId');
    }
  }

  Future<void> fetchMainCategories() async {
    try {
      _isLoading = true;
      _error = null;
      // notifyListeners();

      final categoryResponse = await _repository.getMainCategories();
      _mainCategories = categoryResponse.data.categories;
      log("Main Categories: ${_mainCategories.toString()}");

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error =
          "Failed to load categories, please check your internet connection or try again later.";
      notifyListeners();
      log("Error fetching categories: $e");
    }
  }

  // Fetch content blocks
  Future<void> fetchContentBlocks() async {
    try {
      _isContentBlocksLoading = true;
      _contentBlocksError = null;
      notifyListeners();

      _contentBlocks = await _repository.getContentBlocks();
      log("Content Blocks fetched: ${_contentBlocks.length}");
      _contentBlocksError = null;
    } catch (e) {
      _contentBlocksError = e.toString();
      log('Content blocks fetch error: $e');
    } finally {
      _isContentBlocksLoading = false;
      notifyListeners();
    }
  }

  // Fetch promotional banner
  Future<void> fetchPromotionalBanner(int bannerId) async {
    try {
      _isPromotionalBannerLoading = true;
      _promotionalBannerError = null;
      notifyListeners();

      _promotionalBanner = await _repository.getPromotionalBanner(bannerId);
      log("Promotional Banner fetched: ${_promotionalBanner?.title}");
      _promotionalBannerError = null;
    } catch (e) {
      _promotionalBannerError = e.toString();
      log('Promotional banner fetch error: $e');
    } finally {
      _isPromotionalBannerLoading = false;
      notifyListeners();
    }
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
