import 'dart:developer';
import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/explore/explore_repository.dart';
import 'package:biotech_maali/src/module/home/model/category_model.dart';
import 'package:biotech_maali/src/module/explore/model/subcategory_model.dart';

class ExploreProvider extends ChangeNotifier {
  ExploreProvider() {
    fetchMainCategories();
  }

  ExploreRepository exploreRepository = ExploreRepository();

  bool _isLoading = false;
  String? _error;
  int _selectedCategoryIndex = 0;
  int? _selectedCategoryId;
  String? _selectedCategoryName = "PLANTS";

  int get selectedCategoryIndex => _selectedCategoryIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;
  String? get selectedCategoryName => _selectedCategoryName;

  List<Subcategory> _subcategories = [];
  List<MainCategoryModel> _mainCategories = [];

  List<Subcategory> get subcategories => _subcategories;
  List<MainCategoryModel> get maincategories => _mainCategories;

  void setSelectedCategory(int index, int categoryId, String categoryName) {
    _selectedCategoryIndex = index;
    _selectedCategoryId = categoryId;
    _selectedCategoryName = categoryName;
    fetchSubcategory(categoryId);
    notifyListeners();
  }

  Future<void> fetchSubcategory(int categoryId, {BuildContext? context}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // context!.read<FiltersProvider>().resetAllFilters();
      final response = await exploreRepository.getSubcategories(categoryId);

      if (response == null) {
        return;
      }

      _subcategories = response.data.subCategories;

      notifyListeners();
    } catch (e) {
      log("error: ${e.toString()}");
      _error =
          "Oops! Something went wrong. Please check your connection and try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMainCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final categoryResponse = await exploreRepository.getMainCategories();
      _mainCategories = categoryResponse.data.categories;

      // Set initial category and fetch its subcategories
      if (_mainCategories.isNotEmpty) {
        _selectedCategoryId = _mainCategories[0].id;
        await fetchSubcategory(_selectedCategoryId!);
      }

      log("Main Categories: ${_mainCategories.toString()}");
    } catch (e) {
      _error =
          "Oops! Something went wrong. Please check your connection and try again.";
      log("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
