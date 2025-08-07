import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';

import '../../../../../import.dart';

class ProductDetailsRatingWidget extends StatelessWidget {
  final ProductRating? productRating;

  // final List<ProductReview>? productReviews;

  const ProductDetailsRatingWidget({required this.productRating, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display rating stars using RatingBarIndicator
        RatingBarIndicator(
          rating: productRating?.avgRating ??
              0, // Set the current rating value here
          itemBuilder: (context, index) => SvgPicture.asset(
            'assets/svg/icons/star_rating.svg',
            color: cButtonGreen,
          ),
          itemCount: 5, // Total number of stars
          itemSize: 18.0, // Size of each star
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}
