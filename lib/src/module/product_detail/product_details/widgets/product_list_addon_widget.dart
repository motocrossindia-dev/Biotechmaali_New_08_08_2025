import 'dart:developer';

import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/widgets/product_tile_addon_widget.dart';

import '../../../../../import.dart';

class ProductListAddonWidget extends StatelessWidget {
  final String title;
  // final List<ProductAddOn> productAddonList;

  const ProductListAddonWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12, right: 12), // Add padding for better layout
      child: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          List<ProductAddOn> productAddonList = provider.productAddOn;
          return Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distributes space evenly
                children: [
                  CommonTextWidget(
                    title: title,
                    color: cHomeProductText,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              sizedBoxHeight40,
              SizedBox(
                height: 360,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productAddonList.length,
                  itemBuilder: (context, index) {
                    ProductAddOn product = productAddonList[index];
                    log("product id in ui addon : ${product.id}");
                    log("product iscart in ui addon : ${product.isCart}");
                    // ignore: prefer_const_constructors
                    return Row(
                      children: [
                        ProductTileAddonWidget(
                          productTitle: product.name,
                          productImage: product.image,
                          tempImage: 'assets/png/products/sample_product.png',
                          discountAmount: product.sellingPrice.toString(),
                          actualAmount: product.mrp.toString(),
                          rating: product.productRating.avgRating,
                          mainProdId: product.id,
                          home: true,
                          isWishlist: false,
                          isAddToCart: product.isCart,
                          isFavorite: product.isWishlist,
                        ),
                        sizedBoxWidth15
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
