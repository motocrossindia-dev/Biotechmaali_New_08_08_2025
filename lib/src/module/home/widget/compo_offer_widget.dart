import 'package:biotech_maali/src/module/product_compo_list/product_compo_list_screen.dart';

import '../../../../import.dart';

class CompoOfferWidget extends StatelessWidget {
  const CompoOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: CommonTextWidget(
            title: 'Combo Offers',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 340,
          child: Image.asset('assets/png/images/home_screen_img_2.jpg'),
        ),
        sizedBoxHeight10,
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8),
          child: CommonTextWidget(
            title:
                'Two for One, Twice the Greenery: Get Your Plant Combo Today',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
        sizedBoxHeight10,
        Center(
          child: SizedBox(
            width: 170,
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
