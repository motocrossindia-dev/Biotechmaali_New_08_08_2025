// import '../../../../import.dart';

// class IndoorOutdoorWidget extends StatelessWidget {
//   const IndoorOutdoorWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FiltersProvider>(
//       builder: (context, provider, child) {
//         try {
//           List<IndoorOutdoorModel> indoorOutdoor = provider
//               .indoorOutdoor
//               .map((indoorOutdoor) => IndoorOutdoorModel.fromJson(indoorOutdoor))
//               .toList();
          
//           return ListView.builder(
//             itemCount: indoorOutdoor.length,
//             itemBuilder: (context, index) {
//               IndoorOutdoorModel indoorOutdoorFilter = indoorOutdoor[index];
//               return Container(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         children: [
//                           Checkbox(
//                             value: indoorOutdoorFilter.isSelected,
//                             activeColor: Colors.green,
//                             onChanged: (bool? value) {
//                               if (value == null) return;
//                               provider.setIndoorOutdoor(value, index);
//                             },
//                           ),
//                           Expanded(
//                             child: CommonTextWidget(
//                               title: indoorOutdoorFilter.name,
//                               fontSize: 14,
//                             ),
//                           ),
//                           sizedBoxWidth10,
//                           CommonTextWidget(
//                             title: indoorOutdoorFilter.count.toString(),
//                             fontSize: 14,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         } catch (e) {
//           // print('Error in IndoorOutdoorWidget: $e');
//           return const Center(child: Text('Error loading filters'));
//         }
//       },
//     );
//   }
// }