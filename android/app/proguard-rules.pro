# ============================================================
# QR Toolkit - R8 / ProGuard rules (Android release builds)
# ============================================================

# Flutter wrapper & engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class androidx.annotation.** { *; }
-dontwarn io.flutter.**

# Keep the app's own classes (models, services, etc.)
-keep class com.qrtoolkit.app.** { *; }
-keep class qr_toolkit.** { *; }

# Keep model / serialization classes (avoid obfuscating field names used by
# JSON serialization or platform channels).
-keep class **.models.** { *; }
-keep class **.model.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Parcelable / Serializable implementations used across platform channels.
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Suppress warnings from third-party native SDKs that are not fully
# annotated for obfuscation (common with ad SDKs, scanners, etc.).
-dontwarn android.**
-dontwarn okio.**
-dontwarn okhttp3.**
-dontwarn com.google.**
-dontwarn com.google.android.gms.**

# Enable obfuscation & output a mapping file for deobfuscation later.
-overloadaggressively
-repackageclasses ''
-allowaccessmodification
-printmapping mapping.txt
