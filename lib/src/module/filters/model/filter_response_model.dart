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

  // Parse planters with id (string) and name
  List<FilterStringOption>? get planters {
    final planterList = filters['planter'] as List?;
    if (planterList == null) return null;
    return planterList
        .map((item) => FilterStringOption.fromJson(item as Map<String, dynamic>))
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

  // Parse weights with id and name (API key is 'weight')
  List<FilterOption>? get weights {
    final weightList = filters['weight'] as List?;
    if (weightList == null) return null;
    return weightList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse volumes with id and name
  List<FilterOption>? get volumes {
    final volumeList = filters['volume'] as List?;
    if (volumeList == null) return null;
    return volumeList
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse space and light options
  List<FilterOption>? get spaceAndLight {
    final list = filters['space_and_light'] as List?;
    if (list == null) return null;
    return list
        .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse special filters (with optional icon)
  List<SpecialFilterOption>? get specialFilters {
    final list = filters['special_filters'] as List?;
    if (list == null) return null;
    return list
        .map((item) => SpecialFilterOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse care guides (with icon url, title, subtitle)
  List<CareGuideOption>? get careGuides {
    final list = filters['care_guides'] as List?;
    if (list == null) return null;
    return list
        .map((item) => CareGuideOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse flags (e.g. is_best_seller, is_featured, etc.)
  List<FlagOption>? get flags {
    final list = filters['flags'] as List?;
    if (list == null) return null;
    return list
        .map((item) => FlagOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse rating options
  List<RatingOption>? get ratingOptions {
    final list = filters['rating_options'] as List?;
    if (list == null) return null;
    return list
        .map((item) => RatingOption.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Parse litre sizes with id and name (legacy)
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
}

// Model for filter options with integer id and name
class FilterOption {
  final int id;
  final String name;

  FilterOption({required this.id, required this.name});

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Model for filter options with string id (e.g., planter)
class FilterStringOption {
  final String id;
  final String name;

  FilterStringOption({required this.id, required this.name});

  factory FilterStringOption.fromJson(Map<String, dynamic> json) {
    return FilterStringOption(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Model for special filters with optional icon
class SpecialFilterOption {
  final int id;
  final String name;
  final String? icon;

  SpecialFilterOption({required this.id, required this.name, this.icon});

  factory SpecialFilterOption.fromJson(Map<String, dynamic> json) {
    return SpecialFilterOption(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}

// Model for care guide options
class CareGuideOption {
  final int id;
  final String title;
  final String subtitle;
  final String? icon;

  CareGuideOption({
    required this.id,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  factory CareGuideOption.fromJson(Map<String, dynamic> json) {
    return CareGuideOption(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }
}

// Model for flag options (e.g. is_best_seller)
class FlagOption {
  final int id;
  final String name; // e.g. 'is_best_seller'
  final String label; // e.g. 'Best Seller'

  FlagOption({required this.id, required this.name, required this.label});

  factory FlagOption.fromJson(Map<String, dynamic> json) {
    return FlagOption(
      id: json['id'] as int,
      name: json['name'] as String,
      label: json['label'] as String,
    );
  }
}

// Model for rating options
class RatingOption {
  final String label;
  final double value;

  RatingOption({required this.label, required this.value});

  factory RatingOption.fromJson(Map<String, dynamic> json) {
    return RatingOption(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }
}

class PriceRange {
  final double min;
  final double max;
  PriceRange({required this.min, required this.max});
}
