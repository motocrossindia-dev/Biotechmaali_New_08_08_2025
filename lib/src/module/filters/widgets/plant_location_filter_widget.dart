// import '../../../../import.dart';

// class PlantLocationFilter extends StatelessWidget {
//   const PlantLocationFilter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FiltersProvider>(
//       builder: (context, provider, child) {
//         List<PlantLocationModel> plantLocationFilters = provider
//             .plantLocationFilters
//             .map((plantLocationFilters) =>
//                 PlantLocationModel.fromMap(plantLocationFilters))
//             .toList();
//         return ListView.builder(
//           itemCount: plantLocationFilters.length,
//           itemBuilder: (context, index) {
//             PlantLocationModel plantLocationFilter =
//                 plantLocationFilters[index];
//             return Container(
//               padding: const EdgeInsets.only(right: 20.0),
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: plantLocationFilter.isChecked,
//                           activeColor: Colors.green,
//                           onChanged: (bool? value) {
//                             if (value == null) {
//                               return;
//                             }
//                             provider.setIdealPlantLocation(value, index);
//                           },
//                         ),
//                         Expanded(
//                           child: CommonTextWidget(
//                             title: plantLocationFilter.label,
//                             fontSize: 14,
//                           ),
//                         ),
//                         sizedBoxWidth10,
//                         CommonTextWidget(
//                           title: plantLocationFilter.count.toString(),
//                           fontSize: 14,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
