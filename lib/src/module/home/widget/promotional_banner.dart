import 'package:biotech_maali/src/module/product_list/product_list/product_list_screen.dart';

import '../../../../import.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vibrant and Thriving Plants Online',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Celebrate Friendship with 15% Off',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[900],
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                context.read<HomeProvider>().maincategories.forEach((element) {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: cButtonGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
