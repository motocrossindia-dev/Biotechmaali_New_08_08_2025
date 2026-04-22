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
    if (doublePrice != null) return doublePrice.toInt().toString();
    return price;
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

    // ── Card dimensions ─────────────────────────────────────────────────────
    // cardHeight increased so 40% content area has enough room for all widgets
    final cardWidth = isTablet
        ? screenWidth * 0.3
        : isLargePhone
            ? screenWidth * 0.43
            : screenWidth * 0.45;

    final cardHeight = isTablet
        ? screenHeight * 0.46 // tablet  — bigger card for 60/40 split
        : isSmallPhone
            ? screenHeight * 0.50 // small phone
            : screenHeight * 0.48; // normal phone

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
            // ── IMAGE SECTION — 60% of card height ──────────────────────────
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Full bleed image — fills the entire 60% flex area
                    ProductImageWithLongPress(
                      productImage: productImage,
                      baseUrl: baseUrl,
                      isTablet: isTablet,
                      isSmallPhone: isSmallPhone,
                    ),

                    // Flag Badge — top left
                    if (flags != null && flags!.isNotEmpty)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: AnimatedFlagBadge(flags: flags!),
                      ),

                    // Ribbon badge — top right corner tag
                    if (ribbon != null && ribbon!.isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF44336), // Bright red from design
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            ribbon!.isEmpty
                                ? ''
                                : ribbon![0].toUpperCase() +
                                    ribbon!.substring(1).toLowerCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    // Discount badge — bottom left
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

                    // Wishlist button — bottom right
                    if (home)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: InkWell(
                          onTap: addToFavouriteEvent,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(
                              isTablet
                                  ? 6.0
                                  : isSmallPhone
                                      ? 4.0
                                      : 5.0,
                            ),
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
                                          color: Colors.red, width: 1),
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

            // ── CONTENT SECTION — 40% of card height ────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet
                      ? 12.0
                      : isSmallPhone
                          ? 7.0
                          : 9.0,
                  vertical: isTablet ? 10.0 : 8.0,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize
                              .min, // Use min so it only takes what it needs
                          children: [
                            // Sub Category label
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
                              const SizedBox(height: 3),
                            ],

                            // Product title (1 line as requested)
                            Text(
                              productTitle,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: isTablet
                                    ? 18
                                    : isSmallPhone
                                        ? 13
                                        : 15,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            // Rating row
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFF3B456), size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  rating?.toStringAsFixed(1) ?? '0.0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTablet ? 13 : 11,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '(${numRatings ?? 0})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: isTablet ? 13 : 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // ── Price row + Add button ──────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Price + Save label
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
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
                                                      ? 22
                                                      : isSmallPhone
                                                          ? 17
                                                          : 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black87,
                                                  height: 1.0,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0),
                                                child: Text(
                                                  '₹${_formatPrice(actualAmount)}',
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 13
                                                        : isSmallPhone
                                                            ? 10
                                                            : 12,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xFF8B9289),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    height: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              Text(
                                                '₹${_formatPrice(actualAmount)}',
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? 22
                                                      : isSmallPhone
                                                          ? 17
                                                          : 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black87,
                                                  height: 1.0,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      // Save label (only when discount exists)
                                      if (hasDiscount) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Save ₹${((double.tryParse(actualAmount) ?? 0) - (double.tryParse(discountAmount!) ?? 0)).toInt()}',
                                          style: TextStyle(
                                            color: const Color(0xFFD64436),
                                            fontSize: isTablet
                                                ? 12
                                                : isSmallPhone
                                                    ? 9
                                                    : 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Add to cart button
                                if (home &&
                                    isStock == true &&
                                    addToCartEvent != null) ...[
                                  const SizedBox(width: 30),
                                  InkWell(
                                    onTap: addToCartEvent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: isTablet
                                          ? 36
                                          : isSmallPhone
                                              ? 28
                                              : 32,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3F6331),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.white,
                                            size: isTablet ? 15 : 13,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            isCart ? 'Cart' : 'Add',
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

                            const SizedBox(height: 8),

                            // ── Stock bar ───────────────────────────────────────────
                            if (isStock == true &&
                                stock != null &&
                                stock! > 0) ...[
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
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: stock! >= 20
                                            ? 1.0
                                            : (stock! / 20.0).clamp(0.0, 1.0),
                                        child: AnimatedStockBar(
                                          stock: stock!,
                                          baseColor: stock! > 20
                                              ? const Color(0xFF00B251)
                                              : ((stock! / 20.0)
                                                          .clamp(0.0, 1.0) >
                                                      0.5
                                                  ? const Color(0xFFF3B456)
                                                  : const Color(0xFFD64436)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    stock! > 20
                                        ? 'IN STOCK'
                                        : 'Only $stock left!',
                                    style: TextStyle(
                                      color: stock! > 20
                                          ? const Color(0xFF00B251)
                                          : const Color(0xFFD64436),
                                      fontSize: isTablet
                                          ? 12
                                          : isSmallPhone
                                              ? 9
                                              : 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ] else if (isStock == false ||
                                stock == 0 ||
                                (home && addToCartEvent == null)) ...[
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
                                  const SizedBox(width: 6),
                                  Text(
                                    'OUT OF STOCK',
                                    style: TextStyle(
                                      color: const Color(0xFFD64436),
                                      fontSize: isTablet
                                          ? 12
                                          : isSmallPhone
                                              ? 9
                                              : 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
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

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedFlagBadge
// ─────────────────────────────────────────────────────────────────────────────
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
          ),
        );
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

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedStockBar
// ─────────────────────────────────────────────────────────────────────────────
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
    if (widget.stock <= 20) _controller.repeat();
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
              colors: [widget.baseColor, highlightColor, widget.baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProductImageWithLongPress
// ─────────────────────────────────────────────────────────────────────────────
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
    if (pi is List) return pi.map((e) => e.toString()).toList();
    if (pi is String) {
      if (pi.isEmpty) return [];
      String source = pi;
      if (source.startsWith('[') && source.endsWith(']')) {
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
    if (images.isEmpty) return _buildPlaceholder();

    String currentImage = images[0];
    if (_isLongPressed && images.length > 1) currentImage = images[1];

    final imageUrl = currentImage.startsWith('http')
        ? currentImage
        : '${widget.baseUrl}$currentImage';

    return GestureDetector(
      onLongPressStart: (_) => setState(() => _isLongPressed = true),
      onLongPressEnd: (_) => setState(() => _isLongPressed = false),
      onLongPressCancel: () => setState(() => _isLongPressed = false),
      child: NetworkImageWidget(
        imageUrl: imageUrl,
        fit: BoxFit.fill, // fills taller area without distortion
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: 400,
        memCacheHeight: 600,
        placeholder: (context, url) => Container(color: Colors.grey[50]),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!, width: 1),
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
