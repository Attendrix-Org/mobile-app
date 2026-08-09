package com.attendrix.app.widget.classschedule

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.LinearProgressIndicator
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
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.model.WidgetStatus

object ClassWidgetComponents {

    /**
     * Single-line status label. Replaces the old two-line "ATTENDRIX + contextTitle" header.
     * The status text (LIVE / NEXT / DONE etc.) is the full header.
     * staleByMinutes > 0 appends a muted age indicator on the trailing edge.
     */
    @Composable
    fun StatusLine(
        statusLabel: String,
        isLive: Boolean = false,
        isStale: Boolean = false,
        staleByMinutes: Int = 0
    ) {
        val statusColor = when {
            isLive   -> WidgetTokens.Colours.StatusLive
            statusLabel == "DONE" || statusLabel == "NO CLASSES" -> WidgetTokens.Colours.StatusDone
            statusLabel == "CANCELLED" -> WidgetTokens.Colours.StatusError
            else     -> WidgetTokens.Colours.StatusNext
        }

        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = statusLabel,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Label,
                    fontWeight = FontWeight.Bold,
                    color = statusColor,
                    fontFamily = FontFamily.SansSerif
                )
            )
            if (isStale && staleByMinutes > 0) {
                Spacer(modifier = GlanceModifier.defaultWeight())
                val ageText = if (staleByMinutes >= 60) {
                    "${staleByMinutes / 60}h ago"
                } else {
                    "${staleByMinutes}m ago"
                }
                Text(
                    text = ageText,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Label,
                        color = WidgetTokens.Colours.StatusWarning,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    /**
     * Compact attendance pill. Only rendered when percentage > 0.
     */
    @Composable
    fun AttendancePill(attendance: com.attendrix.app.widget.model.AttendanceModel) {
        val percentage = attendance.percentage
        if (percentage <= 0.0) return
        val required = attendance.required.toDouble()

        val (bgColor, textColor, label) = when {
            percentage < required -> Triple(
                WidgetTokens.Colours.AttendAtRiskBg,
                WidgetTokens.Colours.AttendAtRiskText,
                "${percentage.toInt()}% · At risk"
            )
            percentage <= (required + 5.0) -> Triple(
                WidgetTokens.Colours.AttendOnEdgeBg,
                WidgetTokens.Colours.AttendOnEdgeText,
                "${percentage.toInt()}% · On edge"
            )
            else -> Triple(
                WidgetTokens.Colours.AttendSafeBg,
                WidgetTokens.Colours.AttendSafeText,
                "${percentage.toInt()}% · Safe"
            )
        }

        Box(
            modifier = GlanceModifier
                .background(bgColor)
                .cornerRadius(WidgetTokens.Radius.Chip)
                .padding(horizontal = 6.dp, vertical = 2.dp)
                .clickable(actionStartActivity<MainActivity>()),
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
     * Hero card for the primary (current or next) class. Used in Medium and Large.
     * Left accent bar color reflects state. No hardcoded height on the accent bar.
     */
    @Composable
    fun ClassHeroCard(
        item: com.attendrix.app.widget.model.WidgetClass,
        progress: Double = 0.0,
        nowMillis: Long = WidgetClock.currentTimeMillis()
    ) {
        val isLive = item.isLive(nowMillis)
        val isCancelled = item.status == WidgetStatus.CANCELLED
        val isRescheduled = item.status == WidgetStatus.RESCHEDULED
        val isExtra = item.isExtraClass

        val cardBg = when {
            isCancelled -> WidgetTokens.Colours.HeroCancelBg
            isLive      -> WidgetTokens.Colours.HeroLiveBg
            else        -> WidgetTokens.Colours.HeroNextBg
        }
        val accentBg = when {
            isCancelled -> WidgetTokens.Colours.HeroCancelAccent
            isLive      -> WidgetTokens.Colours.HeroLiveAccent
            else        -> WidgetTokens.Colours.HeroNextAccent
        }
        val statusLabel = when {
            isCancelled  -> "CANCELLED"
            isRescheduled -> "RESCHEDULED"
            isExtra      -> "EXTRA"
            isLive       -> "LIVE"
            else         -> "NEXT"
        }
        val statusColor = when {
            isCancelled  -> WidgetTokens.Colours.StatusError
            isLive       -> WidgetTokens.Colours.StatusLive
            isRescheduled -> WidgetTokens.Colours.StatusWarning
            else         -> WidgetTokens.Colours.StatusNext
        }

        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)
        val countdownText = when {
            isCancelled  -> null
            isRescheduled -> "Rescheduled"
            isLive       -> "${WidgetClock.remainingMinutes(item.endMillis, nowMillis)} min left"
            else         -> "in ${WidgetClock.formatCountdown(item.startMillis, nowMillis)}"
        }

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.Card)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.Top
        ) {
            // Left accent bar — no hardcoded height; fills naturally with content
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
                // Status row: label left, attendance right
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = statusLabel,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Label,
                            fontWeight = FontWeight.Bold,
                            color = statusColor,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    if (!isCancelled) {
                        AttendancePill(item.attendance)
                    }
                }

                Spacer(modifier = GlanceModifier.height(4.dp))

                // Primary: course name
                Text(
                    text = item.courseName,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Hero,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                Spacer(modifier = GlanceModifier.height(2.dp))

                // Secondary: venue · time
                val venueLine = buildString {
                    if (item.venue.isNotBlank()) append(item.venue)
                    append(" · ")
                    append(timeFmt)
                }
                Text(
                    text = venueLine.trimStart(' ', '·', ' '),
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                // Progress bar for live class
                if (isLive && progress > 0.0) {
                    Spacer(modifier = GlanceModifier.height(6.dp))
                    LinearProgressIndicator(
                        progress = progress.toFloat().coerceIn(0f, 1f),
                        modifier = GlanceModifier.fillMaxWidth().height(3.dp),
                        color = WidgetTokens.Colours.HeroLiveAccent,
                        backgroundColor = WidgetTokens.Colours.Divider
                    )
                }

                // Countdown / status caption
                if (countdownText != null) {
                    Spacer(modifier = GlanceModifier.height(4.dp))
                    Text(
                        text = countdownText,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontWeight = FontWeight.Bold,
                            color = if (isLive) WidgetTokens.Colours.StatusLive else WidgetTokens.Colours.StatusNext,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }

    /**
     * Compact upcoming class row for the Large layout timeline.
     * No card background — uses divider + lighter typography to recede behind the hero.
     */
    @Composable
    fun ClassTimelineRow(
        item: com.attendrix.app.widget.model.WidgetClass,
        nowMillis: Long = WidgetClock.currentTimeMillis()
    ) {
        val isCancelled = item.status == WidgetStatus.CANCELLED
        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)
        val textAlpha = if (isCancelled) WidgetTokens.Colours.TextMuted else WidgetTokens.Colours.TextSecondary

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .padding(vertical = 6.dp)
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Small status dot
            Box(
                modifier = GlanceModifier
                    .width(4.dp)
                    .height(4.dp)
                    .background(if (isCancelled) WidgetTokens.Colours.StatusError else WidgetTokens.Colours.StatusNext)
                    .cornerRadius(2.dp)
            ) {}
            Spacer(modifier = GlanceModifier.width(WidgetTokens.Spacing.sm))

            Column(modifier = GlanceModifier.defaultWeight()) {
                Text(
                    text = if (isCancelled) "${item.courseName} (cancelled)" else item.courseName,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        fontWeight = FontWeight.Bold,
                        color = textAlpha,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }

            Spacer(modifier = GlanceModifier.width(WidgetTokens.Spacing.sm))

            // Venue + time trailing
            val trailingText = buildString {
                if (item.venue.isNotBlank()) { append(item.venue); append(" · ") }
                append(timeFmt)
            }
            Text(
                text = trailingText,
                maxLines = 1,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Label,
                    color = WidgetTokens.Colours.TextMuted,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }

    /**
     * Flat empty state — no inner card, rendered directly in the outer widget surface.
     */
    @Composable
    fun EmptyStateContent(reason: EmptyState, isMessWidget: Boolean = false) {
        val (headline, sub, action) = when (reason) {
            EmptyState.WEEKEND           -> Triple("Weekend", "No classes today", "Enjoy your day")
            EmptyState.HOLIDAY           -> Triple("Holiday", "No classes today", null)
            EmptyState.NO_CLASSES        -> Triple("No classes", "Nothing scheduled today", null)
            EmptyState.NO_TIMETABLE      -> Triple("No timetable", "Sync in Attendrix", "Open Attendrix")
            EmptyState.SEMESTER_NOT_STARTED -> Triple("Ready for semester", "Your schedule will appear here", null)
            EmptyState.LOGGED_OUT        -> Triple("Not signed in", "Sign in to Attendrix", "Open Attendrix")
            EmptyState.NO_MESS_SELECTED  -> Triple("Mess not set", "Choose your mess in Attendrix", "Open Attendrix")
            EmptyState.MESS_MISSING      -> Triple("Mess unavailable", "Selected mess not found", "Open Attendrix")
            EmptyState.NO_MENU_AVAILABLE -> Triple("No menu today", "Today's menu isn't available", null)
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
