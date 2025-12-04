import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_search/widget/search_speek_input.dart';
import 'package:biotech_maali/src/widgets/error_message_widget.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/widgets/shimmer/product_tile_shimmer.dart';
import 'product_search_provider.dart';

class ProductSearchView extends StatefulWidget {
  const ProductSearchView({super.key});

  @override
  State<ProductSearchView> createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     context.read<ProductSearchProvider>().searchProducts(
    //         context.read<ProductSearchProvider>().lastSearchQuery);
    //     log("Last search query: ${context.read<ProductSearchProvider>().lastSearchQuery}");
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
      ),
      body: Column(
        children: [
          ChatInput(
            controller: _searchController,
            onSearch: (query) {
              if (query.isNotEmpty) {
                context.read<ProductSearchProvider>().searchProducts(query);
              }
            },
          ),
          Expanded(
            child: Consumer<ProductSearchProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ErrorMessageWidget(
                            errorTitle: "No results found",
                            errorSubTitle: provider.error),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.48,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: provider.products.length +
                      (provider.nextPage != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.products.length) {
                      if (!provider.isLoadingMore) {
                        provider.loadMore();
                      }
                      return const ProductTileShimmer();
                    }

                    final product = provider.products[index];
                    return InkWell(
                      onTap: () {
                        context
                            .read<ProductDetailsProvider>()
                            .fetchProductDetails(product.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                      child: ProductTileWidget(
                        tempImage: "",
                        productTitle: product.name,
                        productImage: product.image,
                        actualAmount: product.mrp.toString(),
                        home: true,
                        isWishlist: product.isWishlist,
                        isCart: product.isCart,
                        mainProdId: product.id,
                        discountAmount: product.sellingPrice.toString(),
                        rating: product.productRating.avgRating,
                        ribbon:
                            null, // Product search doesn't have ribbon field
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
                                  product.id, context);
                          if (result) {
                            provider.updateWishList(
                                product.isWishlist, product.id);
                          } else {
                            return;
                          }
                        },
                        addToCartEvent: product.isCart
                            ? () {
                                // context
                                //     .read<BottomNavProvider>()
                                //     .updateIndex(2);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                      isCategory: false,
                                      isSearch: true,
                                      isHomeProductList: false,
                                      isSubCategory: false,
                                      isWishlist: false,
                                      id: "",
                                      title: "",
                                    ),
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
                                      product.id,
                                      product.isCart,
                                      context,
                                    );

                                if (result) {
                                  provider.updateCart(
                                    product.isCart,
                                    product.id,
                                    context,
                                  );
                                }
                              },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//

void _showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LoginPromptDialog();
    },
  );
}
