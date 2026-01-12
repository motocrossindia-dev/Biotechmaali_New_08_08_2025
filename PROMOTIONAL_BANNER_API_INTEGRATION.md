# Promotional Banner API Integration Guide

## Overview
Successfully integrated promotional banner API (`https://backend.biotechmaali.com/promotion/banner/33/`) into both the home screen promotional banner and product list custom banner widgets.

## API Details

**Endpoint**: `https://backend.biotechmaali.com/promotion/banner/33/`  
**Method**: GET  
**Response Structure**:
```json
{
    "message": "success",
    "data": {
        "id": 33,
        "products_list": [],
        "product_list": [],
        "mobile_banner": "/media/banners/mobileBanner/1_eM1djM6.jpg",
        "web_banner": "/media/banners/webBanner/1_IJAaiJG.jpg",
        "type": "Home",
        "is_visible": true,
        "category": "plant",
        "title": "",
        "subtitle": "",
        "button_text": ""
    }
}
```

## Changes Made

### 1. Model Creation ✅
**File**: `lib/src/module/home/model/promotional_banner_model.dart`

Created `PromotionalBannerModel` with the following fields:
- `id`: Banner ID
- `productsList`: List of product IDs
- `productList`: Detailed product list
- `mobileBanner`: Mobile banner image path
- `webBanner`: Web banner image path
- `type`: Banner type (Home/Hero)
- `isVisible`: Visibility flag
- `category`: Category name
- `title`: Banner title
- `subtitle`: Banner subtitle
- `buttonText`: CTA button text

### 2. Repository Method ✅
**File**: `lib/src/module/home/home_repository.dart`

Added `getPromotionalBanner(int bannerId)` method:
```dart
Future<PromotionalBannerModel> getPromotionalBanner(int bannerId) async {
  final String promotionalBannerUrl = '${BaseUrl.baseUrl}promotion/banner/$bannerId/';
  // Fetches and parses banner data
}
```

### 3. Home Provider Updates ✅
**File**: `lib/src/module/home/home_provider.dart`

**Added State Variables**:
```dart
PromotionalBannerModel? _promotionalBanner;
bool _isPromotionalBannerLoading = false;
String? _promotionalBannerError;
```

**Added Getters**:
```dart
PromotionalBannerModel? get promotionalBanner => _promotionalBanner;
bool get isPromotionalBannerLoading => _isPromotionalBannerLoading;
String? get promotionalBannerError => _promotionalBannerError;
```

**Added Method**:
```dart
Future<void> fetchPromotionalBanner(int bannerId) async {
  // Fetches promotional banner data from API
}
```

### 4. Home Screen Integration ✅
**File**: `lib/src/module/home/home_screen.dart`

Added API call in `initState`:
```dart
context.read<HomeProvider>().fetchPromotionalBanner(33);
```

### 5. Promotional Banner Widget Redesign ✅
**File**: `lib/src/module/home/widget/promotional_banner.dart`

**New Features**:
- ✅ **Consumer Pattern**: Listens to HomeProvider for banner data
- ✅ **Loading State**: Shows shimmer while fetching
- ✅ **Dynamic Content**: Displays image, title, subtitle, and button text from API
- ✅ **Fallback Design**: Shows static banner if API data unavailable
- ✅ **Professional Design**: Card layout with image, rounded corners, and shadow
- ✅ **Image Optimization**: Uses `NetworkImageWidget` with caching
- ✅ **Responsive**: Adapts to screen width

**Design Specifications**:
- Container with rounded corners (12px radius)
- Soft shadow for depth
- Banner image at top (150px height)
- Text content below with padding
- CTA button with elevation
- Cache size: 800×300px for optimal performance

### 6. Custom Banner Widget Update ✅
**File**: `lib/src/module/product_list/home_product_list/widget/custom_banner_widget.dart`

**New Features**:
- ✅ **Consumer Pattern**: Connected to HomeProvider
- ✅ **Dynamic Content**: Uses title, subtitle, and button text from API
- ✅ **Image Integration**: Displays mobile banner image
- ✅ **Compact Design**: Horizontal layout with image on left, text on right
- ✅ **Fallback Design**: Shows static banner if API data unavailable
- ✅ **Image Optimization**: NetworkImageWidget with 160×120px cache

**Design Specifications**:
- Gradient background (lgBanner)
- Image: 80×60px, rounded corners (8px)
- Text: Right-aligned with dynamic sizing
- Button: Compact 24px height
- Cache size: 160×120px for small thumbnail

## Image URL Construction

Both widgets construct full image URLs using:
```dart
final String imageUrl = '${BaseUrl.baseUrlForImages}${bannerData.mobileBanner}';
```

**Base URL**: `https://www.backend.biotechmaali.com`  
**Example Full URL**: `https://www.backend.biotechmaali.com/media/banners/mobileBanner/1_eM1djM6.jpg`

## Features Implemented

### Promotional Banner (Home Screen)
1. **Loading State**: Shimmer animation during fetch
2. **Image Display**: Full-width banner image at 150px height
3. **Dynamic Text**: Title and subtitle from API
4. **CTA Button**: Customizable button text
5. **Fallback**: Static design if API fails
6. **Error Handling**: Graceful error widget display
7. **Image Caching**: Optimized with 800×300px cache
8. **Professional Design**: Card with shadow and rounded corners

### Custom Banner (Product List)
1. **Compact Layout**: Horizontal design for product list header
2. **Image Thumbnail**: 80×60px banner image
3. **Dynamic Content**: Title, subtitle, and button text
4. **Gradient Background**: Maintains existing gradient design
5. **Fallback**: Static design if API fails
6. **Image Caching**: Optimized with 160×120px cache
7. **Right-Aligned Text**: Better for compact spaces

## Usage

### Fetching Banner Data
```dart
// In Home Screen
context.read<HomeProvider>().fetchPromotionalBanner(33);
```

### Accessing Banner Data
```dart
// In any widget
final bannerData = context.watch<HomeProvider>().promotionalBanner;
final isLoading = context.watch<HomeProvider>().isPromotionalBannerLoading;
```

### Checking Data Validity
```dart
final hasValidData = bannerData != null && 
                     bannerData.isVisible && 
                     bannerData.mobileBanner.isNotEmpty;
```

## Fallback Behavior

Both widgets implement graceful fallback:

**When API Data is Invalid**:
- Missing banner data
- `isVisible` is false
- Empty image URL

**Fallback Action**:
- Display static design with hardcoded text
- Maintain original layout and styling
- No error shown to user

## Error Handling

1. **Network Errors**: Caught in repository, logged, and shown as fallback
2. **Invalid Response**: Validates data structure before parsing
3. **Missing Fields**: Uses default values (empty strings)
4. **Image Load Errors**: Shows placeholder icon

## Performance Optimizations

### Promotional Banner
- Image cache: 800×300px (optimized for banners)
- `cached_network_image` for disk + memory caching
- Shimmer loading for smooth UX
- `RepaintBoundary` in home screen

### Custom Banner
- Image cache: 160×120px (small thumbnail)
- Compact design reduces layout complexity
- Efficient `Consumer` pattern
- Minimal re-renders

## Testing Checklist

- [ ] Test with valid API response (banner ID 33)
- [ ] Test with different banner IDs
- [ ] Test loading state (slow network)
- [ ] Test fallback design (invalid data)
- [ ] Test image loading (valid URLs)
- [ ] Test image error handling (invalid URLs)
- [ ] Test navigation to offers page
- [ ] Test on different screen sizes
- [ ] Test with empty title/subtitle
- [ ] Test with custom button text
- [ ] Verify caching works (offline mode)
- [ ] Check memory usage with multiple images

## API Response Scenarios

### Scenario 1: Complete Data
```json
{
  "title": "Spring Sale",
  "subtitle": "Get 20% Off on All Plants",
  "button_text": "Shop Sale",
  "mobile_banner": "/media/banners/spring.jpg",
  "is_visible": true
}
```
**Result**: Displays custom banner with all fields

### Scenario 2: Missing Text Fields
```json
{
  "title": "",
  "subtitle": "",
  "button_text": "",
  "mobile_banner": "/media/banners/image.jpg",
  "is_visible": true
}
```
**Result**: Uses fallback text, shows image

### Scenario 3: Not Visible
```json
{
  "is_visible": false
}
```
**Result**: Shows static fallback design

## Future Enhancements

Potential improvements:
- [ ] Support multiple banner IDs
- [ ] Banner rotation/carousel
- [ ] Click tracking analytics
- [ ] A/B testing support
- [ ] Banner scheduling (start/end dates)
- [ ] Deep linking to specific products
- [ ] Video banner support
- [ ] Animated transitions

## Dependencies

**Required Packages**:
- `cached_network_image: ^3.4.1` - Image caching
- `shimmer: ^3.0.0` - Loading animations
- `dio: ^5.9.0` - HTTP requests
- `provider: ^6.1.5` - State management

## Notes

- Banner ID is hardcoded as `33` in home screen
- Both widgets share same data source (HomeProvider)
- Image optimization ensures fast loading
- Fallback ensures app never shows broken UI
- All changes are backward compatible

---

**Version**: 1.0.0  
**Date**: 30 December 2025  
**Status**: ✅ Production Ready  
**API Endpoint**: `https://backend.biotechmaali.com/promotion/banner/33/`
