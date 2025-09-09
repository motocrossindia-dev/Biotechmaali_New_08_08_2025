import 'dart:developer';

import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';
import 'package:biotech_maali/src/module/product_list/product_list/widgets/offer_product_list_widget.dart';
import 'package:biotech_maali/src/other_modules/services/services_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../../import.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  void showComingSoonBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 30.0, left: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 10),
              Text(
                'Coming Soon!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2164),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                'We are working on something amazing.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          const baseUrl = BaseUrl.baseUrlForImages;
          List<MainCategoryModel> maincategories = provider.maincategories;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: maincategories.length,
            itemBuilder: (context, index) {
              final category = maincategories[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    log("category name: ${category.name}");
                    if (category.name == "SERVICES") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServicesScreen(),
                        ),
                      );
                    } else if (category.name == "GIFTS") {
                      showComingSoonBottomSheet(context);
                    } else if (category.name.toLowerCase() == 'offers') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfferProductListWidget(
                            isCategory: true,
                            title: 'Offers',
                            id: category.id.toString(),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(
                            isCategory: true,
                            title: category.name,
                            id: category.id.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                      0xFF0D2164), // You can change this color
                                  width: 1.0, // You can adjust border width
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    11), // Add padding to reduce image size
                                child: CachedNetworkImage(
                                  imageUrl: '$baseUrl${category.image}',
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        category.name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
