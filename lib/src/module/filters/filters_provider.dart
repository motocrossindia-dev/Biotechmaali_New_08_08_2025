import 'dart:developer';

import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

import '../../../import.dart';
import 'model/filter_response_model.dart';
import 'filters_repository.dart';

class FiltersProvider extends ChangeNotifier {
  final FiltersRepository _repository = FiltersRepository();
  FilterResponseModel? filterResponse;

  // Store selected filter IDs instead of values
  Map<String, List<int>> selectedFilterIds = {};

  bool isLoading = false;
  String selectedCategory = "";
  RangeValues _currentRangeValues = const RangeValues(0, 9999);
  RangeValues get currentRangeValues => _currentRangeValues;

  bool _isLoadingMore = false;
  String? _nextPageUrl;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _nextPageUrl != null;

  Future<void> loadFilters(String type) async {
    String category = "";
    if (type == "POTS") {
      category = "pot";
    } else if (type == "SEEDS") {
      category = "seed";
    } else if (type == "PLANTS") {
      category = "plant";
    } else if (type == "TOOLS") {
      category = "tool";
    } else {
      category = type.toLowerCase();
    }

    try {
      isLoading = true;
      notifyListeners();

      filterResponse = await _repository.getFilters(category);

      // Initialize range values after getting filter response
      if (filterResponse != null) {
        final priceRange = filterResponse!.priceRange;
        _currentRangeValues = RangeValues(priceRange.min, priceRange.max);

        // Set default selected category based on available filters
        final availableCategories = _getDisplayCategories(type);
        if (availableCategories.isNotEmpty) {
          selectedCategory = availableCategories[0]["title"]!;
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load filters');
    }
  }

  // Toggle filter by ID
  void toggleFilterById(String category, int id) {
    if (!selectedFilterIds.containsKey(category)) {
      selectedFilterIds[category] = [];
    }

    if (selectedFilterIds[category]!.contains(id)) {
      selectedFilterIds[category]!.remove(id);
    } else {
      selectedFilterIds[category]!.add(id);
    }

    if (selectedFilterIds[category]!.isEmpty) {
      selectedFilterIds.remove(category);
    }

    notifyListeners();
  }

  // Check if a filter option is selected
  bool isFilterSelected(String category, int id) {
    return selectedFilterIds[category]?.contains(id) ?? false;
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(RangeValues values) {
    // Ensure values are within bounds
    final min = filterResponse?.priceRange.min ?? 0;
    final max = filterResponse?.priceRange.max ?? 9999;

    _currentRangeValues = RangeValues(
      values.start.clamp(min, max),
      values.end.clamp(min, max),
    );
    notifyListeners();
  }

  void resetAllFilters() {
    selectedFilterIds.clear();
    // Reset price range to initial filter values
    if (filterResponse != null) {
      final priceRange = filterResponse!.priceRange;
      _currentRangeValues = RangeValues(priceRange.min, priceRange.max);
    }
    notifyListeners();
  }

  Map<String, dynamic> getFilterParams(String type) {
    // Convert type to singular form for API
    String apiType = type.toLowerCase();
    if (apiType == 'pots') apiType = 'pot';
    if (apiType == 'plants') apiType = 'plant';
    if (apiType == 'seeds') apiType = 'seed';
    if (apiType == 'tools') apiType = 'tool';

    final Map<String, dynamic> params = {
      'category_id': '',
      'type': apiType,
      'search': '',
      'min_price': '',
      'max_price': '',
      'is_featured': 'unknown',
      'is_best_seller': 'unknown',
      'is_seasonal_collection': 'unknown',
      'is_trending': 'unknown',
      'ordering': '',
    };

    // Map selected IDs to appropriate parameter names
    // Store as List for multiple values
    for (var entry in selectedFilterIds.entries) {
      final category = entry.key;
      final ids = entry.value; // Keep as List<int>

      switch (category) {
        case 'subcategories':
          params['subcategory_id'] = ids;
          break;
        case 'color':
          params['color_id'] = ids;
          break;
        case 'size':
          params['size_id'] = ids;
          break;
        case 'planter_size':
          params['planter_size_id'] = ids;
          break;
        case 'planter':
          params['planter_id'] = ids;
          break;
        case 'weights':
          params['weight_id'] = ids;
          break;
        case 'litre_size':
          params['litre_id'] = ids;
          break;
      }
    }

    // Add price range if changed from default
    final priceRange = filterResponse?.priceRange;
    if (priceRange != null) {
      if (_currentRangeValues.start > priceRange.min ||
          _currentRangeValues.end < priceRange.max) {
        params['min_price'] = _currentRangeValues.start.round().toString();
        params['max_price'] = _currentRangeValues.end.round().toString();
      }
    }

    log("Generated filter params: $params");
    return params;
  }

  Future<List<Product>> applyFilters(String type, BuildContext context,
      {bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (_isLoadingMore || !hasMoreData) return [];
        _isLoadingMore = true;
      } else {
        isLoading = true;
        // Reset pagination on fresh filter
        _nextPageUrl = null;
      }
      notifyListeners();

      log("Applying filters for type: $type");
      final params = getFilterParams(type);
      final filterResult = await _repository.applyFilters(
        type.toLowerCase(),
        params,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      log("Filter result message: ${filterResult.message}");
      log("Products count: ${filterResult.products.length}");
      log("Next page URL: ${filterResult.nextPage}");

      _nextPageUrl = filterResult.nextPage;
      final List<Product> products = filterResult.products;

      if (!loadMore) {
        // Reset products on fresh filter
        context.read<ProductListProdvider>().setFilteredProducts(products);
      } else {
        // Append products on pagination
        context.read<ProductListProdvider>().appendProducts(products);
      }

      return products;
    } catch (e) {
      log("Filter error: $e");
      rethrow;
    } finally {
      isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void resetPagination() {
    _nextPageUrl = null;
    _isLoadingMore = false;
  }

  // Helper method to get display categories based on type and available data
  List<Map<String, String>> _getDisplayCategories(String type) {
    List<Map<String, String>> categories = [];

    if (filterResponse == null) return categories;

    // Add categories dynamically based on available data
    if (filterResponse!.subcategories != null &&
        filterResponse!.subcategories!.isNotEmpty) {
      String title = "Type of ";
      switch (type) {
        case "PLANTS":
          title += "Plants";
          break;
        case "POTS":
          title += "Pots";
          break;
        case "SEEDS":
          title += "Seeds";
          break;
        case "TOOLS":
          title += "Tools";
          break;
        default:
          title += type;
      }
      categories.add({"id": "subcategories", "title": title});
    }

    if (filterResponse!.priceRange.max > 0) {
      categories.add({"id": "price", "title": "Price"});
    }

    if (filterResponse!.sizes != null && filterResponse!.sizes!.isNotEmpty) {
      categories.add({"id": "size", "title": "Size"});
    }

    if (filterResponse!.planterSizes != null &&
        filterResponse!.planterSizes!.isNotEmpty) {
      categories.add({
        "id": "planter_size",
        "title": type == "POTS" ? "Pot Size" : "Planter Size"
      });
    }

    if (filterResponse!.planters != null &&
        filterResponse!.planters!.isNotEmpty) {
      categories.add({"id": "planter", "title": "Planter"});
    }

    if (filterResponse!.colors != null && filterResponse!.colors!.isNotEmpty) {
      categories.add({"id": "color", "title": "Color"});
    }

    if (filterResponse!.weights != null &&
        filterResponse!.weights!.isNotEmpty) {
      categories.add({"id": "weights", "title": "Weights"});
    }

    if (filterResponse!.litreSizes != null &&
        filterResponse!.litreSizes!.isNotEmpty) {
      categories.add({"id": "litre_size", "title": "Litre Size"});
    }

    return categories;
  }

  // Public method to get categories
  List<Map<String, String>> getDisplayCategories(String type) {
    return _getDisplayCategories(type);
  }
}
