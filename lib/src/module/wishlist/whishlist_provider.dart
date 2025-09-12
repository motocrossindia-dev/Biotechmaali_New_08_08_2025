import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/widgets/add_to_wishlist.dart';
import 'package:biotech_maali/src/module/wishlist/model/wishlist_model.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _wishlistRepository = WishlistRepository();
  List<WishlistModel> _products = [];
  bool _isLoading = false;
  String? _error;

  WishlistProvider() {
    fetchWishlist();
  }

  List<WishlistModel> get products => _products;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWishlist() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final WishlistResponse response = await _wishlistRepository.getWishlist();
      _products = response
          .wishlists; // Changed from response.products to response.wishlists
      notifyListeners();
    } catch (e) {
      log("error: ${e.toString()}");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    // final cartProvider = context.read<CartProvider>();
    // await cartProvider.fetchCartItems();

    final productIndex =
        _products.indexWhere((product) => product.productId == productId);
    if (productIndex != -1) {
      _products[productIndex].isCart = !isCart;

      // Also update in original list
      final originalIndex =
          _products.indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _products[originalIndex].isCart = !isCart;
      }

      notifyListeners();
    }
  }

  Future<void> addToWishlist(int productId) async {
    try {
      bool result = await _wishlistRepository.addToWishlist(productId);
      if (result) {
        Fluttertoast.showToast(msg: "Product added to whishlist successfully");
      }
      // await fetchWishlist(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(int productId, BuildContext context) async {
    try {
      bool result = await _wishlistRepository.removeFromWishlist(productId);
      if (result) {
        _products.removeWhere((item) => item.id == productId);
        notifyListeners();
        final homeProvider = context.read<HomeProvider>();
        homeProvider.fetchHomeProducts();
        Fluttertoast.showToast(msg: "Item deleted from the wishlist");
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addOrRemoveWhishlistMainProduct(
      int productId, BuildContext context) async {
    // Add productId to loading set

    notifyListeners();

    try {
      bool result =
          await _wishlistRepository.addOrRemoveWishListMainProduct(productId);
      if (result) {
        await fetchWishlist();
        showWishlistMessage(context, true);

        return true;
      } else {
        showWishlistMessage(context, false);
        return true;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      // Remove productId from loading set

      notifyListeners();
    }
  }

  Future<bool> addOrRemoveWhishlistCompinationProduct(
      int productId, BuildContext context) async {
    // Add productId to loading set

    notifyListeners();

    try {
      bool result = await _wishlistRepository
          .addOrRemoveWhishlistCompinationProduct(productId);
      if (result) {
        await fetchWishlist();
        showWishlistMessage(context, true);

        return true;
      } else {
        showWishlistMessage(context, false);
        return true;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      // Remove productId from loading set

      notifyListeners();
    }
  }
}
