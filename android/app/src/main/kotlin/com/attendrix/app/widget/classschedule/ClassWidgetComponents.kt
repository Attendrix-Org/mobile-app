package com.attendrix.app.widget.classschedule

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.LinearProgressIndicator
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
import com.attendrix.app.widget.WidgetTokens
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetClock

object ClassWidgetComponents {

    @Composable
    fun Header(
        contextTitle: String,
        brand: String = "ATTENDRIX",
        isStale: Boolean = false
    ) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .clickable(actionStartActivity<MainActivity>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = GlanceModifier.defaultWeight()) {
                Text(
                    text = if (isStale) "$brand • STALE" else brand.uppercase(),
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = if (isStale) WidgetTokens.Colours.Warning else WidgetTokens.Colours.Primary,
                        fontFamily = FontFamily.SansSerif
                    )
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
        }
    }

    @Composable
    fun StatusBadge(status: com.attendrix.app.widget.model.WidgetStatus, isAbsent: Boolean = false) {
        val (label, bgColor, textColor) = when {
            isAbsent -> Triple("ABSENT", ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)))
            status == com.attendrix.app.widget.model.WidgetStatus.LIVE -> Triple("LIVE NOW", ColorProvider(Color(0xFFDCFCE7)), ColorProvider(Color(0xFF166534)))
            status == com.attendrix.app.widget.model.WidgetStatus.CANCELLED -> Triple("CANCELLED", ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)))
            status == com.attendrix.app.widget.model.WidgetStatus.RESCHEDULED -> Triple("RESCHEDULED", ColorProvider(Color(0xFFFEF3C7)), ColorProvider(Color(0xFFB45309)))
            status == com.attendrix.app.widget.model.WidgetStatus.COMPLETED -> Triple("DONE", ColorProvider(Color(0xFFF3F4F6)), ColorProvider(Color(0xFF4B5563)))
            else -> Triple("NEXT UP", WidgetTokens.Colours.Primary, ColorProvider(Color(0xFFFFFFFF)))
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

    @Composable
    fun AttendancePill(attendance: com.attendrix.app.widget.model.AttendanceModel) {
        val percentage = attendance.percentage
        val required = attendance.required.toDouble()

        val (bgColor, textColor, label) = when {
            percentage < required -> Triple(
                ColorProvider(Color(0xFFFFCDD2)),
                ColorProvider(Color(0xFFB3261E)),
                "${percentage.toInt()}% · At Risk"
            )
            percentage <= (required + 5.0) -> Triple(
                ColorProvider(Color(0xFFFFF0C2)),
                ColorProvider(Color(0xFF7A5900)),
                "${percentage.toInt()}% · On Wire"
            )
            else -> Triple(
                ColorProvider(Color(0xFFE2F3E8)),
                ColorProvider(Color(0xFF0F5223)),
                "${percentage.toInt()}% · Safe"
            )
        }

        Box(
            modifier = GlanceModifier
                .background(bgColor)
                .cornerRadius(WidgetTokens.Radius.Chip)
                .padding(horizontal = 8.dp, vertical = 3.dp)
                .clickable(actionStartActivity<MainActivity>()),
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

    @Composable
    fun UpcomingHeroCard(item: com.attendrix.app.widget.model.WidgetClass, progress: Double = 0.0, nowMillis: Long = WidgetClock.currentTimeMillis()) {
        val isLive = item.isLive(nowMillis)
        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)
        val countdownFmt = if (isLive) {
            val remMin = WidgetClock.remainingMinutes(item.endMillis, nowMillis)
            "${remMin}m left"
        } else {
            WidgetClock.formatCountdown(item.startMillis, nowMillis)
        }

        val isCancelled = item.status == com.attendrix.app.widget.model.WidgetStatus.CANCELLED
        val isRescheduled = item.status == com.attendrix.app.widget.model.WidgetStatus.RESCHEDULED

        val cardBg = when {
            isCancelled -> ColorProvider(Color(0xFFFFF1F2))
            isLive -> WidgetTokens.Colours.HeroContainerLive
            else -> WidgetTokens.Colours.HeroContainerUpcoming
        }
        val accentColor = when {
            isCancelled -> Color(0xFFE11D48)
            isLive -> Color(0xFF24A869)
            else -> Color(0xFF6F61EF)
        }

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
                    .height(134.dp)
                    .background(ColorProvider(accentColor))
                    .cornerRadius(3.dp)
            ) {}

            Column(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(WidgetTokens.Spacing.md)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    StatusBadge(status = if (isLive) com.attendrix.app.widget.model.WidgetStatus.LIVE else item.status, isAbsent = item.isAbsent)

                    Spacer(modifier = GlanceModifier.defaultWeight())
                    if (!isCancelled && item.attendance.percentage > 0) {
                        AttendancePill(item.attendance)
                    }
                }

                Spacer(modifier = GlanceModifier.height(6.dp))

                Text(
                    text = item.courseName,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Title,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                Spacer(modifier = GlanceModifier.height(2.dp))

                Text(
                    text = "${item.venue.ifBlank { "TBD" }} • $timeFmt",
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                Spacer(modifier = GlanceModifier.height(6.dp))

                if (isLive && progress > 0.0) {
                    LinearProgressIndicator(
                        progress = progress.toFloat(),
                        modifier = GlanceModifier.fillMaxWidth().height(4.dp),
                        color = ColorProvider(Color(0xFF24A869)),
                        backgroundColor = ColorProvider(Color(0xFFDCFCE7))
                    )
                    Spacer(modifier = GlanceModifier.height(4.dp))
                }

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = if (isCancelled) "Class Cancelled" else if (isRescheduled) "Rescheduled" else countdownFmt,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(accentColor),
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }

    @Composable
    fun ClassRowItem(item: com.attendrix.app.widget.model.WidgetClass, nowMillis: Long = WidgetClock.currentTimeMillis()) {
        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)

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
                Text(
                    text = item.courseName,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Text(
                    text = "${item.venue.ifBlank { "TBD" }} • $timeFmt",
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
    fun ContextualEmptyStateView(reason: EmptyState) {
        val (title, description) = when (reason) {
            EmptyState.WEEKEND -> Pair("Weekend", "No classes scheduled today. Enjoy your day!")
            EmptyState.HOLIDAY -> Pair("Holiday Today", "No classes today.")
            EmptyState.NO_CLASSES -> Pair("No Classes", "Nothing scheduled for today.")
            EmptyState.NO_TIMETABLE -> Pair("No Timetable", "Sync your timetable in Attendrix.")
            EmptyState.SEMESTER_NOT_STARTED -> Pair("Ready for Semester", "Your schedule will appear here.")
            EmptyState.LOGGED_OUT -> Pair("Sign In", "Sign in to Attendrix to view schedule.")
            EmptyState.NO_MESS_SELECTED -> Pair("Select Mess", "Choose your mess in Attendrix.")
            EmptyState.MESS_MISSING -> Pair("Mess Unavailable", "Selected mess couldn't be found.")
            EmptyState.NO_MENU_AVAILABLE -> Pair("No Menu", "Today's menu isn't available.")
        }

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(WidgetTokens.Spacing.md)
                .clickable(actionStartActivity<MainActivity>()),
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
