import 'dart:developer';
import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';
import 'package:biotech_maali/src/widgets/shimmer/product_tile_shimmer.dart';

import '../../../../import.dart';

class ProductListScreen extends StatefulWidget {
  final bool isCategory;
  final String title;
  final String id;
  final String? categoryName;

  const ProductListScreen(
      {required this.isCategory,
      required this.title,
      required this.id,
      this.categoryName,
      super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedOption = 'Default';
  final ScrollController _scrollController = ScrollController();
  bool _isFiltered = false;

  final List<String> _sortOptions = [
    'Default',
    'Price High To Low',
    'Price Low To High',
    'Alphabetically A-Z',
    'Alphabetically Z-A',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    if (widget.isCategory) {
      if (widget.title == "OFFERS") {
        context.read<ProductListProdvider>().getOfferProductList(context);
      } else {
        context
            .read<ProductListProdvider>()
            .getCategoryProductList(categoryId: widget.id);
      }
    } else {
      context
          .read<ProductListProdvider>()
          .getSubCategoryProductList(subCategoryId: widget.id);
    }

    // Set local _selectedOption to match provider's current sort option
    _selectedOption = context.read<ProductListProdvider>().currentSortOption;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_isFiltered) {
        // Handle filtered products pagination
        final filterProvider = context.read<FiltersProvider>();
        if (!filterProvider.isLoadingMore && filterProvider.hasMoreData) {
          filterProvider.applyFilters(widget.title, context, loadMore: true);
        }
      } else {
        // Handle regular products pagination
        final provider = context.read<ProductListProdvider>();
        if (!provider.isLoadingMore && provider.hasMoreData) {
          if (widget.isCategory) {
            if (widget.title == "OFFERS") {
              provider.getOfferProductList(context, loadMore: true);
            } else {
              provider.getCategoryProductList(
                  categoryId: widget.id, loadMore: true);
            }
          } else {
            provider.getSubCategoryProductList(
                subCategoryId: widget.id, loadMore: true);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        body: Consumer<ProductListProdvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const ProductListShimmer();
            }

            List<Product> products = provider.allProducts;
            log("Building product list with ${products.length} products"); // Add this log

            if (products.isEmpty) {
              return const Center(
                child: Text("No products found"),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                widget.title == "OFFERS"
                    ? const SliverToBoxAdapter(
                        child: SizedBox(height: 10),
                      )
                    : const SliverToBoxAdapter(
                        child: CustomBannerWidget(),
                      ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.48,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Product product = products[index];
                        return InkWell(
                          onTap: () {
                            context
                                .read<ProductDetailsProvider>()
                                .fetchProductDetails(product.prodId);

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
                            isOffer: widget.title == "OFFERS" ? true : false,
                            mainProdId: product.id,
                            productTitle: product.name,
                            productImage: product.image,
                            tempImage: 'assets/png/products/sample_product.png',
                            discountAmount:
                                product.sellingPrice.toString() == "null"
                                    ? "0.00"
                                    : product.sellingPrice.toString(),
                            actualAmount: product.mrp.toString() == "null"
                                ? "0.00"
                                : product.mrp.toString(),
                            rating: product.productRating.avgRating,
                            home: true,
                            isWishlist: product.isWishlist,
                            isCart: product.isCart,
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
                                  .addOrRemoveWhishlistCompinationProduct(
                                      product.prodId, context);
                              if (result) {
                                provider.updateWishList(
                                    product.isWishlist, product.prodId);
                              } else {
                                return;
                              }
                            },
                            addToCartEvent: product.isCart
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartScreen(
                                          isCategory: widget.isCategory,
                                          isSubCategory:
                                              widget.isCategory == false
                                                  ? true
                                                  : false,
                                          isWishlist: false,
                                          title: widget.title,
                                          id: widget.id,
                                          isHomeProductList: false,
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
                                    bool result = await context
                                        .read<CartProvider>()
                                        .addToCart(
                                          product.prodId,
                                          1,
                                          context,
                                        );

                                    if (result) {
                                      provider.updateCart(
                                        product.isCart,
                                        product.prodId,
                                        context,
                                      );
                                    }
                                  },
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
                if (provider.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProductTileShimmer(),
                          SizedBox(width: 15),
                          ProductTileShimmer(),
                        ],
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 70),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: widget.title != "OFFERS"
            ? Container(
                decoration: BoxDecoration(
                  color: cWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: cButtonGreen.withOpacity(0.3),
                              highlightColor: cButtonGreen.withOpacity(0.1),
                              onTap: () {
                                log('Sort button tapped');
                                _showSortByOverlay(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/icons/sort_icon.svg'),
                                    sizedBoxWidth10,
                                    const CommonTextWidget(
                                      title: 'SORT BY',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: cButtonGreen.withOpacity(0.3),
                              highlightColor: cButtonGreen.withOpacity(0.1),
                              onTap: () {
                                log('Filter button tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterScreen(
                                      type: widget.isCategory == false
                                          ? widget.categoryName!
                                          : widget.title,
                                    ),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _isFiltered = true;
                                    });
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/icons/filter_icon.svg'),
                                    sizedBoxWidth10,
                                    const CommonTextWidget(
                                      title: 'FILTER',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : sizedBoxHeight0);
  }

  void _showSortByOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(), // Empty space for left side
                          const CommonTextWidget(
                            title: 'Sort By',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _sortOptions.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          title: Text(
                            _sortOptions[index],
                            style: TextStyle(
                              color: _selectedOption == _sortOptions[index]
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          value: _sortOptions[index],
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            final sortOption = value!;
                            setState(() {
                              _selectedOption = sortOption;
                            });
                            // Call the sorting method in the provider
                            context
                                .read<ProductListProdvider>()
                                .sortProducts(sortOption);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // Update the local selected option when the bottom sheet is closed
      if (mounted) {
        _selectedOption =
            context.read<ProductListProdvider>().currentSortOption;
      }
    });
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
