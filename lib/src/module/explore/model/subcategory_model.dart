// Data model for the root response
class SubcategoryModel {
  final String message;
  final SubcategoryData data;

  SubcategoryModel({
    required this.message,
    required this.data,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      message: json['message'],
      data: SubcategoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Data model for the data object containing subcategories
class SubcategoryData {
  final List<Subcategory> subCategories;

  SubcategoryData({
    required this.subCategories,
  });

  factory SubcategoryData.fromJson(Map<String, dynamic> json) {
    return SubcategoryData(
      subCategories: (json['subCategorys'] as List)
          .map((item) => Subcategory.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategorys': subCategories.map((item) => item.toJson()).toList(),
    };
  }
}

// Data model for individual subcategory
class Subcategory {
  final int id;
  final String name;
  final String image;
  final bool isPublished;
  final int category;

  Subcategory({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublished,
    required this.category,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isPublished: json['is_published'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'is_published': isPublished,
      'category': category,
    };
  }
}
