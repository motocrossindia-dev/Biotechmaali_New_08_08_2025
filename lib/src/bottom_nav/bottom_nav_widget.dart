// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/bottom_nav/widgets/account_prompt_widget.dart';
import 'package:biotech_maali/src/bottom_nav/widgets/cart_login_prompt_widget.dart';
import 'package:biotech_maali/src/module/cart/cart_shimmer.dart';
import 'package:biotech_maali/src/module/location_popup/location_pincode_provider.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';
import 'package:flutter/services.dart';
import '../../import.dart';

class BottomNavWidget extends StatefulWidget {
  final bool isProductDetailsScreen;
  final String productSlug;
  const BottomNavWidget(
      {this.productSlug = '', this.isProductDetailsScreen = false, super.key});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavProvider>().checkAccessTokenValidity(context);
      context
          .read<LocationPincodeProvider>()
          .getCurrentLocationFromBottomNav(context);
    });
    if (widget.isProductDetailsScreen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsScreen(slug: widget.productSlug),
            ),
          );
        },
      );
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (context.read<BottomNavProvider>().currentIndex != 0) {
      context.read<BottomNavProvider>().updateIndex(0);
      return false;
    }

    if (_lastBackPressTime != null &&
        DateTime.now().difference(_lastBackPressTime!) <=
            const Duration(seconds: 2)) {
      return true;
    } else {
      _lastBackPressTime = DateTime.now();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: cButtonGreen.withOpacity(0.7),
          duration: const Duration(seconds: 2),
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exit App?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Press back again to exit',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'EXIT NOW',
            textColor: Colors.redAccent,
            onPressed: () => SystemNavigator.pop(),
          ),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Consumer<BottomNavProvider>(
          builder: (context, bottomNavProvider, child) {
            switch (bottomNavProvider.currentIndex) {
              case 0:
                return const HomeScreen();
              case 1:
                return const ExploreScreen();
              case 2:
                log("message is token valid in screen **********: ${context.read<BottomNavProvider>().isTokenValid}");
                return FutureBuilder<bool>(
                  future: settingsProvider.checkAccessTokenValidity(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CartShimmer());
                    }
                    final isTokenValid = snapshot.data ?? false;
                    if (isTokenValid) {
                      return const CartScreen();
                    } else {
                      log("message is not token valid: $isTokenValid");
                      return CartLoginPromptWidget(
                        onLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MobileNumberScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              case 3:
                return FutureBuilder<bool>(
                  future: settingsProvider.checkAccessTokenValidity(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CartShimmer());
                    }
                    final isTokenValid = snapshot.data ?? false;
                    if (isTokenValid) {
                      return const AccountScreen();
                    } else {
                      log("message is not token valid: $isTokenValid");
                      return AccountPromptWidget(
                        onLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MobileNumberScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              default:
                return const HomeScreen();
            }
          },
        ),
        // ── Custom animated bottom nav bar ──────────────────────────────────
        bottomNavigationBar: Consumer<BottomNavProvider>(
          builder: (context, bottomNavProvider, child) {
            return _AnimatedBottomNav(
              currentIndex: bottomNavProvider.currentIndex,
              onTap: (index) => bottomNavProvider.updateIndex(index),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom animated bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final String selectedSvg;
  final String unselectedSvg;
  final String label;

  const _NavItem({
    required this.selectedSvg,
    required this.unselectedSvg,
    required this.label,
  });
}

const _navItems = [
  _NavItem(
    selectedSvg: 'assets/svg/bottom_nav_bar/icon_home_selected.svg',
    unselectedSvg: 'assets/svg/bottom_nav_bar/icon_home_unselected.svg',
    label: 'Home',
  ),
  _NavItem(
    selectedSvg: 'assets/svg/bottom_nav_bar/icon_category_selected.svg',
    unselectedSvg: 'assets/svg/bottom_nav_bar/icon_category_unselected.svg',
    label: 'Explore',
  ),
  _NavItem(
    selectedSvg: 'assets/svg/bottom_nav_bar/icon_cart_selected.svg',
    unselectedSvg: 'assets/svg/bottom_nav_bar/icon_cart_unselected.svg',
    label: 'Cart',
  ),
  _NavItem(
    selectedSvg: 'assets/svg/bottom_nav_bar/icon_user_selected.svg',
    unselectedSvg: 'assets/svg/bottom_nav_bar/icon_user_unselected.svg',
    label: 'Account',
  ),
];

class _AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<_AnimatedBottomNav>
    with TickerProviderStateMixin {
  // One ripple controller per item
  late final List<AnimationController> _rippleControllers;
  late final List<Animation<double>> _rippleAnimations;
  late final List<Animation<double>> _rippleOpacities;

  // Icon scale controller per item
  late final List<AnimationController> _scaleControllers;
  late final List<Animation<double>> _scaleAnimations;

  // Slide indicator controller
  late final AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;

  static const _darkGreen = Color(0xFF1B3012);
  static const _accentGreen = Color(0xFF9DCD37);

  @override
  void initState() {
    super.initState();

    _rippleControllers = List.generate(
      _navItems.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _rippleAnimations = _rippleControllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();

    _rippleOpacities = _rippleControllers
        .map((c) => Tween<double>(begin: 0.35, end: 0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();

    _scaleControllers = List.generate(
      _navItems.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _scaleAnimations = _scaleControllers
        .map((c) => TweenSequence<double>([
              TweenSequenceItem(
                tween: Tween(begin: 1.0, end: 1.3)
                    .chain(CurveTween(curve: Curves.easeOut)),
                weight: 50,
              ),
              TweenSequenceItem(
                tween: Tween(begin: 1.3, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeIn)),
                weight: 50,
              ),
            ]).animate(c))
        .toList();

    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _indicatorAnimation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void didUpdateWidget(_AnimatedBottomNav old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _animateTo(old.currentIndex, widget.currentIndex);
    }
  }

  void _animateTo(int from, int to) {
    // Ripple on the tapped item
    _rippleControllers[to].forward(from: 0);

    // Scale bounce
    _scaleControllers[to].forward(from: 0);

    // Slide indicator
    _indicatorAnimation = Tween<double>(
      begin: from.toDouble(),
      end: to.toDouble(),
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeInOutCubic,
    ));
    _indicatorController.forward(from: 0);
  }

  void _handleTap(int index) {
    if (index == widget.currentIndex) return;
    widget.onTap(index);
  }

  @override
  void dispose() {
    for (final c in _rippleControllers) {
      c.dispose();
    }
    for (final c in _scaleControllers) {
      c.dispose();
    }
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 64 + bottomPadding,
      decoration: BoxDecoration(
        color: _darkGreen,
        boxShadow: [
          BoxShadow(
            color: _darkGreen.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Sliding green pill indicator
            AnimatedBuilder(
              animation: _indicatorAnimation,
              builder: (_, __) {
                final itemWidth =
                    MediaQuery.of(context).size.width / _navItems.length;
                final left =
                    _indicatorAnimation.value * itemWidth + itemWidth / 2 - 30;
                return Positioned(
                  top: 6,
                  left: left,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _accentGreen,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: _accentGreen.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Nav items
            Row(
              children: List.generate(_navItems.length, (index) {
                final isSelected = widget.currentIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _handleTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _rippleAnimations[index],
                        _scaleAnimations[index],
                      ]),
                      builder: (_, __) {
                        return _NavItemWidget(
                          item: _navItems[index],
                          isSelected: isSelected,
                          rippleProgress: _rippleAnimations[index].value,
                          rippleOpacity: _rippleOpacities[index].value,
                          scaleValue: _scaleAnimations[index].value,
                          activeColor: _accentGreen,
                          inactiveColor: Colors.white.withOpacity(0.5),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final double rippleProgress;
  final double rippleOpacity;
  final double scaleValue;
  final Color activeColor;
  final Color inactiveColor;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.rippleProgress,
    required this.rippleOpacity,
    required this.scaleValue,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Icon with ripple + scale — 34px box keeps total well within 64px
        SizedBox(
          width: 44,
          height: 34,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Water ripple effect
              if (rippleProgress > 0)
                Opacity(
                  opacity: rippleOpacity.clamp(0.0, 1.0),
                  child: Container(
                    width: 44 * rippleProgress,
                    height: 44 * rippleProgress,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor,
                    ),
                  ),
                ),
              // Icon
              Transform.scale(
                scale: scaleValue,
                child: SvgPicture.asset(
                  isSelected ? item.selectedSvg : item.unselectedSvg,
                  colorFilter: ColorFilter.mode(
                    isSelected ? activeColor : inactiveColor,
                    BlendMode.srcIn,
                  ),
                  height: 22,
                  width: 22,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        // Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? activeColor : inactiveColor,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LoginPromptDialog();
    },
  );
}
