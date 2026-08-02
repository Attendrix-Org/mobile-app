# FlutterFlow Native Setup

## Android Manifest

```xml
<receiver
    android:name="com.attendrix.app.widget.AttendrixClassWidgetReceiver"
    android:exported="true"
    android:label="Attendrix Class Widget">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/attendrix_class_widget_info" />
</receiver>
```

## Gradle Dependencies

```groovy
implementation 'androidx.glance:glance-appwidget:1.1.1'
implementation 'androidx.glance:glance-material3:1.1.1'
implementation 'androidx.glance:glance-appwidget-preview:1.1.1'
implementation 'androidx.glance:glance-preview:1.1.1'
```

## Gradle Plugins

```groovy
id "org.jetbrains.kotlin.plugin.compose"
```

In `android/settings.gradle`:
```groovy
id "org.jetbrains.kotlin.plugin.compose" version "2.1.0" apply false
```

## Gradle Manual Modification Note

Note: FlutterFlow UI allows adding dependencies, plugins, and manifest snippets. If your FlutterFlow version cannot inject `buildFeatures` into `android {}`, manually ensure `android/app/build.gradle` contains:

```groovy
android {
    buildFeatures {
        compose true
    }
}
```

## ProGuard

```proguard
-keep class com.attendrix.app.widget.** { *; }
-keep class androidx.glance.** { *; }
```

## MainActivity

```kotlin
package com.attendrix.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.attendrix.app.widget.WidgetBridge

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        WidgetBridge.attach(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }
}
```

## Pubspec

```yaml
  home_widget: ^0.7.0
```
