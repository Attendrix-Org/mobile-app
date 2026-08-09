package com.attendrix.app.widget.core

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import com.attendrix.app.widget.WidgetUpdater
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import java.util.Calendar

/**
 * Event-Driven Boundary Refresh Scheduler for Attendrix Native Widgets.
 * Evaluates exact state transition boundaries for both Class Schedule and Mess Menu domains.
 * Uses AlarmManager.RTC wall-clock scheduling with graceful Android API 31+ exact-alarm fallback.
 */
object WidgetRefreshScheduler {
    private const val TAG = "WidgetRefreshScheduler"
    private const val ACTION_REFRESH_BOUNDARY = "com.attendrix.app.WIDGET_BOUNDARY_REFRESH"
    private const val REQUEST_CODE = 8801

    /**
     * Schedules the next boundary refresh alarm if a valid future boundary exists.
     */
    fun scheduleNextBoundaryRefresh(context: Context, nextBoundaryMillis: Long) {
        val nowMillis = WidgetClock.currentTimeMillis()
        if (nextBoundaryMillis <= nowMillis) return

        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
            val intent = Intent(context, WidgetRefreshReceiver::class.java).apply {
                action = ACTION_REFRESH_BOUNDARY
            }

            val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            val pendingIntent = PendingIntent.getBroadcast(context, REQUEST_CODE, intent, flags)

            val canScheduleExact = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                alarmManager.canScheduleExactAlarms()
            } else true

            if (canScheduleExact) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, nextBoundaryMillis, pendingIntent)
            } else {
                alarmManager.setAndAllowWhileIdle(AlarmManager.RTC, nextBoundaryMillis, pendingIntent)
            }

            val secondsDelay = (nextBoundaryMillis - nowMillis) / 1000L
            Log.d(TAG, "Scheduled next boundary alarm in ${secondsDelay}s (Exact: $canScheduleExact)")
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to schedule boundary refresh alarm", e)
        }
    }

    /**
     * Pure & Deterministic Boundary Calculation Function.
     * Evaluates Class Schedule, Mess Menu, Snapshot Expiration, and Midnight boundaries relative to input timestamp.
     */
    fun calculateNextBoundaryMillis(
        classSnapshot: WidgetSnapshot,
        messSnapshot: WidgetSnapshot,
        nowMillis: Long = WidgetClock.currentTimeMillis()
    ): Long? {
        val boundaries = mutableListOf<Long>()

        // 1. Class Schedule boundaries
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

        val upcomingRows = classPayload.optJSONArray("upcomingRows") ?: JSONArray()
        for (i in 0 until upcomingRows.length()) {
            val row = upcomingRows.optJSONObject(i)
            if (row != null) {
                val start = row.optLong("startMillis", 0L)
                val end = row.optLong("endMillis", 0L)
                if (start > nowMillis) boundaries.add(start)
                if (end > nowMillis) boundaries.add(end)
            }
        }

        // 2. Mess Menu boundaries (convert 24h meal minutes into today/tomorrow Unix timestamps)
        val todayMidnight = getStartOfDayMillis(nowMillis)
        val messPayload = messSnapshot.payload

        val currentMealObj = messPayload.optJSONObject("currentMeal")
        if (currentMealObj != null) {
            val endMin = currentMealObj.optInt("endMinutes", 0)
            if (endMin > 0) {
                val endTimestamp = todayMidnight + (endMin * 60000L)
                if (endTimestamp > nowMillis) boundaries.add(endTimestamp)
            }
        }

        val nextMealObj = messPayload.optJSONObject("nextMeal")
        if (nextMealObj != null) {
            val startMin = nextMealObj.optInt("startMinutes", 0)
            if (startMin > 0) {
                var startTimestamp = todayMidnight + (startMin * 60000L)
                if (startTimestamp <= nowMillis) {
                    startTimestamp += 86400000L // Tomorrow
                }
                if (startTimestamp > nowMillis) boundaries.add(startTimestamp)
            }
        }

        // 3. Global Midnight boundary
        val nextMidnight = todayMidnight + 86400000L
        boundaries.add(nextMidnight)

        // 4. Snapshot Expiration boundaries
        if (classSnapshot.validUntil > nowMillis) boundaries.add(classSnapshot.validUntil)
        if (messSnapshot.validUntil > nowMillis) boundaries.add(messSnapshot.validUntil)

        return boundaries.filter { it > nowMillis }.minOrNull()
    }

    private fun getStartOfDayMillis(nowMillis: Long): Long {
        val cal = Calendar.getInstance().apply {
            timeInMillis = nowMillis
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        return cal.timeInMillis
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
