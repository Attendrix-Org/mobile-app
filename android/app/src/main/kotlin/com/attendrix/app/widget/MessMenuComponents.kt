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
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.attendrix.app.MainActivity

object MessMenuComponents {

    /**
     * Clean Mess Header without Sync button: Brand + Mess Name + Switch chip.
     */
    @Composable
    fun MessHeader(
        messName: String,
        contextTitle: String,
        isSyncing: Boolean = false
    ) {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(
                modifier = GlanceModifier
                    .defaultWeight()
                    .clickable(actionRunCallback<RefreshWidgetAction>())
            ) {
                Text(
                    text = "ATTENDRIX  •  ${messName.uppercase()}",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.Primary,
                        fontFamily = FontFamily.SansSerif
                    ),
                    maxLines = 1
                )
                Text(
                    text = contextTitle,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Title,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }

            // Cycle Mess chip with M3 >= 48dp touch target padding
            Box(
                modifier = GlanceModifier
                    .background(WidgetTokens.Colours.SurfaceVariant)
                    .cornerRadius(WidgetTokens.Radius.Chip)
                    .padding(horizontal = 12.dp, vertical = 8.dp)
                    .clickable(actionRunCallback<CycleMessAction>()),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Switch Mess",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    /**
     * Hero Active Card with M3 Expressive Tonal Container & 6dp Solid Accent Border.
     */
    @Composable
    fun MessHeroCard(meal: MealItem, nowMillis: Long, compact: Boolean = false) {
        val isLive = meal.isLive(nowMillis)
        val badgeText = if (isLive) "NOW SERVING" else "NEXT MEAL"
        val badgeBg = if (isLive) ColorProvider(Color(0xFF24A869)) else WidgetTokens.Colours.Primary
        val accentColor = if (isLive) Color(0xFF24A869) else Color(0xFF6F61EF)
        val cardBg = if (isLive) WidgetTokens.Colours.HeroContainerLive else WidgetTokens.Colours.HeroContainerUpcoming

        val countdownText = if (isLive) {
            val remMs = meal.millisUntilEnd(nowMillis)
            "Ends in ${formatMealCountdown(remMs)}"
        } else {
            val remMs = meal.millisUntilStart(nowMillis)
            "Starts in ${formatMealCountdown(remMs)}"
        }

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.Card),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Prominent 6dp solid vertical accent stripe
            Box(
                modifier = GlanceModifier
                    .width(6.dp)
                    .height(if (compact) 76.dp else 114.dp)
                    .background(ColorProvider(accentColor))
                    .cornerRadius(3.dp)
            ) {}

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(WidgetTokens.Spacing.md)
            ) {
                // Top Bar: Pill badge + Countdown + Diet chip
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = GlanceModifier
                            .background(badgeBg)
                            .cornerRadius(WidgetTokens.Radius.Chip)
                            .padding(horizontal = 10.dp, vertical = 3.dp)
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
                    Text(
                        text = countdownText,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontWeight = FontWeight.Medium,
                            color = ColorProvider(accentColor),
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    DietChip(meal.dietType)
                }

                Spacer(modifier = GlanceModifier.height(6.dp))

                // Meal Name + Time Range
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = meal.mealName,
                        style = TextStyle(
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    if (meal.timeRange.isNotBlank()) {
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
                }

                if (!compact) {
                    Spacer(modifier = GlanceModifier.height(6.dp))

                    // Main Dishes Bullet List (max 3 lines)
                    if (meal.mainItems.isNotEmpty()) {
                        meal.mainItems.take(3).forEach { item ->
                            Text(
                                text = "  • $item",
                                style = TextStyle(
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = WidgetTokens.Colours.TextPrimary,
                                    fontFamily = FontFamily.SansSerif
                                ),
                                maxLines = 1
                            )
                        }
                    }

                    // Staples Section with Thin Semi-transparent Horizontal Divider
                    if (meal.staples.isNotBlank()) {
                        Spacer(modifier = GlanceModifier.height(6.dp))
                        Box(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .height(1.dp)
                                .background(ColorProvider(Color(0x1F000000)))
                        ) {}
                        Spacer(modifier = GlanceModifier.height(4.dp))
                        Text(
                            text = "+ ${meal.staples}",
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Caption,
                                color = WidgetTokens.Colours.TextSecondary,
                                fontFamily = FontFamily.SansSerif
                            ),
                            maxLines = 1
                        )
                    } else if (meal.items.isNotEmpty()) {
                        Spacer(modifier = GlanceModifier.height(6.dp))
                        Box(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .height(1.dp)
                                .background(ColorProvider(Color(0x1F000000)))
                        ) {}
                        Spacer(modifier = GlanceModifier.height(4.dp))
                        Text(
                            text = meal.items.joinToString(" • "),
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Caption,
                                color = WidgetTokens.Colours.TextSecondary,
                                fontFamily = FontFamily.SansSerif
                            ),
                            maxLines = 1
                        )
                    }
                }
            }
        }
    }

    /**
     * Meal-Specific Tonal Card with 6dp Solid Accent Stripe (`▌`).
     */
    @Composable
    fun MessTimelineRow(meal: MealItem, accentIndex: Int = 0) {
        val (cardBg, accentColor) = when (meal.mealName.lowercase()) {
            "breakfast" -> Pair(WidgetTokens.Colours.BreakfastContainer, WidgetTokens.Colours.BreakfastAccent)
            "lunch" -> Pair(WidgetTokens.Colours.LunchContainer, WidgetTokens.Colours.LunchAccent)
            "snacks", "eveningtea", "tea" -> Pair(WidgetTokens.Colours.TeaContainer, WidgetTokens.Colours.TeaAccent)
            "dinner" -> Pair(WidgetTokens.Colours.DinnerContainer, WidgetTokens.Colours.DinnerAccent)
            else -> {
                val fallbackAccents = listOf(
                    WidgetTokens.Colours.BreakfastAccent,
                    WidgetTokens.Colours.LunchAccent,
                    WidgetTokens.Colours.TeaAccent,
                    WidgetTokens.Colours.DinnerAccent
                )
                Pair(WidgetTokens.Colours.Surface, fallbackAccents[accentIndex % fallbackAccents.size])
            }
        }

        val summaryItems = if (meal.mainItems.isNotEmpty()) {
            meal.mainItems.take(3).joinToString(", ")
        } else {
            meal.items.firstOrNull()
                ?.split(Regex("[,/]"))
                ?.take(3)
                ?.joinToString(", ")
                ?: ""
        }

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.InnerBlock),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Prominent 6dp M3 Meal Accent Stripe
            Box(
                modifier = GlanceModifier
                    .width(6.dp)
                    .height(42.dp)
                    .background(accentColor)
                    .cornerRadius(3.dp)
            ) {}

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp, vertical = 6.dp)
            ) {
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = meal.mealName,
                        style = TextStyle(
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        ),
                        modifier = GlanceModifier.defaultWeight()
                    )
                    if (meal.timeRange.isNotBlank()) {
                        Text(
                            text = meal.timeRange,
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Caption,
                                color = WidgetTokens.Colours.TextSecondary,
                                fontFamily = FontFamily.SansSerif
                            )
                        )
                        Spacer(modifier = GlanceModifier.width(6.dp))
                    }
                    DietChip(meal.dietType)
                }
                if (summaryItems.isNotBlank()) {
                    Text(
                        text = summaryItems,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        ),
                        maxLines = 1
                    )
                }
            }
        }
    }

    /**
     * M3 Tonal Dietary Micro-Badge with High Contrast Container/Text pairs.
     */
    @Composable
    fun DietChip(dietType: DietType) {
        val (label, bgColor, textColor) = when (dietType) {
            DietType.VEG -> Triple("VEG", WidgetTokens.Colours.VegChipBg, WidgetTokens.Colours.VegChipText)
            DietType.EGG -> Triple("EGG", WidgetTokens.Colours.EggChipBg, WidgetTokens.Colours.EggChipText)
            DietType.NON_VEG -> Triple("NON-VEG", WidgetTokens.Colours.NonVegChipBg, WidgetTokens.Colours.NonVegChipText)
        }

        Box(
            modifier = GlanceModifier
                .background(bgColor)
                .cornerRadius(WidgetTokens.Radius.Chip)
                .padding(horizontal = 8.dp, vertical = 3.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Micro,
                    fontWeight = FontWeight.Bold,
                    color = textColor,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }
}

/**
 * ActionCallback: Cycle through available messes by notifying Flutter.
 */
class CycleMessAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: androidx.glance.action.ActionParameters
    ) {
        WidgetBridge.notifyCycleMess(context)
    }
}
