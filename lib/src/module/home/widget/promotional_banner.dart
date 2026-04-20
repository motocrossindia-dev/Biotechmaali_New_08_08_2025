import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';

import '../../../../import.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        // Show loading shimmer while fetching
        if (provider.isPromotionalBannerLoading) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Use API data if available, otherwise show fallback
        final bannerData = provider.promotionalBanner;
        final hasValidData = bannerData != null &&
            bannerData.isVisible &&
            bannerData.mobileBanner.isNotEmpty;

        if (!hasValidData) {
          // Fallback to original static banner
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vibrant and Thriving Plants Online',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Celebrate Friendship with 15% Off',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[900],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToOffers(context, provider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cButtonGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }

        // Display banner with image from API
        // Image URL (commented out as the image widget is commented)
        // final String imageUrl =
        //     '${BaseUrl.baseUrlForImages}${bannerData.mobileBanner}';
        final String title = bannerData.title.isNotEmpty
            ? bannerData.title
            : 'Vibrant and Thriving Plants Online';
        final String subtitle = bannerData.subtitle.isNotEmpty
            ? bannerData.subtitle
            : 'Celebrate Friendship with 15% Off';
        final String buttonText = bannerData.buttonText.isNotEmpty
            ? bannerData.buttonText
            : 'Shop Now';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banner Image
                // NetworkImageWidget(
                //   imageUrl: imageUrl,
                //   fit: BoxFit.cover,
                //   width: MediaQuery.of(context).size.width,
                //   height: 150,
                //   memCacheWidth: 800,
                //   memCacheHeight: 300,
                //   placeholder: (context, url) => Container(
                //     height: 150,
                //     color: Colors.grey[100],
                //     child: Center(
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         color: cButtonGreen,
                //       ),
                //     ),
                //   ),
                //   errorWidget: (context, url, error) => Container(
                //     height: 150,
                //     color: Colors.grey[100],
                //     child: const Center(
                //       child: Icon(
                //         Icons.image_not_supported_outlined,
                //         size: 40,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),

                // Text Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title.isNotEmpty)
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (title.isNotEmpty && subtitle.isNotEmpty)
                        const SizedBox(height: 4),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[900],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateToOffers(context, provider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cButtonGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 0,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOffers(BuildContext context, HomeProvider provider) {
    // Track banner click analytics
    AnalyticsService().logBannerClick(
      bannerId: 'promotional_banner',
      bannerName: 'Offers Banner',
      position: 0,
    );

    for (var element in provider.maincategories) {
      if (element.name.toLowerCase() == 'offers') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(
              isCategory: true,
              title: "OFFERS",
              id: element.id.toString(),
              categoryName: element.slug,
            ),
          ),
        );
      }
    }
  }
}
