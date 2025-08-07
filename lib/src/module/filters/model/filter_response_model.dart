class FilterResponseModel {
  final Map<String, dynamic> filters;

  FilterResponseModel({required this.filters});

  factory FilterResponseModel.fromJson(Map<String, dynamic> json) {
    return FilterResponseModel(filters: json['filters'] ?? {});
  }

  List<String>? get subcategories => filters['subcategories']?.cast<String>();
  List<String>? get sizes => filters['size']?.cast<String>();
  List<String>? get planterSizes => filters['planter_size']?.cast<String>();
  List<String>? get planters => filters['planter']?.cast<String>();
  List<String>? get colors => filters['color']?.cast<String>();
  List<String>? get weights => filters['weights']?.cast<String>();
  List<String>? get litreSizes => filters['litre_size']?.cast<String>();

  PriceRange get priceRange {
    final price = filters['price'];
    return PriceRange(
      min: (price['min'] ?? price['price_min'])?.toDouble() ?? 0.0,
      max: (price['max'] ?? price['price_max'])?.toDouble() ?? 0.0,
    );
  }
}

class PriceRange {
  final double min;
  final double max;
  PriceRange({required this.min, required this.max});
}
