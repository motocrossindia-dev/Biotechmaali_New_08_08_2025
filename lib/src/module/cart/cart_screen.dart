import 'package:biotech_maali/src/module/cart/cart_provider.dart';
import 'package:biotech_maali/src/module/cart/cart_shimmer.dart';
import 'package:biotech_maali/src/module/cart/model/cart_item_model.dart';
import 'package:biotech_maali/src/module/cart/widgets/cart_product_tile.dart';
import 'package:biotech_maali/src/module/cart/widgets/price_detailrow.dart';
import 'package:biotech_maali/src/module/product_search/product_search_provider.dart';
import 'package:biotech_maali/src/module/wishlist/whishlist_provider.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';
import 'package:biotech_maali/core/services/in_app_messaging_service.dart';
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

    // Track cart screen view
    AnalyticsService().logScreenView(screenName: ScreenNames.cart);

    // Trigger FIAM cart campaign
    InAppMessagingService().triggerCartView();

    context.read<CartProvider>().fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          if (widget.isCategory) {
            context.read<ProductListProdvider>().getCategoryProductList(
                categoryId: widget.id);
          } else if (widget.isSubCategory == true) {
            context
                .read<ProductListProdvider>()
                .getSubCategoryProductList(subCategoryId: widget.id);
          }

          if (widget.isHomeProductList) {
            context.read<HomeProvider>().fetchPublicFlags();
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

            return AbsorbPointer(
              absorbing: cartProvider.isDeletingItem,
              child: Stack(
                children: [
                  // Main content
                  _buildMainContent(cartProvider),
                  // Loading overlay
                  if (cartProvider.isDeletingItem) _buildLoadingOverlay(),

                  // Full-screen loading overlay for delete operation
                  if (cartProvider.isDeletingItem)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3F6331), // cButtonGreen theme color
                                ),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Removing item...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please wait',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavWidget(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: 160,
                      height: 48,
                      child: provider.isPlacingOrder
                          ? const ButtonShimmer()
                          : Tooltip(
                              message: provider.hasOutOfStockItems
                                  ? 'Remove out-of-stock items to proceed'
                                  : 'Place your order',
                              child: CustomizableButton(
                                title: 'PLACE ORDER',
                                // Disable place order if there are out-of-stock items
                                event: provider.hasOutOfStockItems
                                    ? null
                                    : () {
                                        provider.placeOrder(context);
                                      },
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(CartProvider cartProvider) {
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
          // ── Out-of-stock banner ──
          if (cartProvider.hasOutOfStockItems)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade50,
                    Colors.orange.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header row with icon + text ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cCustomRed.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove_shopping_cart_rounded,
                            color: cCustomRed,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cartProvider.outOfStockItems.length} item${cartProvider.outOfStockItems.length > 1 ? 's' : ''} out of stock',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cCustomRed,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Remove them to place your order',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ── Horizontal item chips ──
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: cartProvider.outOfStockItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final item = cartProvider.outOfStockItems[index];
                          return _buildOutOfStockItemChip(item, cartProvider);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Action buttons row ──
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: cartProvider.isRemovingOutOfStock
                                ? null
                                : () => _showOutOfStockDialog(cartProvider),
                            icon: Icon(Icons.list_alt_rounded,
                                size: 18, color: cCustomRed),
                            label: Text(
                              'View Details',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: cCustomRed,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cCustomRed),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: cartProvider.isRemovingOutOfStock
                                ? null
                                : () async {
                                    await cartProvider
                                        .removeAllOutOfStockItems(context);
                                  },
                            icon: cartProvider.isRemovingOutOfStock
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.delete_sweep_rounded,
                                    size: 18),
                            label: Text(
                              cartProvider.isRemovingOutOfStock
                                  ? 'Removing...'
                                  : 'Remove All',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cCustomRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

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
                sellingPrice: item.sellingPriceWithGst,
                mrp: item.mrpWithGst,
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
                  title: 'Price (${cartProvider.cartItems.length} Items)',
                  amount: cartProvider.totalAmount,
                ),
                const SizedBox(height: 16),
                PriceDetailRow(
                  title: 'Discount',
                  amount: cartProvider.totalDiscount,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                PriceDetailRow(
                  title: 'Total Amount',
                  amount: cartProvider.totalAmount - cartProvider.totalDiscount,
                  isBold: true,
                ),
                const SizedBox(height: 16),
                Center(
                  child: CommonTextWidget(
                    title:
                        'You will save ₹${(cartProvider.totalDiscount).toInt()} on this order',
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
  }

  void _showOutOfStockDialog(CartProvider cartProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Consumer<CartProvider>(
          builder: (context, provider, _) {
            final items = provider.outOfStockItems;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 520),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Icon header ──
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cCustomRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove_shopping_cart_rounded,
                        size: 36,
                        color: cCustomRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Title ──
                    Text(
                      'Out of Stock Items',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // ── Subtitle ──
                    Text(
                      'Remove the following items to proceed with your order.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // ── Item count badge ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: cCustomRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${items.length} item${items.length > 1 ? 's' : ''} unavailable',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cCustomRed,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Item list ──
                    Flexible(
                      child: items.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 48, color: cButtonGreen),
                                  const SizedBox(height: 12),
                                  Text(
                                    'All items cleared!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: cButtonGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  Divider(color: Colors.grey.shade200),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final imageUrl = item.image.toString();
                                final resolvedUrl = imageUrl.startsWith('http')
                                    ? imageUrl
                                    : "${BaseUrl.baseUrlForImages}$imageUrl";

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      // Thumbnail
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: imageUrl.isEmpty
                                            ? Container(
                                                width: 56,
                                                height: 56,
                                                color: Colors.grey.shade100,
                                                child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    color: Colors.grey.shade400,
                                                    size: 22),
                                              )
                                            : NetworkImageWidget(
                                                imageUrl: resolvedUrl,
                                                width: 56,
                                                height: 56,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (ctx, url, error) =>
                                                        Container(
                                                  width: 56,
                                                  height: 56,
                                                  color: Colors.grey.shade100,
                                                  child: Icon(
                                                      Icons
                                                          .image_not_supported_outlined,
                                                      color:
                                                          Colors.grey.shade400,
                                                      size: 22),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Name + qty
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    'Qty: ${item.quantity}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: cCustomRed
                                                        .withOpacity(0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    'Out of stock',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: cCustomRed,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Delete button
                                      Material(
                                        color: cCustomRed.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: provider.isDeletingItem
                                              ? null
                                              : () async {
                                                  await provider.deleteCartItem(
                                                      item.id, context);
                                                  if (!provider
                                                      .hasOutOfStockItems) {
                                                    Navigator.of(ctx).pop();
                                                  }
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              color: cCustomRed,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 20),

                    // ── Bottom action buttons ──
                    if (items.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: provider.isRemovingOutOfStock
                              ? null
                              : () async {
                                  await provider
                                      .removeAllOutOfStockItems(context);
                                  if (!provider.hasOutOfStockItems) {
                                    Navigator.of(ctx).pop();
                                  }
                                },
                          icon: provider.isRemovingOutOfStock
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Icon(Icons.delete_sweep_rounded,
                                  size: 20),
                          label: Text(
                            provider.isRemovingOutOfStock
                                ? 'Removing Items...'
                                : 'Remove All (${items.length})',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cCustomRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          items.isEmpty ? 'Done' : 'Back to Cart',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a single out-of-stock item chip for the banner horizontal list
  Widget _buildOutOfStockItemChip(
      CartItemModel item, CartProvider cartProvider) {
    final imageUrl = item.image.toString();
    final resolvedUrl = imageUrl.startsWith('http')
        ? imageUrl
        : "${BaseUrl.baseUrlForImages}$imageUrl";

    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isEmpty
                ? Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400, size: 20),
                  )
                : NetworkImageWidget(
                    imageUrl: resolvedUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorWidget: (ctx, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade100,
                      child: Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey.shade400, size: 20),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cCustomRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Out of stock',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: cCustomRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap:
                cartProvider.isRemovingOutOfStock || cartProvider.isDeletingItem
                    ? null
                    : () async {
                        await cartProvider.deleteCartItem(item.id, context);
                      },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cCustomRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.close_rounded, color: cCustomRed, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF3F6331), // cButtonGreen theme color
                ),
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Removing item...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
