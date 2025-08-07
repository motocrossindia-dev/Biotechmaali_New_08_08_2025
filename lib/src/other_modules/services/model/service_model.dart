class ServiceModel {
  final int id;
  final String heading;
  final String title;
  final String image;
  final bool visible;

  ServiceModel({
    required this.id,
    required this.heading,
    required this.title,
    required this.image,
    required this.visible,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      heading: json['Heading'] ?? '',
      title: json['title'] ?? '',
      image: json['Image'] ?? '',
      visible: json['Visible'] ?? false,
    );
  }
}