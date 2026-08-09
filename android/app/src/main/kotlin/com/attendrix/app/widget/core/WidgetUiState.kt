package com.attendrix.app.widget.core

import com.attendrix.app.widget.model.MealItem
import com.attendrix.app.widget.model.WidgetClass

enum class EmptyState {
    WEEKEND,
    HOLIDAY,
    NO_TIMETABLE,
    LOGGED_OUT,
    SEMESTER_NOT_STARTED,
    NO_CLASSES,
    NO_MESS_SELECTED,
    MESS_MISSING,
    NO_MENU_AVAILABLE
}

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

sealed interface MessMenuWidgetState {
    object Loading : MessMenuWidgetState
    data class Ready(
        val messName: String,
        val currentMeal: MealItem?,
        val nextMeal: MealItem?,
        val todayMeals: List<MealItem>,
        val updatedAtMillis: Long
    ) : MessMenuWidgetState
    data class Stale(val readyState: Ready, val staleByMinutes: Int) : MessMenuWidgetState
    data class Empty(val reason: EmptyState) : MessMenuWidgetState
    data class Error(val message: String) : MessMenuWidgetState
}
