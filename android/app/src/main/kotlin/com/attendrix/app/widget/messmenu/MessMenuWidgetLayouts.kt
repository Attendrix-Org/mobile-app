package com.attendrix.app.widget.messmenu

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.classschedule.ClassWidgetComponents
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.MessMenuWidgetState
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetTokens

@Composable
fun SmallMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val activeMeal = state.currentMeal ?: state.nextMeal ?: state.todayMeals.firstOrNull()
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        MessMenuWidgetComponents.MessMenuHeader(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(4.dp))

        if (activeMeal != null) {
            Text(
                text = activeMeal.mealName,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            val mainText = if (activeMeal.mainItems.isNotEmpty()) activeMeal.mainItems.joinToString(", ") else activeMeal.staples
            Text(
                text = mainText,
                maxLines = 2,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Caption,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}

@Composable
fun MediumMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val activeMeal = state.currentMeal ?: state.nextMeal ?: state.todayMeals.firstOrNull()
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        MessMenuWidgetComponents.MessMenuHeader(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeMeal != null) {
            MessMenuWidgetComponents.HeroMealCard(meal = activeMeal, nowMillis = nowMillis)
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}

@Composable
fun LargeMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val activeMeal = state.currentMeal ?: state.nextMeal ?: state.todayMeals.firstOrNull()
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        MessMenuWidgetComponents.MessMenuHeader(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeMeal != null) {
            MessMenuWidgetComponents.HeroMealCard(meal = activeMeal, nowMillis = nowMillis)

            Spacer(modifier = GlanceModifier.height(6.dp))

            state.todayMeals.filter { it.mealName != activeMeal.mealName }.take(2).forEach { meal ->
                MessMenuWidgetComponents.MealRowItem(meal = meal)
                Spacer(modifier = GlanceModifier.height(4.dp))
            }
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}
