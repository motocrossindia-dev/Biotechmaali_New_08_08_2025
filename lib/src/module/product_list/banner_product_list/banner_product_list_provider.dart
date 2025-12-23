import 'dart:developer';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_list/banner_product_list/banner_product_list_repository.dart';
import 'package:biotech_maali/src/module/product_list/banner_product_list/model/banner_product_model.dart';
import '../../../../import.dart';

class BannerProductListProvider extends ChangeNotifier {
  final BannerProductListRepository _repository = BannerProductListRepository();

  bool _isLoading = false;
  String? _error;
  BannerProductData? _bannerData;
  List<BannerProduct> _products = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  BannerProductData? get bannerData => _bannerData;
  List<BannerProduct> get products => _products;

  // Fetch banner products
  Future<void> fetchBannerProducts(int bannerId, BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      log("Fetching banner products for banner ID: $bannerId");
      final response = await _repository.getBannerProducts(bannerId);

      _bannerData = response.data;
      _products = response.data.productList;

      log("Fetched ${_products.length} products from banner");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      log("Error fetching banner products: $e");

      // Check if context is still valid before showing snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      notifyListeners();
    }
  }

  // Update wishlist status - following product_list_provider pattern
  void updateWishList(bool isWishlist, int productId) {
    final index = _products.indexWhere((p) => p.prodId == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(isWishlist: !isWishlist);
      notifyListeners();
    }
  }

  // Update cart status - following product_list_provider pattern
  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final index = _products.indexWhere((p) => p.prodId == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(isCart: !isCart);
      notifyListeners();
    }
  }

  // Clear data when leaving the screen
  void clearData() {
    _bannerData = null;
    _products = [];
    _error = null;
    _isLoading = false;
    // Don't call notifyListeners() here - this is called during dispose
    // and would trigger a rebuild while the widget tree is locked
  }
}
