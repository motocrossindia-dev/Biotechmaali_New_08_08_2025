# 🔧 Filter System - Multiple Values Fix

## 🐛 Issue Identified

### Problem:
Backend was returning **400 Bad Request** error when applying filters with multiple selections.

### Root Causes:

1. **Incorrect Type Format**
   - ❌ Sending: `type=pots`, `type=plants`
   - ✅ Should be: `type=pot`, `type=plant`

2. **Wrong Multiple Values Format**
   - ❌ Sending: `subcategory_id=28,29,30,35,39` (comma-separated)
   - ✅ Should be: `subcategory_id=28&subcategory_id=29&subcategory_id=30&subcategory_id=35&subcategory_id=39`

---

## ✅ Solution Implemented

### 1. **Fixed Type Conversion** (`filters_provider.dart`)

```dart
// BEFORE ❌
Map<String, dynamic> getFilterParams(String type) {
  final Map<String, dynamic> params = {
    'type': type.toLowerCase(), // "pots", "plants", etc.
  };
}

// AFTER ✅
Map<String, dynamic> getFilterParams(String type) {
  // Convert type to singular form for API
  String apiType = type.toLowerCase();
  if (apiType == 'pots') apiType = 'pot';
  if (apiType == 'plants') apiType = 'plant';
  if (apiType == 'seeds') apiType = 'seed';
  if (apiType == 'tools') apiType = 'tool';
  
  final Map<String, dynamic> params = {
    'type': apiType, // Now correctly: "pot", "plant", etc.
  };
}
```

### 2. **Fixed Multiple Values Handling** (`filters_provider.dart`)

```dart
// BEFORE ❌
// Stored IDs as comma-separated string
for (var entry in selectedFilterIds.entries) {
  final ids = entry.value.join(','); // "28,29,30"
  params['subcategory_id'] = ids; // Wrong format
}

// AFTER ✅
// Store IDs as List for Dio to handle
for (var entry in selectedFilterIds.entries) {
  final ids = entry.value; // [28, 29, 30] - Keep as List
  params['subcategory_id'] = ids; // Dio will create multiple params
}
```

### 3. **Updated Repository to Handle Lists** (`filters_repository.dart`)

```dart
// BEFORE ❌
final queryParams = {
  'subcategory_id': filters['subcategory_id'] ?? '', // String or comma-separated
  'color_id': filters['color_id'] ?? '',
  // ... hardcoded all params
};

// AFTER ✅
Map<String, dynamic> queryParams = {};

filters.forEach((key, value) {
  if (value is List && value.isNotEmpty) {
    // Dio automatically creates: subcategory_id=28&subcategory_id=29
    queryParams[key] = value;
  } else if (value != null && value != '') {
    queryParams[key] = value;
  } else {
    queryParams[key] = ''; // Keep empty params
  }
});
```

---

## 🔄 How It Works Now

### Example with Multiple Subcategories:

#### User Selection:
- ✅ Rotomolded Pots (ID: 28)
- ✅ Plastic Pots (ID: 29)
- ✅ Hanging Pots (ID: 30)
- ✅ Table Top Pots (ID: 35)
- ✅ Eco Planters (ID: 39)

#### Provider Generates:
```dart
{
  'type': 'pot',  // ✅ Singular form
  'subcategory_id': [28, 29, 30, 35, 39],  // ✅ As List
  'category_id': '',
  'search': '',
  // ... other params
}
```

#### Repository Converts to URL:
```
https://backend.biotechmaali.com/filters/main_productsFilter/
?type=pot
&category_id=
&subcategory_id=28
&subcategory_id=29
&subcategory_id=30
&subcategory_id=35
&subcategory_id=39
&search=
&min_price=
&max_price=
&color_id=
&size_id=
&planter_size_id=
&planter_id=
&weight_id=
&pot_type_id=
&litre_id=
&is_featured=unknown
&is_best_seller=unknown
&is_seasonal_collection=unknown
&is_trending=unknown
&ordering=
```

✅ **Backend accepts this format!**

---

## 🎯 What Was Changed

### File: `filters_provider.dart`

**Changes:**
1. Added type conversion logic (POTS → pot, PLANTS → plant, etc.)
2. Changed from `join(',')` to keeping IDs as `List<int>`
3. Removed unnecessary parameter initialization (let repository handle it)

**Lines Modified:** ~118-145

---

### File: `filters_repository.dart`

**Changes:**
1. Replaced hardcoded parameter building with dynamic approach
2. Added List detection for multiple values
3. Dio automatically handles List → multiple query params conversion

**Lines Modified:** ~24-60

---

## 📊 Before vs After Comparison

### Request Format:

#### ❌ BEFORE (400 Error)
```
URL: /filters/main_productsFilter/
Params: {
  type: "pots",  // Wrong - should be singular
  subcategory_id: "28,29,30,35,39",  // Wrong - comma-separated string
  color_id: "",
  // ...
}

Backend receives:
?type=pots&subcategory_id=28,29,30,35,39

Result: 400 Bad Request ❌
```

#### ✅ AFTER (Success)
```
URL: /filters/main_productsFilter/
Params: {
  type: "pot",  // ✅ Correct - singular
  subcategory_id: [28, 29, 30, 35, 39],  // ✅ Correct - List
  color_id: "",
  // ...
}

Backend receives:
?type=pot&subcategory_id=28&subcategory_id=29&subcategory_id=30&subcategory_id=35&subcategory_id=39

Result: 200 OK ✅
```

---

## 🧪 Testing

### Test Cases:

1. **Single Subcategory Selection** ✅
   ```
   Select: Rotomolded Pots (28)
   URL: ?type=pot&subcategory_id=28
   Result: ✅ Works
   ```

2. **Multiple Subcategory Selection** ✅
   ```
   Select: Rotomolded (28), Plastic (29), Hanging (30)
   URL: ?type=pot&subcategory_id=28&subcategory_id=29&subcategory_id=30
   Result: ✅ Works
   ```

3. **Multiple Colors Selection** ✅
   ```
   Select: Black (45), Red (36), Blue (37)
   URL: ?type=pot&color_id=45&color_id=36&color_id=37
   Result: ✅ Works
   ```

4. **Mixed Filters** ✅
   ```
   Select: 
   - Subcategories: 28, 29
   - Colors: 45, 46
   - Price: 100-5000
   
   URL: ?type=pot&subcategory_id=28&subcategory_id=29&color_id=45&color_id=46&min_price=100&max_price=5000
   Result: ✅ Works
   ```

---

## 💡 Key Points

### Why Dio Handles Lists Automatically?

Dio's query parameter handling:
- **String value:** `param=value`
- **List value:** `param=value1&param=value2&param=value3`
- **Empty value:** `param=`

This is standard HTTP query parameter behavior for array/multiple values.

### Type Conversion Table:

| User Input | API Type |
|------------|----------|
| PLANTS     | plant    |
| POTS       | pot      |
| SEEDS      | seed     |
| TOOLS      | tool     |
| plants     | plant    |
| pots       | pot      |

---

## 📝 Code Snippets

### Provider - Type Conversion:
```dart
String apiType = type.toLowerCase();
if (apiType == 'pots') apiType = 'pot';
if (apiType == 'plants') apiType = 'plant';
if (apiType == 'seeds') apiType = 'seed';
if (apiType == 'tools') apiType = 'tool';
```

### Provider - Keep IDs as List:
```dart
switch (category) {
  case 'subcategories':
    params['subcategory_id'] = ids; // List<int>
    break;
  case 'color':
    params['color_id'] = ids; // List<int>
    break;
  // ...
}
```

### Repository - Dynamic Parameter Building:
```dart
Map<String, dynamic> queryParams = {};

filters.forEach((key, value) {
  if (value is List && value.isNotEmpty) {
    queryParams[key] = value; // Dio handles List
  } else if (value != null && value != '') {
    queryParams[key] = value;
  } else {
    queryParams[key] = '';
  }
});
```

---

## ✅ Verification

### Before Fix:
```
[log] Generated filter params: {subcategory_id: 28,29,30,35,39, type: pots, ...}
[log] Error: 400 Bad Request
```

### After Fix:
```
[log] Generated filter params: {subcategory_id: [28, 29, 30, 35, 39], type: pot, ...}
[log] Filter applied response: {count: 45, results: [...]}
```

---

## 🎉 Status: FIXED ✅

The filter system now correctly:
- ✅ Converts type to singular form
- ✅ Sends multiple values as separate query parameters
- ✅ Works with backend API format
- ✅ Handles single and multiple selections
- ✅ Returns 200 OK instead of 400 error

---

**Date:** December 27, 2025  
**Issue:** Multiple filter values causing 400 error  
**Resolution:** Type conversion + List-based query parameters  
**Status:** ✅ RESOLVED
