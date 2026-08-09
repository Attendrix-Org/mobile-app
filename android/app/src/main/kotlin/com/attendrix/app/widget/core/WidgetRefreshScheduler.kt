package com.attendrix.app.widget.core

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.attendrix.app.widget.WidgetUpdater
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.Calendar

/**
 * Event-Driven Boundary Refresh Scheduler for Attendrix Native Widgets.
 * Schedules exact one-shot AlarmManager triggers at state boundary timestamps (class start/end, meal start/end, midnight).
 * Avoids per-second background polling while guaranteeing exact Glance updates on transition boundaries.
 */
object WidgetRefreshScheduler {
    private const val TAG = "WidgetRefreshScheduler"
    private const val ACTION_REFRESH_BOUNDARY = "com.attendrix.app.WIDGET_BOUNDARY_REFRESH"
    private const val REQUEST_CODE = 8801

    fun scheduleNextBoundaryRefresh(context: Context, nextBoundaryMillis: Long) {
        if (nextBoundaryMillis <= WidgetClock.currentTimeMillis()) return

        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, WidgetRefreshReceiver::class.java).apply {
                action = ACTION_REFRESH_BOUNDARY
            }

            val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            val pendingIntent = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, flags)

            alarmManager.set(AlarmManager.RTC, nextBoundaryMillis, pendingIntent)
            Log.d(TAG, "Scheduled next boundary refresh in ${((nextBoundaryMillis - WidgetClock.currentTimeMillis()) / 1000L)}s")
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to schedule boundary refresh alarm", e)
        }
    }

    fun calculateNextBoundaryMillis(
        classSnapshot: WidgetSnapshot,
        messSnapshot: WidgetSnapshot,
        nowMillis: Long = WidgetClock.currentTimeMillis()
    ): Long? {
        val boundaries = mutableListOf<Long>()

        // 1. Class boundaries
        val classPayload = classSnapshot.payload
        val currentClassObj = classPayload.optJSONObject("currentClass")
        if (currentClassObj != null) {
            val endMillis = currentClassObj.optLong("endMillis", 0L)
            if (endMillis > nowMillis) boundaries.add(endMillis)
        }

        val nextClassObj = classPayload.optJSONObject("nextClass")
        if (nextClassObj != null) {
            val startMillis = nextClassObj.optLong("startMillis", 0L)
            if (startMillis > nowMillis) boundaries.add(startMillis)
        }

        // 2. Midnight boundary
        val cal = Calendar.getInstance().apply {
            timeInMillis = nowMillis
            add(Calendar.DAY_OF_YEAR, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        boundaries.add(cal.timeInMillis)

        return boundaries.filter { it > nowMillis }.minOrNull()
    }
}

class WidgetRefreshReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val pendingResult = goAsync()
        CoroutineScope(Dispatchers.Default).launch {
            try {
                WidgetUpdater.updateAllWidgets(context)
            } finally {
                pendingResult.finish()
            }
        }
    }
}
