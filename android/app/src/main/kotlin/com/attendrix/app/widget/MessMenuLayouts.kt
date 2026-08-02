package com.attendrix.app.widget

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.attendrix.app.MainActivity

// ─────────────────────────────────────────────────────────────────
// Small: Hero Card only
// ─────────────────────────────────────────────────────────────────
@Composable
fun SmallMessMenuLayout(state: MessMenuWidgetState) {
    val now = System.currentTimeMillis()
    val activeMeal = resolveHeroMeal(state, now)
    val isLive = activeMeal?.isLive(now) == true

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        MessMenuComponents.MessHeader(
            messName = state.messName,
            contextTitle = if (isLive) "Now Serving" else "Next Meal",
            isSyncing = state.state == "Loading"
        )
        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

        if (activeMeal != null) {
            MessMenuComponents.MessHeroCard(meal = activeMeal, nowMillis = now, compact = true)
        } else {
            WidgetComponents.ContextualEmptyStateView(state.emptyReason)
        }

        Spacer(modifier = GlanceModifier.defaultWeight())
        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}

// ─────────────────────────────────────────────────────────────────
// Medium: Hero Card + 1 secondary meal row
// ─────────────────────────────────────────────────────────────────
@Composable
fun MediumMessMenuLayout(state: MessMenuWidgetState) {
    val now = System.currentTimeMillis()
    val activeMeal = resolveHeroMeal(state, now)
    val isLive = activeMeal?.isLive(now) == true
    val secondaryMeals = resolveSecondaryMeals(state, activeMeal)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        MessMenuComponents.MessHeader(
            messName = state.messName,
            contextTitle = if (isLive) "Now Serving" else "Next Meal",
            isSyncing = state.state == "Loading"
        )
        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

        if (activeMeal != null) {
            MessMenuComponents.MessHeroCard(meal = activeMeal, nowMillis = now)

            val secondary = secondaryMeals.take(1)
            if (secondary.isNotEmpty()) {
                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                Column(modifier = GlanceModifier.fillMaxWidth().defaultWeight()) {
                    secondary.forEachIndexed { idx, meal ->
                        MessMenuComponents.MessTimelineRow(meal = meal, accentIndex = idx)
                        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                    }
                }
            }
        } else {
            WidgetComponents.ContextualEmptyStateView(state.emptyReason)
        }

        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}

// ─────────────────────────────────────────────────────────────────
// Large: Hero Card + all remaining meal rows
// ─────────────────────────────────────────────────────────────────
@Composable
fun LargeMessMenuLayout(state: MessMenuWidgetState) {
    val now = System.currentTimeMillis()
    val activeMeal = resolveHeroMeal(state, now)
    val isLive = activeMeal?.isLive(now) == true
    val secondaryMeals = resolveSecondaryMeals(state, activeMeal)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        MessMenuComponents.MessHeader(
            messName = state.messName,
            contextTitle = "Today's Menu",
            isSyncing = state.state == "Loading"
        )
        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

        if (activeMeal != null) {
            // HERO CARD: Content-wrapped height (fillMaxWidth only, NO fillMaxHeight/defaultWeight)
            MessMenuComponents.MessHeroCard(meal = activeMeal, nowMillis = now)

            if (secondaryMeals.isNotEmpty()) {
                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))
                // AGENDA LIST: absorbs remaining vertical space via defaultWeight
                Column(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .defaultWeight()
                ) {
                    secondaryMeals.forEachIndexed { idx, meal ->
                        MessMenuComponents.MessTimelineRow(meal = meal, accentIndex = idx)
                        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                    }
                }
            }
        } else {
            WidgetComponents.ContextualEmptyStateView(state.emptyReason)
        }

        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}

// ─────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────

/** Picks the correct hero meal: live meal if any, otherwise next upcoming meal. */
private fun resolveHeroMeal(state: MessMenuWidgetState, nowMillis: Long): MealItem? {
    // Prefer explicitly set currentMeal if it's actually live right now
    if (state.currentMeal != null && state.currentMeal.isLive(nowMillis)) return state.currentMeal
    // Fall back to next meal
    if (state.nextMeal != null) return state.nextMeal
    // If no explicit next, pick first future meal from todayMeals
    return state.todayMeals.firstOrNull { meal ->
        val cal = java.util.Calendar.getInstance()
        cal.timeInMillis = nowMillis
        val nowMin = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + cal.get(java.util.Calendar.MINUTE)
        nowMin < meal.startMinutes || meal.isLive(nowMillis)
    }
}

/** Returns meals from todayMeals that are NOT the hero meal. */
private fun resolveSecondaryMeals(state: MessMenuWidgetState, heroMeal: MealItem?): List<MealItem> {
    if (heroMeal == null) return emptyList()
    return state.todayMeals.filter { it.mealName != heroMeal.mealName }
}
