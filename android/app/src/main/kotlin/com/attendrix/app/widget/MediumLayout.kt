package com.attendrix.app.widget

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.attendrix.app.MainActivity

@Composable
fun MediumLayout(state: WidgetState) {
    val now = System.currentTimeMillis()
    val hasLiveCurrent = state.hasValidLiveClass(now)
    val current = state.currentClass
    val next = state.nextClass

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        WidgetComponents.Header(
            contextTitle = if (hasLiveCurrent) "Current Class" else "Upcoming Classes",
            isSyncing = state.state == "Loading"
        )

        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

        if (hasLiveCurrent && current != null) {
            // MODE 1: Current Class Exists
            val total = (current.endMillis - current.startMillis).coerceAtLeast(1L)
            val progress = ((now - current.startMillis).toDouble() / total.toDouble()).coerceIn(0.0, 1.0)
            val remainingMin = ((current.endMillis - now) / 60000L).coerceAtLeast(0L).toInt()

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .background(WidgetTokens.Colours.Surface)
                    .cornerRadius(WidgetTokens.Radius.InnerBlock)
                    .padding(WidgetTokens.Spacing.md)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    WidgetComponents.StatusChip(status = WidgetStatus.LIVE, isAbsent = current.isAbsent)
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    WidgetComponents.DynamicAttendancePill(current.attendance)
                }

                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))

                Text(
                    text = current.courseName,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.ClassHeader,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    ),
                    maxLines = 1
                )

                Text(
                    text = current.venue,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    ),
                    maxLines = 1
                )

                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))
                WidgetComponents.ProgressSection(progress = progress, remainingMin = remainingMin)

                if (next != null) {
                    Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                    Row(
                        modifier = GlanceModifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Up Next: ${next.courseName}",
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Caption,
                                fontWeight = FontWeight.Medium,
                                color = WidgetTokens.Colours.TextSecondary,
                                fontFamily = FontFamily.SansSerif
                            ),
                            maxLines = 1,
                            modifier = GlanceModifier.defaultWeight()
                        )
                        Text(
                            text = formatCountdown(next.startMillis, now),
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
        } else {
            // MODE 2: No Current Class Exists -> Render Hero Card + 1 Upcoming Timeline Row
            val upcomingList = mutableListOf<WidgetClass>()
            if (state.nextClass != null) upcomingList.add(state.nextClass)
            upcomingList.addAll(state.upcomingRows)

            if (upcomingList.isNotEmpty()) {
                val heroClass = upcomingList.first()
                WidgetComponents.UpcomingHeroCard(item = heroClass, nowMillis = now)

                if (upcomingList.size > 1) {
                    Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                    WidgetComponents.UpcomingTimelineRow(item = upcomingList[1], nowMillis = now, accentIndex = 0)
                }
            } else {
                WidgetComponents.ContextualEmptyStateView(state.emptyReason)
            }
        }

        Spacer(modifier = GlanceModifier.defaultWeight())
        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}
