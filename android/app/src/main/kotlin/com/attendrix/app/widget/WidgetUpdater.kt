package com.attendrix.app.widget

import android.content.Context
import android.util.Log
import androidx.glance.appwidget.updateAll

object WidgetUpdater {
    suspend fun updateAllWidgets(context: Context) {
        try {
            AttendrixClassWidget().updateAll(context)
        } catch (e: Exception) {
            Log.e("WidgetUpdater", "Failed to update Class Widget", e)
        }

        try {
            AttendrixMessMenuWidget().updateAll(context)
        } catch (e: Exception) {
            Log.e("WidgetUpdater", "Failed to update Mess Menu Widget", e)
        }
    }
}
