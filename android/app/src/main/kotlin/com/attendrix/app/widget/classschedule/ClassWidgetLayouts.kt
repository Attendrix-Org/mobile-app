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

// ---------------------------------------------------------------------------
// Small — single focused entity
// ---------------------------------------------------------------------------
@Composable
fun SmallClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val target = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
            .clickable(actionStartActivity<MainActivity>())
    ) {
        if (target != null) {
            val isLive = target.isLive(nowMillis)
            val isCancelled = target.status == com.attendrix.app.widget.model.WidgetStatus.CANCELLED

            val statusWord = when {
                isCancelled -> "CANCELLED"
                isLive      -> "LIVE"
                else        -> "NEXT"
            }

            // Status line (+ stale age trailing)
            ClassWidgetComponents.StatusLine(
                statusLabel = statusWord,
                isLive = isLive,
                isStale = isStale,
                staleByMinutes = staleByMinutes
            )

            Spacer(modifier = GlanceModifier.height(6.dp))

            // Dominant: course name
            Text(
                text = target.courseName,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Hero,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )

            Spacer(modifier = GlanceModifier.defaultWeight())

            // Bottom: venue + countdown on one line
            val countdown = if (isLive) {
                "${WidgetClock.remainingMinutes(target.endMillis, nowMillis)} min left"
            } else {
                "in ${WidgetClock.formatCountdown(target.startMillis, nowMillis)}"
            }
            val venue = target.venue.ifBlank { "TBD" }
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = venue,
                    maxLines = 1,
                    modifier = GlanceModifier.defaultWeight(),
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                if (!isCancelled) {
                    Spacer(modifier = GlanceModifier.width(4.dp))
                    Text(
                        text = countdown,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontWeight = FontWeight.Bold,
                            color = if (isLive) WidgetTokens.Colours.StatusLive else WidgetTokens.Colours.StatusNext,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        } else {
            // No active or upcoming class
            ClassWidgetComponents.StatusLine(
                statusLabel = "DONE",
                isStale = isStale,
                staleByMinutes = staleByMinutes
            )
            Spacer(modifier = GlanceModifier.height(6.dp))
            Text(
                text = "No more classes",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Hero,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.TextPrimary,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.defaultWeight())
            Text(
                text = "Today",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    color = WidgetTokens.Colours.TextSecondary,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }
}

// ---------------------------------------------------------------------------
// Medium — hero card with supporting metadata
// ---------------------------------------------------------------------------
@Composable
fun MediumClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val active = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
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

        if (active != null) {
            ClassWidgetComponents.ClassHeroCard(
                item = active,
                progress = state.progress,
                nowMillis = nowMillis
            )
        } else {
            ClassWidgetComponents.EmptyStateContent(EmptyState.NO_CLASSES)
        }
    }
}

// ---------------------------------------------------------------------------
// Large — hero + compact timeline
// ---------------------------------------------------------------------------
@Composable
fun LargeClassLayout(state: ClassWidgetState.Ready, isStale: Boolean = false, staleByMinutes: Int = 0) {
    val active = state.currentClass ?: state.nextClass
    val nowMillis = WidgetClock.currentTimeMillis()
    val MAX_TIMELINE_ROWS = 3

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(WidgetTokens.Colours.Background)
            .cornerRadius(WidgetTokens.Radius.Card)
            .padding(WidgetTokens.Spacing.md)
    ) {
        // Stale notice (only if stale)
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

        // TODAY label
        Text(
            text = "TODAY",
            style = TextStyle(
                fontSize = WidgetTokens.Typography.Label,
                fontWeight = FontWeight.Bold,
                color = WidgetTokens.Colours.TextMuted,
                fontFamily = FontFamily.SansSerif
            )
        )
        Spacer(modifier = GlanceModifier.height(6.dp))

        if (active != null) {
            // Hero card
            ClassWidgetComponents.ClassHeroCard(
                item = active,
                progress = state.progress,
                nowMillis = nowMillis
            )

            if (state.upcomingRows.isNotEmpty()) {
                Spacer(modifier = GlanceModifier.height(WidgetTokens.Spacing.sm))

                // Divider line
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(WidgetTokens.Colours.Divider)
                ) {}

                Spacer(modifier = GlanceModifier.height(4.dp))

                val visible = state.upcomingRows.take(MAX_TIMELINE_ROWS)
                visible.forEach { row ->
                    ClassWidgetComponents.ClassTimelineRow(item = row, nowMillis = nowMillis)
                }

                val overflow = state.upcomingRows.size - MAX_TIMELINE_ROWS
                if (overflow > 0) {
                    Spacer(modifier = GlanceModifier.height(2.dp))
                    Text(
                        text = "+$overflow more",
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Label,
                            color = WidgetTokens.Colours.TextMuted,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        } else {
            ClassWidgetComponents.EmptyStateContent(EmptyState.NO_CLASSES)
        }
    }
}
