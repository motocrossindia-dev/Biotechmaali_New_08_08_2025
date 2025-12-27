# App Name Change: BiotechMaali → Gidan

## Overview
This document details the changes made to rename the app from "BiotechMaali" to "Gidan" across all platforms (Android, iOS, Web).

## Date: December 24, 2025
**Status**: ✅ Complete

---

## Changes Made

### 1. Android Configuration ✅

#### File: `android/app/src/main/AndroidManifest.xml`
**Changed:**
```xml
<!-- BEFORE -->
android:label="biotech_maali"

<!-- AFTER -->
android:label="Gidan"
```

**Impact:**
- App name displayed on Android home screen: **Gidan**
- App name in Android app drawer: **Gidan**
- App name in recent apps: **Gidan**

---

### 2. iOS Configuration ✅

#### File: `ios/Runner/Info.plist`
**Changed:**
```xml
<!-- BEFORE -->
<key>CFBundleDisplayName</key>
<string>Biotech Maali</string>

<key>CFBundleName</key>
<string>biotech_maali</string>

<!-- AFTER -->
<key>CFBundleDisplayName</key>
<string>Gidan</string>

<key>CFBundleName</key>
<string>Gidan</string>
```

#### File: `ios/Runner.xcodeproj/project.pbxproj`
**Changed (4 occurrences):**
```plaintext
// BEFORE
INFOPLIST_KEY_CFBundleDisplayName = Biotechmaali;

// AFTER
INFOPLIST_KEY_CFBundleDisplayName = Gidan;
```

**Locations Updated:**
- Line ~496 (Profile configuration)
- Line ~505 (Another Profile configuration)
- Line ~691 (Debug configuration)
- Line ~716 (Release configuration)

**Impact:**
- App name displayed on iOS home screen: **Gidan**
- App name in iOS Settings: **Gidan**
- App name in App Store (when built): **Gidan**

---

### 3. Web Configuration ✅

#### File: `web/manifest.json`
**Changed:**
```json
// BEFORE
{
    "name": "biotech_maali",
    "short_name": "biotech_maali",
}

// AFTER
{
    "name": "Gidan",
    "short_name": "Gidan",
}
```

**Impact:**
- Progressive Web App (PWA) name: **Gidan**
- Web app shortcut name: **Gidan**
- Browser bookmark name: **Gidan**

---

## What Was NOT Changed (Intentionally)

### Package Name/Bundle Identifier
These remain unchanged to maintain app identity in stores:

**Android:**
- `applicationId = "com.biotechmaali.app"` (in `build.gradle`)
- `namespace = "com.biotechmaali.app"` (in `build.gradle`)

**iOS:**
- `PRODUCT_BUNDLE_IDENTIFIER = com.example.biotechMaali` (in `project.pbxproj`)

**Flutter:**
- `name: biotech_maali` (in `pubspec.yaml`)

⚠️ **IMPORTANT:** These identifiers should NOT be changed as they uniquely identify your app in:
- Google Play Store
- Apple App Store
- Firebase/Backend systems
- Deep linking configurations

---

## Google Play Store Update Process

### Current Status
- **Current App Name in Play Store:** BiotechMaali
- **New App Name (after update):** Gidan

### Steps to Update in Google Play Console

#### 1. Build New Version
```bash
# Clean previous builds
fvm flutter clean
fvm flutter pub get

# Build new release AAB with updated name
fvm flutter build appbundle --release
```

The AAB will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

#### 2. Update Google Play Console

**A. Upload New Build**
1. Log in to [Google Play Console](https://play.google.com/console)
2. Select your app (com.biotechmaali.app)
3. Go to **Production** → **Create new release**
4. Upload the new `app-release.aab` file
5. Increment version code (e.g., from 71 to 72)

**B. Update Store Listing (Optional but Recommended)**
1. Go to **Store presence** → **Main store listing**
2. Update **App name** field to "Gidan"
3. Save changes

**C. Update Graphics (Optional)**
- If you have new branding/logo for "Gidan", update:
  - App icon
  - Feature graphic
  - Screenshots
  - Promotional graphics

**D. Release Notes**
Add release notes explaining the name change:
```
Version 1.0.72
- Rebranded app name from "BiotechMaali" to "Gidan"
- Updated app icon and branding
- Performance improvements
- Bug fixes
```

#### 3. Submit for Review
1. Review all changes
2. Click **Save** → **Review release**
3. Click **Start rollout to Production**

#### 4. Timeline
- **Review Time:** 1-3 days typically
- **Rollout:** Gradual (can be set to 100% immediately)
- **User Updates:** Users will see "Gidan" after updating the app

---

## Apple App Store Update Process

### Steps to Update in App Store Connect

#### 1. Build New Version
```bash
# Clean and build for iOS
fvm flutter clean
fvm flutter pub get

# Open Xcode project
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select "Product" → "Archive"
# 2. Upload to App Store Connect
```

#### 2. Update App Store Connect

**A. App Information**
1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **App Information**
4. Update **Name** field to "Gidan" (if not already)
5. Save changes

**B. Version Information**
1. Go to **App Store** tab
2. Create new version (e.g., 1.0.72)
3. Upload new build from Xcode
4. Update **What's New** with release notes

**C. Submit for Review**
1. Complete all required fields
2. Submit for review

#### 3. Timeline
- **Review Time:** 1-2 days typically
- **Release:** Automatic or manual (your choice)

---

## Verification Checklist

### Before Building
- [x] AndroidManifest.xml updated to "Gidan"
- [x] iOS Info.plist updated to "Gidan"
- [x] iOS project.pbxproj updated (all 4 occurrences)
- [x] Web manifest.json updated to "Gidan"

### After Building - Android
- [ ] Install APK/AAB on device
- [ ] Verify app name on home screen shows "Gidan"
- [ ] Verify app name in app drawer shows "Gidan"
- [ ] Verify app name in settings shows "Gidan"

### After Building - iOS
- [ ] Install on iOS device/simulator
- [ ] Verify app name on home screen shows "Gidan"
- [ ] Verify app name in Settings shows "Gidan"
- [ ] Verify app name in multitasking view shows "Gidan"

### Store Updates
- [ ] Google Play Console store listing updated
- [ ] App Store Connect app name updated
- [ ] New build uploaded to both stores
- [ ] Release notes mention name change

---

## Important Notes

### 1. Bundle Identifiers
**DO NOT CHANGE:**
- Android: `com.biotechmaali.app`
- iOS: `com.example.biotechMaali`

These identify your app in the stores. Changing them would create a completely new app listing.

### 2. Existing Users
- Users who already have the app installed will see the new name "Gidan" after updating
- They don't need to reinstall
- All user data, settings, and accounts remain intact

### 3. Backend/API
- No backend changes required
- All API endpoints remain the same
- User authentication continues to work

### 4. Deep Links
- Deep linking will continue to work
- URLs remain the same (`com.biotechmaali.app://...`)

### 5. Analytics/Firebase
- No changes needed in Firebase Console
- Analytics will continue tracking under the same project
- All existing data preserved

---

## Testing Recommendations

### 1. Build Test APK/IPA
```bash
# Android Debug
fvm flutter build apk --debug

# iOS Debug (requires Mac)
fvm flutter build ios --debug
```

### 2. Install and Verify
- Install on physical device
- Check app name in all views:
  - Home screen
  - App drawer/library
  - Settings/About
  - Recent apps
  - Notifications

### 3. Functionality Testing
- Ensure all features work normally
- Test login/authentication
- Test payment flows
- Test notifications
- Test deep linking

---

## Rollback Plan

If you need to revert to "BiotechMaali":

### Android
```xml
<!-- In AndroidManifest.xml -->
android:label="biotech_maali"
```

### iOS
```xml
<!-- In Info.plist -->
<key>CFBundleDisplayName</key>
<string>Biotech Maali</string>

<key>CFBundleName</key>
<string>biotech_maali</string>
```

### iOS Xcode
```plaintext
// In project.pbxproj (4 locations)
INFOPLIST_KEY_CFBundleDisplayName = Biotechmaali;
```

### Web
```json
{
    "name": "biotech_maali",
    "short_name": "biotech_maali"
}
```

Then rebuild and redeploy.

---

## Build Commands Reference

### Android Release Build
```bash
# Clean
fvm flutter clean
fvm flutter pub get

# Build AAB (for Play Store)
fvm flutter build appbundle --release

# Build APK (for testing)
fvm flutter build apk --release

# Output locations:
# AAB: build/app/outputs/bundle/release/app-release.aab
# APK: build/app/outputs/flutter-apk/app-release.apk
```

### iOS Release Build
```bash
# Clean
fvm flutter clean
fvm flutter pub get

# Build IPA (via Xcode)
open ios/Runner.xcworkspace
# Then: Product → Archive → Distribute App
```

---

## Support & Troubleshooting

### Issue: App name not updating on device
**Solution:**
1. Uninstall existing app completely
2. Restart device
3. Install new build
4. Verify app name

### Issue: Build fails after changes
**Solution:**
```bash
# Clean everything
fvm flutter clean
rm -rf build/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
rm -rf ios/Podfile.lock

# Reinstall
fvm flutter pub get
cd ios && pod install && cd ..

# Rebuild
fvm flutter build appbundle --release
```

### Issue: Xcode build fails
**Solution:**
1. Open Xcode: `open ios/Runner.xcworkspace`
2. Product → Clean Build Folder (⌘⇧K)
3. Product → Build (⌘B)
4. Check for any errors in Xcode console

---

## Summary

✅ **Completed Changes:**
- Android app name: **Gidan**
- iOS app name: **Gidan**
- Web app name: **Gidan**

📱 **Platform Compatibility:**
- Android: All versions supported
- iOS: All versions supported
- Web: PWA compatible

🏪 **Store Status:**
- Google Play Store: Ready for upload (build new version)
- Apple App Store: Ready for upload (build new version)

⚡ **Next Steps:**
1. Build release version
2. Test on physical devices
3. Upload to Google Play Console
4. Upload to App Store Connect
5. Submit for review
6. Monitor rollout

---

## Version History

| Date | Version | Change |
|------|---------|--------|
| Dec 24, 2025 | 1.0.72 | Rebranded from BiotechMaali to Gidan |

---

## Contact & Support

For any issues or questions regarding the app name change:
- Check this documentation first
- Review build logs for errors
- Test on physical devices before store submission
- Contact development team if issues persist

---

**Document Status:** ✅ Complete
**Last Updated:** December 24, 2025
**Next Review:** After store approval
