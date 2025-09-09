import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductListProdvider extends ChangeNotifier {
  ProductListRepository productListRepository = ProductListRepository();

  List<Product> _allProducts = [];
  List<Product> _originalProducts = [];

  List<Product> _offerProducts = [];
  List<Product> _originalOfferProducts = [];
  List<Product> get offerProducts => _offerProducts;
  List<Product> get originalOfferProducts => _originalOfferProducts;
  bool _isLoading = false;
  String _currentSortOption = 'Default';

  bool _isLoadingMore = false;
  String? _nextPageUrl;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String get currentSortOption => _currentSortOption;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _nextPageUrl != null;

  setFilteredProducts(List<Product> products) async {
    log("Setting filtered products: ${products.length}");
    _originalProducts = List.from(products);
    _allProducts = products;
    log("After setting - allProducts length: ${_allProducts.length}");
    notifyListeners();
  }

  void updateWishList(bool isWishlist, int productId) {
    final productIndex =
        _allProducts.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _allProducts[productIndex].isWishlist = !isWishlist;

      // Also update in original list
      final originalIndex =
          _originalProducts.indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _originalProducts[originalIndex].isWishlist = !isWishlist;
      }

      notifyListeners();
    }
  }

  void updateOfferWishList(bool isWishlist, int productId) {
    final productIndex =
        _offerProducts.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _offerProducts[productIndex].isWishlist = !isWishlist;

      // Also update in original list
      final originalIndex = _originalOfferProducts
          .indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _originalOfferProducts[originalIndex].isWishlist = !isWishlist;
      }

      notifyListeners();
    }
  }

  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final productIndex =
        _allProducts.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _allProducts[productIndex].isCart = !isCart;

      // Also update in original list
      final originalIndex =
          _originalProducts.indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _originalProducts[originalIndex].isCart = !isCart;
      }

      notifyListeners();
    }
  }

  Future<void> updateOfferCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final productIndex =
        _offerProducts.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _offerProducts[productIndex].isCart = !isCart;

      // Also update in original list
      final originalIndex = _originalOfferProducts
          .indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _originalOfferProducts[originalIndex].isCart = !isCart;
      }

      notifyListeners();
    }
  }

  Future<void> getCategoryProductList(
      {String? categoryId, bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _isLoading = true;
      _nextPageUrl = null;
      _allProducts = [];
    }

    try {
      final result = await productListRepository.getCotegoryProductList(
        categoryId!,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

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
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getSubCategoryProductList(
      {String? subCategoryId, bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _isLoading = true;
      _nextPageUrl = null;
      _allProducts = [];
    }

    try {
      final result = await productListRepository.getSubCotegoryProductList(
        subCategoryId!,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

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
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> getOfferProductList(BuildContext context,
      {bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !hasMoreData) return;
      _isLoadingMore = true;
      notifyListeners();
    } else {
      _isLoading = true;
      _nextPageUrl = null;
      // _allProducts = [];
    }

    try {
      final result = await productListRepository.getOfferProducts(
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      if (loadMore) {
        _offerProducts.addAll(result.products);
        _originalOfferProducts.addAll(result.products);
      } else {
        _offerProducts = result.products;
        _originalOfferProducts = List.from(result.products);
      }

      _nextPageUrl = result.nextPage;
      notifyListeners();
    } catch (e) {
      log("error : ${e.toString()}");
      Fluttertoast.showToast(
          msg: "Something went wrong",
          textColor: cWhiteColor,
          backgroundColor: cBottomNav);
      context.read<BottomNavProvider>().updateIndex(0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavWidget(),
        ),
        (route) => false,
      );
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
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

  appendProducts(List<Product> newProducts) {
    log("Appending ${newProducts.length} products to existing ${_allProducts.length}");
    _allProducts.addAll(newProducts);
    _originalProducts.addAll(List.from(newProducts));
    log("After appending - total products: ${_allProducts.length}");
    notifyListeners();
  }
}
