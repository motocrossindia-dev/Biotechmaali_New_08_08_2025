import 'package:biotech_maali/src/module/product_compo_list/product_compo_list_screen.dart';

import '../../../../import.dart';

class CompoOfferWidget extends StatelessWidget {
  const CompoOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, bottom: screenHeight * 0.01),
          child: CommonTextWidget(
            title: 'Combo Offers',
            fontSize: isTablet ? 24.0 : screenWidth * 0.045,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: isTablet ? screenHeight * 0.25 : screenHeight * 0.35,
          width: screenWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/png/images/home_screen_img_2.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: CommonTextWidget(
            title:
                'Two for One, Twice the Greenery: Get Your Plant Combo Today',
            fontSize: isTablet ? 18.0 : screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Center(
          child: SizedBox(
            width: isTablet ? screenWidth * 0.3 : screenWidth * 0.5,
            child: CommonButtonWidget(
              title: 'Explore Combo',
              event: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductCompoListScreen(title: "", products: []),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
