import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_shimmer.dart';

import '../../../../import.dart';

class CartProductTile extends StatelessWidget {
  final int productId;
  final int cartId;
  final String productTitle;
  final String productImage;
  final double sellingPrice;
  final double mrp;
  final int quantity;
  final String stockStatus;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  const CartProductTile({
    super.key,
    required this.productId,
    required this.cartId,
    required this.productTitle,
    required this.productImage,
    required this.sellingPrice,
    required this.mrp,
    required this.quantity,
    required this.stockStatus,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isInStock = stockStatus.toLowerCase() == 'in stock';

    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: NetworkImageWidget(
                      imageUrl: "${BaseUrl.baseUrlForImages}$productImage",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget(
                          title: productTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CommonTextWidget(
                              title: '₹${sellingPrice.toStringAsFixed(2)}',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: cProductRate,
                            ),
                            const SizedBox(width: 8),
                            CommonTextWidget(
                              title: '₹${mrp.toStringAsFixed(2)}',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: cProductRateCrossed,
                              lineThrough: TextDecoration.lineThrough,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isInStock) ...[
                          AddQuantityWidget(
                            itmeId: cartId,
                            quantity: quantity,
                            addition: () => onQuantityChanged(quantity + 1),
                            substaction: () {
                              if (quantity > 1) {
                                onQuantityChanged(quantity - 1);
                              }
                            },
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const CommonTextWidget(
                              title: 'Out of stock',
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: provider.isDeleteLoading(cartId)
                      ? const DeleteButtonShimmer()
                      : IconButton(
                          onPressed: onDelete,
                          icon: SvgPicture.asset(
                            'assets/svg/icons/delete_icon.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
