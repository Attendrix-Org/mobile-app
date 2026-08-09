package com.attendrix.app.widget.messmenu

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
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
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.WidgetTokens
import com.attendrix.app.widget.core.EmptyState

// ---------------------------------------------------------------------------
// Small — single meal snapshot
// ---------------------------------------------------------------------------
@Composable
fun SmallMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val meal = state.currentMeal ?: state.nextMeal
    val isCurrent = state.currentMeal != null

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        if (meal != null) {
            // Status line: meal context + stale notice
            Row(
                modifier = GlanceModifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                val statusText = if (isCurrent) "${meal.mealName.uppercase()} · NOW" else "NEXT  ${meal.mealName.uppercase()}"
                Text(
                    text = statusText,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        fontWeight = FontWeight.Bold,
                        color = if (isCurrent) WidgetTokens.Colours.StatusLive else WidgetTokens.Colours.StatusNext,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                if (isStale && staleByMinutes > 0) {
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    val age = if (staleByMinutes >= 60) "${staleByMinutes / 60}h" else "${staleByMinutes}m"
                    Text(
                        text = age,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Label,
                            color = WidgetTokens.Colours.StatusWarning,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }

            Spacer(modifier = GlanceModifier.height(6.dp))

            // Primary: first main item
            val firstItem = meal.mainItems.firstOrNull() ?: meal.mealName
            Text(
                text = firstItem,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Hero,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            Spacer(modifier = GlanceModifier.defaultWeight())

            // Bottom: secondary items + diet badge
            Row(verticalAlignment = Alignment.CenterVertically) {
                val secondary = meal.mainItems.drop(1).take(2).joinToString(", ")
                if (secondary.isNotBlank()) {
                    Text(
                        text = secondary,
                        maxLines = 1,
                        modifier = GlanceModifier.defaultWeight(),
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Body,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.width(4.dp))
                }
                MessMenuWidgetComponents.DietBadge(meal.dietType)
            }
        } else {
            MessMenuWidgetComponents.MessEmptyStateContent(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}

// ---------------------------------------------------------------------------
// Medium — hero card, no separate header overhead
// ---------------------------------------------------------------------------
@Composable
fun MediumMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val meal = state.currentMeal ?: state.nextMeal
    val isCurrent = state.currentMeal != null

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        // Stale indicator — subtle, top-right aligned
        if (isStale && staleByMinutes > 0) {
            val ageText = if (staleByMinutes >= 60) "${staleByMinutes / 60}h ago" else "${staleByMinutes}m ago"
            Text(
                text = "STALE · $ageText",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Label,
                    color = WidgetTokens.Colours.StatusWarning,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(4.dp))
        }

        // Mess name as the page label
        if (state.messName.isNotBlank()) {
            Text(
                text = state.messName,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Label,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextMuted,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(6.dp))
        }

        if (meal != null) {
            MessMenuWidgetComponents.MealHeroCard(meal = meal, isCurrent = isCurrent)
        } else {
            MessMenuWidgetComponents.MessEmptyStateContent(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}

// ---------------------------------------------------------------------------
// Large — dominant current meal + slim next meal preview
// ---------------------------------------------------------------------------
@Composable
fun LargeMessMenuLayout(state: MessMenuWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val currentMeal = state.currentMeal ?: state.nextMeal
    val nextMeal = if (state.currentMeal != null) state.nextMeal else null
    val isCurrent = state.currentMeal != null

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        // Stale + mess name header line
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (state.messName.isNotBlank()) {
                Text(
                    text = state.messName,
                    maxLines = 1,
                    modifier = GlanceModifier.defaultWeight(),
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextMuted,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            } else {
                Spacer(modifier = GlanceModifier.defaultWeight())
            }
            if (isStale && staleByMinutes > 0) {
                val ageText = if (staleByMinutes >= 60) "${staleByMinutes / 60}h ago" else "${staleByMinutes}m ago"
                Text(
                    text = "STALE · $ageText",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        color = WidgetTokens.Colours.StatusWarning,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (currentMeal != null) {
            // Dominant current/next meal hero
            MessMenuWidgetComponents.MealHeroCard(meal = currentMeal, isCurrent = isCurrent)

            if (nextMeal != null) {
                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

                // Thin divider
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(WidgetTokens.Colours.Divider)
                ) {}

                Spacer(modifier = GlanceModifier.height(4.dp))

                // Slim next meal preview — lower visual weight
                MessMenuWidgetComponents.MealPreviewRow(meal = nextMeal)
            }
        } else {
            MessMenuWidgetComponents.MessEmptyStateContent(EmptyState.NO_MENU_AVAILABLE)
        }
    }
}
