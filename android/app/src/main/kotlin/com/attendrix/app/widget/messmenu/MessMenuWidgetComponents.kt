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
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.WidgetTokens
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.model.DietType
import com.attendrix.app.widget.model.MealItem

object MessMenuWidgetComponents {

    /**
     * Compact diet badge — explicit text label, color reinforces but is not the only signal.
     */
    @Composable
    fun DietBadge(dietType: DietType) {
        val (label, bgColor, textColor) = when (dietType) {
            DietType.VEG     -> Triple("VEG",     WidgetTokens.Colours.DietVegBg,     WidgetTokens.Colours.DietVegText)
            DietType.EGG     -> Triple("EGG",     WidgetTokens.Colours.DietEggBg,     WidgetTokens.Colours.DietEggText)
            DietType.NON_VEG -> Triple("NON-VEG", WidgetTokens.Colours.DietNonVegBg,  WidgetTokens.Colours.DietNonVegText)
            DietType.SPECIAL -> Triple("SPECIAL", WidgetTokens.Colours.DietSpecialBg, WidgetTokens.Colours.DietSpecialText)
        }

        Box(
            modifier = GlanceModifier
                .background(bgColor)
                .cornerRadius(WidgetTokens.Radius.Chip)
                .padding(horizontal = 6.dp, vertical = 2.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Label,
                    fontWeight = FontWeight.Bold,
                    color = textColor,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }

    /**
     * Hero card for the current or next meal.
     * isCurrent = true  → accent colored card (live/active)
     * isCurrent = false → flat dim card (upcoming preview)
     */
    @Composable
    fun MealHeroCard(meal: MealItem, isCurrent: Boolean = true) {
        val cardBg = if (isCurrent) WidgetTokens.Colours.HeroLiveBg else WidgetTokens.Colours.SurfaceDim
        val accentBg = if (isCurrent) WidgetTokens.Colours.HeroLiveAccent else WidgetTokens.Colours.Divider

        // Food content: top 2 main items individually, then staples line
        val topItems = meal.mainItems.take(2)
        val staplesLine = meal.staples.ifBlank {
            meal.mainItems.drop(2).take(3).joinToString(", ")
        }
        val overflowCount = (meal.mainItems.size - 2).coerceAtLeast(0)

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.Card)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.Top
        ) {
            // Left accent bar
            Box(
                modifier = GlanceModifier
                    .width(5.dp)
                    .fillMaxHeight()
                    .background(accentBg)
            ) {}

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(horizontal = WidgetTokens.Spacing.md, vertical = WidgetTokens.Spacing.sm)
            ) {
                // Meal name row — diet badge trailing, time on far right
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = meal.mealName.uppercase(),
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Label,
                            fontWeight = FontWeight.Bold,
                            color = if (isCurrent) WidgetTokens.Colours.StatusLive else WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.width(6.dp))
                    DietBadge(meal.dietType)
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    if (meal.timeRange.isNotBlank()) {
                        Text(
                            text = meal.timeRange,
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Label,
                                color = WidgetTokens.Colours.TextMuted,
                                fontFamily = FontFamily.SansSerif
                            )
                        )
                    }
                }

                Spacer(modifier = GlanceModifier.height(4.dp))

                // Each top main item on its own line for better readability
                topItems.forEach { item ->
                    Text(
                        text = item,
                        maxLines = 1,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Hero,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }

                // Staples line + overflow
                if (staplesLine.isNotBlank() || overflowCount > 0) {
                    Spacer(modifier = GlanceModifier.height(2.dp))
                    val secondLine = buildString {
                        if (staplesLine.isNotBlank()) append(staplesLine)
                        if (overflowCount > 0) {
                            if (staplesLine.isNotBlank()) append(" · ")
                            append("+$overflowCount more")
                        }
                    }
                    Text(
                        text = secondLine,
                        maxLines = 1,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Body,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }

    /**
     * Slim preview row for "next meal" in Large layout.
     * Lower visual weight than the hero card.
     */
    @Composable
    fun MealPreviewRow(meal: MealItem) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .padding(vertical = 6.dp)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = GlanceModifier.defaultWeight()) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = "NEXT  ${meal.mealName.uppercase()}",
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Label,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextMuted,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.width(6.dp))
                    DietBadge(meal.dietType)
                }
                if (meal.mainItems.isNotEmpty()) {
                    Spacer(modifier = GlanceModifier.height(2.dp))
                    Text(
                        text = meal.mainItems.take(2).joinToString(", "),
                        maxLines = 1,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Body,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
            if (meal.timeRange.isNotBlank()) {
                Spacer(modifier = GlanceModifier.width(WidgetTokens.Spacing.sm))
                Text(
                    text = meal.timeRange,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        color = WidgetTokens.Colours.TextMuted,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    /**
     * Flat empty/error state — no inner card, left-aligned for widget context.
     */
    @Composable
    fun MessEmptyStateContent(reason: EmptyState) {
        val (headline, sub, action) = when (reason) {
            EmptyState.NO_MESS_SELECTED  -> Triple("Mess not set", "Choose your mess in Attendrix", "Open Attendrix")
            EmptyState.MESS_MISSING      -> Triple("Mess unavailable", "Selected mess not found", "Open Attendrix")
            EmptyState.NO_MENU_AVAILABLE -> Triple("No menu today", "Today's menu isn't available", null)
            EmptyState.HOLIDAY           -> Triple("Mess closed", "No service today", null)
            else                         -> Triple("No menu", "Open Attendrix to sync", "Open Attendrix")
        }

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .clickable(actionStartActivity<MainActivity>()),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = headline,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Hero,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
            Text(
                text = sub,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            if (action != null) {
                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))
                Text(
                    text = action,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.Primary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }
}
