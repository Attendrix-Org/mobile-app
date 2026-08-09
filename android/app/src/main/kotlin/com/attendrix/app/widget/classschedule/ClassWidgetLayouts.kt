package com.attendrix.app.widget.classschedule

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
import com.attendrix.app.widget.core.WidgetClock

@Composable
fun SmallClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false) {
    val targetClass = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        if (targetClass != null) {
            val isLive = targetClass.isLive(nowMillis)
            val badgeLabel = if (isLive) "LIVE" else "NEXT"
            val countdownFmt = if (isLive) {
                "${WidgetClock.remainingMinutes(targetClass.endMillis, nowMillis)} min left"
            } else {
                "in ${WidgetClock.formatCountdown(targetClass.startMillis, nowMillis)}"
            }

            ClassWidgetComponents.Header(
                contextTitle = badgeLabel,
                isStale = isStale
            )

            Spacer(modifier = GlanceModifier.height(4.dp))

            Text(
                text = targetClass.courseName,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            Spacer(modifier = GlanceModifier.height(4.dp))

            Text(
                text = targetClass.venue.ifBlank { "TBD" },
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            Spacer(modifier = GlanceModifier.defaultWeight())

            Text(
                text = countdownFmt,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Caption,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.Primary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        } else {
            ClassWidgetComponents.Header(
                contextTitle = "DONE",
                isStale = isStale
            )
            Spacer(modifier = GlanceModifier.height(4.dp))
            Text(
                text = "No more classes",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.defaultWeight())
            Text(
                text = "Today",
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
fun MediumClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false) {
    val activeClass = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        ClassWidgetComponents.Header(
            contextTitle = if (state.currentClass != null) "Live Class" else "Next Class",
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeClass != null) {
            ClassWidgetComponents.UpcomingHeroCard(
                item = activeClass,
                progress = state.progress,
                nowMillis = nowMillis
            )
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(EmptyState.NO_CLASSES)
        }
    }
}

@Composable
fun LargeClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false) {
    val activeClass = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        ClassWidgetComponents.Header(
            contextTitle = "Timeline",
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeClass != null) {
            ClassWidgetComponents.UpcomingHeroCard(
                item = activeClass,
                progress = state.progress,
                nowMillis = nowMillis
            )
            Spacer(modifier = GlanceModifier.height(8.dp))

            state.upcomingRows.take(2).forEach { row ->
                ClassWidgetComponents.ClassRowItem(item = row, nowMillis = nowMillis)
                Spacer(modifier = GlanceModifier.height(4.dp))
            }
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(EmptyState.NO_CLASSES)
        }
    }
}
