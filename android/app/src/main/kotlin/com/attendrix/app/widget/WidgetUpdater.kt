package com.attendrix.app.widget

import android.content.Context
import androidx.glance.appwidget.updateAll

object WidgetUpdater {
    suspend fun updateAllWidgets(context: Context) {
        try {
            AttendrixClassWidget().updateAll(context)
        } catch (e: Exception) {
            android.util.Log.e("WidgetUpdater", "Failed to update widgets", e)
        }
    }
}
