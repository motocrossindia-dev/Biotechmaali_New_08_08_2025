import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/home/model/home_product_model.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';
import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';
import 'package:biotech_maali/src/module/product_list/home_product_list/widget/home_product_tile_widget.dart';

import '../../../../import.dart';

class HomeProductListScreen extends StatefulWidget {
  final String title;

  const HomeProductListScreen({
    required this.title,
    super.key,
  });

  @override
  State<HomeProductListScreen> createState() => _HomeProductListScreenState();
}

class _HomeProductListScreenState extends State<HomeProductListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    // await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: widget.title,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductSearchView(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 40.0),
              child: Icon(Icons.search, size: 30),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const ProductListShimmer()
          : SingleChildScrollView(
              child: Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  List<HomeProductModel> products = [];
                  if (widget.title == "Featured") {
                    products = provider.featuredProducts;
                  } else if (widget.title == "Latest") {
                    products = provider.trendingProducts;
                  } else if (widget.title == "Bestseller") {
                    products = provider.bestSellerProducts;
                  } else if (widget.title == "Seasonal Collection") {
                    products = provider.seasonalProducts;
                  }
                  return Column(
                    children: [
                      const CustomBannerWidget(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            HomeProductModel productDetails = products[index];

                            return InkWell(
                              onTap: () {
                                context
                                    .read<ProductDetailsProvider>()
                                    .fetchProductDetails(productDetails.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: productDetails.id,
                                    ),
                                  ),
                                );
                              },
                              child: HomeProductTileWidget(
                                mainProdId: productDetails.id,
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
                                rating: productDetails.productRating.avgRating,
                                home: true,
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
                                      context.read<HomeProvider>();
                                  wishlistProvider.addOrRemoveToWishlist(
                                    productDetails.id,
                                    productDetails.isWishlist,
                                    context,
                                  );
                                },
                                addToCartEvent: productDetails.isCart
                                    ? () {
                                        // context
                                        //     .read<BottomNavProvider>()
                                        //     .updateIndex(2);
                                        // Navigator.pushAndRemoveUntil(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         BottomNavWidget(),
                                        //   ),
                                        //   (route) => false,
                                        // );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen(
                                              isHomeProductList: true,
                                              id: "",
                                              isCategory: false,
                                              title: "",
                                            ),
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
                                        context
                                            .read<HomeProvider>()
                                            .addToCartMainProduct(
                                              productDetails.id,
                                              productDetails.isCart,
                                              context,
                                            );
                                      },
                              ),
                            );
                          },
                        ),
                      ),
                      sizedBoxHeight70,
                    ],
                  );
                },
              ),
            ),
    );
  }

  void showWishlistMessage(BuildContext context, bool isAdded) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdded ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(isAdded
                ? 'Item added to wishlist successfully'
                : 'Item removed from wishlist'),
          ],
        ),
        action: isAdded
            ? SnackBarAction(
                label: 'View Wishlist',
                onPressed: () {
                  // Navigate to wishlist
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WishlistScreen()),
                  );
                },
              )
            : null,
        duration: const Duration(seconds: 2),
        behavior:
            SnackBarBehavior.floating, // Makes it float above bottom nav bar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: isAdded ? Colors.green : Colors.grey[800],
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
