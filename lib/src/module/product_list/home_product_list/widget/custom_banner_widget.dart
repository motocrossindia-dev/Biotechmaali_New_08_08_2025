import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';

class CustomBannerWidget extends StatelessWidget {
  const CustomBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: lgBanner),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 50,
                width: 70,
                child: Image.asset(
                  'assets/png/images/product_list_banner.png',
                  fit: BoxFit.fill,
                )),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const CommonTextWidget(
                    title: 'Vibrant and Thriving Plants Online',
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                  sizedBoxHeight08,
                  const CommonTextWidget(
                    title: 'Celebrate Friendship with 15%',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  sizedBoxHeight08,
                  SizedBox(
                    height: 22,
                    // width: 70,
                    child: CustomizableButton(
                      title: 'Shop Now',
                      fontSize: 8,
                      event: () {
                        context
                            .read<HomeProvider>()
                            .maincategories
                            .forEach((element) {
                          if (element.name.toLowerCase() == 'offers') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                  isCategory: true,
                                  title: "OFFERS",
                                  id: element.id.toString(),
                                ),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
