import 'dart:developer';

import 'package:biotech_maali/src/module/product_list/product_list/model/product_list_model.dart';

import '../../../import.dart';
import 'filters_repository.dart';

class FiltersProvider extends ChangeNotifier {
  final FiltersRepository _repository = FiltersRepository();
  FilterResponseModel? filterResponse;

  // ── Selection state ────────────────────────────────────────────────────────

  /// Single-selected type string from available_types chips (e.g. "plants")
  String? selectedType;

  /// Integer-ID filters: category → [id1, id2, ...]
  Map<String, List<int>> selectedFilterIds = {};

  /// String-ID filters (planter has string IDs like "Nursery Bag")
  Map<String, List<String>> selectedFilterStringIds = {};

  /// Selected flag IDs (integer)
  Set<int> selectedFlagIds = {};

  /// Selected minimum rating value (null = not selected)
  double? selectedRating;

  // ── Price state ────────────────────────────────────────────────────────────

  /// Initial price range loaded from the API
  PriceRange? _initialPriceRange;

  RangeValues _currentRangeValues = const RangeValues(0, 9999);
  RangeValues get currentRangeValues => _currentRangeValues;

  bool get isPriceChanged {
    final pr = _initialPriceRange;
    if (pr == null) return false;
    return _currentRangeValues.start > pr.min ||
        _currentRangeValues.end < pr.max;
  }

  // ── Loading ────────────────────────────────────────────────────────────────

  bool isLoading = false;
  bool _isLoadingMore = false;
  String? _nextPageUrl;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _nextPageUrl != null;

  // ── Load filter options with category type ────────────────────────────────

  /// [type] is the category slug e.g. "plants", "pots", "plant-care"
  Future<void> loadFilters(String type) async {
    try {
      isLoading = true;
      notifyListeners();

      filterResponse = await _repository.getFilters(type);

      if (filterResponse != null) {
        final pr = filterResponse!.priceRange;
        _initialPriceRange = pr;
        _currentRangeValues = RangeValues(pr.min, pr.max);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load filters');
    }
  }

  // ── Type (single-select) ──────────────────────────────────────────────────

  void selectType(String type) {
    if (selectedType == type) {
      selectedType = null;
    } else {
      selectedType = type;
    }
    
    // Clear other selections since options will change entirely
    selectedFilterIds.clear();
    selectedFilterStringIds.clear();
    selectedFlagIds.clear();
    selectedRating = null;
    
    notifyListeners();

    // Refetch filter options with the new type
    loadFilters(selectedType ?? '');
  }

  bool isTypeSelected(String type) => selectedType == type;

  // ── Integer-ID filters ────────────────────────────────────────────────────

  void toggleFilterById(String category, int id) {
    if (selectedFilterIds[category]?.contains(id) ?? false) {
      selectedFilterIds.remove(category);
    } else {
      selectedFilterIds[category] = [id];
    }
    notifyListeners();
  }

  bool isFilterSelected(String category, int id) {
    return selectedFilterIds[category]?.contains(id) ?? false;
  }

  // ── String-ID filters (planter) ───────────────────────────────────────────

  void toggleFilterByStringId(String category, String id) {
    if (selectedFilterStringIds[category]?.contains(id) ?? false) {
      selectedFilterStringIds.remove(category);
    } else {
      selectedFilterStringIds[category] = [id];
    }
    notifyListeners();
  }

  bool isStringFilterSelected(String category, String id) {
    return selectedFilterStringIds[category]?.contains(id) ?? false;
  }

  // ── Flag filters (integer IDs) ────────────────────────────────────────────

  void toggleFlagById(int id) {
    if (selectedFlagIds.contains(id)) {
      selectedFlagIds.remove(id);
    } else {
      selectedFlagIds.clear();
      selectedFlagIds.add(id);
    }
    notifyListeners();
  }

  bool isFlagSelected(int id) => selectedFlagIds.contains(id);

  // ── Rating ────────────────────────────────────────────────────────────────

  void selectRating(double value) {
    selectedRating = selectedRating == value ? null : value;
    notifyListeners();
  }

  // ── Price range ───────────────────────────────────────────────────────────

  void setPriceRange(RangeValues values) {
    final pr = _initialPriceRange;
    final min = pr?.min ?? 0;
    final max = pr?.max ?? 9999;
    _currentRangeValues = RangeValues(
      values.start.clamp(min, max).toDouble(),
      values.end.clamp(min, max).toDouble(),
    );
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void resetAllFilters() {
    selectedType = null;
    selectedFilterIds.clear();
    selectedFilterStringIds.clear();
    selectedFlagIds.clear();
    selectedRating = null;
    if (_initialPriceRange != null) {
      final pr = _initialPriceRange!;
      _currentRangeValues = RangeValues(pr.min, pr.max);
    }
    notifyListeners();
  }

  // ── Build API params ──────────────────────────────────────────────────────

  Map<String, dynamic> getFilterParams() {
    final Map<String, dynamic> params = {
      'mobile_app': 'true',
    };

    // Type — only if user selected one from the chips
    if (selectedType != null && selectedType!.isNotEmpty) {
      params['type'] = selectedType;
    }

    // Price — included automatically when applying if user moved the slider
    if (isPriceChanged) {
      params['min_price'] = _currentRangeValues.start.round().toString();
      params['max_price'] = _currentRangeValues.end.round().toString();
    }

    // Subcategory IDs
    _addIntIds(params, 'subcategories', 'subcategory_id');

    // Color IDs
    _addIntIds(params, 'color', 'color_id');

    // Size IDs
    _addIntIds(params, 'size', 'size_id');

    // Planter size IDs
    _addIntIds(params, 'planter_size', 'planter_size_id');

    // Planter string IDs
    if ((selectedFilterStringIds['planter'] ?? []).isNotEmpty) {
      params['planter_id'] = selectedFilterStringIds['planter'];
    }

    // Weight IDs
    _addIntIds(params, 'weights', 'weight_id');

    // Volume / litre IDs
    _addIntIds(params, 'volume', 'litre_id');

    // Space and light IDs
    _addIntIds(params, 'space_and_light', 'space_and_light_id');

    // Special filter IDs
    _addIntIds(params, 'special_filters', 'special_filter_id');

    // Care guide IDs
    _addIntIds(params, 'care_guides', 'care_guide_id');

    // Flag IDs
    if (selectedFlagIds.isNotEmpty) {
      params['flag'] = selectedFlagIds.toList();
    }

    // Min rating
    if (selectedRating != null) {
      params['min_rating'] = selectedRating.toString();
    }

    log('Filter params built: $params');
    return params;
  }

  void _addIntIds(
    Map<String, dynamic> params,
    String internalKey,
    String apiKey,
  ) {
    final ids = selectedFilterIds[internalKey];
    if (ids != null && ids.isNotEmpty) {
      params[apiKey] = ids;
    }
  }

  // ── Apply filters ─────────────────────────────────────────────────────────

  Future<List<Product>> applyFilters(
    BuildContext context, {
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        if (_isLoadingMore || !hasMoreData) return [];
        _isLoadingMore = true;
      } else {
        isLoading = true;
        _nextPageUrl = null;
      }
      notifyListeners();

      final params = getFilterParams();
      final filterResult = await _repository.applyFilters(
        params,
        nextPageUrl: loadMore ? _nextPageUrl : null,
      );

      log('Products returned: ${filterResult.products.length}');
      log('Next page: ${filterResult.nextPage}');

      _nextPageUrl = filterResult.nextPage;
      final products = filterResult.products;

      if (!loadMore) {
        context.read<ProductListProdvider>().setFilteredProducts(products);
      } else {
        context.read<ProductListProdvider>().appendProducts(products);
      }

      return products;
    } catch (e) {
      log('Filter apply error: $e');
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

  /// Total active filter count — shown as badge on Apply button
  int get activeFilterCount {
    int count = 0;
    if (selectedType != null) count++;
    for (final ids in selectedFilterIds.values) {
      count += ids.length;
    }
    for (final ids in selectedFilterStringIds.values) {
      count += ids.length;
    }
    count += selectedFlagIds.length;
    if (selectedRating != null) count++;
    if (isPriceChanged) count++;
    return count;
  }
}
