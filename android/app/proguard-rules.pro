# Keep MyFatoorah SDK classes and methods
-keep class com.myfatoorah.sdk.** { *; }

# Keep Retrofit (used internally by MyFatoorah SDK) models and methods
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions
-keepattributes *Annotation*

# Keep Gson (used for JSON serialization/deserialization)
-keep class com.google.gson.** { *; }
#-keep class sun.misc.Unsafe { *; }
-keepattributes *Annotation*

# Keep OkHttp (used for HTTP requests)
-keep class okhttp3.** { *; }
-keepclassmembers class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Kotlin classes (MyFatoorah SDK may use Kotlin internally)
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }
-dontwarn kotlin.**

# Keep Timber (if logging is enabled in MyFatoorah SDK)
-dontwarn timber.log.**

# Avoid stripping generic type information from models
-keepattributes Signature

# Suppress warnings for missing classes not used in the app
-dontwarn javax.annotation.**

# Keep classes referenced by reflection
-keepnames class com.myfatoorah.sdk.** { *; }
