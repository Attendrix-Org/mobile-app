package com.attendrix.app.widget.classschedule

import com.attendrix.app.widget.core.ClassWidgetState
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetSnapshot
import com.attendrix.app.widget.model.WidgetClass
import org.json.JSONArray
import org.json.JSONObject

object ClassWidgetMapper {
    fun toWidgetState(snapshot: WidgetSnapshot, nowMillis: Long = WidgetClock.currentTimeMillis()): ClassWidgetState {
        val payload = snapshot.payload
        val stateStr = payload.optString("state", "Ready")
        val emptyReasonStr = payload.optString("emptyReason", "NO_CLASSES").uppercase()

        val emptyReason = try {
            EmptyState.valueOf(emptyReasonStr)
        } catch (_: Throwable) {
            EmptyState.NO_CLASSES
        }

        if (stateStr.equals("Loading", ignoreCase = true)) {
            return ClassWidgetState.Loading
        }
        if (stateStr.equals("Error", ignoreCase = true)) {
            return ClassWidgetState.Error("Couldn't load schedule")
        }
        if (stateStr.equals("Empty", ignoreCase = true)) {
            return ClassWidgetState.Empty(emptyReason)
        }

        val currentClassObj = payload.optJSONObject("currentClass")
        val currentClass = currentClassObj?.let { WidgetClass.fromJson(it) }

        val nextClassObj = payload.optJSONObject("nextClass")
        val nextClass = nextClassObj?.let { WidgetClass.fromJson(it) }

        val upcomingArray = payload.optJSONArray("upcomingRows") ?: JSONArray()
        val upcomingList = mutableListOf<WidgetClass>()
        for (i in 0 until upcomingArray.length()) {
            val obj = upcomingArray.optJSONObject(i)
            if (obj != null) {
                upcomingList.add(WidgetClass.fromJson(obj))
            }
        }

        if (currentClass == null && nextClass == null && upcomingList.isEmpty()) {
            return ClassWidgetState.Empty(emptyReason)
        }

        // Dynamically compute live progress and remaining minutes using WidgetClock
        val progress = if (currentClass != null) {
            WidgetClock.calculateProgress(currentClass.startMillis, currentClass.endMillis, nowMillis)
        } else 0.0

        val remainingMinutes = if (currentClass != null) {
            WidgetClock.remainingMinutes(currentClass.endMillis, nowMillis)
        } else 0

        val overallAttendance = payload.optDouble("overallAttendancePercentage", 100.0)

        val readyState = ClassWidgetState.Ready(
            currentClass = currentClass,
            nextClass = nextClass,
            upcomingRows = upcomingList,
            progress = progress,
            remainingMinutes = remainingMinutes,
            overallAttendancePercentage = overallAttendance,
            updatedAtMillis = snapshot.generatedAt
        )

        return if (snapshot.isStale) {
            val staleMin = ((nowMillis - snapshot.generatedAt) / 60000L).toInt()
            ClassWidgetState.Stale(readyState, staleMin)
        } else {
            readyState
        }
    }
}
