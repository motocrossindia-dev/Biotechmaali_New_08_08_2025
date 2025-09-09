import '../../../../import.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel shimmer
            Container(
              height: 300,
              color: Colors.white,
            ),
            sizedBoxHeight20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and wishlist shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 28,
                        width: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.white,
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight15,

                  // Price row shimmer
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ),
                      sizedBoxWidth10,
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.white,
                      ),
                      sizedBoxWidth10,
                      Container(
                        height: 22,
                        width: 69,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight20,

                  // Rating shimmer
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 50,
                        color: Colors.white,
                      ),
                      sizedBoxWidth10,
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 20,
                            width: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight20,

                  // Plant Size shimmer
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  sizedBoxHeight10,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight20,

                  // Planter Size shimmer
                  Container(
                    height: 16,
                    width: 120,
                    color: Colors.white,
                  ),
                  sizedBoxHeight10,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight20,

                  // Color selection shimmer
                  Container(
                    height: 16,
                    width: 80,
                    color: Colors.white,
                  ),
                  sizedBoxHeight10,
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight20,

                  // Quantity shimmer
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 40,
                        color: Colors.white,
                      ),
                      sizedBoxWidth15,
                      Container(
                        height: 28,
                        width: 85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight20,

                  // Add On Products shimmer
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  sizedBoxHeight10,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight20,

                  // Description shimmer
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  sizedBoxHeight10,
                  Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  sizedBoxHeight70,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
