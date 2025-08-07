import '../../import.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;
  const RatingBarWidget({required this.rating,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display rating stars using RatingBarIndicator
        RatingBarIndicator(
          rating: rating, // Set the current rating value here
          itemBuilder: (context, index) => SvgPicture.asset(
            'assets/svg/icons/star_rating.svg',
            color: cRatingBarStar,
          ),
          itemCount: 5, // Total number of stars
          itemSize: 13.0, // Size of each star
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}
