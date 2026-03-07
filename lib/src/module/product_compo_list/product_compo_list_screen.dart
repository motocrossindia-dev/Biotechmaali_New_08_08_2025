import 'package:biotech_maali/src/module/product_compo_list/model/product_compo_model.dart';
import 'package:biotech_maali/src/module/product_compo_list/product_compo_list_provider.dart';
import 'package:biotech_maali/src/module/product_compo_list/widget/product_compo_widget.dart';
import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';
import 'package:biotech_maali/src/widgets/delivery_unavailable_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../import.dart';

class ProductCompoListScreen extends StatefulWidget {
  final String title;
  const ProductCompoListScreen({required this.title, super.key});

  @override
  State<ProductCompoListScreen> createState() => _ProductCompoListScreenState();
}

class _ProductCompoListScreenState extends State<ProductCompoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCompoListProvider>().fetchComboOffers();
    });
  }

  Future<void> _handleBuyNow(int comboId) async {
    final provider = context.read<ProductCompoListProvider>();
    final response = await provider.placeOrderCombo(comboId);

    // Check if widget is still mounted before using context
    if (!mounted) return;

    switch (response.result) {
      case ComboOrderResult.success:
        Fluttertoast.showToast(
          msg: "Order initiated successfully",
          backgroundColor: cButtonGreen,
          textColor: Colors.white,
        );
        context
            .read<OrderSummaryProvider>()
            .setOrderSummaryData(response.orderData!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderSummaryScreen(
              isSingleProduct: true,
            ),
          ),
        );
        break;

      case ComboOrderResult.profileNotUpdated:
        Fluttertoast.showToast(
          msg: response.message ?? 'Please update your profile first',
          backgroundColor: cBottomNav,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfileScreen(isPlaceOrder: true),
          ),
        );
        break;

      case ComboOrderResult.addressNotUpdated:
        Fluttertoast.showToast(
          msg: response.message ?? 'Please add delivery address',
          backgroundColor: cBottomNav,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const AddEditAddressScreen(isAddAddress: true),
          ),
        );
        break;

      case ComboOrderResult.loginRequired:
        _showErrorDialog(
          'Login Required',
          response.message ?? 'Please login to continue',
          'OK',
          () => Navigator.pop(context),
        );
        break;

      case ComboOrderResult.deliveryUnavailable:
        DeliveryUnavailableDialog.show(
            context, response.message ?? 'Delivery not available');
        break;

      case ComboOrderResult.comboUnavailable:
        _showErrorDialog(
          'Offer Unavailable',
          response.message ??
              'This combo offer is no longer available. Please check other offers.',
          'OK',
          () => Navigator.pop(context),
        );
        break;

      case ComboOrderResult.serverError:
      case ComboOrderResult.networkError:
      case ComboOrderResult.genericError:
        Fluttertoast.showToast(
          msg: response.message ?? 'Something went wrong. Please try again.',
          backgroundColor: cCustomRed,
          textColor: Colors.white,
        );
        break;
    }
  }

  void _showErrorDialog(
    String title,
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: cCustomRed, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cBottomNav,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onPressed();
            },
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                color: cButtonGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cScaffoldBackground,
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: widget.title.isNotEmpty ? widget.title : 'Combo Offers',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductSearchView(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 40.0),
              child: Icon(Icons.search, size: 30),
            ),
          ),
        ],
      ),
      body: Consumer<ProductCompoListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const ProductListShimmer();
          }

          if (provider.error != null && provider.comboOffers.isEmpty) {
            return _buildErrorWidget(provider);
          }

          final comboOffers = provider.comboOffers;
          final shopTheLook = provider.shopTheLook;

          if (comboOffers.isEmpty && shopTheLook.isEmpty) {
            return _buildEmptyWidget();
          }

          return RefreshIndicator(
            color: cButtonGreen,
            onRefresh: () => provider.fetchComboOffers(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const CustomBannerWidget(),
                  _buildSection('Combo Offers', comboOffers, provider),
                  _buildSection('Shop The Look', shopTheLook, provider),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(ProductCompoListProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () => provider.fetchComboOffers(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cButtonGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              'No Combo Offers Available',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: cBottomNav,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for exciting deals!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<ComboOffer> offers,
      ProductCompoListProvider provider) {
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: cButtonGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: cBottomNav,
                ),
              ),
              const Spacer(),
              Text(
                '${offers.length} ${offers.length == 1 ? 'offer' : 'offers'}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offers.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final offer = offers[index];

            double safeDouble(dynamic value) {
              if (value == null) return 0.0;
              if (value is String) {
                final parsed = double.tryParse(value);
                if (parsed == null || parsed.isNaN || parsed.isInfinite) {
                  return 0.0;
                }
                return parsed;
              }
              if (value is num) {
                if (value.isNaN || value.isInfinite) {
                  return 0.0;
                }
                return value.toDouble();
              }
              return 0.0;
            }

            return ProductCompoWidget(
              title: offer.title,
              description: offer.description ?? '',
              totalPrice: safeDouble(offer.totalPrice),
              discount: safeDouble(offer.discount),
              finalPrice: safeDouble(offer.finalPrice),
              products: offer.products,
              image: offer.image,
              isLoading: provider.isBuying,
              onTap: () => _handleBuyNow(offer.id),
            );
          },
        ),
      ],
    );
  }
}
