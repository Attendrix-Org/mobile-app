# Attendrix Android Home Widget Architecture Audit

This document presents Phase 0 Audit of the Android Home Screen Widget implementation from `/Users/shashankmergu/Desktop/attendrix/attendrix-v3-u8m4eb`.

## Audit Summary

- Total Files Analyzed: 20 Kotlin source files + XML + Manifest configurations
- **Required Files**: 8 files (Core Glance UI, Receiver, Models, Serializers, Storage & Redraw helpers)
- **Optional Files**: 0 files
- **Obsolete Files**: 12 files (Legacy native Supabase HTTP clients, WorkManager sync workers, native background schedulers, and obsolete state reducers)

---

## File Audit Matrix

| File | Purpose | Must Migrate? | Dependencies | Notes |
| :--- | :--- | :---: | :--- | :--- |
| `AttendrixClassWidget.kt` | Defines Jetpack Glance Composable UI for Small, Medium, and Large widget form factors. | **YES (REQUIRED)** | Jetpack Glance, `WidgetStateRepository`, `AttendrixWidgetTheme` | Main Glance UI component. Actions updated to trigger app launch for refresh/toggle. |
| `AttendrixClassWidgetReceiver.kt` | `GlanceAppWidgetReceiver` handling system `APPWIDGET_UPDATE` intents. | **YES (REQUIRED)** | Jetpack Glance, `AttendrixClassWidget` | Entry point registered in AndroidManifest. Native WorkManager call removed. |
| `AttendrixWidgetTheme.kt` | Theme tokens (Primary, Surface, Background, Accent, TextPrimary, TextSecondary colors). | **YES (REQUIRED)** | Jetpack Glance UI | Provides unified dark/light color scheme for widget rendering. |
| `WidgetModels.kt` | Data classes (`WidgetState`, `WidgetClass`, `WidgetStudentSummary`, `WidgetAbsenceActionState`). | **YES (REQUIRED)** | Kotlin Standard Library | Data structures representing widget snapshot state. |
| `WidgetStateMapper.kt` | JSON parsing & serialization logic converting string snapshot into `WidgetState`. | **YES (REQUIRED)** | `org.json` | Used to decode JSON state received from `home_widget` storage. |
| `WidgetStateRepository.kt` | Local state reader providing atomic reading of `widget_state_json`. | **YES (REQUIRED)** | DataStore & SharedPreferences (`HomeWidgetPreferences`) | Updated to fallback to `HomeWidget` shared preferences (`HomeWidget.saveWidgetData`). |
| `WidgetBridge.kt` | MethodChannel `com.attendrix.app/widget` interface. | **YES (REQUIRED)** | Flutter Engine BinaryMessenger | Bridge between Flutter and Android for direct state updates. |
| `WidgetUpdater.kt` | Triggers Glance widget UI invalidation (`updateAll`). | **YES (REQUIRED)** | Jetpack Glance (`updateAll`) | Called when Flutter pushes new widget state. |
| `AbsenceRepository.kt` | Interface for native Supabase RPC calls. | **NO (OBSOLETE)** | None | **Eliminated**. Absence actions managed in Flutter via Supabase SDK. |
| `NativeAbsenceRepository.kt` | OkHttp client making native `mark_absent` / `un_mark_absent` RPC calls. | **NO (OBSOLETE)** | OkHttp, `SupabaseSessionStore` | **Eliminated**. Native direct network fetching violates single source of truth. |
| `SyncRepository.kt` | Interface for native schedule sync fetching. | **NO (OBSOLETE)** | None | **Eliminated**. Schedule managed by Flutter app. |
| `NativeSyncRepository.kt` | OkHttp client fetching timetable and attendance directly from Supabase REST endpoints. | **NO (OBSOLETE)** | OkHttp, `SupabaseSessionStore` | **Eliminated**. Replaced by Flutter `HomeWidgetService`. |
| `SupabaseSessionStore.kt` | Native session token store reading encrypted auth state. | **NO (OBSOLETE)** | Android SharedPreferences | **Eliminated**. Native auth state storage no longer needed. |
| `AttendrixSyncWorker.kt` | WorkManager `CoroutineWorker` executing background REST polling. | **NO (OBSOLETE)** | androidx.work | **Eliminated**. WorkManager background sync removed to save battery. |
| `AttendrixSyncScheduler.kt` | WorkManager scheduler enqueueing periodic background workers. | **NO (OBSOLETE)** | androidx.work | **Eliminated**. Periodic background polling removed. |
| `AttendrixRedrawWorker.kt` | WorkManager worker forcing periodic UI redraw. | **NO (OBSOLETE)** | androidx.work | **Eliminated**. UI redrawn when Flutter sends updates. |
| `WidgetSyncManager.kt` | Native sync coordinator triggering background sync tasks. | **NO (OBSOLETE)** | WorkManager | **Eliminated**. Native sync coordination removed. |
| `WidgetAbsenceActionManager.kt` | Native optimistic absence action executor. | **NO (OBSOLETE)** | `NativeAbsenceRepository` | **Eliminated**. Actions handled inside Flutter application. |
| `WidgetAbsenceStateReducer.kt` | Native reducer for optimistic absence button states. | **NO (OBSOLETE)** | `WidgetModels` | **Eliminated**. State managed in Flutter app state. |
| `AttendrixWidgetPreviews.kt` | Jetpack Compose preview provider helpers. | **NO (OBSOLETE)** | Compose UI Tooling | **Eliminated**. Preview annotations not required in production APK. |

---

## Non-Code Resource Audit

| File | Purpose | Must Migrate? | Notes |
| :--- | :--- | :---: | :--- |
| `attendrix_class_widget_info.xml` | AppWidgetProvider metadata defining minimum sizes (140x110dp) and resize modes. | **YES (REQUIRED)** | Placed in `android/app/src/main/res/xml/`. |
| `strings.xml` (`widget_description`) | App widget label/description string resource. | **YES (REQUIRED)** | Placed in `android/app/src/main/res/values/strings.xml`. |
| `AndroidManifest.xml` Receiver | `<receiver>` entry binding `AttendrixClassWidgetReceiver` to `APPWIDGET_UPDATE`. | **YES (REQUIRED)** | Merged into `android/app/src/main/AndroidManifest.xml`. |
