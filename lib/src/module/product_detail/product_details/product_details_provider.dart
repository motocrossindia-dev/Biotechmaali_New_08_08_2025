import 'dart:developer';

import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_repository.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_response_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/recently_viewed_model.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/add_to_cart.dart';
import 'package:biotech_maali/src/widgets/add_to_wishlist.dart';
import 'package:biotech_maali/src/widgets/delivery_unavailable_dialog.dart';
import 'package:biotech_maali/src/widgets/min_order_value_dialog.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_repository.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/in_app_messaging_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../import.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductDetailsRepository productDetailsRepository =
      ProductDetailsRepository();

  final CartRepository _cartRepository = CartRepository();

  ProductDetailsProvider() {
    updateQuantity();
  }

  bool _isLoading = false;
  String? _error;
  int _carouselIndex = 0;
  int _quantity = 1;
  // bool _isWishlist = false;
  bool _isLoadingWishList = false;
  OrderResponseModel? _orderResponse;
  ProductDetailModel? _productDetails;
  List<String> _carouselProductImageList = [];
  List<ProductAddOn> _productAddOn = [];
  List<RecentlyViewedProduct> _recentlyViewedProductList = [];

  String? _productVideo = "";
  String? _whatsIncluded = "";

  // Selected IDs
  int? _selectedSizeId;
  int? _selectedPlanterSizeId;
  int? _selectedPlanterId;
  int? _selectedLitreId;
  int? _selectedColorId;
  int? _selectedWeightId;

  // Current product slug (for API calls)
  String _currentSlug = '';

  // New property for selected tab
  int _selectedTab = 0;

  // Pincode check properties
  bool _isCheckingPincode = false;
  bool? _isDeliveryAvailable;
  String? _deliveryState;
  String? _deliveryPincode;
  String? _pincodeError;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get carouselIndex => _carouselIndex;
  int get quantity => _quantity;
  // bool get isWishlist => _isWishlist;
  bool get isLoadingWishList => _isLoadingWishList;
  OrderResponseModel? get orderResponse => _orderResponse;
  ProductDetailModel? get productDetails => _productDetails;
  List<String> get carouselProductImageList => _carouselProductImageList;
  List<ProductAddOn> get productAddOn => _productAddOn;
  List<RecentlyViewedProduct> get recentlyViewedProductList =>
      _recentlyViewedProductList;
  String? get productVideo => _productVideo;
  String? get whatsIncluded => _whatsIncluded;

  int? get selectedSizeId => _selectedSizeId;
  int? get selectedPlanterSizeId => _selectedPlanterSizeId;
  int? get selectedPlanterId => _selectedPlanterId;
  int? get selectedLitreId => _selectedLitreId;
  int? get selectedColorId => _selectedColorId;
  int? get selectedWeightId => _selectedWeightId;
  String get currentSlug => _currentSlug;

  // Getter for selected tab
  int get selectedTab => _selectedTab;

  // Getters for pincode check
  bool get isCheckingPincode => _isCheckingPincode;
  bool? get isDeliveryAvailable => _isDeliveryAvailable;
  String? get deliveryState => _deliveryState;
  String? get deliveryPincode => _deliveryPincode;
  String? get pincodeError => _pincodeError;

  void updateQuantity() {
    _quantity = 1;
  }

  // Method to set selected tab
  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void updateWishList(bool isWishlist, int productId) {
    final productIndex = _recentlyViewedProductList
        .indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _recentlyViewedProductList[productIndex].isWishlist = !isWishlist;

      // Also update in original list
      final originalIndex = _recentlyViewedProductList
          .indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _recentlyViewedProductList[originalIndex].isWishlist = !isWishlist;
      }

      notifyListeners();
    }
  }

  Future<void> updateCart(
      bool isCart, int productId, BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    await cartProvider.fetchCartItems();

    final productIndex = _recentlyViewedProductList
        .indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _recentlyViewedProductList[productIndex].isCart = !isCart;

      // Also update in original list
      final originalIndex = _recentlyViewedProductList
          .indexWhere((product) => product.id == productId);
      if (originalIndex != -1) {
        _recentlyViewedProductList[originalIndex].isCart = !isCart;
      }

      notifyListeners();
    }
  }

  Future<void> fetchProductDetails(String slug) async {
    // Guard: if already loading the same slug, skip
    if (_isLoading && _currentSlug == slug) return;

    _isLoading = true;
    _error = null;
    _currentSlug = slug;
    // Clear stale data from the previous product so the new screen
    // shows the shimmer instead of the old product's content.
    _productDetails = null;
    _carouselProductImageList = [];
    _productAddOn = [];
    notifyListeners();

    try {
      final details =
          await productDetailsRepository.fetchProductDetails(slug);
      _productDetails = details;

      // Track view product analytics
      AnalyticsService().logScreenView(
        screenName: 'Product: ${details.data.product.mainProductName}',
      );
      AnalyticsService().logViewProduct(
        productId: details.data.product.id.toString(),
        productName: details.data.product.mainProductName,
        price: details.data.product.sellingPrice,
      );
      // Trigger FIAM product detail campaign
      InAppMessagingService().triggerProductDetailView();

      log("===== INITIAL PRODUCT DETAILS =====");
      log("Slug: $slug");
      log("Images count: ${details.data.product.images.length}");
      log("Images: ${details.data.product.images.map((img) => img.image).toList()}");

      _updateCarouselImages();

      // Set default selections
      _selectedSizeId = details.data.product.sizeId;
      _selectedPlanterSizeId = details.data.product.planterSizeId;
      _selectedPlanterId = details.data.product.planterId;
      _selectedColorId = details.data.product.colorId;
      _selectedWeightId = details.data.product.weightId;
      _selectedLitreId = details.data.product.litreId;
      _productAddOn = details.data.productAddOns;
      _productVideo = details.data.product.videoLink;
      _whatsIncluded = details.data.product.whatsIncluded;

      log("Default selections - SizeId: $_selectedSizeId, PlanterSizeId: $_selectedPlanterSizeId, PlanterId: $_selectedPlanterId, ColorId: $_selectedColorId, WeightId: $_selectedWeightId, LitreId: $_selectedLitreId");

      _isLoading = false;
      notifyListeners();

      // Automatically apply default combination filter to get correct images
      await _applyDefaultCombination(slug);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // New method to apply default combination filter
  Future<void> _applyDefaultCombination(String slug) async {
    try {
      // Only apply filter if there are any combinations available
      bool hasCombinations = _selectedSizeId != null ||
          _selectedPlanterSizeId != null ||
          _selectedPlanterId != null ||
          _selectedColorId != null ||
          _selectedWeightId != null ||
          _selectedLitreId != null;

      log("===== CHECKING DEFAULT COMBINATION =====");
      log("Has combinations: $hasCombinations");
      log("Slug: $slug");
      log("SizeId: $_selectedSizeId, PlanterSizeId: $_selectedPlanterSizeId, PlanterId: $_selectedPlanterId, ColorId: $_selectedColorId, WeightId: $_selectedWeightId, LitreId: $_selectedLitreId");

      if (hasCombinations) {
        log("Applying default combination filter for slug: $slug");

        if (_selectedPlanterSizeId != null) {
          await _filterProduct(
            slug: slug,
            planterSizeId: _selectedPlanterSizeId,
            colorId: _selectedColorId,
          );
        } else if (_selectedSizeId != null) {
          await _filterProduct(
            slug: slug,
            sizeId: _selectedSizeId,
          );
        } else if (_selectedLitreId != null) {
          await _filterProduct(
            slug: slug,
            litreId: _selectedLitreId,
          );
        } else if (_selectedWeightId != null) {
          await _filterProduct(
            slug: slug,
            weightId: _selectedWeightId,
          );
        } else if (_selectedPlanterId != null) {
          await _filterProduct(
            slug: slug,
            planterId: _selectedPlanterId,
          );
        } else if (_selectedColorId != null) {
          await _filterProduct(
            slug: slug,
            colorId: _selectedColorId,
          );
        }

        log("===== AFTER FILTER APPLIED =====");
        log("Images count: ${_productDetails?.data.product.images.length ?? 0}");
        log("Images: ${_productDetails?.data.product.images.map((img) => img.image).toList()}");
      } else {
        log("No combinations available, skipping filter");
      }
    } catch (e) {
      log("Error applying default combination: $e");
      // Don't throw error here, just log it
    }
  }

  Future<void> fetchRecentlyViewed() async {
    try {
      final result =
          await productDetailsRepository.fetchRecentlyViewedProduts();

      _recentlyViewedProductList = result.data.products;
      notifyListeners();
    } catch (e) {
      log("Error : ${e.toString()} ");
    }
  }

  Future<bool> addToCartMainProduct(
      int productId, bool isCart, BuildContext context) async {
    log("productId add to cart : $productId");
    try {
      // _isLoading = true;
      notifyListeners();

      final success = await _cartRepository.addToCartForMainProduct(
        productId,
      );

      if (success) {
        final cartProvider = context.read<CartProvider>();
        await cartProvider
            .fetchCartItems(); // Refresh cart items after successful addition

        final productIndex =
            _productAddOn.indexWhere((product) => product.id == productId);
        if (productIndex != -1) {
          final product = _productAddOn[productIndex];
          _productAddOn[productIndex].isCart = !isCart;

          // Track add to cart analytics
          if (!isCart) {
            AnalyticsService().logAddToCart(
              productId: product.id.toString(),
              productName: product.name,
              price: product.sellingPrice,
              quantity: 1,
            );
          }

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
      _error = e.toString();
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

  Future<void> updateSize(int sizeId) async {
    if (_selectedSizeId == sizeId) return;
    await _filterProduct(slug: _currentSlug, sizeId: sizeId);
  }

  Future<void> updatePlanterSize(int planterSizeId) async {
    if (_selectedPlanterSizeId == planterSizeId) return;
    await _filterProduct(
      slug: _currentSlug,
      planterSizeId: planterSizeId,
      colorId: _selectedColorId,
    );
  }

  Future<void> updatePlanter(int planterId) async {
    if (_selectedPlanterId == planterId) return;
    await _filterProduct(
      slug: _currentSlug,
      planterSizeId: _selectedPlanterSizeId,
      planterId: planterId,
    );
  }

  Future<void> updateLitre(int litreId) async {
    if (_selectedLitreId == litreId) return;
    log("litre Id : $litreId");
    await _filterProduct(slug: _currentSlug, litreId: litreId);
  }

  Future<void> updateColor(int colorId) async {
    if (_selectedColorId == colorId) return;
    await _filterProduct(
      slug: _currentSlug,
      sizeId: _selectedSizeId,
      planterSizeId: _selectedPlanterSizeId,
      planterId: _selectedPlanterId,
      colorId: colorId,
    );
  }

  Future<void> updateColorForPot(int colorId) async {
    if (_selectedColorId == colorId) return;
    await _filterProduct(
      slug: _currentSlug,
      planterSizeId: _selectedPlanterSizeId,
      litreId: _selectedLitreId,
      colorId: colorId,
    );
  }

  Future<void> updateWeight(int weightId) async {
    if (_selectedWeightId == weightId) return;
    await _filterProduct(slug: _currentSlug, weightId: weightId);
  }

  Future<void> _filterProduct({
    required String slug,
    int? sizeId,
    int? planterSizeId,
    int? planterId,
    int? litreId,
    int? colorId,
    int? weightId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      log("===== CALLING FILTER API =====");
      log("Slug: $slug, SizeId: $sizeId, PlanterSizeId: $planterSizeId, PlanterId: $planterId, LitreId: $litreId, ColorId: $colorId, WeightId: $weightId");

      final filteredDetails = await productDetailsRepository.filterProduct(
          slug: slug,
          sizeId: sizeId,
          planterSizeId: planterSizeId,
          planterId: planterId,
          litreId: litreId,
          colorId: colorId,
          weightId: weightId);

      log("===== FILTER API RESPONSE =====");
      log("Images count: ${filteredDetails.data.product.images.length}");
      log("Images: ${filteredDetails.data.product.images.map((img) => img.image).toList()}");

      // Update selected IDs
      if (sizeId != null) _selectedSizeId = sizeId;
      if (planterSizeId != null) _selectedPlanterSizeId = planterSizeId;
      if (planterId != null) _selectedPlanterId = planterId;
      if (litreId != null) _selectedLitreId = litreId;
      if (colorId != null) _selectedColorId = colorId;
      if (weightId != null) _selectedWeightId = weightId;

      // Preserve ratings and reviews from original product details
      if (_productDetails != null) {
        // The filter API response does not return GST fields — carry them over
        // from the original product so prices stay GST-inclusive.
        final originalGst = _productDetails!.data.product.gst;
        final filteredProduct =
            filteredDetails.data.product.gst == null && originalGst != null
                ? filteredDetails.data.product.copyWithGst(originalGst)
                : filteredDetails.data.product;

        final ProductDetailModel mergedDetails = ProductDetailModel(
          message: filteredDetails.message,
          data: ProductData(
            productAddOns: filteredDetails.data.productAddOns,
            productType: filteredDetails.data.productType,
            product: filteredProduct,
            productSizes: filteredDetails.data.productSizes,
            productPlanterSizes: filteredDetails.data.productPlanterSizes,
            productPlanters: filteredDetails.data.productPlanters,
            productLitres: filteredDetails.data.productLitres,
            productColors: filteredDetails.data.productColors,
            productWeights: filteredDetails.data.productWeights,
            productRating: _productDetails!.data.productRating,
            productReviews: _productDetails!.data.productReviews,
          ),
        );

        log("Litre : ${filteredDetails.data.productLitres}");
        log("weight : ${filteredDetails.data.productWeights}");
        log("Product size : ${filteredDetails.data.productSizes}");
        log("planter size : ${filteredDetails.data.productPlanterSizes}");
        log("Planter : ${filteredDetails.data.productPlanters}");
        log("color : ${filteredDetails.data.productColors}");

        _productDetails = mergedDetails;

        _selectedSizeId = mergedDetails.data.product.sizeId;
        _selectedPlanterSizeId = mergedDetails.data.product.planterSizeId;
        _selectedPlanterId = mergedDetails.data.product.planterId;
        _selectedLitreId = mergedDetails.data.product.litreId;
        _selectedColorId = mergedDetails.data.product.colorId;
        _selectedWeightId = mergedDetails.data.product.weightId;
      } else {
        _productDetails = filteredDetails;
      }

      _updateCarouselImages();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrRemoveWhishlistCompinationProduct(
      int productId, bool isWishlist, BuildContext context) async {
    _isLoadingWishList = true;
    notifyListeners();

    try {
      bool result = await productDetailsRepository
          .addOrRemoveWhishlistCompinationProduct(productId);
      if (result) {
        _productDetails!.data.product.isWishlist =
            !_productDetails!.data.product.isWishlist;

        notifyListeners(); // Notify listeners about the update

        if (isWishlist) {
          showWishlistMessage(context, false);
        } else if (!isWishlist) {
          showWishlistMessage(context, true);
        }
      } else {
        // _isWishlist = false;
        showWishlistMessage(context, false);
        notifyListeners();
      }
      await context.read<WishlistProvider>().fetchWishlist();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      // Remove productId from loading set
      _isLoadingWishList = false;

      notifyListeners();
    }
  }

  Future<void> placeOrder(int productId, BuildContext context) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _orderResponse =
          await productDetailsRepository.buySingleProduct(productId, quantity);

      _isLoading = false;
      Fluttertoast.showToast(msg: "Order initiated successfully");
      context
          .read<OrderSummaryProvider>()
          .setOrderSummaryData(orderResponse!.data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSummaryScreen(
            // orderData: _orderResponse!.data,
            isSingleProduct: true,
          ),
        ),
      );
    } on ProfileNotUpdatedException {
      _error = 'Please update your profile first';
      Fluttertoast.showToast(msg: _error!);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EditProfileScreen(
                  isPlaceOrder: true,
                )),
      );
    } on AddressNotUpdatedException {
      _error = 'Please add delivery address';
      Fluttertoast.showToast(msg: _error!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddEditAddressScreen(
            isAddAddress: true,
          ),
        ),
      );
    } on MinOrderValueException catch (e) {
      _error = e.message;
      MinOrderValueDialog.show(
        context,
        message: e.message,
        minimumOrderValue: e.minimumOrderValue,
        currentOrderValue: e.currentOrderValue,
      );
    } catch (e) {
      _error = e.toString();
      String errorMessage = _error!.toLowerCase();

      // Check if it's a server error (500)
      if (errorMessage.contains('status code of 500') ||
          errorMessage.contains('server error') ||
          errorMessage.contains('dioexception')) {
        Fluttertoast.showToast(
          msg: "Server is temporarily unavailable. Please try again later.",
          backgroundColor: Colors.red,
        );
      }
      // Check if error is related to delivery/pincode
      else if (errorMessage.contains('delivery not available') ||
          errorMessage.contains('pincode')) {
        // Extract the actual error message
        String displayMessage = _error!
            .replaceAll('Exception: ', '')
            .replaceAll('Failed to place order: ', '');

        // Show delivery unavailable dialog
        DeliveryUnavailableDialog.show(context, displayMessage);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again.",
          backgroundColor: Colors.red,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _updateCarouselImages() {
    if (_productDetails != null) {
      _carouselProductImageList = _productDetails!.data.product.images
          .map((image) => image.image.startsWith('http')
              ? image.image
              : '${BaseUrl.baseUrlForImages}${image.image}')
          .toList();

      // Preload images for better performance
      _preloadImages();
    }
  }

  void _preloadImages() {
    for (String imageUrl in _carouselProductImageList) {
      // Preload images using Image.network's precacheImage
      try {
        NetworkImage(imageUrl);
      } catch (e) {
        log('Error preloading image: $imageUrl - $e');
      }
    }
  }

  void increaseQuantity(int newQuantity, int productId) async {
    bool result = await productDetailsRepository.increaseOrDecreaseQty(
        _quantity, productId.toString(), true);

    if (result) {
      _quantity += newQuantity;
      AnalyticsService().logQuantityChanged(
        productId: productId.toString(),
        productName: _productDetails?.data.product.mainProductName ?? '',
        newQuantity: _quantity,
      );
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "Item is out of stock");
    }
  }

  void decreaseQuantity(int newQuantity, int productId) async {
    bool result = await productDetailsRepository.increaseOrDecreaseQty(
        _quantity, productId.toString(), false);

    if (result == true) {
      if (_quantity > 1) {
        _quantity -= newQuantity;
        AnalyticsService().logQuantityChanged(
          productId: productId.toString(),
          productName: _productDetails?.data.product.mainProductName ?? '',
          newQuantity: _quantity,
        );
        notifyListeners();
      }
    }
  }

  void onCarouselIndexChange(int current) {
    _carouselIndex = current;
    notifyListeners();
  }

  Future<void> checkDeliveryPincode(String pincode) async {
    try {
      _isCheckingPincode = true;
      _pincodeError = null;
      notifyListeners();

      final result =
          await productDetailsRepository.checkDeliveryPincode(pincode);

      _deliveryPincode = result['pincode'];
      _deliveryState = result['state'];
      _isDeliveryAvailable = result['delivery_available'];
      AnalyticsService().logPincodeCheck(
        pincode: pincode,
        isDeliverable: _isDeliveryAvailable ?? false,
      );
    } catch (e) {
      _pincodeError = "we are not delivering to this area, we will come soon";
      _isDeliveryAvailable = null;
      _deliveryState = null;
      AnalyticsService()
          .logPincodeCheck(pincode: pincode, isDeliverable: false);
    } finally {
      _isCheckingPincode = false;
      notifyListeners();
    }
  }

  void clearPincodeCheck() {
    _isDeliveryAvailable = null;
    _deliveryState = null;
    _deliveryPincode = null;
    _pincodeError = null;
    notifyListeners();
  }
}
