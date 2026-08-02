package com.attendrix.app.widget

import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

data class AttendanceModel(
    val attended: Int = 0,
    val missed: Int = 0,
    val percentage: Double = 100.0,
    val required: Int = 80
) {
    fun toJson(): JSONObject = JSONObject().apply {
        put("attended", attended)
        put("missed", missed)
        put("percentage", percentage)
        put("required", required)
    }

    companion object {
        fun fromJson(json: JSONObject): AttendanceModel = AttendanceModel(
            attended = json.optInt("attended", 0),
            missed = json.optInt("missed", 0),
            percentage = json.optDouble("percentage", 100.0),
            required = json.optInt("required", 80)
        )
    }
}

data class WidgetClass(
    val classId: String,
    val courseName: String,
    val courseCode: String = "",
    val courseCategory: String = "",
    val isLab: Boolean = false,
    val isExtraClass: Boolean = false,
    val isPlusSlot: Boolean = false,
    val venue: String,
    val attendance: AttendanceModel = AttendanceModel(),
    val statusCaption: String = "",
    val startMillis: Long,
    val endMillis: Long,
    val isAbsent: Boolean = false,
    val status: WidgetStatus = WidgetStatus.UPCOMING
) {
    /**
     * Current class exists ONLY IF startTime <= now < endTime.
     */
    fun isLive(now: Long = System.currentTimeMillis()): Boolean {
        return startMillis <= now && now < endMillis
    }

    /**
     * Subtle Course Type Label (Low visual emphasis classifier).
     */
    fun courseTypeLabel(): String {
        return when {
            isLab -> "Lab"
            isExtraClass -> "Extra Class"
            isPlusSlot -> "Plus Slot"
            courseCategory.uppercase() in listOf("OE", "DE", "HM", "DA") -> "Elective"
            else -> "Regular"
        }
    }

    /**
     * Custom Attendance Caption matching FlutterFlow action logic.
     */
    fun effectiveCaption(): String {
        if (statusCaption.isNotBlank()) return statusCaption
        val pct = attendance.percentage.toInt()
        val req = attendance.required
        return when {
            attendance.percentage < req -> "Attendance critical at $pct%! You need to attend consecutive classes straight to reach your $req% goal."
            attendance.percentage <= req + 5.0 -> "On track at $pct%. Skipping will drop you close to $req%."
            attendance.percentage >= 100.0 -> "Perfect 100% attendance! Keep the streak going."
            else -> "Solid $pct% attendance. Cushion above your $req% goal."
        }
    }

    fun toJson(): JSONObject = JSONObject().apply {
        put("classId", classId)
        put("courseName", courseName)
        put("courseCode", courseCode)
        put("courseCategory", courseCategory)
        put("isLab", isLab)
        put("isExtraClass", isExtraClass)
        put("isPlusSlot", isPlusSlot)
        put("venue", venue)
        put("attendance", attendance.toJson())
        put("statusCaption", statusCaption)
        put("startMillis", startMillis)
        put("endMillis", endMillis)
        put("isAbsent", isAbsent)
        put("status", status.name)
    }

    companion object {
        fun fromJson(json: JSONObject): WidgetClass {
            val attObj = json.optJSONObject("attendance")
            val attModel = if (attObj != null) {
                AttendanceModel.fromJson(attObj)
            } else {
                val pct = json.optDouble("attendancePercentage", 100.0)
                AttendanceModel(percentage = pct, required = 80)
            }

            return WidgetClass(
                classId = json.optString("classId", ""),
                courseName = json.optString("courseName", ""),
                courseCode = json.optString("courseCode", ""),
                courseCategory = json.optString("courseCategory", ""),
                isLab = json.optBoolean("isLab", false),
                isExtraClass = json.optBoolean("isExtraClass", false),
                isPlusSlot = json.optBoolean("isPlusSlot", false),
                venue = json.optString("venue", ""),
                attendance = attModel,
                statusCaption = json.optString("statusCaption", ""),
                startMillis = json.optLong("startMillis", 0L),
                endMillis = json.optLong("endMillis", 0L),
                isAbsent = json.optBoolean("isAbsent", false),
                status = try {
                    WidgetStatus.valueOf(json.optString("status", "UPCOMING").uppercase())
                } catch (_: Throwable) {
                    WidgetStatus.UPCOMING
                }
            )
        }
    }
}

/**
 * Reusable Natural M3 Countdown Formatter.
 */
fun formatCountdown(targetMillis: Long, nowMillis: Long = System.currentTimeMillis()): String {
    val diffMillis = targetMillis - nowMillis
    if (diffMillis <= 0) return "Now"

    val diffMin = diffMillis / 60000L
    if (diffMin < 1) return "Now"
    if (diffMin < 60) return "${diffMin} min"

    val diffHours = diffMin / 60L
    val remMin = diffMin % 60L

    val targetCal = Calendar.getInstance().apply { timeInMillis = targetMillis }
    val nowCal = Calendar.getInstance().apply { timeInMillis = nowMillis }

    val isNextDay = targetCal.get(Calendar.DAY_OF_YEAR) == nowCal.get(Calendar.DAY_OF_YEAR) + 1 &&
            targetCal.get(Calendar.YEAR) == nowCal.get(Calendar.YEAR)

    if (diffHours < 24) {
        if (isNextDay && diffHours >= 8) {
            return "Tomorrow"
        }
        return if (remMin > 0) "${diffHours}h ${remMin}m" else "${diffHours}h"
    }

    val diffDays = diffHours / 24L
    val remHours = diffHours % 24L

    if (diffDays < 7) {
        return if (remHours > 0) "${diffDays}d ${remHours}h" else "${diffDays}d"
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
    val startStr = fmt.format(Date(startMillis))
    val endStr = fmt.format(Date(endMillis))
    return "$startStr - $endStr"
}

/**
 * Relative date formatter (e.g. "Today, 2:00 PM", "Tomorrow, 8:00 AM", "Wed, Jul 29 • 10:00 AM").
 */
fun formatRelativeDate(millis: Long, nowMillis: Long = System.currentTimeMillis()): String {
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

data class WidgetState(
    val version: Int = 4,
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
    val updatedAtMillis: Long = System.currentTimeMillis(),
    val preferredTimeFormat: String = "FORMAT_12H",
    val absenceActionStatus: String = "Idle",
    val absenceActionClassId: String? = null
) {
    fun hasValidLiveClass(now: Long = System.currentTimeMillis()): Boolean {
        val current = currentClass ?: return false
        return current.isLive(now)
    }

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

                val overallAttendance = json.optDouble("overallAttendancePercentage", 100.0)
                val updatedAtMillis = json.optLong("updatedAtMillis", System.currentTimeMillis())

                WidgetState(
                    version = 4,
                    widgetType = "class_schedule",
                    state = stateStr,
                    emptyReason = emptyReason,
                    currentClass = currentClass,
                    nextClass = nextClass,
                    upcomingRows = upcomingList,
                    overallAttendancePercentage = overallAttendance,
                    updatedAtMillis = updatedAtMillis
                )
            } catch (e: Throwable) {
                WidgetState(state = "Loading")
            }
        }
    }
}
