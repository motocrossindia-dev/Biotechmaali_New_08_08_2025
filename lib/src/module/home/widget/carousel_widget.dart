import 'dart:developer';

import 'package:biotech_maali/src/module/product_list/banner_product_list/banner_product_list_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../import.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isBannersLoading) {
          return const ShimmerWidget();
        }

        if (provider.bannersError != null) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: Center(
              child: Text(
                'Error loading banners: ${provider.bannersError}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final banners = provider.visibleHomeBanners;

        if (banners.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: const Center(
              child: Text(
                'No banners available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.38,
                autoPlay: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  provider.onCaroucelIndexChange(index);
                },
              ),
              items: banners.map((imageUrl) {
                return InkWell(
                  onTap: () {
                    // Get banner ID
                    final bannerId = imageUrl['bannerId'];
                    final productId = imageUrl['productId'];

                    log("Banner tapped - Banner ID: $bannerId, Product ID: $productId");

                    // If productId is 0 or null, navigate to banner product list
                    if (productId == '0' ||
                        productId == null ||
                        productId.isEmpty) {
                      if (bannerId != null && bannerId != '0') {
                        // Navigate to banner product list screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BannerProductListScreen(
                              bannerId: int.parse(bannerId),
                              title: 'Featured Products',
                            ),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(msg: "No products available");
                      }
                      return;
                    }

                    // If productId exists, navigate to product details
                    context
                        .read<ProductDetailsProvider>()
                        .fetchProductDetails(int.parse(productId));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                            productId: int.parse(productId)),
                      ),
                    );
                  },
                  child: NetworkImageWidget(
                    imageUrl: imageUrl['image'] ?? '',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.38,
                    memCacheWidth: 800, // Optimized banner cache size
                    memCacheHeight: 400,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: Colors.grey[50],
                      child: const SizedBox.shrink(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image\n$url',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (banners.length > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners.asMap().entries.map((entry) {
                  // log("entry.key: ${entry.key.toString()}");
                  return provider.caroucelIndex == entry.key
                      ? Container(
                          width: 30,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: cButtonGreen,
                          ),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[400],
                          ),
                        );
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.38,
        color: Colors.white,
      ),
    );
  }
}
