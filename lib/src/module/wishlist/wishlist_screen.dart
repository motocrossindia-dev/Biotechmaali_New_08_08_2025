import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/module/wishlist/widget/wishlist_product_tile_widget.dart';

import '../../../import.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().fetchWishlist();
    });
    WishlistProvider();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // context.read<BottomNavProvider>().updateIndex(0);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BottomNavWidget(),
        //   ),
        //   (route) => false,
        // );
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const CommonTextWidget(
            title: "Favorite Products",
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              context.read<BottomNavProvider>().updateIndex(0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavWidget(),
                ),
                (route) => false,
              );
            },
          ),
        ),
        body: Consumer<WishlistProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.error!),
                    ElevatedButton(
                      onPressed: () => provider.fetchWishlist(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64),
                    SizedBox(height: 16),
                    Text('Your wishlist is empty'),
                  ],
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
                      itemCount: provider.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 0.48,
                      ),
                      itemBuilder: (context, index) {
                        final product = provider.products[index];
                        return InkWell(
                          onTap: () {
                            context
                                .read<ProductDetailsProvider>()
                                .fetchProductDetails(product.mainProductId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  productId: product.id,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              WishlistProductTileWidget(
                                productId: product.productId,
                                isCart: product.isCart,
                                productTitle: product.name,
                                productImage: product.image,
                                tempImage:
                                    '/assets/png/products/sample_product.png',
                                addDeleteEvent: () {
                                  provider.removeFromWishlist(
                                      product.id, context);
                                },
                                mrp: product.mrp.toInt().toString(),
                                sellingPrice:
                                    product.sellingPrice.toInt().toString(),
                                home: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
