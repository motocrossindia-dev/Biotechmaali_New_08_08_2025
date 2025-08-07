// import '../../../../import.dart';

// class PotSizeWidget extends StatelessWidget {
//   const PotSizeWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FiltersProvider>(
//       builder: (context, provider, child) {
//         try {
//           List<PotSizeModel> potSize = provider
//               .potSize
//               .map((potSize) => PotSizeModel.fromJson(potSize))
//               .toList();
          
//           return ListView.builder(
//             itemCount: potSize.length,
//             itemBuilder: (context, index) {
//               PotSizeModel potSizes = potSize[index];

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
//                             value: potSizes.isSelected,
//                             activeColor: Colors.green,
//                             onChanged: (bool? value) {
//                               if (value == null) return;
//                               provider.setPotSize(value, index);
//                             },
//                           ),
//                           Expanded(
//                             child: CommonTextWidget(
//                               title: potSizes.name,
//                               fontSize: 14,
//                             ),
//                           ),
//                           sizedBoxWidth10,
//                           CommonTextWidget(
//                             title: potSizes.count.toString(),
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