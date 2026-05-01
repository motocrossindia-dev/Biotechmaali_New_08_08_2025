import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';

class CustomBannerWidget extends StatelessWidget {
  const CustomBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        // Get promotional banner data
        final bannerData = provider.promotionalBanner;
        final hasValidData = bannerData != null &&
            bannerData.isVisible &&
            bannerData.mobileBanner.isNotEmpty;

        if (!hasValidData) {
          // Fallback to original static banner
          return Container(
            decoration: BoxDecoration(gradient: lgBanner),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 70,
                    child: Image.asset(
                      'assets/png/images/product_list_banner.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CommonTextWidget(
                          title: 'Vibrant and Thriving Plants Online',
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                        sizedBoxHeight08,
                        const CommonTextWidget(
                          title: 'Celebrate Friendship with 15%',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        sizedBoxHeight08,
                        SizedBox(
                          height: 22,
                          child: CustomizableButton(
                            title: 'Shop Now',
                            fontSize: 8,
                            event: () {
                              _navigateToOffers(context, provider);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }

        // Display banner with data from API
        final String imageUrl = bannerData.mobileBanner;
        final String title = bannerData.title.isNotEmpty
            ? bannerData.title
            : 'Vibrant and Thriving Plants Online';
        final String subtitle = bannerData.subtitle.isNotEmpty
            ? bannerData.subtitle
            : 'Celebrate Friendship with 15%';
        final String buttonText = bannerData.buttonText.isNotEmpty
            ? bannerData.buttonText
            : 'Shop Now';

        return Container(
          decoration: BoxDecoration(
            gradient: lgBanner,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Banner Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 60,
                    width: 80,
                    child: NetworkImageWidget(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 60,
                      memCacheWidth: 160,
                      memCacheHeight: 120,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Text Content
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (title.isNotEmpty)
                        CommonTextWidget(
                          title: title,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.right,
                        ),
                      if (title.isNotEmpty && subtitle.isNotEmpty)
                        sizedBoxHeight08,
                      if (subtitle.isNotEmpty)
                        CommonTextWidget(
                          title: subtitle,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.right,
                        ),
                      sizedBoxHeight08,
                      SizedBox(
                        height: 24,
                        child: CustomizableButton(
                          title: buttonText,
                          fontSize: 9,
                          event: () {
                            _navigateToOffers(context, provider);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOffers(BuildContext context, HomeProvider provider) {
    for (var element in provider.maincategories) {
      if (element.name.toLowerCase() == 'offers') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(
              isCategory: true,
              title: element.name,
              id: element.id.toString(),
              categoryName: element.slug,
            ),
          ),
        );
      }
    }
  }
}
