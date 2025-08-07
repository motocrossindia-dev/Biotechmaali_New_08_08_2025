// import '../../../../import.dart';

// class TypeOfPlantsWidget extends StatelessWidget {
//   const TypeOfPlantsWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FiltersProvider>(
//       builder: (context, provider, child) {
//         List<PlantFilterModel> plantLocationFilters = provider.plantFilters
//             .map((plantLocationFilters) =>
//                 PlantFilterModel.fromJson(plantLocationFilters))
//             .toList();
//         return ListView.builder(
//           itemCount: provider.plantFilters.length,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           itemBuilder: (context, index) {
//             PlantFilterModel plantLocationFilter = plantLocationFilters[index];
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               height: 48,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: Checkbox(
//                       value: plantLocationFilter.isSelected,
//                       onChanged: (bool? value) {
//                         if (value == null) {
//                           return;
//                         }
//                         provider.setTypeOfPlants(value, index);
//                       },
//                       activeColor: cButtonGreen,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     // Added Expanded to handle long text
//                     child: Text(
//                       plantLocationFilter.name,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8), // Added spacing
//                   Text(
//                     plantLocationFilter.count.toString(),
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.black54,
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
