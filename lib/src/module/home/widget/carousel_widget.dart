import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
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
                    if (imageUrl['productId'] == '0') {
                      Fluttertoast.showToast(msg: "No product available");
                      return;
                    }
                    log("Banner tapped: ${imageUrl['productId']}");
                    context.read<ProductDetailsProvider>().fetchProductDetails(
                        int.parse(imageUrl['productId'] ?? '0'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                            productId: int.parse(imageUrl['productId'] ?? '0')),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl['image'] ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const ShimmerWidget(),
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
