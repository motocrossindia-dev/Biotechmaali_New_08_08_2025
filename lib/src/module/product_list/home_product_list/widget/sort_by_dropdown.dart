// import 'package:flutter/material.dart';

// class SortByDropdown extends StatefulWidget {
//   const SortByDropdown({super.key});

//   @override
//   _SortByDropdownState createState() => _SortByDropdownState();
// }

// class _SortByDropdownState extends State<SortByDropdown> {
//   String _selectedOption = 'Default';

//   final List<String> _sortOptions = [
//     'Default',
//     'Relevance',
//     'Just Launched',
//     'Best Selling',
//     'Price High To Low',
//     'Price Low To High',
//     'Alphabetically A-Z',
//     'Alphabetically Z-A',
//   ];

//   void _showSortByOverlay(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.8,
//           maxChildSize: 0.95,
//           minChildSize: 0.6,
//           builder: (_, controller) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text(
//                       'Sort By',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       controller: controller,
//                       itemCount: _sortOptions.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(
//                             _sortOptions[index],
//                             style: TextStyle(
//                               color: _selectedOption == _sortOptions[index]
//                                   ? Colors.blue
//                                   : Colors.black,
//                             ),
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _selectedOption = _sortOptions[index];
//                             });
//                             Navigator.pop(context);
//                           },
//                         );
//                       },
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

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showSortByOverlay(context),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Sort By: $_selectedOption'),
//             Icon(
//               Icons.arrow_drop_down,
//               color: Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
