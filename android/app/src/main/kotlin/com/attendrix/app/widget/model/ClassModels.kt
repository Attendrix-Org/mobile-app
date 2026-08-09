package com.attendrix.app.widget.model

import com.attendrix.app.widget.core.WidgetClock
import org.json.JSONObject

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

enum class WidgetStatus {
    LIVE,
    UPCOMING,
    COMPLETED,
    CANCELLED,
    RESCHEDULED,
    ABSENT,
    HOLIDAY
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
    fun isLive(now: Long = WidgetClock.currentTimeMillis()): Boolean {
        return startMillis <= now && now < endMillis
    }

    fun courseTypeLabel(): String {
        return when {
            isLab -> "Lab"
            isExtraClass -> "Extra Class"
            isPlusSlot -> "Plus Slot"
            courseCategory.uppercase() in listOf("OE", "DE", "HM", "DA") -> "Elective"
            else -> "Regular"
        }
    }

    fun effectiveCaption(): String {
        if (statusCaption.isNotBlank()) return statusCaption
        val pct = attendance.percentage.toInt()
        val req = attendance.required
        return when {
            attendance.percentage < req -> "Attendance critical at $pct%! Attend consecutive classes to reach $req%."
            attendance.percentage <= req + 5.0 -> "On track at $pct%. Skipping will drop you close to $req%."
            attendance.percentage >= 100.0 -> "Perfect 100% attendance! Keep the streak going."
            else -> "Solid $pct% attendance. Safe above your $req% goal."
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
