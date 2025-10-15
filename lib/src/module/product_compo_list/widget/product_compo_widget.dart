import '../../../../import.dart';

class ProductCompoWidget extends StatelessWidget {
  final String title;
  final String description;
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final List<String> products;
  final String image;
  final VoidCallback onTap;

  const ProductCompoWidget({
    required this.title,
    required this.description,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.products,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: NetworkImageWidget(
              imageUrl: '${BaseUrl.baseUrlForImages}$image',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(description),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '₹${finalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (discount > 0 && totalPrice > 0) ...[
                      Text(
                        '₹${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_calculateDiscountPercentage(discount, totalPrice)}% OFF',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Includes: ${products.join(", ")}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          CommonButtonWidget(
            title: "BUY NOW",
            event: onTap,
          )
        ],
      ),
    );
  }

  // Helper method to safely calculate discount percentage
  int _calculateDiscountPercentage(double discount, double totalPrice) {
    if (totalPrice <= 0 || discount <= 0) return 0;

    final percentage = (discount / totalPrice * 100);

    if (percentage.isNaN || percentage.isInfinite) return 0;

    return percentage.round();
  }
}
