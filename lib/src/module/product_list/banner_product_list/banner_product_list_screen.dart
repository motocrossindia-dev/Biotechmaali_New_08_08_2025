import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/product_list/banner_product_list/banner_product_list_provider.dart';
import 'package:biotech_maali/src/module/product_list/banner_product_list/model/banner_product_model.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';
import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';
import 'package:biotech_maali/src/module/product_list/home_product_list/widget/home_product_tile_widget.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';

import '../../../../import.dart';

class BannerProductListScreen extends StatefulWidget {
  final int bannerId;
  final String title;

  const BannerProductListScreen({
    required this.bannerId,
    required this.title,
    super.key,
  });

  @override
  State<BannerProductListScreen> createState() =>
      _BannerProductListScreenState();
}

class _BannerProductListScreenState extends State<BannerProductListScreen> {
  late BannerProductListProvider _provider;

  @override
  void initState() {
    super.initState();
    // Fetch banner products when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<BannerProductListProvider>()
            .fetchBannerProducts(widget.bannerId, context);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save reference to provider in didChangeDependencies
    _provider = context.read<BannerProductListProvider>();
  }

  @override
  void dispose() {
    // Use the saved reference instead of context
    _provider.clearData();
    super.dispose();
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
      body: Consumer<BannerProductListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ProductListShimmer();
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading products',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchBannerProducts(widget.bannerId, context);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          List<BannerProduct> products = provider.products;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
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
                      BannerProduct productDetails = products[index];

                      return InkWell(
                        onTap: () {
                          context
                              .read<ProductDetailsProvider>()
                              .fetchProductDetails(productDetails.prodId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                productId: productDetails.prodId,
                              ),
                            ),
                          );
                        },
                        child: HomeProductTileWidget(
                          mainProdId: productDetails.prodId,
                          productTitle: productDetails.name,
                          productImage: productDetails.image,
                          tempImage: 'assets/png/products/sample_product.png',
                          discountAmount:
                              productDetails.sellingPrice.toString(),
                          actualAmount: productDetails.mrp.toString(),
                          rating:
                              productDetails.productRating.avgRating.toDouble(),
                          home: true,
                          isWishlist: productDetails.isWishlist,
                          isCart: productDetails.isCart,
                          ribbon: productDetails.ribbon,
                          addToFavouriteEvent: () async {
                            final settingsProvider =
                                context.read<SettingsProvider>();
                            bool isAuth = await settingsProvider
                                .checkAccessTokenValidity(context);

                            if (!isAuth) {
                              _showLoginDialog(context);
                              return;
                            }

                            if (context.mounted) {
                              // Use WishlistProvider directly
                              await context
                                  .read<WishlistProvider>()
                                  .addOrRemoveWhishlistCompinationProduct(
                                    productDetails.prodId,
                                    context,
                                  );

                              // Update local product state
                              if (context.mounted) {
                                context
                                    .read<BannerProductListProvider>()
                                    .updateWishList(
                                      productDetails.isWishlist,
                                      productDetails.prodId,
                                    );
                              }
                            }
                          },
                          addToCartEvent: productDetails.isCart
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(
                                        isHomeProductList: false,
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

                                  if (context.mounted) {
                                    // Use CartProvider directly
                                    await context
                                        .read<CartProvider>()
                                        .addToCart(
                                          productDetails.prodId,
                                          1,
                                          context,
                                        );

                                    // Update local product state
                                    if (context.mounted) {
                                      await context
                                          .read<BannerProductListProvider>()
                                          .updateCart(
                                            productDetails.isCart,
                                            productDetails.prodId,
                                            context,
                                          );
                                    }
                                  }
                                },
                        ),
                      );
                    },
                  ),
                ),
                sizedBoxHeight70,
              ],
            ),
          );
        },
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
