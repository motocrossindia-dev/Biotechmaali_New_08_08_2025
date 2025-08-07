class PotSizeModel {
  final String id;
  final String name;
  final int count;
  bool isSelected;

  PotSizeModel({
    required this.id,
    required this.name,
    required this.count,
    this.isSelected = false,
  });

  // Updated fromJson to match your data structure
  factory PotSizeModel.fromJson(Map<String, dynamic> json) {
    return PotSizeModel(
      id: json['id'] as String,
      name: json['label'] as String, // Changed from 'name' to 'label'
      count: json['count'] as int,
      isSelected: json['isSelected'] as bool? ?? false, // Changed from 'isSelected' to 'isChecked'
    );
  }

  // Updated toJson to match your data structure
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': name, // Changed from 'name' to 'label'
      'count': count,
      'isSelected': isSelected, // Changed from 'isSelected' to 'isChecked'
    };
  }
}