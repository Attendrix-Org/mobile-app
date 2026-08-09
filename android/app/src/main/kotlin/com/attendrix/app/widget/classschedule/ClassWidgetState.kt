package com.attendrix.app.widget.classschedule

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.model.WidgetClass

sealed interface ClassWidgetState {
    object Loading : ClassWidgetState
    data class Ready(
        val currentClass: WidgetClass?,
        val nextClass: WidgetClass?,
        val upcomingRows: List<WidgetClass>,
        val progress: Double,
        val remainingMinutes: Int,
        val overallAttendancePercentage: Double,
        val updatedAtMillis: Long
    ) : ClassWidgetState
    data class Stale(val readyState: Ready, val staleByMinutes: Int) : ClassWidgetState
    data class Empty(val reason: EmptyState) : ClassWidgetState
    data class Error(val message: String) : ClassWidgetState
}
