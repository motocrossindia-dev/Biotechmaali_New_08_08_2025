import '../../../../import.dart';

class PriceDetailRow extends StatelessWidget {
  final String title;
  final double amount;
  final Color? color;
  final bool isBold;

  const PriceDetailRow({
    super.key,
    required this.title,
    required this.amount,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget(
          title: title,
          fontSize: 16,
          fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
        ),
        CommonTextWidget(
          title: '₹${amount.toStringAsFixed(2)}',
          fontSize: 16,
          fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
          color: color,
        ),
      ],
    );
  }
}
