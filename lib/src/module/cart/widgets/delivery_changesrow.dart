import '../../../../import.dart';

class DeliveryChargesRow extends StatelessWidget {
  const DeliveryChargesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget(
          title: 'Delivery Charges',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        Row(
          children: [
            CommonTextWidget(
              title: '₹80',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              lineThrough: TextDecoration.lineThrough,
            ),
            SizedBox(width: 4),
            CommonTextWidget(
              title: 'Free',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}
