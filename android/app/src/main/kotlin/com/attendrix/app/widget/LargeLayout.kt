package com.attendrix.app.widget

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
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import com.attendrix.app.MainActivity

@Composable
fun LargeLayout(state: WidgetState) {
    val now = System.currentTimeMillis()
    val hasLiveCurrent = state.hasValidLiveClass(now)
    val current = state.currentClass

    val upcomingList = mutableListOf<WidgetClass>()
    if (state.nextClass != null) upcomingList.add(state.nextClass)
    upcomingList.addAll(state.upcomingRows)

    val heroClass = if (hasLiveCurrent && current != null) current else upcomingList.firstOrNull()
    val remainingClasses = if (hasLiveCurrent && current != null) upcomingList else upcomingList.drop(1)

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        // 1. Header
        WidgetComponents.Header(
            contextTitle = if (hasLiveCurrent) "Current Class" else "Upcoming Classes",
            isSyncing = state.state == "Loading"
        )

        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

        // 2. HERO CARD (Content-wrapped height ONLY)
        if (heroClass != null) {
            WidgetComponents.UpcomingHeroCard(
                item = heroClass,
                nowMillis = now,
                overallAttendance = state.overallAttendancePercentage
            )
            Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))
        }

        // 3. SECONDARY AGENDA LIST (Takes defaultWeight to fill remaining space)
        if (remainingClasses.isNotEmpty()) {
            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .defaultWeight()
            ) {
                remainingClasses.take(3).forEachIndexed { idx, classItem ->
                    WidgetComponents.UpcomingTimelineRow(
                        item = classItem,
                        nowMillis = now,
                        accentIndex = idx
                    )
                    Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))
                }
            }
        } else if (heroClass == null) {
            WidgetComponents.ContextualEmptyStateView(state.emptyReason)
        }

        Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.xs))

        // 4. Footer
        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}
