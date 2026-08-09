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
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.WidgetTokens

@Composable
fun SmallMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val meal = state.currentMeal ?: state.nextMeal

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        MessMenuWidgetComponents.Header(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(4.dp))

        if (meal != null) {
            Text(
                text = meal.mealName.uppercase(),
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Caption,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.Primary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(2.dp))
            Text(
                text = meal.mainItems.firstOrNull() ?: "Meal items",
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(2.dp))
            Text(
                text = meal.mainItems.drop(1).take(2).joinToString(", "),
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Caption,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        } else {
            Text(
                text = "No Menu",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }
}

@Composable
fun MediumMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val meal = state.currentMeal ?: state.nextMeal

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        MessMenuWidgetComponents.Header(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (meal != null) {
            MessMenuWidgetComponents.MealHeroCard(meal = meal, isCurrent = state.currentMeal != null)
        } else {
            MessMenuWidgetComponents.ContextualMessEmptyStateView(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}

@Composable
fun LargeMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false) {
    val meal = state.currentMeal ?: state.nextMeal
    val nextMeal = if (state.currentMeal != null) state.nextMeal else null

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        MessMenuWidgetComponents.Header(
            messName = state.messName,
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (meal != null) {
            MessMenuWidgetComponents.MealHeroCard(meal = meal, isCurrent = true)
            if (nextMeal != null) {
                Spacer(modifier = GlanceModifier.height(8.dp))
                MessMenuWidgetComponents.MealHeroCard(meal = nextMeal, isCurrent = false)
            }
        } else {
            MessMenuWidgetComponents.ContextualMessEmptyStateView(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}
