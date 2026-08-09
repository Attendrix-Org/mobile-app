package com.attendrix.app.widget.messmenu

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.model.MealItem

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
