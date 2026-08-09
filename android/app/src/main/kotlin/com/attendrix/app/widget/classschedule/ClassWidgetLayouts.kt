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
import com.attendrix.app.widget.core.ClassWidgetState
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetTokens

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
        ClassWidgetComponents.Header(
            contextTitle = if (targetClass?.isLive(nowMillis) == true) "Live" else "Schedule",
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(4.dp))

        if (targetClass != null) {
            val isLive = targetClass.isLive(nowMillis)
            val countdownFmt = if (isLive) {
                "${WidgetClock.remainingMinutes(targetClass.endMillis, nowMillis)}m left"
            } else {
                WidgetClock.formatCountdown(targetClass.startMillis, nowMillis)
            }

            Text(
                text = targetClass.courseName,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            Spacer(modifier = GlanceModifier.height(2.dp))

            Text(
                text = "${targetClass.venue.ifBlank { "TBD" }} • $countdownFmt",
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Caption,
                    fontWeight = FontWeight.Medium,
                    color = WidgetTokens.Colours.Primary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(com.attendrix.app.widget.core.EmptyState.NO_CLASSES)
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
            contextTitle = if (state.currentClass != null) "Live Class" else "Schedule",
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeClass != null) {
            ClassWidgetComponents.UpcomingHeroCard(item = activeClass, nowMillis = nowMillis)
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(com.attendrix.app.widget.core.EmptyState.NO_CLASSES)
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
            contextTitle = "Daily Schedule",
            isStale = isStale
        )

        Spacer(modifier = GlanceModifier.height(6.dp))

        if (activeClass != null) {
            ClassWidgetComponents.UpcomingHeroCard(item = activeClass, nowMillis = nowMillis)
            Spacer(modifier = GlanceModifier.height(8.dp))

            state.upcomingRows.take(2).forEach { row ->
                ClassWidgetComponents.ClassRowItem(item = row, nowMillis = nowMillis)
                Spacer(modifier = GlanceModifier.height(4.dp))
            }
        } else {
            ClassWidgetComponents.ContextualEmptyStateView(com.attendrix.app.widget.core.EmptyState.NO_CLASSES)
        }
    }
}
