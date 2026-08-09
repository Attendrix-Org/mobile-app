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
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.attendrix.app.MainActivity
import com.attendrix.app.widget.RefreshWidgetAction
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetTokens
import com.attendrix.app.widget.model.DietType
import com.attendrix.app.widget.model.MealItem

object MessMenuWidgetComponents {

    @Composable
    fun MessMenuHeader(
        messName: String,
        isStale: Boolean = false
    ) {
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
    fun HeroMealCard(meal: MealItem, nowMillis: Long = WidgetClock.currentTimeMillis()) {
        val isLive = meal.isLive(nowMillis)
        val cardBg = if (isLive) WidgetTokens.Colours.HeroContainerLive else WidgetTokens.Colours.HeroContainerUpcoming
        val accentColor = if (isLive) Color(0xFF24A869) else Color(0xFF6F61EF)
        val badgeText = if (isLive) "SERVED NOW" else "NEXT MEAL"

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.Card)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = GlanceModifier
                    .width(6.dp)
                    .height(130.dp)
                    .background(ColorProvider(accentColor))
                    .cornerRadius(3.dp)
            ) {}

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(WidgetTokens.Spacing.md)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = GlanceModifier
                            .background(ColorProvider(accentColor))
                            .cornerRadius(WidgetTokens.Radius.Chip)
                            .padding(horizontal = 8.dp, vertical = 3.dp)
                    ) {
                        Text(
                            text = badgeText,
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Micro,
                                fontWeight = FontWeight.Bold,
                                color = ColorProvider(Color(0xFFFFFFFF)),
                                fontFamily = FontFamily.SansSerif
                            )
                        )
                    }

                    Spacer(modifier = GlanceModifier.width(8.dp))
                    DietBadge(dietType = meal.dietType)

                    Spacer(modifier = GlanceModifier.defaultWeight())
                    Text(
                        text = meal.timeRange,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Micro,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }

                Spacer(modifier = GlanceModifier.height(4.dp))

                Text(
                    text = meal.mealName,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Title,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                Spacer(modifier = GlanceModifier.height(2.dp))

                val mainText = if (meal.mainItems.isNotEmpty()) meal.mainItems.joinToString(", ") else "Special Menu"
                Text(
                    text = mainText,
                    maxLines = 2,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                if (meal.staples.isNotBlank()) {
                    Spacer(modifier = GlanceModifier.height(2.dp))
                    Text(
                        text = "Staples: ${meal.staples}",
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
    }

    @Composable
    fun DietBadge(dietType: DietType) {
        val (bgColor, textColor, label) = when (dietType) {
            DietType.VEG -> Triple(ColorProvider(Color(0xFFDCFCE7)), ColorProvider(Color(0xFF166534)), "VEG")
            DietType.EGG -> Triple(ColorProvider(Color(0xFFFEF3C7)), ColorProvider(Color(0xFFB45309)), "EGG")
            DietType.NON_VEG -> Triple(ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)), "NON-VEG")
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
    fun MealRowItem(meal: MealItem) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(horizontal = WidgetTokens.Spacing.md, vertical = 8.dp)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = GlanceModifier.defaultWeight()) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = meal.mealName,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Body,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.width(6.dp))
                    DietBadge(dietType = meal.dietType)
                }
                Text(
                    text = if (meal.mainItems.isNotEmpty()) meal.mainItems.joinToString(", ") else meal.staples,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }

            Spacer(modifier = GlanceModifier.width(6.dp))

            Text(
                text = meal.timeRange,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Micro,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }
}
