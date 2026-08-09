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
import com.attendrix.app.widget.AttendrixClassWidget
import com.attendrix.app.widget.RefreshWidgetAction
import com.attendrix.app.widget.core.EmptyState
import com.attendrix.app.widget.core.WidgetClock
import com.attendrix.app.widget.core.WidgetTokens
import com.attendrix.app.widget.model.AttendanceModel
import com.attendrix.app.widget.model.WidgetClass
import com.attendrix.app.widget.model.WidgetStatus

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
                .clickable(actionRunCallback<RefreshWidgetAction>()),
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
    fun UpcomingHeroCard(item: WidgetClass, nowMillis: Long = WidgetClock.currentTimeMillis()) {
        val isLive = item.isLive(nowMillis)
        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)
        val countdownFmt = if (isLive) {
            val remMin = WidgetClock.remainingMinutes(item.endMillis, nowMillis)
            "${remMin}m remaining"
        } else {
            WidgetClock.formatCountdown(item.startMillis, nowMillis)
        }

        val badgeBg = if (isLive) ColorProvider(Color(0xFF24A869)) else WidgetTokens.Colours.Primary
        val badgeText = if (isLive) "LIVE NOW" else "NEXT UP"
        val cardBg = if (isLive) WidgetTokens.Colours.HeroContainerLive else WidgetTokens.Colours.HeroContainerUpcoming
        val accentColor = if (isLive) Color(0xFF24A869) else Color(0xFF6F61EF)

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

                    Spacer(modifier = GlanceModifier.defaultWeight())
                    DynamicAttendancePill(item.attendance)
                }

                Spacer(modifier = GlanceModifier.height(6.dp))

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = item.courseName,
                        maxLines = 1,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Title,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        ),
                        modifier = GlanceModifier.defaultWeight()
                    )
                    if (item.courseTypeLabel().isNotBlank()) {
                        Spacer(modifier = GlanceModifier.width(6.dp))
                        CourseTypePill(item.courseTypeLabel())
                    }
                }

                Spacer(modifier = GlanceModifier.height(2.dp))

                Text(
                    text = "${item.courseCode} • ${item.venue.ifBlank { "TBD" }}",
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Body,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )

                Spacer(modifier = GlanceModifier.height(6.dp))

                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = timeFmt,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontWeight = FontWeight.Medium,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    Text(
                        text = countdownFmt,
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
    fun CourseTypePill(label: String) {
        val (bgColor, textColor) = when (label.lowercase()) {
            "lab" -> Pair(ColorProvider(Color(0xFFE0F2FE)), ColorProvider(Color(0xFF0369A1)))
            "extra class" -> Pair(ColorProvider(Color(0xFFD1FAE5)), ColorProvider(Color(0xFF047857)))
            "plus slot" -> Pair(ColorProvider(Color(0xFFEDE7F6)), ColorProvider(Color(0xFF6D28D9)))
            "elective" -> Pair(ColorProvider(Color(0xFFFEF3C7)), ColorProvider(Color(0xFFB45309)))
            else -> Pair(ColorProvider(Color(0xFFF3F4F6)), ColorProvider(Color(0xFF4B5563)))
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
                    fontWeight = FontWeight.Medium,
                    color = textColor,
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }

    @Composable
    fun DynamicAttendancePill(attendance: AttendanceModel) {
        val percentage = attendance.percentage
        val required = attendance.required.toDouble()

        val (bgColor, textColor, label) = when {
            percentage < required -> Triple(
                ColorProvider(Color(0xFFFFCDD2)),
                ColorProvider(Color(0xFFB3261E)),
                "${percentage.toInt()}% (Req:${attendance.required}%)"
            )
            percentage <= (required + 5.0) -> Triple(
                ColorProvider(Color(0xFFFFF0C2)),
                ColorProvider(Color(0xFF7A5900)),
                "${percentage.toInt()}% (On Wire)"
            )
            else -> Triple(
                ColorProvider(Color(0xFFE2F3E8)),
                ColorProvider(Color(0xFF0F5223)),
                "${percentage.toInt()}% Safe"
            )
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
    fun ClassRowItem(item: WidgetClass, nowMillis: Long = WidgetClock.currentTimeMillis()) {
        val timeFmt = WidgetClock.formatTimeRange(item.startMillis, item.endMillis)
        val countdownFmt = WidgetClock.formatCountdown(item.startMillis, nowMillis)

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(horizontal = WidgetTokens.Spacing.md, vertical = 10.dp)
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
                    text = "${item.courseCode} • ${item.venue.ifBlank { "TBD" }}",
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        color = WidgetTokens.Colours.TextSecondary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }

            Spacer(modifier = GlanceModifier.width(8.dp))

            Column(horizontalAlignment = Alignment.End) {
                Text(
                    text = timeFmt,
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Caption,
                        fontWeight = FontWeight.Medium,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Text(
                    text = "in $countdownFmt",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Medium,
                        color = WidgetTokens.Colours.Primary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    @Composable
    fun ContextualEmptyStateView(reason: EmptyState) {
        val (title, description, buttonLabel) = when (reason) {
            EmptyState.NO_CLASSES -> Triple("No classes today", "You have no classes scheduled for today.", null)
            EmptyState.NO_MENU_AVAILABLE -> Triple("No menu available", "Today's menu isn't available yet.", null)
            EmptyState.NO_MESS_SELECTED -> Triple("Choose your mess", "Select your mess in Attendrix.", "Select Mess")
            EmptyState.MESS_MISSING -> Triple("Mess unavailable", "Your selected mess couldn't be found.", "Choose Another")
            EmptyState.WEEKEND -> Triple("Enjoy your weekend", "No classes scheduled today.", null)
            EmptyState.HOLIDAY -> Triple("Holiday today", "Classes resume tomorrow.", null)
            EmptyState.NO_TIMETABLE -> Triple("No timetable", "Sync your timetable to begin.", null)
            EmptyState.SEMESTER_NOT_STARTED -> Triple("Ready for semester", "Your schedule will appear here.", null)
            EmptyState.LOGGED_OUT -> Triple("Sign in", "Sign in to Attendrix.", "Sign In")
        }

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(WidgetTokens.Spacing.md),
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

            if (buttonLabel != null) {
                Spacer(modifier = GlanceModifier.height(8.dp))
                Box(
                    modifier = GlanceModifier
                        .background(WidgetTokens.Colours.Primary)
                        .cornerRadius(WidgetTokens.Radius.Button)
                        .height(48.dp)
                        .padding(horizontal = 16.dp)
                        .clickable(actionStartActivity<MainActivity>()),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = buttonLabel,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Body,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTokens.Colours.Surface,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }
}
