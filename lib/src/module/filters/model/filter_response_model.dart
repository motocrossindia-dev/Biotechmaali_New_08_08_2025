class FilterResponseModel {
  final Map<String, dynamic> filters;

  FilterResponseModel({required this.filters});

  factory FilterResponseModel.fromJson(Map<String, dynamic> json) {
    return FilterResponseModel(filters: json['filters'] ?? {});
  }

  // Get list of available types
  List<String>? get availableTypes =>
      (filters['available_types'] as List?)?.cast<String>();

  // Parse subcategories with id and name
  List<FilterOption>? get subcategories {
    final subCats = filters['subcategories'] as List?;
    if (subCats == null) return null;
    return subCats
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse sizes with id and name
  List<FilterOption>? get sizes {
    final sizeList = filters['size'] as List?;
    if (sizeList == null) return null;
    return sizeList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse planter sizes with id and name
  List<FilterOption>? get planterSizes {
    final planterSizeList = filters['planter_size'] as List?;
    if (planterSizeList == null) return null;
    return planterSizeList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse planters with id and name
  List<FilterOption>? get planters {
    final planterList = filters['planter'] as List?;
    if (planterList == null) return null;
    return planterList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse colors with id and name
  List<FilterOption>? get colors {
    final colorList = filters['color'] as List?;
    if (colorList == null) return null;
    return colorList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse weights with id and name
  List<FilterOption>? get weights {
    final weightList = filters['weights'] as List?;
    if (weightList == null) return null;
    return weightList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse litre sizes with id and name
  List<FilterOption>? get litreSizes {
    final litreList = filters['litre_size'] as List?;
    if (litreList == null) return null;
    return litreList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse price range
  PriceRange get priceRange {
    final price = filters['price'];
    if (price == null) {
      return PriceRange(min: 0.0, max: 9999.0);
    }
    return PriceRange(
      min: (price['price_min'] ?? price['min'])?.toDouble() ?? 0.0,
      max: (price['price_max'] ?? price['max'])?.toDouble() ?? 9999.0,
    );
  }

  // Helper method to get available filter categories dynamically
  List<String> getAvailableCategories() {
    List<String> categories = [];
    if (subcategories != null && subcategories!.isNotEmpty) {
      categories.add('subcategories');
    }
    if (filters['price'] != null) categories.add('price');
    if (sizes != null && sizes!.isNotEmpty) categories.add('size');
    if (planterSizes != null && planterSizes!.isNotEmpty) {
      categories.add('planter_size');
    }
    if (planters != null && planters!.isNotEmpty) categories.add('planter');
    if (colors != null && colors!.isNotEmpty) categories.add('color');
    if (weights != null && weights!.isNotEmpty) categories.add('weights');
    if (litreSizes != null && litreSizes!.isNotEmpty) {
      categories.add('litre_size');
    }
    return categories;
  }
}

// Model for filter options with id and name
class FilterOption {
  final int id;
  final String name;
  bool isSelected;

  FilterOption({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(
      id: json['id'] as int,
      name: json['name'] as String,
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }
}

class PriceRange {
  final double min;
  final double max;
  PriceRange({required this.min, required this.max});
}
