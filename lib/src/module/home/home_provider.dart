import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/home/home_repository.dart';
import 'package:biotech_maali/src/module/home/model/banner_model.dart';
import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/home/model/home_product_model.dart';
import 'package:biotech_maali/src/widgets/add_to_cart.dart';
import 'package:biotech_maali/src/widgets/add_to_wishlist.dart';
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
  List<HomeProductModel> _allProducts = [];
  List<MainCategoryModel> _mainCategories = [];

  // Getters
  bool get isLoading => _isLoading;

  bool get isCartLoading => _isCartLoading;
  String? get error => _error;
  List<HomeProductModel> get allProducts => _allProducts;
  List<MainCategoryModel> get maincategories => _mainCategories;

  List<HomeProductModel> get featuredProducts =>
      _allProducts.where((product) => product.isFeatured).toList();

  List<HomeProductModel> get bestSellerProducts =>
      _allProducts.where((product) => product.isBestSeller).toList();

  List<HomeProductModel> get seasonalProducts =>
      _allProducts.where((product) => product.isSeasonalCollection).toList();

  List<HomeProductModel> get trendingProducts =>
      _allProducts.where((product) => product.isTrending).toList();

  bool _isBannersLoading = false;

  // Separate error states
  String? _bannersError;
  String? _productsError;

  List<BannerModel> _banners = [];

  // Carousel related code (keeping existing functionality)
  bool get isBannersLoading => _isBannersLoading;

  String? get bannersError => _bannersError;
  String? get productsError => _productsError;
  List<BannerModel> get banners => _banners;
  int _caroucelIndex = 0;
  int get caroucelIndex => _caroucelIndex;

  List<Map<String, String>> get visibleHomeBanners {
    const baseUrl = BaseUrl.baseUrlForImages; // Add your base URL here
    return _banners
        .where((banner) =>
            banner.isVisible &&
            (banner.type == 'Home' || banner.type == 'Hero'))
        .map((banner) => {
              'image': '$baseUrl${banner.mobileBanner}',
              'productId': banner.productId?.toString() ?? '0',
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

  setLocationPincode(String pincode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pincode', pincode);
    log("Pincode set: $pincode");
    pinCode = pincode;
    notifyListeners();
  }

  updateFullAddress(String address) async {
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
        final productIndex =
            _allProducts.indexWhere((product) => product.id == productId);
        if (productIndex != -1) {
          _allProducts[productIndex].isWishlist = !isWishlist;

          notifyListeners(); // Notify listeners about the update
        }
        if (isWishlist) {
          showWishlistMessage(context, false);
        } else if (!isWishlist) {
          showWishlistMessage(context, true);
        }
      }
    } catch (e) {
      _error =
          "Failed to add or remove item from wishlist, something went wrong.";
      // _loadingProductIds.remove(productId);
      notifyListeners();
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

        final productIndex =
            _allProducts.indexWhere((product) => product.id == productId);
        if (productIndex != -1) {
          _allProducts[productIndex].isCart = !isCart;

          notifyListeners(); // Notify listeners about the update
        }
        if (isCart) {
          showCartMessage(context, false);
        } else if (!isCart) {
          showCartMessage(context, true);
        }
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
        fetchHomeProducts(),
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

  // Fetch products
  Future<void> fetchHomeProducts() async {
    try {
      _isLoading = true;
      _error = null;
      // notifyListeners();

      _allProducts = await _repository.getHomeProducts();

      for (var element in _allProducts) {
        log(element.image.toString());
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error =
          "Failed to load products, please check your internet connection or try again later.";
      notifyListeners();
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

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
