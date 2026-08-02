# Attendrix Mess Menu Widget Audit & Architecture Plan

This document presents Phase 0 audit findings for integrating the **Attendrix Mess Menu Widget** into **Widget System v2**.

---

## 1. Existing Flutter Codebase Audit

### Data Models & Structs
- **`MessStruct`** (`lib/backend/schema/structs/mess_struct.dart`): Contains `messId` (String), `name` (String), and `menu` (`List<MessMenuStruct>`).
- **`MessMenuStruct`** (`lib/backend/schema/structs/mess_menu_struct.dart`): Contains `weekday` (int), `meal` (String: `breakfast`, `lunch`, `eveningTea`/`snacks`, `dinner`), and `menu` (String formatted text).
- **`FFAppState`** (`lib/app_state.dart`): Caches `_Messes` (`List<MessStruct>`) persistently in `secureStorage` under key `ff_Messes`.

### Custom Functions
- **`getMessMenu`** (`lib/custom_code/functions/get_mess_menu.dart`): Receives `List<MessStruct>`, `selectedMessId`, `selectedWeekday`, and `mealType`. Splits menu item strings by `+`, sanitizes whitespace, and returns `List<String>` of dish items.

---

## 2. Widget System v2 Component Reuse Matrix

| Widget System v2 Component | Reused in Mess Menu Widget? | Notes |
| :--- | :---: | :--- |
| `WidgetTokens` | **YES** | Reuses M3 radii (28dp cards, 16dp chips, 20dp buttons), spacing, typography, and M3 color roles. |
| `WidgetTheme` | **YES** | Reuses `GlanceTheme` wrapper and dynamic color roles. |
| `WidgetComponents.Header` | **YES** | Reuses standard ATTENDRIX header and refresh action. |
| `WidgetComponents.FreshnessFooter` | **YES** | Reuses smart freshness warning ("Updated 2 min ago" / "Data may be out of date"). |
| `WidgetComponents.StaticLoadingPlaceholder` | **YES** | Reuses static M3 placeholder blocks. |
| `WidgetComponents.ContextualEmptyStateView` | **YES** | Reuses empty state view with new `EmptyState` reasons (`WEEKEND`, `HOLIDAY`, `NO_TIMETABLE`, `LOGGED_OUT`). |
| `WidgetComponents.ErrorStateView` | **YES** | Reuses friendly error card with 48dp "Open App" button. |
| `WidgetUiState` | **YES** | Reuses sealed state interface (`Loading`, `Ready`, `Empty`, `Offline`, `Error`). |
| `HomeWidgetService` | **YES** | Extended with `updateMessMenu(...)` convenience method pushing `version: 5` payloads. |

---

## 3. Unique Mess Menu Additions

- **`MessMenuModels.kt`**: `MessMenuWidgetState`, `MealItem`, `MessMenuPayload`.
- **`MessMenuComponents.kt`**: `MealCard`, `DietChip` (Veg, Egg, Non-Veg), `MealTimeline`.
- **`MessMenuLayouts.kt`**: `SmallMessMenuLayout` (2x2), `MediumMessMenuLayout` (4x2), `LargeMessMenuLayout` (4x4).
- **`AttendrixMessMenuWidget.kt`**: `GlanceAppWidget` and `GlanceAppWidgetReceiver` for `AttendrixMessMenuWidgetReceiver`.
- **`attendrix_mess_menu_widget_info.xml`**: AppWidgetProvider metadata for mess menu widget.
