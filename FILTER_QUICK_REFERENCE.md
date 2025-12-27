# Filter System - Quick Reference Guide

## 🚀 Quick Start

### Using the Filter System:

```dart
// Navigate to filter screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FilterScreen(type: "PLANTS"), // or POTS, SEEDS, TOOLS
  ),
);
```

---

## 📋 API Endpoints

### Get Available Filters
```
GET: https://backend.biotechmaali.com/filters/filters_n/
Query: ?type=plant (or pot, seed, tool)
```

### Apply Filters & Get Products
```
GET: https://backend.biotechmaali.com/filters/main_productsFilter/
Query Parameters:
  - type: plant/pot/seed/tool
  - subcategory_id: 28,29 (comma-separated IDs)
  - color_id: 45,46
  - size_id: 20,21
  - planter_size_id: 27,28
  - litre_id: 1,2
  - weight_id: 5,6
  - min_price: 100
  - max_price: 5000
  - is_featured: unknown
  - is_best_seller: unknown
  - is_seasonal_collection: unknown
  - is_trending: unknown
  - ordering: ""
```

---

## 🔧 Key Methods

### FiltersProvider Methods:

```dart
// Load filters from API
await provider.loadFilters("PLANTS");

// Toggle filter selection by ID
provider.toggleFilterById("color", 45);

// Check if filter is selected
bool isSelected = provider.isFilterSelected("color", 45);

// Set price range
provider.setPriceRange(RangeValues(100, 5000));

// Reset all filters
provider.resetAllFilters();

// Apply filters and get products
await provider.applyFilters("PLANTS", context);

// Get dynamic categories
List<Map<String, String>> categories = provider.getDisplayCategories("PLANTS");
```

---

## 📊 Data Models

### FilterOption
```dart
class FilterOption {
  final int id;           // Backend ID
  final String name;      // Display name
  bool isSelected;        // Selection state
}
```

### FilterResponseModel
```dart
class FilterResponseModel {
  List<String>? availableTypes;        // ["pot", "plant", "seed"]
  List<FilterOption>? subcategories;   // Type of plants/pots/etc
  List<FilterOption>? colors;          // Color options
  List<FilterOption>? sizes;           // Size options
  List<FilterOption>? planterSizes;    // Planter size options
  List<FilterOption>? planters;        // Planter options
  List<FilterOption>? weights;         // Weight options
  List<FilterOption>? litreSizes;      // Litre size options
  PriceRange priceRange;               // Min/max price
}
```

---

## 🎯 Filter Categories by Type

### PLANTS
- Type of Plants (subcategories)
- Price
- Size
- Planter Size
- Planter
- Color

### POTS
- Type of Pots (subcategories)
- Price
- Pot Size (planter_size)
- Litre Size
- Color

### SEEDS
- Type of Seeds (subcategories)
- Price
- Weights

### TOOLS
- Type of Tools (subcategories)
- Price
- Size
- Color

---

## 🔄 Filter Flow

```
User Opens Filter Screen
         ↓
Load Filters (API Call)
         ↓
Display Dynamic Categories
         ↓
User Selects Filters
         ↓
User Clicks Apply
         ↓
Build Query Params
         ↓
Apply Filters (API Call)
         ↓
Update Product List
         ↓
Navigate Back
```

---

## 💻 Code Examples

### Example 1: Loading Filters
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<FiltersProvider>().loadFilters(widget.type);
  });
}
```

### Example 2: Toggle Filter
```dart
CheckboxListTile(
  title: Text(option.name),
  value: provider.isFilterSelected(category, option.id),
  onChanged: (bool? checked) {
    if (checked != null) {
      provider.toggleFilterById(category, option.id);
    }
  },
)
```

### Example 3: Price Range
```dart
RangeSlider(
  values: provider.currentRangeValues,
  min: provider.filterResponse?.priceRange.min ?? 0,
  max: provider.filterResponse?.priceRange.max ?? 9999,
  onChanged: provider.setPriceRange,
)
```

### Example 4: Apply Filters
```dart
ElevatedButton(
  onPressed: () async {
    try {
      provider.resetPagination();
      final result = await provider.applyFilters(widget.type, context);
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply filters: $e')),
      );
    }
  },
  child: const Text('Apply'),
)
```

---

## 🐛 Common Issues & Solutions

### Issue 1: Filters not loading
**Solution:** Check type parameter is lowercase (plant, pot, seed, tool)

### Issue 2: Products not updating
**Solution:** Ensure `ProductListProvider` is properly integrated

### Issue 3: Pagination not working
**Solution:** Call `resetPagination()` before applying new filters

### Issue 4: Categories not showing
**Solution:** API might not return data for that category - check backend

---

## 📱 Integration with Product List

### In product_list_screen.dart:

```dart
// Check if filtered
bool _isFiltered = false;

// Scroll listener for pagination
void _scrollListener() {
  if (_scrollController.position.pixels == 
      _scrollController.position.maxScrollExtent) {
    if (_isFiltered) {
      final filterProvider = context.read<FiltersProvider>();
      if (!filterProvider.isLoadingMore && filterProvider.hasMoreData) {
        filterProvider.applyFilters(widget.title, context, loadMore: true);
      }
    }
  }
}

// Navigate to filter screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FilterScreen(type: widget.title),
  ),
).then((value) {
  if (value != null) {
    setState(() => _isFiltered = true);
  }
});
```

---

## 🎨 UI Components

### Left Panel - Categories
- Dynamically generated based on available filters
- Visual indicator for selected category
- Scrollable list

### Right Panel - Filter Options
- CheckboxListTile for each option
- Shows option name with ID tracking
- Supports multiple selections

### Price Range Slider
- RangeSlider with dynamic min/max
- Shows current selected range
- Real-time updates

### Bottom Bar
- Clear All button (resets all filters)
- Apply button (applies filters and gets products)
- Fixed at bottom of screen

---

## ✅ Testing Commands

```dart
// Test filter loading
await context.read<FiltersProvider>().loadFilters("PLANTS");

// Test filter selection
context.read<FiltersProvider>().toggleFilterById("color", 45);

// Test filter application
await context.read<FiltersProvider>().applyFilters("PLANTS", context);

// Test reset
context.read<FiltersProvider>().resetAllFilters();
```

---

## 📞 Support

For issues or questions:
1. Check FILTER_SYSTEM_UPDATE.md for detailed documentation
2. Review code comments in provider/repository files
3. Test with different product types (PLANTS, POTS, SEEDS, TOOLS)

---

**Last Updated:** December 27, 2025
**Version:** 2.0 (New API Integration)
