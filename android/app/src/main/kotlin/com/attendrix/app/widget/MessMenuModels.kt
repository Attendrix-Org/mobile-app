package com.attendrix.app.widget

import org.json.JSONArray
import org.json.JSONObject

enum class DietType {
    VEG,
    EGG,
    NON_VEG
}

data class MealItem(
    val mealName: String,
    val timeRange: String = "",
    // Parsed fields from Dart payload
    val mainItems: List<String> = emptyList(),
    val staples: String = "",
    val dietType: DietType = DietType.VEG,
    // Operating window in 24h minutes-since-midnight for time-aware context
    val startMinutes: Int = 0,
    val endMinutes: Int = 0,
    // Legacy field
    val items: List<String> = emptyList()
) {
    /** True if this meal is currently being served. */
    fun isLive(nowMillis: Long): Boolean {
        if (startMinutes == 0 && endMinutes == 0) return false
        val cal = java.util.Calendar.getInstance()
        cal.timeInMillis = nowMillis
        val nowMin = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + cal.get(java.util.Calendar.MINUTE)
        return nowMin in startMinutes until endMinutes
    }

    /** Milliseconds until this meal starts (0 if already started or passed). */
    fun millisUntilStart(nowMillis: Long): Long {
        if (startMinutes == 0) return 0L
        val cal = java.util.Calendar.getInstance()
        cal.timeInMillis = nowMillis
        val nowMin = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + cal.get(java.util.Calendar.MINUTE)
        val diffMin = startMinutes - nowMin
        return if (diffMin > 0) diffMin * 60_000L else 0L
    }

    /** Milliseconds until this meal ends (0 if not live or passed). */
    fun millisUntilEnd(nowMillis: Long): Long {
        if (endMinutes == 0) return 0L
        val cal = java.util.Calendar.getInstance()
        cal.timeInMillis = nowMillis
        val nowMin = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + cal.get(java.util.Calendar.MINUTE)
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
            // Parse mainItems
            val mainItemsArray = json.optJSONArray("mainItems") ?: JSONArray()
            val mainItemsList = mutableListOf<String>()
            for (i in 0 until mainItemsArray.length()) {
                val s = mainItemsArray.optString(i)
                if (s.isNotBlank()) mainItemsList.add(s.trim())
            }

            // Parse legacy items
            val itemsArray = json.optJSONArray("items") ?: JSONArray()
            val itemsList = mutableListOf<String>()
            for (i in 0 until itemsArray.length()) {
                itemsList.add(itemsArray.optString(i))
            }

            // If mainItems is empty, derive from first legacy item split by comma/slash
            val effectiveMain = if (mainItemsList.isNotEmpty()) {
                mainItemsList
            } else if (itemsList.isNotEmpty()) {
                itemsList.first()
                    .split(Regex("[,/]"))
                    .map { it.trim() }
                    .filter { it.isNotBlank() }
            } else {
                emptyList()
            }

            val staplesRaw = json.optString("staples", "").trim()
            // If staples not in payload, derive from second legacy item
            val effectiveStaples = if (staplesRaw.isNotBlank()) {
                staplesRaw
            } else if (itemsList.size > 1) {
                itemsList.drop(1).joinToString(", ")
            } else {
                ""
            }

            // Diet classification: prefer Dart-sent type, fall back to inference
            val dietStr = json.optString("dietType", "").uppercase()
            val dietType = when (dietStr) {
                "NON_VEG", "NON-VEG" -> DietType.NON_VEG
                "EGG" -> DietType.EGG
                "VEG" -> DietType.VEG
                else -> {
                    // Infer from mainItems + legacy items
                    val allText = (effectiveMain + itemsList).joinToString(" ").lowercase()
                    when {
                        allText.contains("chicken") || allText.contains("mutton") ||
                        allText.contains("fish") || allText.contains("prawns") ||
                        allText.contains("beef") || allText.contains("meat") -> DietType.NON_VEG
                        allText.contains("egg") || allText.contains("burjee") ||
                        allText.contains("omelette") -> DietType.EGG
                        else -> DietType.VEG
                    }
                }
            }

            // Time window in minutes-since-midnight
            val startH = json.optInt("startH", 0)
            val startM = json.optInt("startM", 0)
            val endH = json.optInt("endH", 0)
            val endM = json.optInt("endM", 0)
            val startMinutes = json.optInt("startMinutes", startH * 60 + startM)
            val endMinutes = json.optInt("endMinutes", endH * 60 + endM)

            return MealItem(
                mealName = json.optString("mealName", ""),
                timeRange = json.optString("timeRange", ""),
                mainItems = effectiveMain,
                staples = effectiveStaples,
                dietType = dietType,
                startMinutes = startMinutes,
                endMinutes = endMinutes,
                items = itemsList
            )
        }
    }
}

data class MessMenuWidgetState(
    val version: Int = 5,
    val widgetType: String = "mess_menu",
    val state: String = "Ready",
    val emptyReason: EmptyState = EmptyState.NO_CLASSES,
    val messName: String = "Mess Menu",
    val currentMeal: MealItem? = null,
    val nextMeal: MealItem? = null,
    val todayMeals: List<MealItem> = emptyList(),
    val updatedAtMillis: Long = System.currentTimeMillis()
) {
    companion object {
        fun fromJson(rawJson: String): MessMenuWidgetState {
            if (rawJson.isBlank()) {
                return MessMenuWidgetState(state = "Loading")
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

                val messName = json.optString("messName", "Mess Menu")

                val currentMealObj = json.optJSONObject("currentMeal")
                val currentMeal = currentMealObj?.let { MealItem.fromJson(it) }

                val nextMealObj = json.optJSONObject("nextMeal")
                val nextMeal = nextMealObj?.let { MealItem.fromJson(it) }

                val mealsArray = json.optJSONArray("todayMeals") ?: JSONArray()
                val todayMeals = mutableListOf<MealItem>()
                for (i in 0 until mealsArray.length()) {
                    val obj = mealsArray.optJSONObject(i)
                    if (obj != null) {
                        todayMeals.add(MealItem.fromJson(obj))
                    }
                }

                val updatedAtMillis = json.optLong("updatedAtMillis", System.currentTimeMillis())

                MessMenuWidgetState(
                    version = 5,
                    widgetType = "mess_menu",
                    state = stateStr,
                    emptyReason = emptyReason,
                    messName = messName,
                    currentMeal = currentMeal,
                    nextMeal = nextMeal,
                    todayMeals = todayMeals,
                    updatedAtMillis = updatedAtMillis
                )
            } catch (e: Throwable) {
                MessMenuWidgetState(state = "Loading")
            }
        }
    }
}

/** Format a minutes-since-midnight countdown into "5h 28m" or "42 min". */
fun formatMealCountdown(millisRemaining: Long): String {
    val totalMin = (millisRemaining / 60_000L).coerceAtLeast(0L)
    return when {
        totalMin >= 60 -> "${totalMin / 60}h ${totalMin % 60}m"
        else -> "${totalMin} min"
    }
}
