package com.attendrix.app.widget

import android.content.Context
import android.util.Log
import androidx.glance.appwidget.updateAll
import com.attendrix.app.widget.core.WidgetRefreshScheduler
import com.attendrix.app.widget.core.WidgetStateStore

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

        try {
            val classSnapshot = WidgetStateStore.getClassSnapshot(context)
            val messSnapshot = WidgetStateStore.getMessMenuSnapshot(context)
            val nextBoundary = WidgetRefreshScheduler.calculateNextBoundaryMillis(classSnapshot, messSnapshot)
            if (nextBoundary != null) {
                WidgetRefreshScheduler.scheduleNextBoundaryRefresh(context, nextBoundary)
            }
        } catch (e: Exception) {
            Log.e("WidgetUpdater", "Failed to schedule next boundary refresh", e)
        }
    }
}
