// class PlantFilterModel {
//   final String id;
//   final String name;
//   final int count;
//   bool isSelected;

//   PlantFilterModel({
//     required this.id,
//     required this.name,
//     required this.count,
//     this.isSelected = false,
//   });

//   // Factory constructor to create a PlantFilterModel object from JSON
//   factory PlantFilterModel.fromJson(Map<String, dynamic> json) {
//     return PlantFilterModel(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       count: json['count'] as int,
//       isSelected: json['isSelected'] as bool,
//     );
//   }

//   // Method to convert a PlantFilter object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'count': count,
//       'isSelected': isSelected,
//     };
//   }
// }
