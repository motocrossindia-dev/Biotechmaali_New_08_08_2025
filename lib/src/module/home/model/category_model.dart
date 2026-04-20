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
  final String? type;
  final String name;
  final String image;
  final bool isPublished;
  final int order;
  final String slug;

  MainCategoryModel({
    required this.id,
    this.type,
    required this.name,
    required this.image,
    required this.isPublished,
    required this.order,
    required this.slug,
  });

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json['id'] as int,
      type: json['type'] as String?,
      name: json['name'] as String,
      image: json['image'] as String,
      isPublished: json['is_published'] as bool,
      order: json['order'] as int,
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'image': image,
      'is_published': isPublished,
      'order': order,
      'slug': slug,
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, type: $type, name: $name, image: $image, isPublished: $isPublished, order: $order, slug: $slug)';
  }
}
