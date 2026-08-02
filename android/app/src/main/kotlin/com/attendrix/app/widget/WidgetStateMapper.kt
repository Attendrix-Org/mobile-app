package com.attendrix.app.widget

import org.json.JSONArray
import org.json.JSONObject

object WidgetStateMapper {

    fun fromJson(rawJson: String): WidgetState {
        if (rawJson.isBlank()) {
            return WidgetState(state = "Loading")
        }
        return try {
            val json = JSONObject(rawJson)
            val version = json.optInt("version", 4)
            val stateStr = json.optString("state", "Loading")

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

            val nextClassIsUpcomingDay = json.optBoolean("nextClassIsUpcomingDay", false)

            val rowsArray = json.optJSONArray("upcomingRows")
                ?: json.optJSONArray("todayClasses")
                ?: JSONArray()
            val upcomingRows = mutableListOf<WidgetClass>()
            for (i in 0 until rowsArray.length()) {
                val itemObj = rowsArray.optJSONObject(i)
                if (itemObj != null) {
                    upcomingRows.add(WidgetClass.fromJson(itemObj))
                }
            }

            val upcomingRowsAreFutureDays = json.optBoolean("upcomingRowsAreFutureDays", false)
            val remainingCount = json.optInt("remainingCount", 0)
            val progress = json.optDouble("progress", 0.0)
            val remainingMinutes = json.optInt("remainingMinutes", 0)
            val overallAttendancePercentage = json.optDouble("overallAttendancePercentage", 100.0)
            val updatedAtMillis = json.optLong("updatedAtMillis", System.currentTimeMillis())
            val preferredTimeFormat = json.optString("preferredTimeFormat", "FORMAT_12H")

            val absenceActionStatus = json.optString("absenceActionStatus", "Idle")
            val absenceActionClassId = json.optString("absenceActionClassId", null)

            WidgetState(
                version = 4,
                state = stateStr,
                emptyReason = emptyReason,
                currentClass = currentClass,
                nextClass = nextClass,
                nextClassIsUpcomingDay = nextClassIsUpcomingDay,
                upcomingRows = upcomingRows,
                upcomingRowsAreFutureDays = upcomingRowsAreFutureDays,
                remainingCount = remainingCount,
                progress = progress,
                remainingMinutes = remainingMinutes,
                overallAttendancePercentage = overallAttendancePercentage,
                updatedAtMillis = updatedAtMillis,
                preferredTimeFormat = preferredTimeFormat,
                absenceActionStatus = absenceActionStatus,
                absenceActionClassId = absenceActionClassId
            )
        } catch (e: Throwable) {
            WidgetState(state = "Loading")
        }
    }

    fun toUiState(state: WidgetState): WidgetUiState {
        return when (state.state) {
            "Loading" -> WidgetUiState.Loading
            "Offline" -> WidgetUiState.Offline(state, state.updatedAtMillis)
            "SyncFailed", "Error" -> WidgetUiState.Error("Couldn't load widget")
            "AuthExpired" -> WidgetUiState.Empty(EmptyState.LOGGED_OUT)
            "Empty" -> WidgetUiState.Empty(state.emptyReason)
            else -> {
                if (state.currentClass == null && state.nextClass == null && state.upcomingRows.isEmpty()) {
                    WidgetUiState.Empty(state.emptyReason)
                } else {
                    WidgetUiState.Ready(state)
                }
            }
        }
    }
}
