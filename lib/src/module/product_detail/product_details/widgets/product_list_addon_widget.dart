import 'dart:developer';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';

import '../../../../../import.dart';

class ProductListAddonWidget extends StatelessWidget {
  final String title;

  const ProductListAddonWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        final List<ProductAddOn> productAddonList = provider.productAddOn;

        if (productAddonList.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: CommonTextWidget(
                title: title,
                color: cHomeProductText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productAddonList.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final ProductAddOn product = productAddonList[index];
                log('Addon product id: ${product.id}, isCart: ${product.isCart}');

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (product.slug != null && product.slug!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            slug: product.slug!,
                          ),
                        ),
                      );
                    }
                  },
                  child: ProductTileWidget(
                    isOffer: false,
                    mainProdId: product.id,
                    productTitle: product.name,
                    productImage: product.image,
                    tempImage: 'assets/png/products/sample_product.png',
                    discountAmount: product.sellingPrice.toStringAsFixed(2),
                    actualAmount: product.mrp.toStringAsFixed(2),
                    rating: product.productRating.avgRating,
                    numRatings: product.productRating.numRatings,
                    flags: product.flags,
                    ribbon: product.ribbon,
                    isStock: product.isStock ?? true,
                    stock: product.stock ?? 0,
                    home: true,
                    isWishlist: product.isWishlist,
                    isCart: product.isCart,
                    subCategorySlug: product.subCategorySlug,
                    addToFavouriteEvent: () async {
                      final settingsProvider =
                          context.read<SettingsProvider>();
                      bool isAuth = await settingsProvider
                          .checkAccessTokenValidity(context);
                      if (!isAuth) {
                        _showLoginDialog(context, product.id);
                        return;
                      }
                      context
                          .read<WishlistProvider>()
                          .addOrRemoveWhishlistCompinationProduct(
                              product.id, context);
                    },
                    addToCartEvent: product.isCart
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavWidget(),
                              ),
                            );
                          }
                        : () async {
                            final settingsProvider =
                                context.read<SettingsProvider>();
                            bool isAuth = await settingsProvider
                                .checkAccessTokenValidity(context);
                            if (!isAuth) {
                              _showLoginDialog(context, product.id);
                              return;
                            }
                            context
                                .read<ProductDetailsProvider>()
                                .addToCartMainProduct(
                                    product.id, product.isCart, context);
                          },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginPromptDialog(productId: productId);
      },
    );
  }
}
