import 'package:biotech_maali/src/module/home/model/home_product_model.dart';
import 'package:biotech_maali/src/module/product_compo_list/model/product_compo_model.dart';
import 'package:biotech_maali/src/module/product_compo_list/product_compo_list_provider.dart';
import 'package:biotech_maali/src/module/product_compo_list/widget/product_compo_widget.dart';
import 'package:biotech_maali/src/module/product_list/product_list_shimmer.dart';
import 'package:biotech_maali/src/module/product_search/product_search_screen.dart';

import '../../../import.dart';

class ProductCompoListScreen extends StatefulWidget {
  final String title;
  final List<HomeProductModel> products;
  const ProductCompoListScreen(
      {required this.title, required this.products, super.key});

  @override
  State<ProductCompoListScreen> createState() => _ProductCompoListScreenState();
}

class _ProductCompoListScreenState extends State<ProductCompoListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCompoListProvider>().fetchComboOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: widget.title,
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

          if (provider.error != null) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(provider.error!),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBannerWidget(),
                _buildSection('Combo Offers', provider.comboOffers),
                _buildSection('Shop The Look', provider.shopTheLook),
                sizedBoxHeight70,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<ComboOffer> offers) {
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offers.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final offer = offers[index];

            // Helper function to safely convert double to avoid NaN/Infinity

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
              onTap: () {
                context
                    .read<ProductCompoListProvider>()
                    .placeOrderCompo(offer.id, context);
              },
            );
          },
        ),
      ],
    );
  }
}
