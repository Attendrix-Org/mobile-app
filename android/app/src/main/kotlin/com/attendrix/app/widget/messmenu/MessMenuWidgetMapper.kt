package com.attendrix.app.widget.messmenu

import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetSnapshot
import com.attendrix.app.widget.model.MealItem
import org.json.JSONArray

object MessMenuWidgetMapper {
    fun toWidgetState(snapshot: WidgetSnapshot, nowMillis: Long = WidgetClock.currentTimeMillis()): MessMenuWidgetState {
        if (snapshot.isExpired(nowMillis)) {
            return MessMenuWidgetState.Empty(EmptyState.NO_MENU_AVAILABLE)
        }

        val payload = snapshot.payload
        val stateStr = payload.optString("state", "Ready")
        val emptyReasonStr = payload.optString("emptyReason", "NO_MENU_AVAILABLE").uppercase()

        val emptyReason = try {
            EmptyState.valueOf(emptyReasonStr)
        } catch (_: Throwable) {
            EmptyState.NO_MENU_AVAILABLE
        }

        if (stateStr.equals("Loading", ignoreCase = true)) {
            return MessMenuWidgetState.Loading
        }
        if (stateStr.equals("Error", ignoreCase = true)) {
            return MessMenuWidgetState.Error("Couldn't load mess menu")
        }
        if (stateStr.equals("Empty", ignoreCase = true)) {
            return MessMenuWidgetState.Empty(emptyReason)
        }

        val messName = payload.optString("messName", "Mess Menu")
        val currentMealObj = payload.optJSONObject("currentMeal")
        val currentMeal = currentMealObj?.let { MealItem.fromJson(it) }

        val nextMealObj = payload.optJSONObject("nextMeal")
        val nextMeal = nextMealObj?.let { MealItem.fromJson(it) }

        val mealsArray = payload.optJSONArray("todayMeals") ?: JSONArray()
        val todayMeals = mutableListOf<MealItem>()
        for (i in 0 until mealsArray.length()) {
            val obj = mealsArray.optJSONObject(i)
            if (obj != null) {
                todayMeals.add(MealItem.fromJson(obj))
            }
        }

        if (currentMeal == null && nextMeal == null && todayMeals.isEmpty()) {
            return MessMenuWidgetState.Empty(emptyReason)
        }

        val readyState = MessMenuWidgetState.Ready(
            messName = messName,
            currentMeal = currentMeal,
            nextMeal = nextMeal,
            todayMeals = todayMeals,
            updatedAtMillis = snapshot.generatedAt
        )

        return if (snapshot.isStale(nowMillis)) {
            val staleMin = ((nowMillis - snapshot.generatedAt) / 60000L).toInt().coerceAtLeast(0)
            MessMenuWidgetState.Stale(readyState, staleMin)
        } else {
            readyState
        }
    }
}
