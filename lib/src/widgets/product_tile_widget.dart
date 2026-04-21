import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import '../../import.dart';

class ProductTileWidget extends StatelessWidget {
  final bool? isOffer;
  final String productTitle;
  final dynamic productImage;
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
  final String? ribbon;
  final List<String>? flags;
  final bool? isStock;
  final int? stock;
  final String? subCategorySlug;
  final int? numRatings;

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
    this.ribbon,
    this.flags,
    this.isStock,
    this.stock,
    this.subCategorySlug,
    this.numRatings,
    super.key,
  });

  String get formattedSubCategory {
    if (subCategorySlug == null || subCategorySlug!.isEmpty) return '';
    return subCategorySlug!.replaceAll('-', ' ').toUpperCase();
  }

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
        ? screenHeight * 0.22 // Adjusted for dynamic responsive UI
        : isSmallPhone
            ? screenHeight * 0.28 // Adjusted for dynamic responsive UI
            : screenHeight * 0.25; // Adjusted for responsive fit

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
              flex: isTablet ? 5 : 4, // More space for image on tablets
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Stack(
                  children: [
                    // Square image container aligned to top - FULL WIDTH
                    SizedBox(
                      width: double.infinity, // Force full width
                      child: AspectRatio(
                        aspectRatio: 1, // Makes image square

                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          ),
                          child: ProductImageWithLongPress(
                            productImage: productImage,
                            baseUrl: baseUrl,
                            isTablet: isTablet,
                            isSmallPhone: isSmallPhone,
                          ),
                        ),
                      ),
                    ),
                    // Flag Badge (top-left) inside the image stack
                    if (flags != null && flags!.isNotEmpty)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: AnimatedFlagBadge(flags: flags!),
                      ),
                    // Ribbon badge (diagonal top right corner)
                    if (ribbon != null && ribbon!.isNotEmpty)
                      Positioned(
                        top: 18,
                        right: -32,
                        child: Transform.rotate(
                          angle: 45 * 3.141592653589793 / 180,
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet
                                  ? 6
                                  : isSmallPhone
                                      ? 3
                                      : 4,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE55B5B).withOpacity(
                                  0.85), // Muted red slightly transparent
                            ),
                            child: Text(
                              ribbon!.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet
                                    ? 12
                                    : isSmallPhone
                                        ? 8
                                        : 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Discount badge (bottom left corner)
                    if (shouldShowDiscountBadge)
                      Positioned(
                        bottom: 0,
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
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                            ),
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
                    // Wishlist button (top right corner, below ribbon)
                    if (home)
                      Positioned(
                        top: 45,
                        right: 8,
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
              flex: isTablet
                  ? 4
                  : 5, // More space for content to prevent overflow
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? 12.0
                      : isSmallPhone
                          ? 6.0
                          : 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isTablet ? 6 : 8),

                    // Sub Category
                    if (formattedSubCategory.isNotEmpty) ...[
                      Text(
                        formattedSubCategory,
                        style: TextStyle(
                          color: const Color(0xFF758572),
                          fontSize: isTablet
                              ? 12
                              : isSmallPhone
                                  ? 9
                                  : 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 2 : 4),
                    ],

                    // Title
                    Flexible(
                      child: Text(
                        productTitle,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: isTablet
                              ? 18
                              : isSmallPhone
                                  ? 14
                                  : 16,
                          fontWeight: FontWeight.w500,
                          height: 1.2, // Tighter line height
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: isTablet ? 2 : 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFFF3B456), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${numRatings ?? 0})',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price, Action and Stock Layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top part: Price & Save Row + Add button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Price & Save info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (hasDiscount) ...[
                                          Text(
                                            '₹${_formatPrice(discountAmount!)}',
                                            style: TextStyle(
                                              fontSize: isTablet
                                                  ? 24
                                                  : isSmallPhone
                                                      ? 18
                                                      : 22,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black87,
                                              height: 1.0,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Text(
                                              '₹${_formatPrice(actualAmount)}',
                                              style: TextStyle(
                                                fontSize: isTablet
                                                    ? 14
                                                    : isSmallPhone
                                                        ? 11
                                                        : 13,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF8B9289),
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            '₹${_formatPrice(actualAmount)}',
                                            style: TextStyle(
                                              fontSize: isTablet
                                                  ? 24
                                                  : isSmallPhone
                                                      ? 18
                                                      : 22,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black87,
                                              height: 1.0,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  // Save label
                                  if (hasDiscount) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Save ₹${((double.tryParse(actualAmount) ?? 0) - (double.tryParse(discountAmount!) ?? 0)).toInt()}',
                                      style: TextStyle(
                                        color: const Color(
                                            0xFFD64436), // Red color for Save
                                        fontSize: isTablet
                                            ? 13
                                            : isSmallPhone
                                                ? 10
                                                : 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Add button
                            if (home &&
                                isStock == true &&
                                addToCartEvent != null) ...[
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: addToCartEvent,
                                borderRadius: BorderRadius.circular(
                                    10), // Matched image roundness
                                child: Container(
                                  height: isTablet
                                      ? 36
                                      : isSmallPhone
                                          ? 28
                                          : 32,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3F6331),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons
                                            .shopping_cart_outlined, // Outlined cart icon
                                        color: Colors.white,
                                        size: isTablet ? 16 : 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isCart ? "Cart" : 'Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet
                                              ? 14
                                              : isSmallPhone
                                                  ? 11
                                                  : 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        // Stock segment underneath (full width row with bar + text)
                        if (isStock == true && stock != null && stock! > 0) ...[
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // The Bar
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: stock! >= 20
                                        ? 1.0
                                        : (stock! / 20.0).clamp(0.0, 1.0),
                                    child: AnimatedStockBar(
                                      stock: stock!,
                                      baseColor: stock! > 20
                                          ? const Color(0xFF00B251)
                                          : ((stock! / 20.0).clamp(0.0, 1.0) >
                                                  0.5
                                              ? const Color(0xFFF3B456)
                                              : const Color(0xFFD64436)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // The Text
                              Text(
                                stock! > 20 ? 'IN STOCK' : 'Only $stock left!',
                                style: TextStyle(
                                  color: stock! > 20
                                      ? const Color(0xFF00B251)
                                      : const Color(
                                          0xFFD64436), // Red color typically for "Only X left!"
                                  fontSize: isTablet
                                      ? 12
                                      : isSmallPhone
                                          ? 9
                                          : 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ] else if (isStock == false ||
                            stock == 0 ||
                            (home && addToCartEvent == null)) ...[
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'OUT OF STOCK',
                                style: TextStyle(
                                  color: const Color(0xFFD64436),
                                  fontSize: isTablet
                                      ? 12
                                      : isSmallPhone
                                          ? 9
                                          : 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
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

class AnimatedFlagBadge extends StatefulWidget {
  final List<String> flags;

  const AnimatedFlagBadge({required this.flags, super.key});

  @override
  State<AnimatedFlagBadge> createState() => _AnimatedFlagBadgeState();
}

class _AnimatedFlagBadgeState extends State<AnimatedFlagBadge> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.flags.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.flags.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flags.isEmpty) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -0.5),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ));
      },
      child: Container(
        key: ValueKey<int>(_currentIndex),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF3B456).withOpacity(0.85),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          widget.flags[_currentIndex].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class AnimatedStockBar extends StatefulWidget {
  final int stock;
  final Color baseColor;

  const AnimatedStockBar({
    required this.stock,
    required this.baseColor,
    super.key,
  });

  @override
  State<AnimatedStockBar> createState() => _AnimatedStockBarState();
}

class _AnimatedStockBarState extends State<AnimatedStockBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.stock <= 20) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedStockBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stock <= 20 && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.stock > 20 && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stock > 20) {
      return Container(
        decoration: BoxDecoration(
          color: widget.baseColor,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    final highlightColor = Colors.white.withOpacity(0.5);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment(-2.5 + (_controller.value * 5), 0),
              end: Alignment(-0.5 + (_controller.value * 5), 0),
              colors: [
                widget.baseColor,
                highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class ProductImageWithLongPress extends StatefulWidget {
  final dynamic productImage;
  final String baseUrl;
  final bool isTablet;
  final bool isSmallPhone;

  const ProductImageWithLongPress({
    required this.productImage,
    required this.baseUrl,
    required this.isTablet,
    required this.isSmallPhone,
    super.key,
  });

  @override
  State<ProductImageWithLongPress> createState() =>
      _ProductImageWithLongPressState();
}

class _ProductImageWithLongPressState extends State<ProductImageWithLongPress> {
  bool _isLongPressed = false;

  List<String> _getImages() {
    final pi = widget.productImage;
    if (pi == null) return [];
    if (pi is List) {
      return pi.map((e) => e.toString()).toList();
    }
    if (pi is String) {
      if (pi.isEmpty) return [];
      String source = pi;
      if (source.startsWith('[') && source.endsWith(']')) {
        // Safe robust decoding for arrays that might lack quotes in raw mode
        source = source.substring(1, source.length - 1);
        final parts = source.split(',');
        return parts
            .map((e) {
              var s = e.trim();
              if ((s.startsWith("'") && s.endsWith("'")) ||
                  (s.startsWith('"') && s.endsWith('"'))) {
                if (s.length >= 2) s = s.substring(1, s.length - 1);
              }
              return s;
            })
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [source];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final images = _getImages();
    if (images.isEmpty) {
      return _buildPlaceholder();
    }

    String currentImage = images[0];
    if (_isLongPressed && images.length > 1) {
      currentImage = images[1];
    }

    // The model already resolves relative → full URL.
    // If still relative (edge case), prefix here as a safety net.
    final imageUrl = currentImage.startsWith('http')
        ? currentImage
        : '${widget.baseUrl}$currentImage';

    return GestureDetector(
      onLongPressStart: (_) => setState(() => _isLongPressed = true),
      onLongPressEnd: (_) => setState(() => _isLongPressed = false),
      onLongPressCancel: () => setState(() => _isLongPressed = false),
      child: NetworkImageWidget(
        imageUrl: imageUrl,
        fit: BoxFit.fitHeight,
        width: 200,
        height: 200,
        memCacheWidth: 300,
        memCacheHeight: 300,
        placeholder: (context, url) => Container(
          color: Colors.grey[50],
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
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
            size: widget.isTablet ? 50 : (widget.isSmallPhone ? 30 : 40),
          ),
          SizedBox(height: widget.isSmallPhone ? 4 : 8),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: widget.isTablet ? 14 : (widget.isSmallPhone ? 10 : 12),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
