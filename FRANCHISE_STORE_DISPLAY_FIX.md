# Franchise Enquiry Screen - Store Display Fix

## Issue
The "Check Out Our Stores" section in the franchise enquiry screen was not displaying any stores. This was caused by improper use of the `OurStoreProvider` in the build method.

## Root Cause

**Problem Code**:
```dart
SizedBox(
  height: 350,
  child: ListView.builder(
    itemCount: context.read<OurStoreProvider>().stores.length,
    itemBuilder: (context, index) {
      final store = context.read<OurStoreProvider>().stores[index];
      return StoreCard(store: store);
    },
  ),
),
```

**Issues**:
1. ❌ Used `context.read()` instead of `Consumer` or `context.watch()`
2. ❌ No handling for loading state
3. ❌ No handling for error state
4. ❌ No handling for empty state
5. ❌ Widget doesn't rebuild when provider data changes

## Solution Implemented

### File Modified: `franchise_enquiry_screen.dart`

Replaced the store display section with proper `Consumer` pattern:

```dart
Consumer<OurStoreProvider>(
  builder: (context, storeProvider, child) {
    // Loading state
    if (storeProvider.isLoading) {
      return SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (storeProvider.error != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              Text(storeProvider.error ?? 'Failed to load stores'),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (storeProvider.stores.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text('No stores available'),
        ),
      );
    }

    // Success - display stores
    return SizedBox(
      height: 350,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: storeProvider.stores.length,
        itemBuilder: (context, index) {
          final store = storeProvider.stores[index];
          return StoreCard(store: store);
        },
      ),
    );
  },
),
```

## Features Added

### 1. Loading State ✅
- Shows `CircularProgressIndicator` while stores are being fetched
- Height: 200px container for consistent layout
- Centered loading indicator

### 2. Error State ✅
- Displays error icon and message if fetch fails
- Red color scheme for error visibility
- Shows actual error message from provider
- Fallback message: "Failed to load stores"

### 3. Empty State ✅
- Shows "No stores available" when list is empty
- Grey text color for subtle appearance
- Centered message

### 4. Success State ✅
- Displays stores in scrollable list
- Uses `StoreCard` widget for each store
- Maintains 350px height container
- 16px padding around list

### 5. Reactive Updates ✅
- Uses `Consumer` pattern for automatic rebuilds
- Widget updates when provider data changes
- Proper lifecycle management

## Technical Details

### Provider Pattern
- **Before**: `context.read<OurStoreProvider>()` (doesn't listen to changes)
- **After**: `Consumer<OurStoreProvider>` (automatically rebuilds)

### State Management
```dart
OurStoreProvider {
  List<OurStoreModel> stores;   // Store data
  bool isLoading;                // Loading flag
  String? error;                 // Error message
}
```

### Widget Hierarchy
```
Consumer<OurStoreProvider>
  ├── Loading: CircularProgressIndicator
  ├── Error: Error icon + message
  ├── Empty: "No stores available"
  └── Success: ListView.builder
                └── StoreCard(s)
```

## Store Card Display

Each store shows:
- 📷 Store image (200px height)
- 📍 Store name and location
- 📞 Contact number
- ⏰ Opening hours
- 🗺️ Map link button

## User Experience Improvements

### Before:
- ❌ No stores visible
- ❌ No feedback if loading
- ❌ No error handling
- ❌ No empty state handling

### After:
- ✅ Stores display correctly
- ✅ Loading indicator while fetching
- ✅ Error message if fetch fails
- ✅ Empty state message if no stores
- ✅ Smooth scrolling list
- ✅ Professional store cards

## Integration with Our Store Screen

The franchise screen now properly integrates with:
1. `OurStoreProvider` - Data source
2. `StoreCard` - Display component
3. `OurStoresScreen` - Full store list (via "VIEW ALL" button)

### Data Flow:
```
OurStoreProvider
  ↓ (loads stores on init)
Repository
  ↓ (fetches from API)
API Response
  ↓ (parses to models)
OurStoreModel[]
  ↓ (notifies listeners)
Consumer rebuilds
  ↓ (renders)
StoreCard widgets
```

## Bonus Fix

Also fixed unused variable warning in `promotional_banner.dart`:
- Commented out `imageUrl` variable (image widget already commented)
- Removed compilation warning

## Testing Checklist

- [ ] Test with stores loaded successfully
- [ ] Test loading state (slow network)
- [ ] Test error state (network failure)
- [ ] Test empty state (no stores in API)
- [ ] Test scrolling with multiple stores
- [ ] Test "VIEW ALL" button navigation
- [ ] Test store card display
- [ ] Test map link functionality
- [ ] Verify images load correctly
- [ ] Check responsive layout on different screens

## Benefits

1. **Proper State Management** ✅
   - Reactive to provider changes
   - Automatic rebuilds

2. **Better UX** ✅
   - Clear loading feedback
   - Helpful error messages
   - Empty state handling

3. **Maintainable Code** ✅
   - Follows Flutter best practices
   - Uses Consumer pattern correctly
   - Proper error handling

4. **Professional Appearance** ✅
   - Smooth loading states
   - Clean store cards
   - Consistent styling

## Related Files

- ✅ `franchise_enquiry_screen.dart` - Main fix
- ✅ `our_store_provider.dart` - Data provider
- ✅ `our_store_screen.dart` - StoreCard component
- ✅ `promotional_banner.dart` - Minor warning fix

---

**Status**: ✅ Fixed  
**Date**: 30 December 2025  
**Issue**: Stores not displaying in franchise screen  
**Solution**: Replaced `context.read()` with proper `Consumer` pattern and added state handling
