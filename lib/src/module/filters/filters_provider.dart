import 'dart:developer';

import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

import '../../../import.dart';
import 'model/filter_response_model.dart';
import 'filters_repository.dart';

class FiltersProvider extends ChangeNotifier {
  final FiltersRepository _repository = FiltersRepository();
  FilterResponseModel? filterResponse;
  Map<String, List<String>> selectedFilters = {};
  bool isLoading = false;
  String selectedCategory = "Type of Plants";
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
    }
    try {
      isLoading = true;
      notifyListeners();

      filterResponse = await _repository.getFilters(category);

      // Initialize range values after getting filter response
      if (filterResponse != null) {
        final priceRange = filterResponse!.priceRange;
        _currentRangeValues = RangeValues(priceRange.min, priceRange.max);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load filters');
    }
  }

  void toggleFilter(String category, String value) {
    if (!selectedFilters.containsKey(category)) {
      selectedFilters[category] = [];
    }

    if (selectedFilters[category]!.contains(value)) {
      selectedFilters[category]!.remove(value);
    } else {
      selectedFilters[category]!.add(value);
    }

    if (selectedFilters[category]!.isEmpty) {
      selectedFilters.remove(category);
    }

    notifyListeners();
  }

  String getFilterQueryString() {
    return selectedFilters.entries
        .map((e) => '${e.key}=${e.value.join(",")}')
        .join('&');
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
    selectedFilters.clear();
    // Reset price range to initial filter values
    if (filterResponse != null) {
      final priceRange = filterResponse!.priceRange;
      _currentRangeValues = RangeValues(priceRange.min, priceRange.max);
    }
    notifyListeners();
  }

  Map<String, dynamic> getFilterParams() {
    final Map<String, dynamic> params = {};

    // Add selected filters
    for (var entry in selectedFilters.entries) {
      params[entry.key] = entry.value.join(',');
    }

    // Add price range if changed from default
    if (_currentRangeValues.start > 0 || _currentRangeValues.end < 9999) {
      params['price_min'] = _currentRangeValues.start.round().toString();
      params['price_max'] = _currentRangeValues.end.round().toString();
    }

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

      log("Type : $type");
      final params = getFilterParams();
      final filterResult = await _repository.applyFilters(type, params,
          nextPageUrl: loadMore ? _nextPageUrl : null);

      log("message : ${filterResult.message}");
      log("products : ${filterResult.products.length}");
      log("next page URL: ${filterResult.nextPage}");

      _nextPageUrl = filterResult.nextPage;
      final List<Product> products = filterResult.products;

      if (!loadMore) {
        // Reset products on fresh filter
        context.read<ProductListProdvider>().setFilteredProducts(products);
        // resetAllFilters();
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
}
