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
import androidx.glance.layout.height
import androidx.glance.layout.padding
import com.attendrix.app.MainActivity

@Composable
fun SmallLayout(state: WidgetState) {
    val now = System.currentTimeMillis()
    val hasLiveCurrent = state.hasValidLiveClass(now)
    val activeClass = if (hasLiveCurrent) state.currentClass else (state.nextClass ?: state.upcomingRows.firstOrNull())

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

        if (activeClass != null) {
            if (!hasLiveCurrent) {
                // Hero card only for Small Widget in Upcoming mode
                WidgetComponents.UpcomingHeroCard(item = activeClass, nowMillis = now)
            } else {
                WidgetComponents.UpcomingHeroCard(item = activeClass, nowMillis = now)
            }
        } else {
            WidgetComponents.ContextualEmptyStateView(state.emptyReason)
        }

        Spacer(modifier = GlanceModifier.defaultWeight())
        WidgetComponents.FreshnessFooter(state.updatedAtMillis, isOffline = state.state == "Offline")
    }
}
