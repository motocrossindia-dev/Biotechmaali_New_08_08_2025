# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# 16KB page size support
-keep class * extends java.lang.annotation.Annotation { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Firebase classes (if using Firebase)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Gson classes (if using Gson)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.examples.android.model.** { <fields>; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Preserve line number information for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# Preserve all annotations
-keepattributes *Annotation*

# For Google Play Services
-keep public class com.google.vending.licensing.ILicensingService
-keep public class com.android.vending.licensing.ILicensingService

# For native libraries used by plugins
-keep class **.R
-keep class **.R$* {
    <fields>;
}
