package com.attendrix.app.widget.model

import com.attendrix.app.widget.core.WidgetClock
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

enum class DietType {
    VEG,
    EGG,
    NON_VEG,
    SPECIAL
}

data class MealItem(
    val mealName: String,
    val timeRange: String = "",
    val mainItems: List<String> = emptyList(),
    val staples: String = "",
    val dietType: DietType = DietType.VEG,
    val startMinutes: Int = 0,
    val endMinutes: Int = 0,
    val items: List<String> = emptyList()
) {
    fun isLive(nowMillis: Long = WidgetClock.currentTimeMillis()): Boolean {
        if (startMinutes == 0 && endMinutes == 0) return false
        val cal = Calendar.getInstance().apply { timeInMillis = nowMillis }
        val nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)
        return nowMin in startMinutes until endMinutes
    }

    fun millisUntilStart(nowMillis: Long = WidgetClock.currentTimeMillis()): Long {
        if (startMinutes == 0) return 0L
        val cal = Calendar.getInstance().apply { timeInMillis = nowMillis }
        val nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)
        val diffMin = startMinutes - nowMin
        return if (diffMin > 0) diffMin * 60_000L else 0L
    }

    fun millisUntilEnd(nowMillis: Long = WidgetClock.currentTimeMillis()): Long {
        if (endMinutes == 0) return 0L
        val cal = Calendar.getInstance().apply { timeInMillis = nowMillis }
        val nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)
        val diffMin = endMinutes - nowMin
        return if (diffMin > 0) diffMin * 60_000L else 0L
    }

    fun toJson(): JSONObject = JSONObject().apply {
        put("mealName", mealName)
        put("timeRange", timeRange)
        put("mainItems", JSONArray(mainItems))
        put("staples", staples)
        put("dietType", dietType.name)
        put("startMinutes", startMinutes)
        put("endMinutes", endMinutes)
        put("items", JSONArray(items))
    }

    companion object {
        fun fromJson(json: JSONObject): MealItem {
            val mainItemsArr = json.optJSONArray("mainItems") ?: JSONArray()
            val mainList = mutableListOf<String>()
            for (i in 0 until mainItemsArr.length()) {
                mainList.add(mainItemsArr.optString(i))
            }

            val itemsArr = json.optJSONArray("items") ?: JSONArray()
            val itemsList = mutableListOf<String>()
            for (i in 0 until itemsArr.length()) {
                itemsList.add(itemsArr.optString(i))
            }

            val dietStr = json.optString("dietType", "VEG").uppercase()
            val dietType = try {
                DietType.valueOf(dietStr)
            } catch (_: Throwable) {
                DietType.VEG
            }

            val startH = json.optInt("startH", 0)
            val startM = json.optInt("startM", 0)
            val endH = json.optInt("endH", 0)
            val endM = json.optInt("endM", 0)

            val startMin = if (json.has("startMinutes")) json.optInt("startMinutes") else startH * 60 + startM
            val endMin = if (json.has("endMinutes")) json.optInt("endMinutes") else endH * 60 + endM

            return MealItem(
                mealName = json.optString("mealName", "Meal"),
                timeRange = json.optString("timeRange", ""),
                mainItems = mainList,
                staples = json.optString("staples", ""),
                dietType = dietType,
                startMinutes = startMin,
                endMinutes = endMin,
                items = itemsList
            )
        }
    }
}
