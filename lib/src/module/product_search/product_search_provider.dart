import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/src/module/product_search/product_search_repository.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';

class ProductSearchProvider extends ChangeNotifier {
  final ProductSearchRepository _repository = ProductSearchRepository();
  List<Product> products = [];
  bool isLoading = false;
  String error = '';
  String? nextPage;
  bool isLoadingMore = false;
  String lastSearchQuery = '';
  bool hasSearched = false; // Track if user has performed a search
  Timer? _debounce;

  bool isTyping = false;

  bool showBorderAnimation = false;

  // Clear all products and reset state
  void clearProducts() {
    // Cancel any pending search request
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    products = [];
    error = '';
    nextPage = null;
    lastSearchQuery = '';
    hasSearched = false;
    isLoading = false;
    notifyListeners();
  }

  void updateWishList(bool isWishlist, int productId) {
    final productIndex =
        products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      products[productIndex].isWishlist = !isWishlist;

      notifyListeners();
    }
  }

  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final productIndex =
        products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      products[productIndex].isCart = !isCart;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        isLoading = true;
        error = '';
        lastSearchQuery = query;
        hasSearched = true;
        notifyListeners();

        final response = await _repository.searchProducts(query);
        products = response.products;
        nextPage = response.nextPage;

        // Track search analytics
        if (products.isEmpty) {
          AnalyticsService().logSearchNoResults(searchTerm: query);
        } else {
          AnalyticsService().logSearch(
            searchTerm: query,
            resultsCount: products.length,
          );
        }

        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        error =
            "Failed to search products, something went wrong please try again later.";
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> loadMore() async {
    if (nextPage == null || isLoadingMore) return;

    try {
      isLoadingMore = true;
      // notifyListeners();

      final response =
          await _repository.loadMoreProducts(nextPage!, lastSearchQuery);
      products.addAll(response.products);
      nextPage = response.nextPage;

      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      isLoadingMore = false;
      error = e.toString();
      notifyListeners();
    }
  }
}
