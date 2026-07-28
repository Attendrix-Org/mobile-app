# Attendrix Widget System v2 — Phase 0 Production Audit (`WIDGET_PRODUCTION_AUDIT.md`)

This document presents the Phase 0 audit of the Attendrix Android 16 Material You Widget System prior to executing the final production polish pass.

---

## 1. Executive Summary & Audit Matrix

| System Component | Current State | Required Production Polish |
| :--- | :--- | :--- |
| **Visual Hierarchy** | Course title competes with chips and venues | **Polish**: Course Name must dominate typography (18sp Bold M3). Countdown/Status is 2nd, Metadata 3rd, Attendance Chip is 4th. |
| **Upcoming Class Hierarchy** | Upcoming items rendered equally | **Polish**: Nearest upcoming class receives high visual emphasis (`NEXT: Fluid Mechanics • Starts in 43 min`), followed by secondary rows (`Heat Transfer • Tomorrow`). |
| **Header Layout** | Context title + 36dp refresh icon | **Polish**: Minimalist Google-style Header. Brand (`ATTENDRIX`) + Context (`Current Class` / `Upcoming` / `Now Serving`). Low-emphasis 36dp tonal refresh button. |
| **Mess Widget Layout** | All meals rendered with equal weight | **Polish**: Current meal (*"Now Serving"*) dominates with `SurfaceContainer` background & bullet items (`• Item`). Remaining meals become lightweight timeline items. |
| **Countdown Formatting** | Formatted string ranges | **Polish**: Natural M3 countdown formatter (`Now`, `43 min`, `2h 14m`, `17h 25m`, `Tomorrow`, `1d 7h`, `Jul 28`). Zero raw durations. |
| **Empty State Copy** | Informative technical text | **Polish**: Delightful human copy (*"Enjoy your weekend. No classes scheduled today."*, *"Choose your mess in Attendrix."*, etc.). |
| **Chip Aesthetics** | Saturated status chips | **Polish**: M3 tonal chips with muted backgrounds and high contrast text. |
| **Whitespace & Padding** | Compact padding | **Polish**: Material You spacing (16dp lg padding, 28dp card radii, 16dp chips, flat tonal containers). |

---

## 2. Detailed Production Audit by Widget

### A. Class Schedule Widget
- **Mode 1 (Live Class)**: Active class dominates with course title, 32 min remaining countdown, venue, and low-emphasis attendance percentage chip.
- **Mode 2 (Upcoming Only)**: Progress bar, completion %, and live badges are completely removed. Nearest class is highlighted; secondary classes are listed cleanly.

### B. Mess Menu Widget
- **Now Serving**: Highlights current meal, countdown to meal end (`Ends in 48 min`), and bullet list (`• Item\n• Item\n+2 more`).
- **Next Meal**: Displays next meal, start countdown (`Starts in 2h 12m`), and bullet preview.
- **Large 4x4 Dashboard**: Active meal card dominates top half; remaining meals format as secondary timeline items below.

---

## 3. Production Polish Action Plan

1. **`WidgetTokens.kt`**: Fine-tune M3 tonal color providers and radii (28dp cards, 16dp chips, 20dp buttons, 18dp icon buttons).
2. **`WidgetModels.kt`**: Standardize `formatCountdown(targetMillis, now)` utility (`Now`, `43 min`, `2h 14m`, `17h 25m`, `Tomorrow`, `1d 7h`, `Jul 28`).
3. **`WidgetComponents.kt`**: Overhaul `Header`, `ContextualEmptyStateView`, `StatusChip`, `AttendanceChip`, `ProgressSection`, `FreshnessFooter` with M3 copy & tonal styling.
4. **`SmallLayout.kt`, `MediumLayout.kt`, `LargeLayout.kt`**: Enforce strict course title dominance and upcoming class hierarchy.
5. **`MessMenuLayouts.kt`**: Enforce current meal dominance, bullet lists (`• Item`), and secondary meal timeline rows.
6. **`HomeWidgetService.dart`**: Verify zero redundant JSON parsing or state mapping.
