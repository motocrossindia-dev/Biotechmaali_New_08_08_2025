import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';

import '../../../../import.dart';

class WishlistProductTileWidget extends StatelessWidget {
  final int productId;
  final bool isCart;
  final String productTitle;
  final String? productImage;
  final String tempImage;
  final double? rating;
  final String mrp;
  final String? sellingPrice;
  final bool home;
  final VoidCallback? addDeleteEvent;
  final VoidCallback? addToCartEvent;

  const WishlistProductTileWidget({
    required this.productId,
    required this.isCart,
    required this.productTitle,
    this.productImage,
    required this.tempImage,
    required this.mrp,
    this.sellingPrice,
    this.rating,
    this.addDeleteEvent,
    this.addToCartEvent,
    required this.home,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseUrl = BaseUrl.baseUrlForImages;

    return Container(
      width: 175,
      decoration: BoxDecoration(color: cAppBackround),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8),
                child: InkWell(
                    onTap: addDeleteEvent,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 15.0, top: 15),
                      child: Icon(Icons.delete_outline),
                    )),
              )
            ],
          ),
          sizedBoxHeight08,
          productImage != null
              ? SizedBox(
                  height: 150,
                  child: NetworkImageWidget(
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
          sizedBoxHeight10,
          RatingBarWidget(
            rating: rating ?? 0,
          ),
          sizedBoxHeight10,
          CommonTextWidget(
            title: productTitle,
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
                title: '₹$sellingPrice',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: cProductRate,
              ),
              sizedBoxWidth5,
              CommonTextWidget(
                title: '₹$mrp',
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
                    title: isCart ? 'Go To Cart' : 'Add To Cart',
                    height: 38,
                    event: isCart
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(
                                  id: productId.toString(),
                                  isCategory: false,
                                  isSubCategory: false,
                                  title: productTitle,
                                  isHomeProductList: false,
                                  isWishlist: true,
                                ),
                              ),
                            );
                          }
                        : () async {
                            final settingsProvider =
                                context.read<SettingsProvider>();
                            bool isAuth = await settingsProvider
                                .checkAccessTokenValidity(context);
                            if (!isAuth) {
                              _showLoginDialog(context);
                              return;
                            }
                            bool result =
                                await context.read<CartProvider>().addToCart(
                                      productId,
                                      1,
                                      context,
                                    );

                            if (result) {
                              context.read<WishlistProvider>().updateCart(
                                    isCart,
                                    productId,
                                    context,
                                  );
                            }
                          },
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

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
