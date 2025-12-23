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
  Size get preferredSize => const Size.fromHeight(115);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Responsive sizing
    final logoWidth = isTablet ? screenWidth * 0.12 : screenWidth * 0.25;
    final logoHeight = isTablet ? screenHeight * 0.05 : screenHeight * 0.045;
    final iconSize = isTablet ? 26.0 : 22.0;
    final searchBarHeight = isTablet ? 50.0 : 42.0;
    final horizontalPadding = screenWidth * 0.04;
    final locationWidth = isTablet ? screenWidth * 0.35 : screenWidth * 0.3;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 115,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: screenHeight * 0.008,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo and Location Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/png/Gidan Logo.png',
                    height: logoHeight,
                    width: logoWidth,
                    fit: BoxFit.contain,
                  ),
                  Flexible(
                    child: Consumer<HomeProvider>(
                      builder: (context, provider, child) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LocationPincodePopup()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/icons/location_icon.svg',
                              height: iconSize,
                              width: iconSize,
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            // Auto-scrolling address container
                            Flexible(
                              child: SizedBox(
                                width: locationWidth,
                                height: isTablet ? 24 : 20,
                                child: provider.fullAddress.isNotEmpty
                                    ? _AutoScrollingText(
                                        text: provider.fullAddress,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isTablet ? 14 : 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        scrollSpeed: 200,
                                      )
                                    : Text(
                                        'Getting location...',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: isTablet ? 14 : 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            // Static pincode with styling
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                provider.pinCode != "Searching..."
                                    ? provider.pinCode
                                    : "560001",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: isTablet ? 12 : 11,
                                  fontWeight: FontWeight.w600,
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
              SizedBox(height: screenHeight * 0.006),
              // Search Bar and Icons Row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: searchBarHeight,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductSearchView(),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cSearchBox,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: isTablet ? 14 : 12,
                          ),
                          hintText: 'Search for "plants"',
                          prefixIcon: Icon(
                            Icons.search,
                            size: isTablet ? 26 : 22,
                          ),
                          suffixIcon: IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/icons/microphone.svg',
                              height: isTablet ? 24 : 20,
                              width: isTablet ? 24 : 20,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductSearchView(),
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: screenWidth * 0.04,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/icons/heart_unselected.svg',
                      height: isTablet ? 28 : 24,
                      width: isTablet ? 28 : 24,
                    ),
                    onPressed: () async {
                      final settingsProvider = context.read<SettingsProvider>();
                      bool status = await settingsProvider
                          .checkAccessTokenValidity(context);
                      if (!status) {
                        _showLoginDialog(context);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistScreen(),
                        ),
                      );
                    },
                  ),
                ],
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

// Auto-scrolling text widget
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

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

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
