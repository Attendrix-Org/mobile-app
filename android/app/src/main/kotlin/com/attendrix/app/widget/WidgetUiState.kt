package com.attendrix.app.widget

enum class WidgetStatus {
    LIVE,
    UPCOMING,
    COMPLETED,
    CANCELLED,
    ABSENT,
    HOLIDAY
}

enum class EmptyState {
    WEEKEND,
    HOLIDAY,
    NO_TIMETABLE,
    LOGGED_OUT,
    SEMESTER_NOT_STARTED,
    NO_CLASSES,
    NO_MESS_SELECTED,
    MESS_MISSING
}

sealed interface WidgetUiState {
    object Loading : WidgetUiState
    data class Ready(val data: WidgetState) : WidgetUiState
    data class Empty(val reason: EmptyState) : WidgetUiState
    data class Offline(val data: WidgetState, val updatedAtMillis: Long) : WidgetUiState
    data class Error(val message: String) : WidgetUiState
}
