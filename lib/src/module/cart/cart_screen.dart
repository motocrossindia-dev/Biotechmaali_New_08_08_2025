import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_shimmer.dart';
import 'package:biotech_maali/src/module/cart/widgets/cart_product_tile.dart';
import 'package:biotech_maali/src/module/cart/widgets/price_detailrow.dart';
import 'package:biotech_maali/src/module/product_search/product_search_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import '../../../import.dart';

class CartScreen extends StatefulWidget {
  final bool isWishlist;
  final bool isHomeProductList;
  final bool isCategory;
  final bool isSubCategory;
  final bool isSearch;
  final String title;
  final String id;
  const CartScreen({
    this.isWishlist = false,
    this.isHomeProductList = false,
    this.isCategory = false,
    this.isSubCategory = false,
    this.isSearch = false,
    this.title = "",
    this.id = "",
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          if (widget.isCategory) {
            if (widget.title == "OFFERS") {
              context.read<ProductListProdvider>().getOfferProductList(context);
            } else {
              context
                  .read<ProductListProdvider>()
                  .getCategoryProductList(categoryId: widget.id);
            }
          } else if (widget.isSubCategory == true) {
            context
                .read<ProductListProdvider>()
                .getSubCategoryProductList(subCategoryId: widget.id);
          }

          if (widget.isHomeProductList) {
            context.read<HomeProvider>().fetchHomeProducts();
          }
          if (widget.isWishlist) {
            context.read<WishlistProvider>().fetchWishlist();
          }
          if (widget.isSearch) {
            context.read<ProductSearchProvider>().searchProducts(
                context.read<ProductSearchProvider>().lastSearchQuery);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 4,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const CommonTextWidget(
            title: 'Shopping Cart',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            // if (cartProvider.isLoading || cartProvider.isPlacingOrder) {
            //   return const CartShimmer();
            // }

            if (cartProvider.error.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cartProvider.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cartProvider.fetchCartItems(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (cartProvider.cartItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64),
                    SizedBox(height: 16),
                    Text('Your cart is empty'),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.cartItems.length,
                    separatorBuilder: (context, index) => Container(
                      height: 8,
                      color: cAppBackround,
                    ),
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return CartProductTile(
                        key: ValueKey(item.id),
                        productId: item.productId,
                        cartId: item.id,
                        productTitle: item.name,
                        productImage: item.image,
                        sellingPrice:
                            double.parse(item.sellingPrice.toString()),
                        mrp: double.parse(item.mrp.toString()),
                        quantity: item.quantity,
                        stockStatus: item.stockStatus,
                        onQuantityChanged: (newQuantity) async {
                          await cartProvider.updateCartItemQuantity(
                              item.id, newQuantity);
                        },
                        onDelete: () async {
                          await cartProvider.deleteCartItem(item.id, context);
                        },
                      );
                    },
                  ),
                  Container(
                    height: 8,
                    color: cAppBackround,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CommonTextWidget(
                          title: 'Price Details',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                        PriceDetailRow(
                          title:
                              'Price (${cartProvider.cartItems.length} Items)',
                          amount: cartProvider.totalAmount,
                        ),
                        const SizedBox(height: 16),
                        PriceDetailRow(
                          title: 'Discount',
                          amount: cartProvider.totalDiscount,
                          color: Colors.green,
                        ),
                        // const SizedBox(height: 16),
                        // const DeliveryChargesRow(),
                        const SizedBox(height: 16),
                        PriceDetailRow(
                          title: 'Total Amount',
                          amount: cartProvider.totalAmount -
                              cartProvider.totalDiscount,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: CommonTextWidget(
                            title:
                                'You will save ₹${(cartProvider.totalDiscount).toStringAsFixed(2)} on this order',
                            color: Colors.green,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 160,
                height: 48,
                child: CustomizableBorderColoredButton(
                  title: 'CANCEL',
                  event: () {
                    context.read<BottomNavProvider>().updateIndex(0);
                  },
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: 160,
                    height: 48,
                    child: provider.isPlacingOrder
                        ? const ButtonShimmer() // Use ButtonShimmer instead of CartShimmer
                        : CustomizableButton(
                            title: 'PLACE ORDER',
                            event: () {
                              provider.placeOrder(context);
                            }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
