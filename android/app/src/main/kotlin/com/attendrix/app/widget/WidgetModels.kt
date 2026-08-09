package com.attendrix.app.widget

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.model.AttendanceModel
import com.attendrix.app.widget.model.WidgetClass
import com.attendrix.app.widget.model.WidgetStatus
import org.json.JSONArray
import org.json.JSONObject

typealias AttendanceModel = AttendanceModel
typealias WidgetClass = WidgetClass
typealias WidgetStatus = WidgetStatus

data class WidgetState(
    val version: Int = 6,
    val widgetType: String = "class_schedule",
    val state: String = "Ready",
    val emptyReason: EmptyState = EmptyState.NO_CLASSES,
    val currentClass: WidgetClass? = null,
    val nextClass: WidgetClass? = null,
    val nextClassIsUpcomingDay: Boolean = false,
    val upcomingRows: List<WidgetClass> = emptyList(),
    val upcomingRowsAreFutureDays: Boolean = false,
    val remainingCount: Int = 0,
    val progress: Double = 0.0,
    val remainingMinutes: Int = 0,
    val overallAttendancePercentage: Double = 100.0,
    val updatedAtMillis: Long = System.currentTimeMillis()
) {
    companion object {
        fun fromJson(rawJson: String): WidgetState {
            if (rawJson.isBlank()) {
                return WidgetState(state = "Loading")
            }
            return try {
                val json = JSONObject(rawJson)
                val stateStr = json.optString("state", "Ready")
                val emptyReasonStr = json.optString("emptyReason", "NO_CLASSES").uppercase()
                val emptyReason = try {
                    EmptyState.valueOf(emptyReasonStr)
                } catch (_: Throwable) {
                    EmptyState.NO_CLASSES
                }

                val currentClassObj = json.optJSONObject("currentClass")
                val currentClass = currentClassObj?.let { WidgetClass.fromJson(it) }

                val nextClassObj = json.optJSONObject("nextClass")
                val nextClass = nextClassObj?.let { WidgetClass.fromJson(it) }

                val upcomingArray = json.optJSONArray("upcomingRows") ?: JSONArray()
                val upcomingList = mutableListOf<WidgetClass>()
                for (i in 0 until upcomingArray.length()) {
                    val obj = upcomingArray.optJSONObject(i)
                    if (obj != null) {
                        upcomingList.add(WidgetClass.fromJson(obj))
                    }
                }

                WidgetState(
                    version = 6,
                    widgetType = "class_schedule",
                    state = stateStr,
                    emptyReason = emptyReason,
                    currentClass = currentClass,
                    nextClass = nextClass,
                    upcomingRows = upcomingList,
                    overallAttendancePercentage = json.optDouble("overallAttendancePercentage", 100.0),
                    updatedAtMillis = json.optLong("updatedAtMillis", System.currentTimeMillis())
                )
            } catch (_: Throwable) {
                WidgetState(state = "Loading")
            }
        }
    }
}
