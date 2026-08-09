package com.attendrix.app.widget.messmenu

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.RefreshWidgetAction
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetTokens
import com.attendrix.app.widget.model.DietType

object MessMenuWidgetComponents {

    @Composable
    fun Header(messName: String, isStale: Boolean = false) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .clickable(actionRunCallback<RefreshWidgetAction>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = GlanceModifier.defaultWeight()) {
                Text(
                    text = if (isStale) "MESS MENU • STALE" else "MESS MENU",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = if (isStale) WidgetTokens.Colours.Warning else WidgetTokens.Colours.Primary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Text(
                    text = messName,
                    maxLines = 1,
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
    fun DietBadge(dietType: DietType) {
        val (label, bgColor, textColor) = when (dietType) {
            DietType.VEG -> Triple("VEG", ColorProvider(Color(0xFFDCFCE7)), ColorProvider(Color(0xFF166534)))
            DietType.EGG -> Triple("EGG", ColorProvider(Color(0xFFFEF3C7)), ColorProvider(Color(0xFFB45309)))
            DietType.NON_VEG -> Triple("NON-VEG", ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)))
            DietType.SPECIAL -> Triple("SPECIAL", ColorProvider(Color(0xFFEDE7F6)), ColorProvider(Color(0xFF6D28D9)))
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
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    color = textColor,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }

    @Composable
    fun MealHeroCard(meal: com.attendrix.app.widget.model.MealItem, isCurrent: Boolean = true) {
        val mainDishes = meal.mainItems.take(2).joinToString(", ")
        val staplesStr = meal.staples.ifBlank { meal.mainItems.drop(2).joinToString(", ") }
        val remainingCount = (meal.mainItems.size - 2).coerceAtLeast(0)

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(if (isCurrent) WidgetTokens.Colours.HeroContainerLive else WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(WidgetTokens.Spacing.md)
                .clickable(actionStartActivity<MainActivity>())
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = meal.mealName.uppercase(),
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Spacer(modifier = GlanceModifier.width(6.dp))
                DietBadge(meal.dietType)
                Spacer(modifier = GlanceModifier.defaultWeight())
                Text(
                    text = meal.timeRange,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }

            Spacer(modifier = GlanceModifier.height(6.dp))

            Text(
                text = mainDishes.ifBlank { "Menu items scheduled" },
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            if (staplesStr.isNotBlank()) {
                Spacer(modifier = GlanceModifier.height(2.dp))
                Text(
                    text = if (remainingCount > 0) "$staplesStr • +$remainingCount more" else staplesStr,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    @Composable
    fun ContextualMessEmptyStateView(reason: EmptyState) {
        val (title, description) = when (reason) {
            EmptyState.NO_MESS_SELECTED -> Pair("Select Mess", "Choose your mess in Attendrix.")
            EmptyState.NO_MENU_AVAILABLE -> Pair("No Menu", "Today's menu isn't available.")
            EmptyState.HOLIDAY -> Pair("Mess Closed", "Mess is closed for holiday today.")
            else -> Pair("No Menu Available", "Open Attendrix to sync mess menu.")
        }

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(WidgetTokens.Spacing.md),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = title,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(4.dp))
            Text(
                text = description,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    color = WidgetTokens.Colours.TextSecondary,
                    textAlign = TextAlign.Center,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }
}
