# Attendrix Widget System v2 — Phase 0 UX Audit Report (`WIDGET_UX_AUDIT.md`)

This report presents a thorough audit of the existing Attendrix Widget System v2 before executing the UX, layout, and information architecture refactor.

---

## 1. Current Rendering Pipeline

```
SharedPreferences ("HomeWidgetPreferences") 
      │
      ▼
WidgetStateRepository / AttendrixMessMenuWidget (getSnapshot)
      │
      ▼
WidgetStateMapper.toUiState(snapshot) ──> WidgetUiState (Loading | Ready | Empty | Offline | Error)
      │
      ▼
WidgetStateRenderer / MessMenuStateRenderer
      │
      ├─► SmallLayout (2x2)
      ├─► MediumLayout (4x2)
      └─► LargeLayout (4x4)
```

---

## 2. Audit of Current Implementation vs Required Refactors

| Feature / Subsystem | Current Implementation | Audit Findings & Required Refactor |
| :--- | :--- | :--- |
| **Current Class Logic** | Checked `currentClass != null` | **BUG DETECTED**: Future classes were sometimes placed in `currentClass` and rendered as `LIVE`. Must enforce strict `startTime <= now < endTime` check. |
| **Class Render Modes** | Rendered progress bar even when `currentClass` was missing or static. | **REFACTOR**: Implement exactly 2 Modes:<br>• **Mode 1 (Current Class Exists)**: Current Class Card + Progress Bar + Upcoming.<br>• **Mode 2 (No Current Class)**: NO progress bar, NO live badge, NO `%`. Render Upcoming list with countdowns. |
| **Countdown Formatting** | Displayed raw min or formatted clock ranges ("8:00 AM - 9:30 AM"). | **REFACTOR**: Implement reusable `formatCountdown(targetMillis, now)`:<br>• `< 1 min`: `"Now"`<br>• `< 60 min`: `"43 min"`<br>• `< 24 hours`: `"17h 25m"`<br>• `< 7 days`: `"1d 7h"`<br>• `>= 7 days`: Formatted date |
| **Progress & Duration** | Visual progress bar with % and remaining minutes. | **REFACTOR**: Display progress ONLY when `currentClass` exists. Show `████████░░ 68% • 32 min left`. |
| **Header UI** | Large text + oversized "Refresh" / "Syncing" pill button. | **REFACTOR**: Compact Material 3 Header. Brand (`ATTENDRIX`) + Context (`Current Class` / `Upcoming Classes` / `Mess Menu`). Replace pill button with 36dp M3 tonal icon button. |
| **Attendance Chip** | High-contrast pill. | **REFACTOR**: Reduce visual prominence (`92% Attendance`). Class name must dominate. |
| **Mess Widget Logic** | Displayed static first meal or Breakfast. | **REFACTOR**: Determine active meal strictly by current time:<br>• **Current Meal**: *"Now Serving"* -> Meal Name -> *"Ends in 48 min"*.<br>• **Next Meal**: *"Next Meal"* -> Meal Name -> *"Starts in 1h 12m"*. |
| **Menu List Formatting** | Paragraph string separated by commas. | **REFACTOR**: Bulleted list (`• Item\n• Item\n+2 more`) for maximum glanceability. |
| **Spacing & Whitespace** | Compact layout with low whitespace. | **REFACTOR**: Apply M3 vertical rhythm, increased padding, 28dp card radii, 16dp chips, 20dp buttons, flat tonal containers. |

---

## 3. Plan for UX Refactor Execution

1. **`WidgetTokens.kt`**: Update M3 spacing & touch targets (36dp icon button, 48dp minimum click targets).
2. **`WidgetUiState.kt`**: Add `formatCountdown(...)` utility and `getMealStatus(...)`.
3. **`WidgetComponents.kt`**: Redesign `Header` (36dp M3 icon button + Context line), `StatusChip`, `AttendanceChip`, `BulletMenuList`, `ProgressSection`, `FreshnessFooter`.
4. **`SmallLayout.kt` & `MediumLayout.kt` & `LargeLayout.kt`**: Enforce Mode 1 vs Mode 2 rendering for Class Widget.
5. **`MessMenuLayouts.kt`**: Enforce Current Meal ("Now Serving") vs Next Meal ("Next Meal") rendering with bullet lists.
6. **`AttendrixClassWidget.kt` & `AttendrixMessMenuWidget.kt`**: Keep Glance entry points, update previews and state rendering.
7. **`lib/services/home_widget_service.dart`**: Ensure `syncFromAppState` evaluates strict live class times (`startTime <= now < endTime`) and meal time ranges.
