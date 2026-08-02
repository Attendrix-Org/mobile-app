package com.attendrix.app.widget

import android.content.Context

/**
 * Read-only state reader for Attendrix Glance Widget.
 *
 * Reads snapshot JSON strictly from `HomeWidgetPreferences` SharedPreferences
 * persisted by `HomeWidgetService` in Flutter.
 */
object WidgetStateRepository {
    private const val PREFS_NAME = "HomeWidgetPreferences"
    private const val WIDGET_STATE_KEY = "widget_state_json"

    fun getSnapshot(context: Context): WidgetState {
        val homeWidgetPrefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        var jsonStr = homeWidgetPrefs.getString(WIDGET_STATE_KEY, null)

        if (jsonStr.isNullOrBlank()) {
            val defaultPrefs = context.getSharedPreferences(context.packageName + "_preferences", Context.MODE_PRIVATE)
            jsonStr = defaultPrefs.getString(WIDGET_STATE_KEY, null)
        }

        if (!jsonStr.isNullOrBlank()) {
            return WidgetStateMapper.fromJson(jsonStr)
        }

        // Return empty onboarding state if app has not pushed schedule data yet
        return WidgetState(state = "Empty", emptyReason = EmptyState.NO_TIMETABLE)
    }
}
