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
  // Increase height to accommodate content
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 140, // Match with preferredSize
      flexibleSpace: SafeArea(
        // Add SafeArea
        child: Column(
          children: [
            Padding(
              // Adjust top padding
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/png/biotech_logo.png',
                    height: 42,
                    width: 80,
                  ),
                  Consumer<HomeProvider>(
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
                        children: [
                          SvgPicture.asset(
                            'assets/svg/icons/location_icon.svg',
                            height: 22,
                            width: 22,
                          ),
                          const SizedBox(width: 6),
                          // Auto-scrolling address container
                          SizedBox(
                            width: 120, // Fixed width for scrolling area
                            height: 20,
                            child: provider.fullAddress.isNotEmpty
                                ? _AutoScrollingText(
                                    text: provider.fullAddress,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    scrollSpeed: 200,
                                  )
                                : const Text(
                                    'Getting location...',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          // Static pincode with styling
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
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
                                  : "560001", // Default pincode while loading
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizedBoxHeight05,
            Padding(
              // Adjust vertical padding
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      width: 251,
                      child: TextFormField(
                        readOnly: true, // Prevents keyboard from showing
                        showCursor: false, // Hides the cursor
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
                          hintStyle: GoogleFonts.poppins(fontSize: 12),
                          hintText: 'Search for "plants"',
                          prefixIcon: const Icon(Icons.search, size: 22),
                          suffixIcon: IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/icons/microphone.svg',
                              height: 20,
                              width: 20,
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/icons/heart_unselected.svg',
                      height: 24,
                      width: 24,
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
                  // IconButton(
                  //   icon: SvgPicture.asset(
                  //     'assets/svg/icons/notification_unselected.svg',
                  //     height: 24,
                  //     width: 24,
                  //   ),
                  //   onPressed: () {
                  //     // Handle notification button press
                  //   },
                  // ),
                ],
              ),
            )
          ],
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
