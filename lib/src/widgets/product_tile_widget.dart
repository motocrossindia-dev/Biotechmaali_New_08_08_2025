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
    final containerSize = screenWidth * 0.07; // ~7% of screen width
    final iconSize = screenWidth * 0.045;
    const baseUrl = BaseUrl.baseUrlForImages;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: screenWidth * 0.425, // More responsive width (~43% of screen)
        decoration: BoxDecoration(
          color: cAppBackround,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favorite button section
            if (home)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8),
                    child: InkWell(
                      onTap: addToFavouriteEvent,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    size: iconSize,
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
                  )
                ],
              )
            else
              sizedBoxHeight08,

            // Product image - inlined to avoid method calls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: productImage != null && productImage!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: '$baseUrl$productImage',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 150,
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
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No Image',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 150,
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
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (shouldShowDiscountBadge)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cButtonGreen,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            sizedBoxHeight10,

            // Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: RatingBarWidget(
                  rating: rating ?? 0,
                ),
              ),
            ),

            sizedBoxHeight10,

            // Product title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: CommonTextWidget(
                  title: productTitle,
                  color: cProductTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            sizedBoxHeight10,

            // Price section - inlined to avoid method calls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show discounted price first if there's a discount
                  if (hasDiscount) ...[
                    CommonTextWidget(
                      title: '₹$discountAmount',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cProductRate,
                    ),
                    sizedBoxWidth5,
                    CommonTextWidget(
                      title: '₹$actualAmount',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: cProductRateCrossed,
                      lineThrough: TextDecoration.lineThrough,
                    ),
                  ] else ...[
                    // Show only actual price if no discount
                    CommonTextWidget(
                      title: '₹$actualAmount',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cProductRate,
                    ),
                  ],
                ],
              ),
            ),

            sizedBoxHeight10,

            // Add to cart button
            if (home)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BorderColoredButton(
                  title: isCart ? "Go To Cart" : 'Add To Cart',
                  height: 38,
                  event: addToCartEvent,
                ),
              )
            else
              sizedBoxHeight0,
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
