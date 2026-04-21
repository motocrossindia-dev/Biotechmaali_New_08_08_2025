class PublicFlagModel {
  final int id;
  final String name; // e.g. "is_best_seller"
  final String label; // e.g. "Best Seller"

  PublicFlagModel({
    required this.id,
    required this.name,
    required this.label,
  });

  factory PublicFlagModel.fromJson(Map<String, dynamic> json) {
    return PublicFlagModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
    };
  }
}
