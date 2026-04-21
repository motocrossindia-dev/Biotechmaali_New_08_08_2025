import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_search/widget/search_speek_input.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/widgets/shimmer/product_tile_shimmer.dart';
import 'package:biotech_maali/src/widgets/no_products_found_widget.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
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
    super.initState();

    // Track search screen view
    AnalyticsService().logScreenView(screenName: ScreenNames.productSearch);

    // Add listener to clear products when text is empty
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty) {
      context.read<ProductSearchProvider>().clearProducts();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
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
              } else {
                context.read<ProductSearchProvider>().clearProducts();
              }
            },
          ),
          Expanded(
            child: Consumer<ProductSearchProvider>(
              builder: (context, provider, child) {
                // Show loading indicator
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show error message with animation
                if (provider.error.isNotEmpty) {
                  return NoProductsFoundWidget(
                    title: 'Search Failed',
                    subtitle: provider.error,
                    onRetry: () {
                      if (provider.lastSearchQuery.isNotEmpty) {
                        provider.searchProducts(provider.lastSearchQuery);
                      }
                    },
                    retryButtonText: 'Try Again',
                  );
                }

                // Show initial state - before any search
                if (!provider.hasSearched) {
                  return _buildInitialSearchState();
                }

                // Show no results found after search
                if (provider.products.isEmpty && provider.hasSearched) {
                  return NoProductsFoundWidget(
                    title: 'No Results Found',
                    subtitle:
                        'We couldn\'t find any products matching "${provider.lastSearchQuery}".\nTry different keywords or check your spelling.',
                  );
                }

                // Show products grid
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
                        tempImage: "",
                        productTitle: product.name,
                        productImage: product.image,
                        actualAmount: product.mrpWithGst.toString(),
                        home: true,
                        isWishlist: product.isWishlist,
                        isCart: product.isCart,
                        mainProdId: product.id,
                        discountAmount: product.sellingPriceWithGst.toString(),
                        rating: product.productRating.avgRating,
                        numRatings: product.productRating.numRatings,
                        flags: product.flags,
                        isStock: product.isStock,
                        stock: product.stock,
                        subCategorySlug: product.subCategorySlug,
                        ribbon: product.ribbon,
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
                        // Disable Add to Cart when product not buyable
                        addToCartEvent: product.isCart
                            ? () {
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
                                );
                              }
                            : (product.isBuyable
                                ? () async {
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
                                  }
                                : null),
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

  // Initial search state widget - shown before user searches
  Widget _buildInitialSearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: cButtonGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 60,
                color: cButtonGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Search Products',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: cButtonGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start typing to search for plants,\nseeds, fertilizers and more...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
