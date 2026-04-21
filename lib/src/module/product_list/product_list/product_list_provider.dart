import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_repository.dart';

class ProductListProdvider extends ChangeNotifier {
  ProductListRepository productListRepository = ProductListRepository();

  List<Product> _allProducts = [];
  List<Product> _originalProducts = [];

  bool _isLoading = false;
  String _currentSortOption = 'Default';

  bool _isLoadingMore = false;
  String? _nextPageUrl;

  /// Generation counter: incremented on every fresh load so that stale
  /// API responses from a previous category are silently discarded.
  int _loadGeneration = 0;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String get currentSortOption => _currentSortOption;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _nextPageUrl != null;

  /// Call this synchronously in initState (before the post-frame callback)
  /// so the very first build sees isLoading=true and empty lists.
  /// Does NOT call notifyListeners() — safe to use during build phase.
  void resetForNewLoad() {
    _loadGeneration++;
    _isLoading = true;
    _nextPageUrl = null;
    _allProducts = [];
    _originalProducts = [];
    _currentSortOption = 'Default';
    // No notifyListeners() here — called synchronously in initState,
    // the first build() will read these values directly.
  }

  Future<void> setFilteredProducts(List<Product> products) async {
    log("Setting filtered products: ${products.length}");
    _originalProducts = List.from(products);
    _allProducts = products;
    log("After setting - allProducts length: ${_allProducts.length}");
    notifyListeners();
  }

  void updateWishList(bool isWishlist, int productId) {
    final productIndex =
        _allProducts.indexWhere((product) => product.prodId == productId);
    if (productIndex != -1) {
      _allProducts[productIndex].isWishlist = !isWishlist;

      // Also update in original list
      final originalIndex = _originalProducts
          .indexWhere((product) => product.prodId == productId);
      if (originalIndex != -1) {
        _originalProducts[originalIndex].isWishlist = !isWishlist;
      }

      notifyListeners();
    }
  }

  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final productIndex =
        _allProducts.indexWhere((product) => product.prodId == productId);
    if (productIndex != -1) {
      _allProducts[productIndex].isCart = !isCart;

      // Also update in original list
      final originalIndex = _originalProducts
          .indexWhere((product) => product.prodId == productId);
      if (originalIndex != -1) {
        _originalProducts[originalIndex].isCart = !isCart;
      }

      notifyListeners();
    }
  }

  /// Fetches products for a category by its ID.
  /// All categories (plants, pots, offers, etc.) use this single method.
  Future<void> getCategoryProductList(
      {required String categoryId, bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _loadGeneration++;
      _isLoading = true;
      _nextPageUrl = null;
      _allProducts = [];
      _originalProducts = [];
      notifyListeners();
    }

    // Capture the generation at the start of this request.
    final int thisGeneration = _loadGeneration;

    try {
      final result = await productListRepository.getCotegoryProductList(
        categoryId,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      // If a newer load was triggered while we were waiting, discard this
      // stale response so old products never flash on screen.
      if (thisGeneration != _loadGeneration) return;

      if (loadMore) {
        _allProducts.addAll(result.products);
        _originalProducts.addAll(result.products);
      } else {
        _allProducts = result.products;
        _originalProducts = List.from(result.products);
      }

      _nextPageUrl = result.nextPage;
      notifyListeners();
    } catch (e) {
      log("error : ${e.toString()}");
    } finally {
      if (thisGeneration == _loadGeneration) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<void> getSubCategoryProductList(
      {String? subCategoryId, bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _loadGeneration++;
      _isLoading = true;
      _nextPageUrl = null;
      _allProducts = [];
      _originalProducts = [];
      notifyListeners();
    }

    final int thisGeneration = _loadGeneration;

    try {
      final result = await productListRepository.getSubCotegoryProductList(
        subCategoryId!,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      if (thisGeneration != _loadGeneration) return;

      if (loadMore) {
        _allProducts.addAll(result.products);
        _originalProducts.addAll(result.products);
      } else {
        _allProducts = result.products;
        _originalProducts = List.from(result.products);
      }

      _nextPageUrl = result.nextPage;
      notifyListeners();
    } catch (e) {
      log("error : ${e.toString()}");
    } finally {
      if (thisGeneration == _loadGeneration) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  // New method to sort products
  void sortProducts(String sortOption) {
    _currentSortOption = sortOption;

    // Create a new list to avoid modifying the original directly during sorting
    List<Product> sortedProducts = List.from(_allProducts);

    switch (sortOption) {
      case 'Default':
        // Return to original order
        sortedProducts = List.from(_originalProducts);
        break;

      case 'Price High To Low':
        sortedProducts.sort((a, b) => b.sellingPrice.compareTo(a.sellingPrice));
        break;

      case 'Price Low To High':
        sortedProducts.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;

      case 'Alphabetically A-Z':
        sortedProducts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;

      case 'Alphabetically Z-A':
        sortedProducts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
    }

    _allProducts = sortedProducts;
    notifyListeners();
  }

  void appendProducts(List<Product> newProducts) {
    log("Appending ${newProducts.length} products to existing ${_allProducts.length}");
    _allProducts.addAll(newProducts);
    _originalProducts.addAll(List.from(newProducts));
    log("After appending - total products: ${_allProducts.length}");
    notifyListeners();
  }

  Future<void> getFlagProductList(
      {required int flagId, bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _loadGeneration++;
      _isLoading = true;
      _nextPageUrl = null;
      _allProducts = [];
      _originalProducts = [];
      notifyListeners();
    }

    final int thisGeneration = _loadGeneration;

    try {
      final result = await productListRepository.getFlagProductList(
        flagId,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      if (thisGeneration != _loadGeneration) return;

      if (loadMore) {
        _allProducts.addAll(result.products);
        _originalProducts.addAll(result.products);
      } else {
        _allProducts = result.products;
        _originalProducts = List.from(result.products);
      }

      _nextPageUrl = result.nextPage;
      notifyListeners();
    } catch (e) {
      log("error : ${e.toString()}");
    } finally {
      if (thisGeneration == _loadGeneration) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }
}
