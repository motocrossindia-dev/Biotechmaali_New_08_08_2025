import 'package:biotech_maali/src/module/home/model/public_flag_model.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';

import '../../../../import.dart';

class DynamicFlagSectionWidget extends StatelessWidget {
  final PublicFlagModel flag;
  final ProductListModel? productResponse;

  const DynamicFlagSectionWidget({
    super.key,
    required this.flag,
    required this.productResponse,
  });

  @override
  Widget build(BuildContext context) {
    if (productResponse == null || productResponse!.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Product> productsToDisplay = productResponse!.products.take(4).toList();
    final int remainingCount = productResponse!.count - productsToDisplay.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                title: flag.label,
                color: cHomeProductText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productsToDisplay.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65, // Tune based on ProductTileWidget layout
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final Product product = productsToDisplay[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        slug: product.slug ?? '',
                      ),
                    ),
                  );
                },
                child: ProductTileWidget(
                  productTitle: product.name,
                  productImage: product.image,
                  tempImage: 'assets/png/products/sample_product.png',
                  discountAmount: product.sellingPriceWithGst.toString() == "null"
                      ? "0.00"
                      : product.sellingPriceWithGst.toString(),
                  actualAmount: product.mrpWithGst.toString() == "null"
                      ? "0.00"
                      : product.mrpWithGst.toString(),
                  rating: product.productRating.avgRating,
                  numRatings: product.productRating.numRatings,
                  home: true,
                  isWishlist: product.isWishlist,
                  isCart: product.isCart,
                  ribbon: product.ribbon,
                  flags: product.flags,
                  isStock: product.isStock,
                  stock: product.stock,
                  subCategorySlug: product.subCategorySlug,
                  mainProdId: product.id,
                  addToFavouriteEvent: () async {
                    final settingsProvider = context.read<SettingsProvider>();
                    bool isAuth = await settingsProvider.checkAccessTokenValidity(context);
                    if (!isAuth) {
                      _showLoginDialog(context);
                      return;
                    }
                    context.read<WishlistProvider>().addOrRemoveWhishlistMainProduct(product.id, context);
                  },
                  addToCartEvent: () async {
                    final settingsProvider = context.read<SettingsProvider>();
                    bool isAuth = await settingsProvider.checkAccessTokenValidity(context);
                    if (!isAuth) {
                      _showLoginDialog(context);
                      return;
                    }
                    final cartProvider = context.read<CartProvider>();
                    await cartProvider.addToCartMainProduct(product.id, true, context);
                  },
                ),
              );
            },
          ),
          // View All Button
          if (remainingCount > 0) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3F6331),
                  side: const BorderSide(color: Color(0xFF3F6331)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(
                        isCategory: false,
                        title: flag.label,
                        id: flag.id.toString(),
                        flagId: flag.id,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View All $remainingCount more ${flag.label} Products',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
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
