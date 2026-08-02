# Attendrix Native Android Home Screen Widget Setup (v2.1 Production Polish)

This document provides technical instructions for building, deploying, and validating the Attendrix Android Home Screen Widget system.

---

## 1. System Architecture

The widget is built on Android **Jetpack Glance** (`androidx.glance`) in native Kotlin and integrated with Flutter via the `home_widget` package.

### Unidirectional Data Flow

```
Supabase / App State ──> Flutter (HomeWidgetService) ──> HomeWidget Storage ──> Glance Widget (Render)
```

1. Flutter manages all application state, network requests to Supabase, and business logic.
2. When class schedules or attendance states change, Flutter calls `HomeWidgetService.update(...)`.
3. `HomeWidgetService` serializes state to `HomeWidgetPreferences` SharedPreferences and triggers `HomeWidget.updateWidget()`.
4. Native `WidgetStateRepository` is strictly **read-only**, fetching JSON snapshot directly from `HomeWidgetPreferences`.
5. `AttendrixClassWidgetReceiver` receives system update broadcast and invalidates `AttendrixClassWidget` Glance UI.

---

## 2. API Design (`HomeWidgetService`)

`HomeWidgetService` (`lib/services/home_widget_service.dart`) serves as the unified Flutter API:

- `initialize()`: Sets up home_widget bindings.
- `update(Map<String, dynamic> data)`: Primary update method serializing JSON to `HomeWidgetPreferences`.
- `updateCurrentClass(...)`: Convenience wrapper around `update()` passing current class payload.
- `updateAttendance(...)`: Convenience wrapper around `update()` passing attendance status.
- `setEmptyState(reason)`: Convenience wrapper for contextual empty states (`WEEKEND`, `HOLIDAY`, `LOGGED_OUT`, `NO_TIMETABLE`, `SEMESTER_NOT_STARTED`).
- `refresh()`: Triggers widget UI invalidation.
- `clear()`: Sets widget state to `Empty` (`LOGGED_OUT`).

---

## 3. Form Factor Information Hierarchy

`AttendrixClassWidget.kt` uses `SizeMode.Responsive` mapping 3 dedicated layouts:

- **Small (2x2)**: "What do I need right now?" — Current class, status chip, start/end time.
- **Medium (4x2)**: Current class + venue + progress bar (elapsed & remaining time) + attendance chip.
- **Large (4x4)**: Contextual time greeting ("Good Morning") + current class card + attendance summary + today's schedule list.

---

## 4. Required Permissions & Manifest Setup

### Android Manifest (`android/app/src/main/AndroidManifest.xml`)

Permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

Receiver:
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

---

## 5. Real-Device & OEM Launcher Validation Matrix

To validate runtime performance and OEM launcher compatibility:

| OEM Launcher | Material You Dynamic Color | Resizing (2x2 / 4x2 / 4x4) | Dark Mode | Device Reboot Persistence |
| :--- | :---: | :---: | :---: | :---: |
| **Google Pixel (Stock Android)** | ✅ Verified | ✅ Verified | ✅ Verified | ✅ Verified |
| **Samsung One UI** | ✅ Verified | ✅ Verified | ✅ Verified | ✅ Verified |
| **Nothing OS** | ✅ Verified | ✅ Verified | ✅ Verified | ✅ Verified |
| **Xiaomi / HyperOS** | ✅ Verified | ✅ Verified | ✅ Verified | ✅ Verified |

### Runtime Lifecycle Testing Procedure

1. **Fresh Install**: Install app APK on test device/emulator.
2. **Pin Widget**: Add "Attendrix Class Widget" to home screen. Initial state displays static M3 placeholder.
3. **State Push**: Log in to Attendrix -> `HomeWidgetService.updateCurrentClass(...)` immediately renders live class card.
4. **App Termination**: Force-close app from Recent Apps -> Widget retains cached snapshot from `HomeWidgetPreferences`.
5. **Reboot**: Restart device -> System launcher re-loads Glance widget from `HomeWidgetPreferences` without opening app.
