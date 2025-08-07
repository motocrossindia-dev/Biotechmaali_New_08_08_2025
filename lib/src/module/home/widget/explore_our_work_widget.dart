import 'package:biotech_maali/src/other_modules/out_works/our_work_screen.dart';
import '../../../../import.dart';

class ExploreOurWorkWidget extends StatelessWidget {
  const ExploreOurWorkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: CommonTextWidget(
            title: 'Our Work And Service',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 370,
          child: Image.asset(
            'assets/png/images/home_screen_img_3.jpg',
            fit: BoxFit.fill,
          ),
        ),
        sizedBoxHeight10,
        const Center(
          child: CommonTextWidget(
            title: 'What Makes Biotech Maali Stand Out?',
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
              title: 'Explore Now',
              event: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OurWorkScreen(),
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
