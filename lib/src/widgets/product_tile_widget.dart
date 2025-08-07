import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import '../../import.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  Widget _buildProductImage() {
    const baseUrl = BaseUrl.baseUrlForImages;
    return Stack(
      children: [
        productImage != null
            ? SizedBox(
                height: 150,
                child: CachedNetworkImage(
                  imageUrl: '$baseUrl$productImage',
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      _buildNoImagePlaceholder(),
                ),
              )
            : _buildNoImagePlaceholder(),
        if (isOffer == true)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cButtonGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                '${_calculateDiscountPercentage()}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.07; // ~7% of screen width
    final iconSize = screenWidth * 0.045;
    return Container(
      width: 175,
      decoration: BoxDecoration(color: cAppBackround),
      child: Column(
        children: [
          home
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8),
                      child: InkWell(
                        onTap: addToFavouriteEvent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: isWishlist
                              ? Container(
                                  height: containerSize,
                                  width: containerSize,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 0.5,
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
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    )
                  ],
                )
              : sizedBoxHeight08,
          _buildProductImage(),
          sizedBoxHeight10,
          RatingBarWidget(
            rating: rating ?? 0,
          ),
          sizedBoxHeight10,
          CommonTextWidget(
            title: productTitle.length > 18
                ? '${productTitle.substring(0, 18)}...'
                : productTitle,
            color: cProductTitle,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            maxLines: 1,
          ),
          sizedBoxHeight10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextWidget(
                title: '₹$discountAmount',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cProductRate,
              ),
              sizedBoxWidth5,
              CommonTextWidget(
                title: '₹$actualAmount',
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: cProductRateCrossed,
                lineThrough: TextDecoration.lineThrough,
              )
            ],
          ),
          sizedBoxHeight10,
          home
              ? Padding(
                  padding: const EdgeInsets.only(left: 1.0, right: 1),
                  child: BorderColoredButton(
                    title: isCart ? "Go To Cart" : 'Add To Cart',
                    height: 38,
                    event: addToCartEvent,
                  ),
                )
              : sizedBoxHeight0
        ],
      ),
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.red,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
