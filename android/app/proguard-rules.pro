# Keep ErrorProne annotations
-dontwarn com.google.errorprone.annotations.**
-keep class com.google.errorprone.annotations.** { *; }

# Keep javax annotations
-dontwarn javax.annotation.**
-keep class javax.annotation.** { *; }

# Keep GuardedBy annotation
-dontwarn javax.annotation.concurrent.GuardedBy
-keep class javax.annotation.concurrent.GuardedBy { *; }
