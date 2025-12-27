# Filter System Update - Complete Implementation Guide

## 🎯 Overview
Complete refactoring of the filter system to use the new backend API with dynamic filter categories and ID-based selection.

---

## 🔄 API Changes

### Old API Endpoints:
- **Get Filters:** `https://www.backend.biotechmaali.com/filters/filters/`
- **Apply Filters:** `https://www.backend.biotechmaali.com/filters/productsFilter/`

### New API Endpoints:
- **Get Filters:** `https://backend.biotechmaali.com/filters/filters_n/`
- **Apply Filters:** `https://backend.biotechmaali.com/filters/main_productsFilter/`

---

## 📊 New API Response Structure

### 1. Get Filters Response (`/filters/filters_n/?type=pot`)

```json
{
  "filters": {
    "available_types": ["pot", "plant", "plantcare", "seed"],
    "subcategories": [
      {"id": 28, "name": "Rotomolded Pots"},
      {"id": 29, "name": "Plastic Pots"}
    ],
    "price": {
      "price_min": 2.0,
      "price_max": 4094.1
    },
    "planter_size": [
      {"id": 27, "name": "10 inches"},
      {"id": 28, "name": "11 inches"}
    ],
    "litre_size": [
      {"id": 1, "name": "1 litre"},
      {"id": 2, "name": "2 litre"}
    ],
    "color": [
      {"id": 18, "name": "Baltic Brown"},
      {"id": 45, "name": "Black"}
    ]
  }
}
```

### 2. Apply Filters Response (`/filters/main_productsFilter/`)

**Query Parameters:**
```
category_id, subcategory_id, type, search, min_price, max_price, 
color_id, size_id, planter_size_id, planter_id, weight_id, 
pot_type_id, litre_id, is_featured, is_best_seller, 
is_seasonal_collection, is_trending, ordering
```

**Response:**
```json
{
  "count": 66,
  "next": "https://backend.biotechmaali.com/...",
  "previous": null,
  "filters_applied": {
    "category_id": "",
    "subcategory_id": "",
    "type": "plant",
    ...
  },
  "results": [
    {
      "id": 341,
      "prod_id": 1090,
      "name": "🌿 Dwarf Areca Palm",
      "is_cart": false,
      "is_wishlist": false,
      "mrp": 100.0,
      "selling_price": 100.0,
      "image": "/media/main_product_images/CP.jpg",
      "product_rating": {
        "avg_rating": 0,
        "num_ratings": 0
      },
      "ribbon": "Fast Selling"
    }
  ]
}
```

---

## 📝 Changes Made

### 1. **filter_response_model.dart** - Complete Rewrite

#### Key Changes:
- Added `FilterOption` class to handle objects with `id` and `name`
- Changed all filter lists from `List<String>` to `List<FilterOption>`
- Added dynamic category detection method
- Improved price range parsing

#### New Classes:
```dart
class FilterOption {
  final int id;
  final String name;
  bool isSelected;
}

class FilterResponseModel {
  // Getters now return List<FilterOption>? instead of List<String>?
  List<FilterOption>? get subcategories;
  List<FilterOption>? get colors;
  List<FilterOption>? get sizes;
  // ... etc
  
  // New method
  List<String> getAvailableCategories();
}
```

---

### 2. **filters_repository.dart** - API Integration Update

#### Key Changes:
- Updated base URL to `https://backend.biotechmaali.com`
- Changed endpoint from `/filters/filters/` to `/filters/filters_n/`
- Changed endpoint from `/filters/productsFilter/` to `/filters/main_productsFilter/`
- Updated query parameter structure for new API

#### New Query Params:
```dart
{
  'type': type,
  'category_id': '',
  'subcategory_id': '',
  'search': '',
  'min_price': '',
  'max_price': '',
  'color_id': '',
  'size_id': '',
  'planter_size_id': '',
  'planter_id': '',
  'weight_id': '',
  'pot_type_id': '',
  'litre_id': '',
  'is_featured': 'unknown',
  'is_best_seller': 'unknown',
  'is_seasonal_collection': 'unknown',
  'is_trending': 'unknown',
  'ordering': '',
}
```

---

### 3. **filters_provider.dart** - Logic Update

#### Key Changes:
- Changed from `Map<String, List<String>> selectedFilters` to `Map<String, List<int>> selectedFilterIds`
- Added `toggleFilterById(String category, int id)` method
- Added `isFilterSelected(String category, int id)` method
- Updated `getFilterParams()` to build new API structure
- Added `getDisplayCategories()` for dynamic category generation
- Improved price range handling

#### Filter ID Mapping:
```dart
switch (category) {
  case 'subcategories': params['subcategory_id'] = ids;
  case 'color': params['color_id'] = ids;
  case 'size': params['size_id'] = ids;
  case 'planter_size': params['planter_size_id'] = ids;
  case 'planter': params['planter_id'] = ids;
  case 'weights': params['weight_id'] = ids;
  case 'litre_size': params['litre_id'] = ids;
}
```

---

### 4. **filters_screen.dart** - UI Update

#### Key Changes:
- **Dynamic Category List:** Categories are now generated based on API response
- **Filter Options with IDs:** Uses `FilterOption` objects instead of strings
- **Improved Section Builder:** New `_buildFilterOptionsSection()` method
- **Better Error Handling:** Shows appropriate messages
- **Responsive Layout:** Better handling of empty states

#### New UI Flow:
1. Load filters from API → Parse available categories
2. Display categories dynamically in left panel
3. Show filter options with checkboxes in right panel
4. Track selections by ID
5. Build query params with IDs on Apply

---

## 🔧 How It Works

### Flow Diagram:

```
1. User opens FilterScreen with type (PLANTS/POTS/SEEDS/TOOLS)
   ↓
2. loadFilters(type) → API call to /filters/filters_n/?type=plant
   ↓
3. Parse response → Create FilterOption objects
   ↓
4. getDisplayCategories() → Dynamically generate category list
   ↓
5. User selects filters → toggleFilterById(category, id)
   ↓
6. User taps Apply → getFilterParams(type)
   ↓
7. Build query with IDs → API call to /filters/main_productsFilter/
   ↓
8. Update ProductListProvider → Show filtered products
   ↓
9. Navigate back with results
```

---

## 🎨 Dynamic Category Generation

The system now automatically detects which categories are available:

```dart
// Before: Hardcoded categories
case "POTS":
  categories = [
    {"id": "subcategories", "title": "Type of Pots"},
    {"id": "price", "title": "Price"},
    {"id": "planter_size", "title": "Pot Size"},
  ];

// After: Dynamic detection
List<Map<String, String>> getDisplayCategories(String type) {
  if (subcategories != null && subcategories!.isNotEmpty) {
    categories.add({"id": "subcategories", "title": "Type of $type"});
  }
  if (priceRange.max > 0) {
    categories.add({"id": "price", "title": "Price"});
  }
  // ... automatically adds only available filters
}
```

---

## 📱 Integration with Product List

The filter system seamlessly integrates with the product list screen:

### In `product_list_screen.dart`:

```dart
// Pagination handling for filtered products
void _scrollListener() {
  if (_isFiltered) {
    final filterProvider = context.read<FiltersProvider>();
    if (!filterProvider.isLoadingMore && filterProvider.hasMoreData) {
      filterProvider.applyFilters(widget.title, context, loadMore: true);
    }
  }
}

// Navigation to FilterScreen
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

## ✅ Benefits of New Implementation

### 1. **Dynamic & Flexible**
- Automatically adapts to API changes
- No hardcoded category lists
- Supports any filter type backend provides

### 2. **ID-Based Selection**
- More reliable than string matching
- Prevents issues with special characters
- Better for internationalization

### 3. **Improved Performance**
- Efficient ID-based lookups
- Better state management
- Optimized pagination

### 4. **Better UX**
- Shows only available filters
- Clear visual feedback
- Proper error handling

### 5. **Maintainable Code**
- Clean separation of concerns
- Reusable components
- Well-documented logic

---

## 🧪 Testing Checklist

- [x] Filter loading for PLANTS
- [x] Filter loading for POTS
- [x] Filter loading for SEEDS
- [x] Filter loading for TOOLS
- [x] Category selection
- [x] Filter option selection (checkbox)
- [x] Price range slider
- [x] Clear filters functionality
- [x] Apply filters and get products
- [x] Pagination with filters
- [x] Navigation back with results
- [x] Error handling
- [x] Empty state handling

---

## 🚀 Usage Example

```dart
// 1. Navigate to FilterScreen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FilterScreen(type: "PLANTS"),
  ),
);

// 2. Provider handles everything
context.read<FiltersProvider>().loadFilters("PLANTS");

// 3. User selects filters
provider.toggleFilterById("color", 45); // Black color
provider.toggleFilterById("subcategories", 28); // Rotomolded Pots
provider.setPriceRange(RangeValues(100, 5000));

// 4. Apply filters
await provider.applyFilters("PLANTS", context);

// 5. Products automatically updated in ProductListProvider
```

---

## 📌 Key Files Modified

1. **lib/src/module/filters/model/filter_response_model.dart**
   - Complete rewrite with FilterOption class
   - Dynamic category detection

2. **lib/src/module/filters/filters_repository.dart**
   - New API endpoints
   - Updated query parameters

3. **lib/src/module/filters/filters_provider.dart**
   - ID-based filter selection
   - Dynamic category generation
   - Improved param building

4. **lib/src/module/filters/filters_screen.dart**
   - Dynamic UI rendering
   - New section builders
   - Better state management

5. **lib/src/module/filters/filters.dart**
   - Added export for filter_response_model.dart

---

## 🔗 API Documentation

### Get Filters Endpoint:
- **URL:** `https://backend.biotechmaali.com/filters/filters_n/`
- **Method:** GET
- **Query Params:** `type` (plant/pot/seed/tool)
- **Returns:** Available filter options with IDs

### Apply Filters Endpoint:
- **URL:** `https://backend.biotechmaali.com/filters/main_productsFilter/`
- **Method:** GET
- **Query Params:** Multiple filter IDs and values
- **Returns:** Paginated product list with filter metadata

---

## 💡 Pro Tips

1. **Always pass the correct type:** Ensure type param matches backend expectations (lowercase)
2. **Handle empty states:** UI gracefully handles missing filter categories
3. **Use pagination:** Filter results support infinite scroll
4. **Reset on new filter:** Provider automatically resets pagination
5. **Check available categories:** Use `getDisplayCategories()` before rendering

---

## 🎉 Conclusion

The filter system has been completely refactored to work with the new backend API. It's now:
- ✅ Fully dynamic
- ✅ ID-based and reliable
- ✅ Better integrated with product list
- ✅ More maintainable
- ✅ Production-ready

**Status:** ✅ Complete and tested
**Date:** December 27, 2025
