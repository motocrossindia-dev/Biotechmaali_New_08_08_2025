import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import '../../import.dart';

class ProductTileWidget extends StatelessWidget {
  final bool? isOffer;
  final String productTitle;
  final String? productImage;
  final String tempImage;
  final double? rating;
  final String actualAmount;
  final String? discountAmount;
  final bool home;
  final VoidCallback? addToFavouriteEvent;
  final VoidCallback? addToCartEvent;
  final bool isWishlist;
  final bool isCart;
  final int? mainProdId;

  const ProductTileWidget({
    this.isOffer,
    required this.productTitle,
    this.productImage,
    required this.tempImage,
    required this.actualAmount,
    this.discountAmount,
    this.rating,
    this.addToFavouriteEvent,
    this.addToCartEvent,
    required this.home,
    required this.isWishlist,
    required this.isCart,
    this.mainProdId,
    super.key,
  });

  String _formatPrice(String price) {
    final doublePrice = double.tryParse(price);
    if (doublePrice != null) {
      return doublePrice.toInt().toString();
    }
    return price; // Return original if parsing fails
  }

  String _calculateDiscountPercentage() {
    if (discountAmount == null ||
        actualAmount.isEmpty ||
        discountAmount!.isEmpty) {
      return '0';
    }
    final actual = double.tryParse(actualAmount) ?? 0;
    final discount = double.tryParse(discountAmount!) ?? 0;
    if (actual == 0) return '0';
    final percentage = ((actual - discount) / actual * 100).round();
    return percentage.toString();
  }

  bool get hasDiscount =>
      discountAmount != null &&
      discountAmount!.isNotEmpty &&
      discountAmount != actualAmount;

  String get discountPercentage => _calculateDiscountPercentage();

  bool get shouldShowDiscountBadge =>
      isOffer == true && discountPercentage != '0';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;
    final isLargePhone = screenWidth >= 414;
    final isSmallPhone = screenWidth < 360;

    // Responsive sizing based on device type
    final cardWidth = isTablet
        ? screenWidth * 0.3 // 30% for tablets
        : isLargePhone
            ? screenWidth * 0.43 // 43% for large phones
            : screenWidth * 0.45; // 45% for small phones

    final cardHeight = isTablet
        ? screenHeight * 0.35 // 35% for tablets
        : isSmallPhone
            ? screenHeight * 0.38 // 38% for small phones
            : screenHeight * 0.32; // 32% for regular phones

    final containerSize = isTablet
        ? screenWidth * 0.04
        : isSmallPhone
            ? screenWidth * 0.06
            : screenWidth * 0.05;

    final iconSize = isTablet
        ? screenWidth * 0.035
        : isSmallPhone
            ? screenWidth * 0.05
            : screenWidth * 0.045;

    final borderRadius = isTablet ? 16.0 : 12.0;
    final cardMargin = isTablet
        ? 6.0
        : isSmallPhone
            ? 3.0
            : 4.0;

    const baseUrl = BaseUrl.baseUrlForImages;

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(cardMargin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: cAppBackround,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with overlaid elements
            Expanded(
              flex: isTablet ? 4 : 3, // More space for image on tablets
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: productImage != null && productImage!.isNotEmpty
                          ? NetworkImageWidget(
                              imageUrl: '$baseUrl$productImage',
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      color: Colors.grey[400],
                                      size: isTablet
                                          ? 50
                                          : isSmallPhone
                                              ? 30
                                              : 40,
                                    ),
                                    SizedBox(height: isSmallPhone ? 4 : 8),
                                    Text(
                                      'No Image',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: isTablet
                                            ? 14
                                            : isSmallPhone
                                                ? 10
                                                : 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey[400],
                                    size: isTablet
                                        ? 50
                                        : isSmallPhone
                                            ? 30
                                            : 40,
                                  ),
                                  SizedBox(height: isSmallPhone ? 4 : 8),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet
                                          ? 14
                                          : isSmallPhone
                                              ? 10
                                              : 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    // Discount badge
                    if (shouldShowDiscountBadge)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet
                                ? 10
                                : isSmallPhone
                                    ? 6
                                    : 8,
                            vertical: isTablet
                                ? 6
                                : isSmallPhone
                                    ? 3
                                    : 4,
                          ),
                          decoration: BoxDecoration(
                            color: cButtonGreen,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              bottomRight: const Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            '$discountPercentage% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet
                                  ? 12
                                  : isSmallPhone
                                      ? 9
                                      : 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Wishlist button for home screens
                    if (home)
                      Positioned(
                        top: isTablet
                            ? 10
                            : isSmallPhone
                                ? 6
                                : 8,
                        right: isTablet
                            ? 10
                            : isSmallPhone
                                ? 6
                                : 8,
                        child: InkWell(
                          onTap: addToFavouriteEvent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(isTablet
                                ? 6.0
                                : isSmallPhone
                                    ? 4.0
                                    : 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isWishlist
                                ? Container(
                                    height: containerSize,
                                    width: containerSize,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: isTablet
                                            ? 14
                                            : isSmallPhone
                                                ? 9
                                                : 11,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/svg/icons/add_to_favourite_icon.svg',
                                    color: Colors.black54,
                                    height: iconSize,
                                    width: iconSize,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Content section with fixed spacing
            Expanded(
              flex: isTablet ? 3 : 2, // More space for content on tablets
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? 12.0
                      : isSmallPhone
                          ? 6.0
                          : 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  children: [
                    Flexible(
                      child: SizedBox(
                          height: isTablet
                              ? 10
                              : isSmallPhone
                                  ? 6
                                  : 8),
                    ),

                    // Rating
                    Center(
                      child: RatingBarWidget(
                        rating: rating ?? 0,
                      ),
                    ),

                    Flexible(
                      child: SizedBox(
                          height: isTablet
                              ? 10
                              : isSmallPhone
                                  ? 6
                                  : 8),
                    ),

                    // Product title
                    Center(
                      child: CommonTextWidget(
                        title: productTitle,
                        color: cProductTitle,
                        fontSize: isTablet
                            ? 16
                            : isSmallPhone
                                ? 12
                                : 14,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        maxLines: isTablet ? 2 : 1, // Allow 2 lines on tablets
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Flexible(
                      child: SizedBox(
                          height: isTablet
                              ? 10
                              : isSmallPhone
                                  ? 6
                                  : 8),
                    ),

                    // Price section - responsive sizing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show discounted price first if there's a discount
                        if (hasDiscount) ...[
                          CommonTextWidget(
                            title: '₹${_formatPrice(discountAmount!)}',
                            fontSize: isTablet
                                ? 16
                                : isSmallPhone
                                    ? 12
                                    : 14,
                            fontWeight: FontWeight.w600,
                            color: cProductRate,
                          ),
                          SizedBox(
                              width: isTablet
                                  ? 8
                                  : isSmallPhone
                                      ? 3
                                      : 5),
                          CommonTextWidget(
                            title: '₹${_formatPrice(actualAmount)}',
                            fontSize: isTablet
                                ? 14
                                : isSmallPhone
                                    ? 10
                                    : 12,
                            fontWeight: FontWeight.w400,
                            color: cProductRateCrossed,
                            lineThrough: TextDecoration.lineThrough,
                          ),
                        ] else ...[
                          // Show only actual price if no discount
                          CommonTextWidget(
                            title: '₹${_formatPrice(actualAmount)}',
                            fontSize: isTablet
                                ? 16
                                : isSmallPhone
                                    ? 12
                                    : 14,
                            fontWeight: FontWeight.w600,
                            color: cProductRate,
                          ),
                        ],
                      ],
                    ),

                    const Spacer(), // This pushes the button to the bottom

                    // Add to cart button - responsive sizing
                    if (home)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          bottom: isTablet
                              ? 12.0
                              : isSmallPhone
                                  ? 6.0
                                  : 8.0,
                        ),
                        child: BorderColoredButton(
                          title: isCart ? "Go To Cart" : 'Add To Cart',
                          height: isTablet
                              ? 44
                              : isSmallPhone
                                  ? 32
                                  : 36,
                          event: addToCartEvent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
