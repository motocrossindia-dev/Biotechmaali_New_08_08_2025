import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';
import 'package:biotech_maali/src/module/explore/model/subcategory_model.dart';
import 'package:biotech_maali/src/widgets/error_message_widget.dart';

import '../../../../import.dart';

class SubCategories extends StatelessWidget {
  const SubCategories({super.key});

  @override
  Widget build(BuildContext context) {
    String imageBaseUrl = BaseUrl.baseUrlForImages;
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.error != null) {
          return Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorMessageWidget(
                  errorTitle: "Something went wrong",
                  errorSubTitle: provider.error!,
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.fetchMainCategories();
                    provider.fetchSubcategory(provider.selectedCategoryId ?? 0,
                        context: context);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ));
        }

        List<Subcategory> subcategories = provider.subcategories;

        if (subcategories.isEmpty) {
          return const Expanded(
            child: Center(
              child: Text('No subcategories available'),
            ),
          );
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(
                            id: subcategory.id.toString(),
                            isCategory: false,
                            title: subcategory.name,
                            categoryName: provider.selectedCategoryName,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                              left: 6,
                              right: 6,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: cExploreCategory,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                  bottom: Radius.circular(8),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                  bottom: Radius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: imageBaseUrl + subcategory.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subcategory.name,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
