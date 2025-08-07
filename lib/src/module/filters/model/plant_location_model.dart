class PlantLocationModel {
  final String id;
  final String label;
  final int count;
  bool isChecked;

  PlantLocationModel({
    required this.id,
    required this.label,
    required this.count,
    this.isChecked = false,
  });

  // Factory method to create a PlantLocationModel instance from a map
  factory PlantLocationModel.fromMap(Map<String, dynamic> map) {
    return PlantLocationModel(
      id: map['id'] as String,
      label: map['label'] as String,
      count: map['count'] as int,
      isChecked: map['isChecked'] as bool,
    );
  }

  // Method to convert Location instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'count': count,
      'isChecked': isChecked,
    };
  }
}
