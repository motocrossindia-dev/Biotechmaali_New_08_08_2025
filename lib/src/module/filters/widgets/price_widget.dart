// import '../../../../import.dart';

// class PriceWidget extends StatefulWidget {
//   const PriceWidget({super.key});

//   @override
//   _PriceWidgetState createState() => _PriceWidgetState();
// }

// class _PriceWidgetState extends State<PriceWidget> {

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FiltersProvider>(
//       builder: (context, provider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CommonTextWidget(
//                     title: 'Selected Range',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   const SizedBox(height: 8),
//                   CommonTextWidget(
//                     title:
//                         '${provider.currentRangeValues.start.toInt()} - ${provider.currentRangeValues.end.toInt()}',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   const SizedBox(height: 16),
//                   RangeSlider(
//                     values: provider.currentRangeValues,
//                     min: 0,
//                     max: 10000,
//                     activeColor: cButtonGreen,
//                     inactiveColor: Colors.grey[300],
//                     onChanged: (RangeValues values) {
//                       provider.setCurrentRangeValues(values);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
