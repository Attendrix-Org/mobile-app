# Attendrix Native Home Screen Widget Migration Report

## Migration Summary

This report documents the migration of Attendrix Android Home Screen Widgets into the target `native` repository branch.

---

## System Architecture

```
                                  ┌────────────────────────┐
                                  │   Supabase / Backend   │
                                  └───────────┬────────────┘
                                              │
                                              ▼
                                  ┌────────────────────────┐
                                  │  Flutter App (Context) │
                                  └───────────┬────────────┘
                                              │
                                  ┌───────────┴────────────┐
                                  │   HomeWidgetService    │
                                  └─────┬────────────┬─────┘
                                        │            │
             Payload v4 (Class Schedule)│            │Payload v5 (Mess Menu)
                                        ▼            ▼
                   ┌───────────────────────┐  ┌───────────────────────┐
                   │ HomeWidgetPreferences │  │ HomeWidgetPreferences │
                   │ (Class Schedule JSON) │  │   (Mess Menu JSON)    │
                   └───────────┬───────────┘  └───────────┬───────────┘
                               │                          │
                               ▼                          ▼
                   ┌───────────────────────┐  ┌───────────────────────┐
                   │ AttendrixClassWidget  │  │ AttendrixMessMenu    │
                   │    (Glance Widget)    │  │   Widget (Glance)     │
                   └───────────────────────┘  └───────────────────────┘
```

---

## Registered Widgets

### 1. Attendrix Class Schedule Widget (`AttendrixClassWidgetReceiver`)
- **Receiver**: `com.attendrix.app.widget.AttendrixClassWidgetReceiver`
- **Metadata**: `xml/attendrix_class_widget_info.xml`
- **Payload Version**: `version: 4`
- **Supported Layouts**: Small (2x2), Medium (4x2), Large (4x4)
- **Features**: Live class progress bar, time remaining, attendance status chip, tap action to launch app.

### 2. Attendrix Mess Menu Widget (`AttendrixMessMenuWidgetReceiver`)
- **Receiver**: `com.attendrix.app.widget.AttendrixMessMenuWidgetReceiver`
- **Metadata**: `xml/attendrix_mess_menu_widget_info.xml`
- **Payload Version**: `version: 5`
- **Supported Layouts**: Small (2x2), Medium (4x2), Large (4x4)
- **Features**: Current/next meal determination, diet chips (Veg, Egg, Non-Veg), meal timings, today's full menu schedule.

---

## File Mapping Summary

| Target Path | Purpose |
| :--- | :--- |
| `lib/services/home_widget_service.dart` | Single Flutter API for Class & Mess Menu widgets |
| `android/app/src/main/kotlin/com/attendrix/app/widget/WidgetTokens.kt` | Material 3 Design Tokens |
| `android/app/src/main/kotlin/com/attendrix/app/widget/WidgetUiState.kt` | Sealed State Machine & Enums |
| `android/app/src/main/kotlin/com/attendrix/app/widget/WidgetTheme.kt` | GlanceTheme Provider |
| `android/app/src/main/kotlin/com/attendrix/app/widget/WidgetComponents.kt` | Shared M3 Composables |
| `android/app/src/main/kotlin/com/attendrix/app/widget/SmallLayout.kt` | Class Widget 2x2 Layout |
| `android/app/src/main/kotlin/com/attendrix/app/widget/MediumLayout.kt` | Class Widget 4x2 Layout |
| `android/app/src/main/kotlin/com/attendrix/app/widget/LargeLayout.kt` | Class Widget 4x4 Layout |
| `android/app/src/main/kotlin/com/attendrix/app/widget/MessMenuModels.kt` | Mess Menu Data Models |
| `android/app/src/main/kotlin/com/attendrix/app/widget/MessMenuComponents.kt` | Unique Mess Menu Composables |
| `android/app/src/main/kotlin/com/attendrix/app/widget/MessMenuLayouts.kt` | Mess Menu 2x2 / 4x2 / 4x4 Layouts |
| `android/app/src/main/kotlin/com/attendrix/app/widget/AttendrixMessMenuWidget.kt` | Mess Menu Glance Widget & Receiver |

---

## Build & Verification Results

- `flutter analyze lib/services/home_widget_service.dart`: **No issues found!**
- `flutter build apk --debug --no-pub`: **`✓ Built build/app/outputs/flutter-apk/app-debug.apk`**
