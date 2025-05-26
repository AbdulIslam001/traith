# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Needed for Firestore serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firestore.v1.** { *; }

# Needed for Kotlin (if you use Kotlin)
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**
