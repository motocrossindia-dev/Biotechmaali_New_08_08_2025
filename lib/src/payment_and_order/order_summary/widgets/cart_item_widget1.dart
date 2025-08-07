// import '../../../../import.dart';

// class CartItemsWidget extends StatelessWidget {
//   const CartItemsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildCartItem(),
//         _buildCartItem(),
//       ],
//     );
//   }

//   Widget _buildCartItem() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Image.asset(
//                 'assets/png/products/sample_product.png',
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const CommonTextWidget(
//                       title: 'Peace Lily Plant',
//                       fontWeight: FontWeight.bold,
//                     ),
//                     const SizedBox(height: 4),
//                     const CommonTextWidget(title: '₹499.00'),
//                     CommonTextWidget(
//                       title: 'You Save ₹100.00',
//                       color: cButtonGreen,
//                     ),
//                     sizedBoxHeight05,
//                     AddQuantityWidget(
//                       quantity: 1,
//                       addition: () {},
//                       substaction: () {},
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Divider()
//       ],
//     );
//   }
// }
