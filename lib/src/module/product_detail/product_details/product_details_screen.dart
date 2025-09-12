import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_shimmer.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/planter_size_widget.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/pot_litre_widget.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/product_list_addon_widget.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/product_list_recently_viewed_widget.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/seed_weight_widget.dart';
import 'package:biotech_maali/src/widgets/add_to_cart.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:flutter/services.dart';
import '../../../../import.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({required this.productId, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _pincodeController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductDetailsProvider>();
      // provider.fetchProductDetails(widget.productId);
      provider.updateQuantity();
      provider.fetchRecentlyViewed();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  Widget _buildPincodeChecker() {
    final provider = context.watch<ProductDetailsProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04), // Responsive padding
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check Delivery Availability',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: _pincodeController,
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit pincode',
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: Colors.grey[600], size: 20),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          borderSide:
                              BorderSide(color: cButtonGreen, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        counterText: "",
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(fontSize: 15),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  constraints: BoxConstraints(
                    minWidth: screenWidth * 0.2, // Responsive button width
                    maxWidth: screenWidth * 0.25,
                  ),
                  decoration: BoxDecoration(
                    color: cButtonGreen,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      onTap: provider.isCheckingPincode
                          ? null
                          : () {
                              if (_pincodeController.text.length == 6) {
                                provider.checkDeliveryPincode(
                                    _pincodeController.text);
                                FocusScope.of(context).unfocus();
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        child: provider.isCheckingPincode
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Check',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.isDeliveryAvailable != null)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: provider.isDeliveryAvailable!
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: provider.isDeliveryAvailable!
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      provider.isDeliveryAvailable!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: provider.isDeliveryAvailable!
                          ? Colors.green
                          : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        provider.isDeliveryAvailable!
                            ? 'Delivery available to ${provider.deliveryState}'
                            : 'Delivery not available to this location',
                        style: TextStyle(
                          color: provider.isDeliveryAvailable!
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (provider.pincodeError != null)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        provider.pincodeError!,
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _calculateDiscountPercentage(double sellingPrice, double mrp) {
    if (mrp <= 0 || sellingPrice <= 0 || sellingPrice >= mrp) {
      return '0% OFF';
    }

    final percentage = (100 - (sellingPrice / mrp * 100));

    if (percentage.isNaN || percentage.isInfinite || percentage <= 0) {
      return '0% OFF';
    }

    return '${percentage.toInt()}% OFF';
  }

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = context.watch<ProductDetailsProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: productDetailsProvider
                  .productDetails?.data.product.mainProductName ??
              "Product Details",
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titleSpacing: 8,
      ),
      body: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ProductDetailsShimmer();
          }

          ProductDetailModel? product = provider.productDetails;
          if (product == null) {
            return const Center(
              child: Text('Data is not available'),
            );
          }
          log("Product Id in UI: ${widget.productId}");
          ProductData productDetail = product.data;

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Carousel
                    const CaroucelProductWidget(),

                    const SizedBox(height: 12),

                    // Product Information Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title and Wishlist
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CommonTextWidget(
                                  title: product.data.product.mainProductName,
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: provider.isLoadingWishList
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.red.shade200,
                                        highlightColor: Colors.red.shade50,
                                        period:
                                            const Duration(milliseconds: 1200),
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        icon: productDetail.product.isWishlist
                                            ? const Icon(Icons.favorite,
                                                color: Colors.red, size: 24)
                                            : SvgPicture.asset(
                                                'assets/svg/icons/heart_unselected.svg',
                                                color: Colors.black54,
                                                height: 24,
                                                width: 24,
                                              ),
                                        onPressed: () {
                                          provider
                                              .addOrRemoveWhishlistCompinationProduct(
                                                  productDetail.product.id,
                                                  productDetail
                                                      .product.isWishlist,
                                                  context);
                                        },
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Price and Rating Section
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RatingsAndReviews(
                                    productData: productDetail,
                                    productId: widget.productId,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Price Row
                                Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    CommonTextWidget(
                                      title:
                                          '₹${productDetail.product.sellingPrice}',
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: cProductRate,
                                    ),
                                    if (productDetail.product.mrp >
                                        productDetail.product.sellingPrice)
                                      CommonTextWidget(
                                        title: '₹${productDetail.product.mrp}',
                                        fontSize: isTablet ? 14 : 12,
                                        fontWeight: FontWeight.w400,
                                        color: cProductRateCrossed,
                                        lineThrough: TextDecoration.lineThrough,
                                      ),
                                    if (productDetail.product.mrp >
                                        productDetail.product.sellingPrice)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: cButtonGreen,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: CommonTextWidget(
                                          title: _calculateDiscountPercentage(
                                              productDetail
                                                  .product.sellingPrice,
                                              productDetail.product.mrp),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Rating
                                ProductDetailsRatingWidget(
                                  productRating: productDetail.productRating,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Product Variants Section
                          // Product Variants Section
                          // Product Sizes
                          if (productDetail.productSizes.isNotEmpty) ...[
                            CommonTextWidget(
                              title: productDetail.productType == "plant"
                                  ? "Select Plant Size"
                                  : productDetail.productType == "tool"
                                      ? 'Select Tool Size'
                                      : productDetail.productType == "seed"
                                          ? "Select Seed Size"
                                          : productDetail.productType == "pot"
                                              ? "Select Pot Size"
                                              : "Select Size",
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productDetail.productSizes.length,
                                itemBuilder: (context, index) {
                                  ProductSize productSize =
                                      productDetail.productSizes[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ProductSizeWidget(
                                      id: productSize.id,
                                      name: productSize.size,
                                      event: () {
                                        provider.updateSize(productSize.id,
                                            productDetail.product.id);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Planter Sizes
                          if (productDetail.productPlanterSizes.isNotEmpty) ...[
                            CommonTextWidget(
                              title: 'Select Planter Size',
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    productDetail.productPlanterSizes.length,
                                itemBuilder: (context, index) {
                                  ProductPlanterSize productPlanterSizes =
                                      productDetail.productPlanterSizes[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: PlanterSizeWidget(
                                      id: productPlanterSizes.id,
                                      name: productPlanterSizes.size,
                                      event: () {
                                        provider.updatePlanterSize(
                                            productPlanterSizes.id,
                                            productDetail.product.id);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Planters
                          if (productDetail.productPlanters.isNotEmpty) ...[
                            CommonTextWidget(
                              title: 'Select Planter',
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productDetail.productPlanters.length,
                                itemBuilder: (context, index) {
                                  ProductPlanter productPlanter =
                                      productDetail.productPlanters[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: PlanterWidget(
                                      id: productPlanter.id,
                                      name: productPlanter.name,
                                      event: () {
                                        provider.updatePlanter(
                                            productPlanter.id,
                                            productDetail.product.id);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Litres
                          if (productDetail.productLitres.isNotEmpty) ...[
                            CommonTextWidget(
                              title: 'Select Litre',
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productDetail.productLitres.length,
                                itemBuilder: (context, index) {
                                  ProductLitre productLitre =
                                      productDetail.productLitres[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: PotLitreWidget(
                                      id: productLitre.id,
                                      name: productLitre.name.toString(),
                                      event: () {
                                        provider.updateLitre(
                                          productLitre.id,
                                          productDetail.product.id,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Weights
                          if (productDetail.productWeights.isNotEmpty) ...[
                            CommonTextWidget(
                              title: 'Select Product Weight',
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productDetail.productWeights.length,
                                itemBuilder: (context, index) {
                                  ProductWeight productWeight =
                                      productDetail.productWeights[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SeedWeightWidget(
                                      id: productWeight.id,
                                      name:
                                          "${productWeight.sizeGrams.toString()} gm",
                                      event: () {
                                        provider.updateWeight(productWeight.id,
                                            productDetail.product.id);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),

                    // Colors and Quantity Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Colors
                          if (productDetail.productColors.isNotEmpty) ...[
                            CommonTextWidget(
                              title: 'Color:',
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productDetail.productColors.length,
                                itemBuilder: (context, index) {
                                  ProductColor productColor =
                                      productDetail.productColors[index];
                                  Color color = Color(int.parse(
                                          productColor.colorCode.substring(1),
                                          radix: 16) |
                                      0xFF000000);
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ColorContainerWidget(
                                      onTap: () {
                                        if (productDetail.productType ==
                                            "pot") {
                                          provider.updateColorForPot(
                                              productColor.id,
                                              productDetail.product.id);
                                          return;
                                        }
                                        provider.updateColor(productColor.id,
                                            productDetail.product.id);
                                      },
                                      color: color,
                                      isSelected: provider.selectedColorId ==
                                              productColor.id
                                          ? true
                                          : false,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Quantity
                          Row(
                            children: [
                              CommonTextWidget(
                                title: 'Qty: ',
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(width: 16),
                              AddQuantityWidget(
                                quantity: provider.quantity,
                                addition: () {
                                  provider.increaseQuantity(
                                      1, productDetail.product.id);
                                },
                                substaction: () {
                                  provider.decreaseQuantity(
                                      1, productDetail.product.id);
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Pincode Checker
                          _buildPincodeChecker(),

                          // Add-ons
                          if (provider.productAddOn.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const ProductListAddonWidget(title: 'Add On'),
                          ] else ...[
                            const SizedBox(height: 20),
                          ],

                          // Product Description
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: ProductDescription(provider: provider),
                          ),

                          const SizedBox(height: 20),

                          // Recently Viewed
                          const ProductListRecentlyViewedWidget(
                              title: 'Recently Viewed'),

                          // Bottom padding for fixed buttons
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                    sizedBoxHeight15
                  ],
                ),
              ),

              // Fixed Bottom Buttons
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cWhiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: isTablet ? 52 : 48,
                            child: provider.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: cButtonGreen,
                                      color: cButtonRed,
                                    ),
                                  )
                                : CustomizableBorderColoredButton(
                                    title: 'BUY NOW',
                                    event: () async {
                                      final settingsProvider =
                                          context.read<SettingsProvider>();
                                      bool isAuth = await settingsProvider
                                          .checkAccessTokenValidity(context);

                                      if (!isAuth) {
                                        _showLoginDialog(
                                            context, productDetail.product.id);
                                        return;
                                      }
                                      provider.placeOrder(
                                          productDetail.product.id, context);
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: isTablet ? 52 : 48,
                            child: CustomizableButton(
                              title: productDetail.product.isCart
                                  ? "ITEM IN CART"
                                  : 'ADD TO CART',
                              event: productDetail.product.isCart
                                  ? () {
                                      // Fluttertoast.showToast(
                                      //   msg: "Item already in cart",
                                      //   backgroundColor: Colors.black87,
                                      //   textColor: Colors.white,
                                      // );

                                      showCartMessage(context, false);
                                    }
                                  : () async {
                                      bool? isAuthenticated = await context
                                          .read<SettingsProvider>()
                                          .checkAccessTokenValidity(context);
                                      if (isAuthenticated) {
                                        final productDetailProvider = context
                                            .read<ProductDetailsProvider>();
                                        bool result = await context
                                            .read<CartProvider>()
                                            .addToCart(
                                                product.data.product.id,
                                                productDetailProvider.quantity,
                                                context);
                                        if (result) {
                                          productDetail.product.isCart = true;
                                          setState(() {
                                            // Update UI to reflect item added to cart
                                          });
                                        }
                                      } else {
                                        _showLoginDialog(
                                            context, productDetail.product.id);
                                        return;
                                      }
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _showLoginDialog(BuildContext context, int productId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoginPromptDialog(productId: productId);
    },
  );
}
