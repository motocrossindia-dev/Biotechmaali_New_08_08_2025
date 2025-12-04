import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/home/model/home_product_model.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/module/product_list/home_product_list/widget/home_product_tile_widget.dart';
import '../../../../import.dart';

class HomeProductsTileWidget extends StatelessWidget {
  final String title;

  const HomeProductsTileWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                title: title,
                color: cHomeProductText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return CustomizableButton(
                    title: 'View All',
                    event: () {
                      // context.read<HomeProvider>().fetchWishlistProductId();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeProductListScreen(
                            title: title,
                          ),
                        ),
                      );
                    },
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  );
                },
              )
            ],
          ),
          sizedBoxHeight40,
          SizedBox(
            height: 280,
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                List<HomeProductModel> products = [];
                if (title == "Featured") {
                  products = provider.allProducts;
                } else if (title == "Latest") {
                  products = provider.trendingProducts;
                } else if (title == "Bestseller") {
                  products = provider.bestSellerProducts;
                } else if (title == "Seasonal Collection") {
                  products = provider.seasonalProducts;
                }
                return products.isEmpty
                    ? Center(
                        child: AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 3200),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.inventory_2,
                                        size: 40,
                                        color: cButtonGreen,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 1000),
                                child: Text(
                                  "No $title Products",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 1200),
                                child: Text(
                                  "Check back later for new arrivals",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          HomeProductModel productDetails = products[index];

                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<ProductDetailsProvider>()
                                      .fetchProductDetails(productDetails.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                        productId: productDetails.id,
                                      ),
                                    ),
                                  );
                                },
                                child: HomeProductTileWidget(
                                  productTitle: productDetails.name,
                                  productImage: productDetails.image,
                                  tempImage:
                                      'assets/png/products/sample_product.png',
                                  discountAmount: productDetails.sellingPrice
                                              .toString() ==
                                          "null"
                                      ? "0.00"
                                      : productDetails.sellingPrice.toString(),
                                  actualAmount:
                                      productDetails.mrp.toString() == "null"
                                          ? "0.00"
                                          : productDetails.mrp.toString(),
                                  rating:
                                      productDetails.productRating.avgRating,
                                  home: false, // Show favorite button on image
                                  isWishlist: productDetails.isWishlist,
                                  isCart: productDetails.isCart,
                                  ribbon: productDetails
                                      .ribbon, // Pass ribbon from model
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
                                    wishlistProvider
                                        .addOrRemoveWhishlistMainProduct(
                                            productDetails.id, context);
                                  },
                                  mainProdId: productDetails.id,
                                ),
                              ),
                              sizedBoxWidth15
                            ],
                          );
                        },
                      );
              },
            ),
          )
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
