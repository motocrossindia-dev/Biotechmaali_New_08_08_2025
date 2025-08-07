class ProductSampleDetails {
  final String id;
  final String name;
  final double price;
  final String? description;

  ProductSampleDetails({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  // Method to convert JSON to ProductSampleDetails object
  factory ProductSampleDetails.fromJson(Map<String, dynamic> json) {
    return ProductSampleDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  // Method to convert ProductSampleDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}
