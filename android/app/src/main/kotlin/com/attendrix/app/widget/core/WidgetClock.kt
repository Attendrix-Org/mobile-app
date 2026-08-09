package com.attendrix.app.widget.core

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/**
 * Centralized Time Calculation Engine for Attendrix Native Widgets.
 * Evaluates live progress, countdowns, and relative formatting locally without requiring per-second Flutter rebuilds.
 */
object WidgetClock {
    fun currentTimeMillis(): Long = System.currentTimeMillis()

    fun calculateProgress(startMillis: Long, endMillis: Long, nowMillis: Long = currentTimeMillis()): Double {
        if (endMillis <= startMillis || nowMillis <= startMillis) return 0.0
        if (nowMillis >= endMillis) return 1.0
        return ((nowMillis - startMillis).toDouble() / (endMillis - startMillis).toDouble()).coerceIn(0.0, 1.0)
    }

    fun remainingMinutes(endMillis: Long, nowMillis: Long = currentTimeMillis()): Int {
        if (nowMillis >= endMillis) return 0
        return (((endMillis - nowMillis) / 60000L)).toInt().coerceAtLeast(0)
    }

    fun formatCountdown(targetMillis: Long, nowMillis: Long = currentTimeMillis()): String {
        val diffMillis = targetMillis - nowMillis
        if (diffMillis <= 0L) return "Now"

        val diffMin = diffMillis / 60000L
        if (diffMin < 1L) return "Now"
        if (diffMin < 60L) return "${diffMin} min"

        val diffHours = diffMin / 60L
        val remMin = diffMin % 60L

        val targetCal = Calendar.getInstance().apply { timeInMillis = targetMillis }
        val nowCal = Calendar.getInstance().apply { timeInMillis = nowMillis }

        val isNextDay = targetCal.get(Calendar.DAY_OF_YEAR) == nowCal.get(Calendar.DAY_OF_YEAR) + 1 &&
                targetCal.get(Calendar.YEAR) == nowCal.get(Calendar.YEAR)

        if (diffHours < 24L) {
            if (isNextDay && diffHours >= 8L) return "Tomorrow"
            return if (remMin > 0L) "${diffHours}h ${remMin}m" else "${diffHours}h"
        }

        val diffDays = diffHours / 24L
        val remHours = diffHours % 24L

        if (diffDays < 7L) {
            return if (remHours > 0L) "${diffDays}d ${remHours}h" else "${diffDays}d"
        }

        val fmt = SimpleDateFormat("MMM d", Locale.getDefault())
        return fmt.format(Date(targetMillis))
    }

    fun formatFullDate(millis: Long): String {
        if (millis <= 0L) return ""
        val fmt = SimpleDateFormat("EEE, MMM d", Locale.getDefault())
        return fmt.format(Date(millis))
    }

    fun formatTimeRange(startMillis: Long, endMillis: Long): String {
        if (startMillis <= 0L || endMillis <= 0L) return ""
        val fmt = SimpleDateFormat("h:mm a", Locale.getDefault())
        return "${fmt.format(Date(startMillis))} - ${fmt.format(Date(endMillis))}"
    }

    fun formatRelativeDate(millis: Long, nowMillis: Long = currentTimeMillis()): String {
        if (millis <= 0L) return ""
        val targetCal = Calendar.getInstance().apply { timeInMillis = millis }
        val nowCal = Calendar.getInstance().apply { timeInMillis = nowMillis }

        val timeFmt = SimpleDateFormat("h:mm a", Locale.getDefault())
        val timeStr = timeFmt.format(Date(millis))

        val isToday = targetCal.get(Calendar.YEAR) == nowCal.get(Calendar.YEAR) &&
                targetCal.get(Calendar.DAY_OF_YEAR) == nowCal.get(Calendar.DAY_OF_YEAR)

        val isTomorrow = targetCal.get(Calendar.YEAR) == nowCal.get(Calendar.YEAR) &&
                targetCal.get(Calendar.DAY_OF_YEAR) == nowCal.get(Calendar.DAY_OF_YEAR) + 1

        return when {
            isToday -> "Today, $timeStr"
            isTomorrow -> "Tomorrow, $timeStr"
            else -> {
                val dateFmt = SimpleDateFormat("EEE, MMM d", Locale.getDefault())
                "${dateFmt.format(Date(millis))} • $timeStr"
            }
        }
    }
}
