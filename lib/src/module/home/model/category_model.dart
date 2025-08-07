// category_model.dart

class CategoryModel {
  final String message;
  final CategoryData data;

  CategoryModel({
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      message: json['message'] as String,
      data: CategoryData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CategoryData {
  final List<MainCategoryModel> categories;

  CategoryData({
    required this.categories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => MainCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class MainCategoryModel {
  final int id;
  final String name;
  final String image;
  final bool isPublished;

  MainCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublished,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      isPublished: json['is_published'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'is_published': isPublished,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, image: $image, isPublished: $isPublished)';
  }
}