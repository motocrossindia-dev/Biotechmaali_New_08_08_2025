import '../../../../../import.dart';

class RecentlyViewedProductTile extends StatelessWidget {
  final int mainProdId;
  final String productTitle;
  final String? productImage;
  final String tempImage;
  final String? discountAmount;
  final String actualAmount;
  final double? rating;
  final bool isWishlist;
  final bool isCart;
  final VoidCallback addToFavouriteEvent;
  final VoidCallback addToCartEvent;

  const RecentlyViewedProductTile({
    required this.mainProdId,
    required this.productTitle,
    this.productImage,
    required this.tempImage,
    this.discountAmount,
    required this.actualAmount,
    this.rating,
    required this.isWishlist,
    required this.isCart,
    required this.addToFavouriteEvent,
    required this.addToCartEvent,
    super.key,
  });

  bool get hasDiscount =>
      discountAmount != null &&
      discountAmount!.isNotEmpty &&
      discountAmount != actualAmount;

  String _calculateDiscountPercentage() {
    if (discountAmount == null ||
        actualAmount.isEmpty ||
        discountAmount!.isEmpty) return '0';
    final actual = double.tryParse(actualAmount) ?? 0;
    final discount = double.tryParse(discountAmount!) ?? 0;
    if (actual == 0) return '0';
    final percentage = ((actual - discount) / actual * 100).round();
    return percentage.toString();
  }

  String get discountPercentage => _calculateDiscountPercentage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    const baseUrl = BaseUrl.baseUrlForImages;

    // Calculate responsive dimensions
    double cardWidth = screenWidth * (isTablet ? 0.35 : 0.45);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: screenWidth * 0.03),
      decoration: BoxDecoration(
        color: cWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with wishlist button
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: productImage != null && productImage!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: '$baseUrl$productImage',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                tempImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Image.asset(
                            tempImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                  ),
                ),
                // Wishlist button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: addToFavouriteEvent,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isWishlist ? cButtonRed : Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cButtonRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonTextWidget(
                        title: '$discountPercentage% OFF',
                        color: cWhiteColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content section - optimized for space
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating - compact

                  // Product title - compact
                  CommonTextWidget(
                    title: productTitle,
                    color: cProductTitle,
                    fontSize: isTablet ? 13 : 12,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price section - exactly matching ProductTileWidget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show discounted price first if there's a discount
                      if (hasDiscount) ...[
                        CommonTextWidget(
                          title: '₹$discountAmount',
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w600,
                          color: cProductRate,
                        ),
                        const SizedBox(width: 4),
                        CommonTextWidget(
                          title: '₹$actualAmount',
                          fontSize: isTablet ? 11 : 10,
                          fontWeight: FontWeight.w400,
                          color: cProductRateCrossed,
                          lineThrough: TextDecoration.lineThrough,
                        ),
                      ] else ...[
                        // Show only actual price if no discount
                        CommonTextWidget(
                          title: '₹$actualAmount',
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w600,
                          color: cProductRate,
                        ),
                      ],
                    ],
                  ),

                  // Add to cart button - compact
                  SizedBox(
                    width: double.infinity,
                    height: 32, // Reduced button height
                    child: BorderColoredButton(
                      title: isCart ? "Go To Cart" : 'Add To Cart',
                      height: 32,
                      event: addToCartEvent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
