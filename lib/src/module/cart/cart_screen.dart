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
        backgroundColor: const Color(0xFFF9FBF7),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: Navigator.canPop(context)
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF1B3012), size: 20),
                        onPressed: () => Navigator.pop(context),
                      )
                    : null,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Cart',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B3012),
                      ),
                    ),
                    if (cartProvider.cartItems.isNotEmpty)
                      Text(
                        '${cartProvider.cartItems.length} item${cartProvider.cartItems.length == 1 ? '' : 's'}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
                actions: [
                  if (cartProvider.cartItems.isNotEmpty)
                    cartProvider.isClearingCart
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF3B5226),
                              ),
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () => _showClearCartDialog(cartProvider),
                            icon: const Icon(Icons.delete_outline,
                                size: 16, color: Color(0xFF3B5226)),
                            label: Text(
                              'Clear',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF3B5226),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                ],
              );
            },
          ),
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.isLoading) {
              return const CartShimmer();
            }

            return AbsorbPointer(
              absorbing: cartProvider.isDeletingItem || cartProvider.isPlacingOrder,
              child: Stack(
                children: [
                  _buildMainContent(cartProvider),
                  if (cartProvider.isDeletingItem || cartProvider.isPlacingOrder)
                    _buildLoadingOverlay(cartProvider.isPlacingOrder
                        ? 'Processing Order...'
                        : 'Updating Cart...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(String message) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF3B5226)),
              const SizedBox(height: 16),
              Text(
                message,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(CartProvider provider) {
    if (provider.cartItems.isEmpty) {
      return _buildEmptyCart();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFreeDeliveryProgress(provider),

          // Cart Items List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.cartItems.length,
            itemBuilder: (context, index) {
              final item = provider.cartItems[index];
              return CartProductTile(
                item: item,
                onQuantityChanged: (qty) =>
                    provider.updateCartItemQuantity(item.id, qty),
                onDelete: () => provider.deleteCartItem(item.id, context),
              );
            },
          ),

          _buildRecommendations(provider),
          _buildPriceSummary(provider),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(CartProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Cart',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3012),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${provider.cartItems.length} items · ₹${provider.totalAmount.toInt()}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          if (provider.cartItems.isNotEmpty)
            TextButton.icon(
              onPressed: provider.isClearingCart 
                ? null 
                : () => _showClearCartDialog(provider),
              icon: provider.isClearingCart
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B5226)),
                  )
                : const Icon(Icons.delete_outline, size: 18, color: Color(0xFF3B5226)),
              label: Text(
                'Clear cart',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF3B5226),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showClearCartDialog(CartProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear Cart?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to remove all items from your cart?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.clearEntireCart();
            },
            child: Text('CLEAR ALL', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeDeliveryProgress(CartProvider provider) {
    final threshold = provider.freeShippingThreshold;
    final total = provider.totalAmount;
    final isFree = total >= threshold;
    final progress = (total / threshold).clamp(0.0, 1.0);
    final remaining = threshold - total;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFA6C13C).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isFree ? const Color(0xFF3B5226) : const Color(0xFFFF7A00)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: isFree ? const Color(0xFF3B5226) : const Color(0xFFFF7A00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isFree ? 'CONGRATS! FREE DELIVERY IS ON US' : 'ADD ₹${remaining.toInt()} MORE TO UNLOCK FREE DELIVERY',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B3012),
                  ),
                ),
              ),
              Text(
                '₹${total.toInt()} / ₹${threshold.toInt()}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFree ? const Color(0xFF3B5226) : const Color(0xFFFF7A00),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildBadge(Icons.verified_user_outlined, 'SAFE'),
                  const SizedBox(width: 12),
                  _buildBadge(Icons.autorenew, '7-DAY'),
                ],
              ),
              if (!isFree)
                Text(
                  'Almost there!',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade400,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(CartProvider provider) {
    if (provider.recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Color(0xFFFF7A00), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'COMPLETE YOUR GARDEN',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B3012),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'HANDPICKED FOR YOUR COLLECTION',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'TOP PICKS',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: provider.recommendations.length,
            itemBuilder: (context, index) {
              final item = provider.recommendations[index];
              return _buildRecommendationCard(item, provider, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(CartRecommendationModel item, CartProvider provider, BuildContext context) {
    final resolvedImageUrl = item.image?.startsWith('http') == true
        ? item.image!
        : "${BaseUrl.baseUrlForImages}${item.image}";

    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: NetworkImageWidget(
              imageUrl: resolvedImageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3012),
            ),
          ),
          Text(
            'PROFESSIONAL SELECTION',
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${item.sellingPrice.toInt()}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3012),
                ),
              ),
              GestureDetector(
                onTap: () => provider.addRecommendationToCart(item.prodId, context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(Icons.add, size: 18, color: Color(0xFF3B5226)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3012),
                ),
              ),
              Text(
                '₹${provider.totalAmount.toInt()}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3B5226),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Incl. all taxes',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: provider.hasOutOfStockItems
                  ? null
                  : () => provider.placeOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    provider.hasOutOfStockItems ? Colors.grey : const Color(0xFF3B5226),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: provider.isPlacingOrder
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'SECURE CHECKOUT',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, color: Colors.grey.shade300, size: 14),
              const SizedBox(width: 6),
              Text(
                '100% Secure Payments',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xFF3B5226).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFF3B5226)),
          ),
          const SizedBox(height: 32),
          Text(
            'Your cart is empty',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B3012),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Explore our collections and find\nsomething special for your garden.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<BottomNavProvider>().updateIndex(0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavWidget()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B5226),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'CONTINUE SHOPPING',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
