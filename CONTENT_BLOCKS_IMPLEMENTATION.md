# Content Blocks Dynamic Implementation

## Summary
Implemented dynamic content blocks feature that fetches data from the backend API and displays it across multiple home screen widgets. This replaces static content with dynamic, backend-controlled content.

## API Endpoint
```
GET https://backend.biotechmaali.com/utils/content-blocks/
```

## Response Structure
```json
[
  {
    "id": 3,
    "section": "offers_rewards | combo_offers | banner | home_screen_video",
    "title": "Content Title",
    "subtitle": "Content Subtitle",
    "button_text": "Button Label",
    "image": "https://backend.biotechmaali.com/media/...",
    "video_link": "https://www.youtube.com/watch?v=...",
    "order": 0,
    "is_active": true
  }
]
```

## Files Created/Modified

### 1. **ContentBlock Model** (`content_block_model.dart`)
**Purpose**: Parse and structure content blocks data from API

**Fields**:
- `id`: Unique identifier
- `section`: Content section type (combo_offers, banner, home_screen_video, offers_rewards)
- `title`: Main heading text
- `subtitle`: Supporting text
- `buttonText`: Button label text
- `image`: Image URL (nullable)
- `videoLink`: YouTube video URL (nullable)
- `order`: Display order
- `isActive`: Visibility flag

**Methods**:
- `fromJson()`: Parse from API response
- `toJson()`: Convert to JSON

### 2. **HomeRepository** (`home_repository.dart`)
**Added Method**: `getContentBlocks()`

**Functionality**:
- Fetches content blocks from API
- Returns `List<ContentBlock>`
- Handles errors and logging
- No authentication required (public endpoint)

### 3. **HomeProvider** (`home_provider.dart`)

**Added State Variables**:
```dart
List<ContentBlock> _contentBlocks = [];
bool _isContentBlocksLoading = false;
String? _contentBlocksError;
```

**Added Getters**:
- `contentBlocks`: All content blocks
- `isContentBlocksLoading`: Loading state
- `contentBlocksError`: Error message
- `comboOfferContent`: First active combo_offers block
- `bannerContent`: First active banner block
- `homeScreenVideoContent`: First active home_screen_video block
- `offersRewardsContent`: All active offers_rewards blocks

**Added Method**: `fetchContentBlocks()`
- Called on home screen initialization
- Fetches and stores content blocks
- Updates loading and error states

### 4. **HomeScreen** (`home_screen.dart`)
**Updated**: `initState()`

Added content blocks fetch:
```dart
context.read<HomeProvider>().fetchContentBlocks();
```

### 5. **CompoOfferWidget** (`compo_offer_widget.dart`)

**Changes**:
- Wrapped in `Consumer<HomeProvider>`
- Uses `homeProvider.comboOfferContent`
- **Dynamic Image**: Uses `comboOffer.image` or fallback to static asset
- **Dynamic Title**: Uses `comboOffer.title` or default text
- **Dynamic Button**: Uses `comboOffer.buttonText` or "Explore Combo"
- **Null Handling**: Returns `SizedBox.shrink()` if no content available
- **Error Handling**: Shows fallback image on network error

**Replaced**:
- Static image: `'assets/png/images/home_screen_img_2.jpg'` → `comboOffer.image`
- Static title: `'Two for One, Twice the Greenery...'` → `comboOffer.title`
- Static button: `'Explore Combo'` → `comboOffer.buttonText`

### 6. **ReferFriendWidget** (`refer_friend_widget.dart`)

**Changes**:
- Wrapped in `Consumer<HomeProvider>`
- Uses `homeProvider.bannerContent`
- **Dynamic Image**: Uses `bannerContent.image` or fallback to static asset
- **Dynamic Title**: Uses `bannerContent.title` or default "Refer & Earn..."
- **Dynamic Subtitle**: Uses `bannerContent.subtitle` or default text
- **Error Handling**: Shows fallback image on network error

**Replaced**:
- Static image: `'assets/png/images/home_screen_img_1.jpg'` → `bannerContent.image`
- Static title: `'Refer & Earn with BiotechMaali Rewards'` → `bannerContent.title`
- Static subtitle: `'Share the green...'` → `bannerContent.subtitle`

### 7. **YoutubeVideoplayerWidget** (`youtube_videoplayer_widget.dart`)

**Changes**:
- Added `_isInitialized` flag
- Moved controller initialization to `didChangeDependencies()`
- Uses `homeProvider.homeScreenVideoContent`
- **Dynamic Video URL**: Uses `videoContent.videoLink` or default URL
- **Safe Initialization**: Only initializes once using flag

**Replaced**:
- Static URL: `'https://www.youtube.com/watch?v=md63AQAmqVU'` → `videoContent.videoLink`

## Content Section Mapping

| Section | Widget | Dynamic Fields |
|---------|--------|----------------|
| `combo_offers` | CompoOfferWidget | image, title, button_text |
| `banner` | ReferFriendWidget | image, title, subtitle |
| `home_screen_video` | YoutubeVideoplayerWidget | video_link |
| `offers_rewards` | (Future use) | All fields |

## Features Implemented

✅ **Dynamic Content Loading**
- Fetches content on home screen load
- Stores in provider for app-wide access
- Separated by content section

✅ **Fallback Support**
- Shows default content if API fails
- Shows static images if network images fail
- Graceful degradation

✅ **Section Filtering**
- Only active content (`is_active: true`) is displayed
- Filtered by section type
- Order-based sorting ready (via `order` field)

✅ **Error Handling**
- API errors logged and stored
- Network image errors show fallback
- Null safety throughout

✅ **Performance**
- Content blocks fetched once on home screen load
- Cached in provider for instant access
- No repeated API calls

## Benefits

1. **CMS-like Control**: Backend can update content without app updates
2. **A/B Testing Ready**: Easy to test different content variations
3. **Seasonal Updates**: Change images and text for holidays/seasons
4. **Multilingual Support**: Backend can serve different content by locale
5. **Marketing Flexibility**: Quick promotional content changes
6. **Consistent Data Structure**: Single model for all content types

## Testing Checklist

- [ ] Home screen loads content blocks on launch
- [ ] Combo offer shows dynamic image from API
- [ ] Combo offer shows dynamic title from API
- [ ] Combo offer shows dynamic button text from API
- [ ] Refer friend shows dynamic image from API
- [ ] Refer friend shows dynamic title from API
- [ ] Refer friend shows dynamic subtitle from API
- [ ] YouTube player shows dynamic video URL from API
- [ ] Fallback images work when API images fail
- [ ] Default content shows when content blocks not available
- [ ] Combo offer hides when no active content
- [ ] Content updates on app restart
- [ ] No errors in console

## Future Enhancements

1. **Offers/Rewards Section**: Implement UI for `offers_rewards` content blocks
2. **Click Tracking**: Track user interactions with dynamic content
3. **Deep Linking**: Link content blocks to specific app screens/products
4. **Image Caching**: Implement proper image caching for better performance
5. **Refresh on Resume**: Fetch new content when app comes to foreground
6. **Order-based Display**: Use `order` field to sort content blocks
7. **Analytics**: Track which content performs best

## Notes

- Content blocks API is public (no authentication required)
- Only active content (`is_active: true`) is displayed
- Section names are case-sensitive
- YouTube video links are automatically converted to video IDs
- Network images have error fallbacks to local assets
- Provider caches content for entire session
