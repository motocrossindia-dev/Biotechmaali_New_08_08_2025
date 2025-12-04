import '../../../../../import.dart';

class CaroucelProductWidget extends StatefulWidget {
  const CaroucelProductWidget({super.key});

  @override
  State<CaroucelProductWidget> createState() => _CaroucelProductWidgetState();
}

class _CaroucelProductWidgetState extends State<CaroucelProductWidget> {
  @override
  void initState() {
    super.initState();
    // Preload images when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  void _preloadImages() {
    final provider = context.read<ProductDetailsProvider>();
    for (String imageUrl in provider.carouselProductImageList) {
      if (imageUrl.isNotEmpty) {
        precacheImage(
          NetworkImage(imageUrl),
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsProvider>(
      builder: (context, provider, child) {
        // Show loading or empty state if no images
        if (provider.carouselProductImageList.isEmpty) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: [
            // Carousel Slider
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 20, left: 20),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context)
                      .size
                      .width, // Square height based on width
                  autoPlay: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    provider.onCarouselIndexChange(index);
                  },
                ),
                items: provider.carouselProductImageList
                    .map(
                      (item) => Center(
                        child: AspectRatio(
                          aspectRatio: 1.0, // Makes it square (1:1 ratio)
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: NetworkImageWidget(
                              imageUrl: item,
                              fit: BoxFit
                                  .cover, // Changed from fill to cover for better square display
                              memCacheWidth: (MediaQuery.of(context)
                                          .size
                                          .width *
                                      MediaQuery.of(context).devicePixelRatio)
                                  .round(),
                              memCacheHeight: (MediaQuery.of(context)
                                          .size
                                          .width *
                                      MediaQuery.of(context).devicePixelRatio)
                                  .round(),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // Indicators
            if (provider.carouselProductImageList.length >
                1) // Only show if multiple images
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: provider.carouselProductImageList.asMap().entries.map(
                  (entry) {
                    return provider.carouselIndex == entry.key
                        ? Container(
                            width: 27.0,
                            height: 5.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cButtonGreen,
                            ),
                          )
                        : Container(
                            width: 5.0,
                            height: 5.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cCaroucelButtonGrey,
                            ),
                          );
                  },
                ).toList(),
              ),
          ],
        );
      },
    );
  }
}
