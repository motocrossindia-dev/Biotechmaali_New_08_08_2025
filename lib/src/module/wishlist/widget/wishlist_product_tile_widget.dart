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
  final bool isWishlist;
  final bool? isStock;
  final VoidCallback? addDeleteEvent;
  final VoidCallback? addToCartEvent;

  const WishlistProductTileWidget({
    required this.productId,
    required this.isCart,
    required this.isWishlist,
    this.isStock,
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
    return ProductTileWidget(
      mainProdId: productId,
      productTitle: productTitle,
      productImage: productImage,
      tempImage: tempImage,
      actualAmount: mrp,
      discountAmount: sellingPrice,
      rating: rating,
      home: home,
      isWishlist: isWishlist,
      isCart: isCart,
      isStock: isStock,
      addToFavouriteEvent: addDeleteEvent,
      addToCartEvent: addToCartEvent ??
          (isCart
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(
                        id: "",
                        isCategory: false,
                        isSubCategory: false,
                        title: "",
                        isHomeProductList: false,
                        isWishlist: true,
                      ),
                    ),
                  );
                }
              : () async {
                  final settingsProvider = context.read<SettingsProvider>();
                  bool isAuth =
                      await settingsProvider.checkAccessTokenValidity(context);
                  if (!isAuth) {
                    _showLoginDialog(context);
                    return;
                  }
                  bool result = await context.read<CartProvider>().addToCart(
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
                }),
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
