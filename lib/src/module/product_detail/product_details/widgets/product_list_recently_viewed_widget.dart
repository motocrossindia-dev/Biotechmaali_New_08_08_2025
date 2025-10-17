import 'dart:developer';

import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/recently_viewed_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/recently_viewed_product_tile.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'dart:math' as math;

import '../../../../../import.dart';

class ProductListRecentlyViewedWidget extends StatelessWidget {
  final String title;

  const ProductListRecentlyViewedWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Calculate responsive height - optimized to show full content without overflow
    double containerHeight = screenHeight * (isTablet ? 0.37 : 0.34);
    // Adjusted height bounds to ensure Add to Cart button is fully visible
    containerHeight = containerHeight.clamp(270.0, 350.0);

    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        List<RecentlyViewedProduct> recentlyViewedProducts =
            provider.recentlyViewedProductList;

        // Return empty container if no products to show
        if (recentlyViewedProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03), // Responsive padding
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distributes space evenly
                children: [
                  CommonTextWidget(
                    title: title,
                    color: cHomeProductText,
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                  height: screenHeight *
                      0.015), // Reduced spacing to minimize blank space
              SizedBox(
                height: containerHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: math.min(
                      4,
                      recentlyViewedProducts
                          .length), // Use math.min for cleaner code
                  itemBuilder: (context, index) {
                    RecentlyViewedProduct productData =
                        recentlyViewedProducts[index];

                    log('Recently Viewed Product Data: ${productData.sellingPrice.toString()}');
                    return InkWell(
                      onTap: () {
                        context
                            .read<ProductDetailsProvider>()
                            .fetchProductDetails(productData.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(productId: productData.id),
                          ),
                        );
                      },
                      child: RecentlyViewedProductTile(
                        mainProdId: productData.id,
                        productTitle: productData.name,
                        productImage: productData.image,
                        tempImage: 'assets/png/products/sample_product.png',
                        discountAmount: productData.sellingPrice
                            .toString(), // Selling price (lower price)
                        actualAmount:
                            productData.mrp.toString(), // MRP (higher price)
                        rating: productData.productRating.avgRating,
                        isWishlist: productData.isWishlist,
                        isCart: productData.isCart,
                        addToFavouriteEvent: () async {
                          final settingsProvider =
                              context.read<SettingsProvider>();
                          bool isAuth = await settingsProvider
                              .checkAccessTokenValidity(context);

                          if (!isAuth) {
                            _showLoginDialog(context);
                            return;
                          }
                          final wishlistProvider =
                              context.read<WishlistProvider>();
                          bool result = await wishlistProvider
                              .addOrRemoveWhishlistMainProduct(
                                  productData.id, context);
                          if (result) {
                            provider.updateWishList(
                                productData.isWishlist, productData.id);
                          } else {
                            return;
                          }
                        },
                        addToCartEvent: productData.isCart
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartScreen(),
                                  ),
                                );
                              }
                            : () async {
                                final settingsProvider =
                                    context.read<SettingsProvider>();
                                bool isAuth = await settingsProvider
                                    .checkAccessTokenValidity(context);
                                if (!isAuth) {
                                  _showLoginDialog(context);
                                  return;
                                }
                                bool result = await context
                                    .read<CartProvider>()
                                    .addToCartMainProduct(
                                      productData.id,
                                      productData.isCart,
                                      context,
                                    );

                                if (result) {
                                  provider.updateCart(
                                    productData.isCart,
                                    productData.id,
                                    context,
                                  );
                                }
                              },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
