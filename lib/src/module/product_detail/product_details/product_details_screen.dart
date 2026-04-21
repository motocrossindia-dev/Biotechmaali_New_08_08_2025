import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/product_details_shimmer.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/product_list_addon_widget.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/product_list_recently_viewed_widget.dart';
import 'package:biotech_maali/src/widgets/add_to_cart.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:flutter/services.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
import '../../../../import.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String slug;
  const ProductDetailsScreen({required this.slug, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  final _pincodeController = TextEditingController();
  bool _isInitialized = false;
  late TabController _tabController;

  static const List<String> _tabTitles = [
    'Description',
    'Care Guide',
    "What's Included",
    'Reviews',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    AnalyticsService().logScreenView(screenName: ScreenNames.productDetails);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductDetailsProvider>();
      provider.updateQuantity();
      provider.fetchRecentlyViewed();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<ProductDetailsProvider>();
        provider.fetchProductDetails(widget.slug);
      });
    }
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productDetailsProvider = context.watch<ProductDetailsProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: productDetailsProvider
                  .productDetails?.data.product.mainProductName ??
              'Product Details',
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titleSpacing: 8,
      ),
      body: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.productDetails == null) {
            return const ProductDetailsShimmer();
          }

          ProductDetailModel? product = provider.productDetails;
          if (product == null) {
            return const Center(child: Text('Data is not available'));
          }
          log("Product slug in UI: ${widget.slug}");
          ProductData productDetail = product.data;

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image Carousel ──────────────────────────────────
                    const CaroucelProductWidget(),

                    const SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Product Name + Wishlist ──────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CommonTextWidget(
                                  title:
                                      productDetail.product.mainProductName,
                                  fontSize: isTablet ? 22 : 19,
                                  fontWeight: FontWeight.w700,
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
                                        period: const Duration(
                                            milliseconds: 1200),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        constraints: const BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        icon: productDetail.product.isWishlist
                                            ? const Icon(Icons.favorite,
                                                color: Colors.red, size: 26)
                                            : SvgPicture.asset(
                                                'assets/svg/icons/heart_unselected.svg',
                                                color: Colors.black54,
                                                height: 26,
                                                width: 26,
                                              ),
                                        onPressed: () {
                                          provider
                                              .addOrRemoveWhishlistCompinationProduct(
                                            productDetail.product.id,
                                            productDetail.product.isWishlist,
                                            context,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // ── Stock Status ─────────────────────────────
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: productDetail.product.isBuyable
                                      ? const Color(0xFF2E7D32)
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                productDetail.product.isBuyable
                                    ? 'In stock (${productDetail.product.stockWord})'
                                    : 'Out of stock',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: productDetail.product.isBuyable
                                      ? const Color(0xFF2E7D32)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ── Price + Rating ───────────────────────────
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RatingsAndReviews(
                                    productData: productDetail,
                                    productId: productDetail.product.id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '₹${productDetail.product.sellingPrice.toInt()}',
                                      style: TextStyle(
                                        fontSize: isTablet ? 22 : 20,
                                        fontWeight: FontWeight.w700,
                                        color: cProductRate,
                                      ),
                                    ),
                                    if (productDetail.product.mrp >
                                        productDetail
                                            .product.sellingPrice) ...[
                                      Text(
                                        '₹${productDetail.product.mrp.toInt()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: cProductRateCrossed,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: cButtonGreen,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _calculateDiscountPercentage(
                                            productDetail
                                                .product.sellingPrice,
                                            productDetail.product.mrp,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ProductDetailsRatingWidget(
                                  productRating: productDetail.productRating,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Planter Sizes ────────────────────────────
                          if (productDetail.productPlanterSizes.isNotEmpty) ...[
                            _sectionLabel('Select Planter Size', isTablet),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: productDetail.productPlanterSizes
                                  .map((ps) => _sizeChip(
                                        label: ps.size,
                                        selected: provider
                                                .selectedPlanterSizeId ==
                                            ps.id,
                                        onTap: () =>
                                            provider.updatePlanterSize(ps.id),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Plant Sizes ──────────────────────────────
                          if (productDetail.productSizes.isNotEmpty) ...[
                            _sectionLabel(
                              productDetail.productType == 'plant'
                                  ? 'Select Plant Size'
                                  : productDetail.productType == 'tool'
                                      ? 'Select Tool Size'
                                      : 'Select Size',
                              isTablet,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: productDetail.productSizes
                                  .map((s) => _sizeChip(
                                        label: s.size,
                                        selected:
                                            provider.selectedSizeId == s.id,
                                        onTap: () =>
                                            provider.updateSize(s.id),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Litres ───────────────────────────────────
                          if (productDetail.productLitres.isNotEmpty) ...[
                            _sectionLabel('Select Litre', isTablet),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: productDetail.productLitres
                                  .map((l) => _sizeChip(
                                        label: l.name,
                                        selected:
                                            provider.selectedLitreId == l.id,
                                        onTap: () =>
                                            provider.updateLitre(l.id),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Weights ──────────────────────────────────
                          if (productDetail.productWeights.isNotEmpty) ...[
                            _sectionLabel('Select Weight', isTablet),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: productDetail.productWeights
                                  .map((w) => _sizeChip(
                                        label:
                                            '${w.sizeGrams} gm',
                                        selected:
                                            provider.selectedWeightId == w.id,
                                        onTap: () =>
                                            provider.updateWeight(w.id),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Planters ─────────────────────────────────
                          if (productDetail.productPlanters.isNotEmpty) ...[
                            _sectionLabel('Select Planter', isTablet),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: productDetail.productPlanters
                                  .map((p) => _sizeChip(
                                        label: p.name,
                                        selected:
                                            provider.selectedPlanterId == p.id,
                                        onTap: () =>
                                            provider.updatePlanter(p.id),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Colors ───────────────────────────────────
                          if (productDetail.productColors.isNotEmpty) ...[
                            _sectionLabel(
                                'Recommended Planter Color', isTablet),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: productDetail.productColors.map((c) {
                                Color color = const Color(0xFFCCCCCC);
                                try {
                                  String hex = c.colorCode
                                      .replaceFirst('#', '');
                                  if (hex.length == 6) hex = 'FF$hex';
                                  color = Color(int.parse(hex, radix: 16));
                                } catch (_) {}

                                final isSelected =
                                    provider.selectedColorId == c.id;
                                return GestureDetector(
                                  onTap: () {
                                    if (productDetail.productType == 'pot' ||
                                        productDetail.productType == 'pots') {
                                      provider.updateColorForPot(c.id);
                                    } else {
                                      provider.updateColor(c.id);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color,
                                          border: Border.all(
                                            color: isSelected
                                                ? cButtonGreen
                                                : Colors.grey.shade300,
                                            width: isSelected ? 2.5 : 1.5,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: cButtonGreen
                                                        .withOpacity(0.35),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                  )
                                                ]
                                              : null,
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check,
                                                color: Colors.white, size: 18)
                                            : null,
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          c.colorName,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isSelected
                                                ? cButtonGreen
                                                : Colors.grey[700],
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // ── Quantity ──────────────────────────────────
                          Row(
                            children: [
                              Text(
                                'Qty:',
                                style: TextStyle(
                                  fontSize: isTablet ? 15 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              AddQuantityWidget(
                                quantity: provider.quantity,
                                addition: () => provider.increaseQuantity(
                                    1, productDetail.product.id),
                                substaction: () => provider.decreaseQuantity(
                                    1, productDetail.product.id),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ── Delivery Check ────────────────────────────
                          _buildPincodeChecker(),

                          const SizedBox(height: 24),

                          // ── Description Tabs ──────────────────────────
                          _buildDescriptionTabs(productDetail, provider),

                          const SizedBox(height: 24),

                          // ── Add-Ons ───────────────────────────────────
                          if (provider.productAddOn.isNotEmpty) ...[
                            const ProductListAddonWidget(title: 'Add On'),
                            const SizedBox(height: 24),
                          ],

                          // ── Recently Viewed ───────────────────────────
                          const ProductListRecentlyViewedWidget(
                              title: 'Recently Viewed'),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Fixed Bottom Buttons ──────────────────────────────────
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
                                    event: productDetail.product.isBuyable
                                        ? () async {
                                            final settingsProvider = context
                                                .read<SettingsProvider>();
                                            bool isAuth =
                                                await settingsProvider
                                                    .checkAccessTokenValidity(
                                                        context);
                                            if (!isAuth) {
                                              _showLoginDialog(
                                                  context,
                                                  productDetail.product.id);
                                              return;
                                            }
                                            provider.placeOrder(
                                                productDetail.product.id,
                                                context);
                                          }
                                        : null,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: isTablet ? 52 : 48,
                            child: CustomizableButton(
                              title: productDetail.product.isCart
                                  ? 'ITEM IN CART'
                                  : 'ADD TO CART',
                              event: productDetail.product.isCart
                                  ? () {
                                      showCartMessage(context, false);
                                    }
                                  : (productDetail.product.isBuyable
                                      ? () async {
                                          bool? isAuthenticated =
                                              await context
                                                  .read<SettingsProvider>()
                                                  .checkAccessTokenValidity(
                                                      context);
                                          if (isAuthenticated) {
                                            final productDetailProvider =
                                                context.read<
                                                    ProductDetailsProvider>();
                                            bool result = await context
                                                .read<CartProvider>()
                                                .addToCart(
                                                    product
                                                        .data.product.id,
                                                    productDetailProvider
                                                        .quantity,
                                                    context);
                                            if (result) {
                                              productDetail.product.isCart =
                                                  true;
                                              setState(() {});
                                            }
                                          } else {
                                            _showLoginDialog(
                                                context,
                                                productDetail.product.id);
                                            return;
                                          }
                                        }
                                      : null),
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

  // ── Size / Option Chip ─────────────────────────────────────────────────────
  Widget _sizeChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? cButtonGreen : Colors.white,
          border: Border.all(
            color: selected ? cButtonGreen : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: cButtonGreen.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String label, bool isTablet) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: isTablet ? 12 : 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
        letterSpacing: 0.8,
      ),
    );
  }

  // ── Pincode Checker ────────────────────────────────────────────────────────
  Widget _buildPincodeChecker() {
    final provider = context.watch<ProductDetailsProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.local_shipping_outlined, color: Colors.orange[700], size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'CHECK DELIVERY',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _pincodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter PIN code',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: Colors.grey[500], size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      counterText: '',
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(fontSize: 15),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
              GestureDetector(
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
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: cButtonGreen,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: provider.isCheckingPincode
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'CHECK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Delivery info hints
          const Row(
            children: [
              Text('📦', style: TextStyle(fontSize: 13)),
              SizedBox(width: 6),
              Text('Free delivery on orders ₹2000+',
                  style: TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                'Same-day dispatch before 2PM (Bangalore)',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Pincode result
          if (provider.isDeliveryAvailable != null)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                    size: 18,
                  ),
                  const SizedBox(width: 8),
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
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.pincodeError!,
                      style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Description Tabs ───────────────────────────────────────────────────────
  Widget _buildDescriptionTabs(
      ProductData productDetail, ProductDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: cButtonGreen,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            indicatorColor: cButtonGreen,
            indicatorWeight: 2.5,
            tabAlignment: TabAlignment.start,
            tabs: [
              const Tab(text: 'Description'),
              const Tab(text: 'Care Guide'),
              const Tab(text: "What's Included"),
              Tab(
                text:
                    'Reviews (${productDetail.productRating?.numRatings ?? 0})',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Content driven by selectd tab
        AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            return _buildTabContent(productDetail, provider);
          },
        ),
      ],
    );
  }

  Widget _buildTabContent(
      ProductData productDetail, ProductDetailsProvider provider) {
    switch (_tabController.index) {
      case 0: // Description
        return _buildDescription(productDetail.product.shortDescription);
      case 1: // Care Guide
        final care = productDetail.product.description;
        if (care.isEmpty) {
          return _buildEmptyState('No care guides available for this product.');
        }
        return _buildDescription(care);
      case 2: // What's Included
        final included = productDetail.product.whatsIncluded ?? '';
        if (included.isEmpty) {
          return _buildEmptyState("What's included info not available.");
        }
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: Colors.green.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  included,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      case 3: // Reviews
        final reviews = productDetail.productReviews ?? [];
        final rating = productDetail.productRating;
        return _buildReviewsSection(reviews, rating);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDescription(String text) {
    if (text.isEmpty) {
      return _buildEmptyState('No description available.');
    }
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.7, color: Colors.black87),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(
      List<ProductReview> reviews, ProductRating? rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star breakdown
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer reviews',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${rating?.avgRating.toStringAsFixed(1) ?? '0.0'} out of 5',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rating?.numRatings ?? 0} global ratings',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(5, (i) {
                    int star = 5 - i;
                    int count = rating?.starsGiven
                            .where((s) =>
                                s.roundedRating.toInt() == star)
                            .fold<int>(0, (sum, s) => sum + s.count) ??
                        0;
                    int total = rating?.numRatings ?? 0;
                    double fraction = total > 0 ? count / total : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text('$star star',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700])),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: fraction,
                                backgroundColor: Colors.grey[200],
                                color: Colors.amber,
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(fraction * 100).toInt()}%',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // No reviews placeholder
            Expanded(
              flex: 3,
              child: reviews.isEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey[300]!, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.star_border,
                              size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          const Text('No reviews yet',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('Be the first to share your experience!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reviews
                          .map((r) => _reviewCard(r))
                          .toList(),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _reviewCard(ProductReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: cButtonGreen.withOpacity(0.2),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                      color: cButtonGreen, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(review.date,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                    5,
                    (i) => Icon(
                          i < review.latestRating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.productReview,
              style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _calculateDiscountPercentage(double sellingPrice, double mrp) {
    if (mrp <= 0 || sellingPrice <= 0 || sellingPrice >= mrp) return '0% OFF';
    final percentage = (100 - (sellingPrice / mrp * 100));
    if (percentage.isNaN || percentage.isInfinite || percentage <= 0) {
      return '0% OFF';
    }
    return '${percentage.toInt()}% OFF';
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
