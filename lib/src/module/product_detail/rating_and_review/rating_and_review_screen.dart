import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';

class RatingsAndReviews extends StatelessWidget {
  final ProductData productData;
  final int productId;

  const RatingsAndReviews(
      {required this.productData, required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return RatingAndReviewProvider(productData: productData);
      },
      child: RatingsAndReviewsContent(
        productData: productData,
        productId: productId,
      ),
    );
  }
}

class RatingsAndReviewsContent extends StatelessWidget {
  final ProductData productData;
  final int productId;
  const RatingsAndReviewsContent(
      {required this.productData, required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const CommonTextWidget(
          title: 'Ratings',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Consumer<RatingAndReviewProvider>(
        builder: (context, provider, child) {
          if (provider.productData?.productRating == null) {
            return const Center(child: Text('No ratings available'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Rating Summary
              Row(
                children: [
                  Text(
                    provider.averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: provider.ratingDistribution.entries
                          .map((entry) => _buildRatingBar(
                                entry.key,
                                entry.value,
                                provider.totalRatings,
                              ))
                          .toList()
                          .reversed
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  '${provider.totalRatings} Ratings',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Write Review Button

              OutlinedButton(
                onPressed: !provider.productData!.product.isPurchased
                    ? () {
                        showCannotReviewDialog(context);
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductRatingScreen(productId: productId),
                          ),
                        );
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: provider.productData!.product.isPurchased
                      ? cButtonGreen
                      : cBorderGrey,
                  side: BorderSide(
                      color: provider.productData!.product.isPurchased
                          ? cButtonGreen
                          : cBorderGrey),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Write a review'),
              ),
              const SizedBox(height: 16),

              // Most Recent Toggle
              if (provider.reviews.isNotEmpty) ...[
                OutlinedButton(
                  onPressed: () => provider.setShowReviews(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cButtonGreen,
                    side: BorderSide(color: cButtonGreen),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Most Recent'),
                        sizedBoxWidth5,
                        Icon(
                          provider.showReviews
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Reviews List
                if (provider.showReviews)
                  ...provider.reviews.map((review) => _buildReviewCard(review)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingBar(int rating, int count, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$rating'),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? count / total : 0,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ProductReview review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text(review.userName[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          review.date,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < review.latestRating
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          // Text(review.productReview),
          const Divider(height: 32),
        ],
      ),
    );
  }

  void showCannotReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.red.shade700,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Purchase Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You need to purchase this product before leaving a review.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'DISMISS',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cButtonGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onPressed: () {
                        // Navigate to product purchase page
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        // Additional navigation code here
                      },
                      child: const Text('BUY NOW'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
