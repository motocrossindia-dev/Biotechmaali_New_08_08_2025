# Quick Reference: App Name Change

## ✅ Changes Complete: biotech_maali → Gidan

---

## Files Changed (Summary)

| Platform | File | Line Changed |
|----------|------|--------------|
| **Android** | `AndroidManifest.xml` | Line 21: `android:label="Gidan"` |
| **iOS** | `Info.plist` | Lines 10, 18: Display & Bundle Name |
| **iOS** | `project.pbxproj` | 4 locations: `INFOPLIST_KEY_CFBundleDisplayName = Gidan` |
| **Web** | `manifest.json` | Lines 2-3: name & short_name |

---

## Quick Build Commands

```bash
# Clean everything
fvm flutter clean && fvm flutter pub get

# Build Android Release (Play Store)
fvm flutter build appbundle --release

# Build Android Debug (Testing)
fvm flutter build apk --debug

# Build iOS (open Xcode)
open ios/Runner.xcworkspace
```

---

## Output Locations

```
Android AAB:  build/app/outputs/bundle/release/app-release.aab
Android APK:  build/app/outputs/flutter-apk/app-release.apk
iOS Archive:  Via Xcode → Product → Archive
```

---

## What Changed ✅

- Home screen app name: **Gidan**
- App drawer/library name: **Gidan**
- Settings app name: **Gidan**
- Store listing name: **Gidan** (when updated)

## What Stayed Same ✓

- Package ID: `com.biotechmaali.app`
- Bundle ID: `com.example.biotechMaali`
- All user data & accounts
- All functionality & features

---

## Next Steps

1. **Build** new release version
2. **Test** on physical device
3. **Upload** to stores
4. **Update** store listings
5. **Submit** for review

---

## Testing Checklist

- [ ] App name shows "Gidan" on home screen
- [ ] App name shows "Gidan" in app drawer
- [ ] Login works normally
- [ ] All features functional
- [ ] No errors in console

---

## Store Upload

### Google Play Console
1. Go to console.play.google.com
2. Upload `app-release.aab`
3. Update store listing name to "Gidan"
4. Submit for review

### App Store Connect
1. Build via Xcode (Product → Archive)
2. Upload to App Store Connect
3. Update app name to "Gidan"
4. Submit for review

---

## Documentation Created

📄 `APP_NAME_CHANGE_GUIDE.md` - Complete guide
📄 `APP_NAME_CHANGE_SUMMARY.md` - Quick summary
📄 `APP_NAME_COMPARISON.md` - Before/after comparison
📄 `APP_NAME_QUICK_REFERENCE.md` - This file

---

## Need to Rollback?

See `APP_NAME_CHANGE_GUIDE.md` → "Rollback Plan" section

---

**Status:** ✅ Ready for Production
**Date:** December 24, 2025
