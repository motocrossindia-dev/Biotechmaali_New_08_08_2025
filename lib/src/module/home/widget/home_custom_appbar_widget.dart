import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/location_popup/location_pincode_popup.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';
import 'package:biotech_maali/src/module/wishlist/wishlist_screen.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';

import '../../../../import.dart';

class CustomAppBarWithSearch extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWithSearch({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(120); // 56 toolbar + 64 bottom

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final logoWidth = isTablet ? screenWidth * 0.18 : screenWidth * 0.30;
    final logoHeight = isTablet ? screenHeight * 0.04 : screenHeight * 0.038;
    final iconSize = isTablet ? 24.0 : 20.0;
    final horizontalPadding = screenWidth * 0.04;
    final locationWidth = isTablet ? screenWidth * 0.35 : screenWidth * 0.26;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      // Gradient covers both toolbar + bottom widget via flexibleSpace
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B3012),
              Color(0xFF2E4D1E),
              Color(0xFF3F6331),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 56,
      // ── Logo + Location in toolbar ──────────────────────────────────────
      title: Consumer<HomeProvider>(
        builder: (context, provider, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/png/Gidan Logo.png',
              height: logoHeight,
              width: logoWidth,
              color: cWhiteColor,
              fit: BoxFit.contain,
            ),
            Flexible(
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LocationPincodePopup()),
                ),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PulsingLocationIcon(iconSize: iconSize),
                      SizedBox(width: screenWidth * 0.012),
                      Flexible(
                        child: SizedBox(
                          width: locationWidth,
                          height: 18,
                          child: provider.fullAddress.isNotEmpty
                              ? _AutoScrollingText(
                                  text: provider.fullAddress,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 13 : 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  scrollSpeed: 200,
                                )
                              : Text(
                                  'Getting location...',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: isTablet ? 13 : 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.018, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9DCD37).withOpacity(0.22),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: const Color(0xFF9DCD37).withOpacity(0.5),
                              width: 1),
                        ),
                        child: Text(
                          provider.pinCode != "Searching..."
                              ? provider.pinCode
                              : "560001",
                          style: TextStyle(
                            color: const Color(0xFF9DCD37),
                            fontSize: isTablet ? 11 : 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      titleSpacing: horizontalPadding,
      // ── Search bar + Wishlist below toolbar ─────────────────────────────
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: Colors.white,
          padding:
              EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextFormField(
                    readOnly: true,
                    showCursor: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProductSearchView()),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cSearchBox,
                      hintStyle: GoogleFonts.poppins(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey.shade500),
                      hintText: 'Search for "plants"',
                      prefixIcon: Icon(Icons.search,
                          size: isTablet ? 24 : 20,
                          color: const Color(0xFF3F6331)),
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          'assets/svg/icons/microphone.svg',
                          height: isTablet ? 22 : 18,
                          width: isTablet ? 22 : 18,
                          colorFilter: const ColorFilter.mode(
                              Color(0xFF3F6331), BlendMode.srcIn),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProductSearchView()),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: screenWidth * 0.04),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: cButtonGreen.withOpacity(0.12)),
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: cButtonGreen.withOpacity(0.12)),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cButtonGreen, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: cButtonGreen.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: cButtonGreen.withOpacity(0.15), width: 1),
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: BoxConstraints(
                      minWidth: isTablet ? 48 : 44,
                      minHeight: isTablet ? 48 : 44),
                  icon: SvgPicture.asset(
                    'assets/svg/icons/heart_unselected.svg',
                    height: isTablet ? 24 : 20,
                    width: isTablet ? 24 : 20,
                    colorFilter:
                        ColorFilter.mode(cButtonGreen, BlendMode.srcIn),
                  ),
                  onPressed: () async {
                    final sp = context.read<SettingsProvider>();
                    if (!await sp.checkAccessTokenValidity(context)) {
                      _showLoginDialog(context);
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WishlistScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing location icon
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingLocationIcon extends StatefulWidget {
  final double iconSize;
  const _PulsingLocationIcon({required this.iconSize});

  @override
  State<_PulsingLocationIcon> createState() => _PulsingLocationIconState();
}

class _PulsingLocationIconState extends State<_PulsingLocationIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Transform.scale(
        scale: _pulse.value,
        child: child,
      ),
      child: SvgPicture.asset(
        'assets/svg/icons/location_icon.svg',
        height: widget.iconSize,
        width: widget.iconSize,
        colorFilter: const ColorFilter.mode(
          Color(0xFF9DCD37), // accent lime green
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Auto-scrolling text (unchanged logic)
// ─────────────────────────────────────────────────────────────────────────────

class _AutoScrollingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double scrollSpeed;

  const _AutoScrollingText({
    required this.text,
    required this.style,
    this.scrollSpeed = 50.0,
  });

  @override
  State<_AutoScrollingText> createState() => _AutoScrollingTextState();
}

class _AutoScrollingTextState extends State<_AutoScrollingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: (widget.text.length * widget.scrollSpeed).round(),
      ),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _startScrolling();
  }

  void _startScrolling() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted && _scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _controller.repeat();
        _animation.addListener(() {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(maxScroll * _animation.value);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        "     ${widget.text}     ",
        style: widget.style,
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
