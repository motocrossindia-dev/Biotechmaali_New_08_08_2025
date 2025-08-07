import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/recently_viewed_model.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'dart:math' as math;

import '../../../../../import.dart';

class ProductListRecentlyViewedWidget extends StatelessWidget {
  final String title;

  const ProductListRecentlyViewedWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        List<RecentlyViewedProduct> recentlyViewedProducts =
            provider.recentlyViewedProductList;

        // Return empty container if no products to show
        if (recentlyViewedProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(
              left: 12, right: 12), // Add padding for better layout
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distributes space evenly
                children: [
                  CommonTextWidget(
                    title: title,
                    color: cHomeProductText,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              sizedBoxHeight40,
              SizedBox(
                height: 360,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: math.min(
                      4,
                      recentlyViewedProducts
                          .length), // Use math.min for cleaner code
                  itemBuilder: (context, index) {
                    RecentlyViewedProduct productData =
                        recentlyViewedProducts[index];
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<ProductDetailsProvider>()
                                .fetchProductDetails(productData.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    productId: productData.id),
                              ),
                            );
                          },
                          child: ProductTileWidget(
                            mainProdId: productData.id,
                            productTitle: productData.name,
                            productImage: productData.image,
                            tempImage: 'assets/png/products/sample_product.png',
                            discountAmount: productData.mrp.toString(),
                            actualAmount: productData.price.toString(),
                            rating: productData.productRating.avgRating,
                            home: true,
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
                                    // context
                                    //     .read<BottomNavProvider>()
                                    //     .updateIndex(2);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CartScreen(),
                                      ),
                                      // (route) => false,
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
                        ),
                        sizedBoxWidth15
                      ],
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
