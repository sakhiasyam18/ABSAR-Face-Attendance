# Keep Flutter shared_preferences and Kotlin coroutines from being stripped by R8
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }

# Keep Firebase Component Registrars used by ML Kit
-keep class * implements com.google.firebase.components.ComponentRegistrar {
    <init>();
}
-keep,allowshrinking interface com.google.firebase.components.ComponentRegistrar

# Keep ML Kit internal classes, registrars, and tasks
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google_mlkit_commons.** { *; }
-keep class com.google_mlkit_face_detection.** { *; }
