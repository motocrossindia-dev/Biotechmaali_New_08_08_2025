import 'dart:developer';

import 'package:biotech_maali/src/module/home/model/category_model.dart';

import '../../../../import.dart';

class ExploreCategoryWidget extends StatelessWidget {
  const ExploreCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const baseUrl = BaseUrl.baseUrlForImages;
    final exploreProvider = context.read<ExploreProvider>();
    final exploreProviderWatch = context.watch<ExploreProvider>();

    return Container(
      color: cCategoryUnselected,
      height: 145,
      child: Consumer<ExploreProvider>(
        builder: (context, provider, child) {
          List<MainCategoryModel> mainCategories = provider.maincategories;

          return ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: mainCategories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final category = mainCategories[index];
              return category.name == "SERVICES" ||
                      category.name == "GIFTS" ||
                      category.name == "OFFERS"
                  ? Container()
                  : InkWell(
                      onTap: () {
                        exploreProvider.setSelectedCategory(
                            index, category.id, category.name);
                        log('Selected category: ${category.name}');
                      },
                      child: Container(
                        color:
                            exploreProviderWatch.selectedCategoryIndex == index
                                ? cCategoryMainBackground
                                : cCategoryUnselected,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            exploreProviderWatch.selectedCategoryIndex == index
                                ? Container(
                                    height: 105,
                                    width: 8,
                                    color: cButtonGreen,
                                  )
                                : sizedBoxWidth0,
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  sizedBoxHeight10,
                                  Center(
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: cExploreCategory),
                                        borderRadius: BorderRadius.circular(10),
                                        color: exploreProviderWatch
                                                    .selectedCategoryIndex ==
                                                index
                                            ? cScaffoldBackground
                                            : cExploreCategory,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '$baseUrl${category.image}',
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    category.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: exploreProviderWatch
                                                  .selectedCategoryIndex ==
                                              index
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
