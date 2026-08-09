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
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.LinearProgressIndicator
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
import androidx.glance.text.FontStyle
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.attendrix.app.MainActivity

object WidgetComponents {

    /**
     * Minimalist M3 Header without Sync button (uncluttered, spacious).
     * Implicit refresh is attached to tap on header text or footer line.
     */
    @Composable
    fun Header(
        contextTitle: String,
        brand: String = "ATTENDRIX",
        isSyncing: Boolean = false
    ) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .clickable(actionRunCallback<RefreshWidgetAction>()),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = GlanceModifier.defaultWeight()) {
                Text(
                    text = brand.uppercase(),
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.Primary,
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

    /**
     * Hero Active Card for Class Glance Widget.
     * Features: 6dp solid accent stripe, Context badge + Dynamic Per-Class Attendance Pill,
     * Course title (maxLines = 2) + Code • Venue, Low-emphasis Course Type pill, Custom Attendance Status Caption,
     * and explicit schedule date/time footer.
     */
    @Composable
    fun UpcomingHeroCard(item: WidgetClass, nowMillis: Long, overallAttendance: Double = 100.0) {
        val isLive = item.isLive(nowMillis)
        val dateFmt = formatFullDate(item.startMillis)
        val timeFmt = formatTimeRange(item.startMillis, item.endMillis)
        val countdownFmt = if (isLive) {
            val remMin = ((item.endMillis - nowMillis) / 60000L).coerceAtLeast(0L)
            "${remMin}m remaining"
        } else {
            formatCountdown(item.startMillis, nowMillis)
        }

        val badgeBg = if (isLive) ColorProvider(Color(0xFF24A869)) else WidgetTokens.Colours.Primary
        val badgeText = if (isLive) "LIVE NOW" else "NEXT UP"
        val cardBg = if (isLive) WidgetTokens.Colours.HeroContainerLive else WidgetTokens.Colours.HeroContainerUpcoming
        val accentColor = if (isLive) Color(0xFF24A869) else Color(0xFF6F61EF)

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(cardBg)
                .cornerRadius(WidgetTokens.Radius.Card),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Prominent 6dp M3 Solid Accent Stripe
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
                // Top Row: Badge + Dynamic Attendance Risk Pill
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

                    if (isLive) {
                        Spacer(modifier = GlanceModifier.width(8.dp))
                        AttendanceActionChip(classId = item.classId, isAbsent = item.isAbsent)
                    }

                    Spacer(modifier = GlanceModifier.defaultWeight())
                    DynamicAttendancePill(item.attendance)
                }

                Spacer(modifier = GlanceModifier.height(6.dp))

                // Dominant Course Title (max 2 lines)
                Text(
                    text = item.courseName,
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    ),
                    maxLines = 2
                )

                // Subtitle: Code • Venue (12sp)
                val codeVenueStr = listOfNotNull(
                    if (item.courseCode.isNotBlank()) item.courseCode else null,
                    if (item.venue.isNotBlank()) item.venue else null
                ).joinToString(" • ")

                if (codeVenueStr.isNotBlank()) {
                    Text(
                        text = codeVenueStr,
                        style = TextStyle(
                            fontSize = 12.sp,
                            color = ColorProvider(Color(0xFF483A70)),
                            fontFamily = FontFamily.SansSerif
                        ),
                        maxLines = 1
                    )
                }

                Spacer(modifier = GlanceModifier.height(4.dp))

                // Low-emphasis Course Type Pill
                CourseTypePill(item.courseTypeLabel())

                Spacer(modifier = GlanceModifier.height(6.dp))

                // Custom Attendance Status Caption Box
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .background(ColorProvider(Color(0x12000000)))
                        .cornerRadius(8.dp)
                        .padding(horizontal = 8.dp, vertical = 5.dp)
                ) {
                    Text(
                        text = item.effectiveCaption(),
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            fontStyle = FontStyle.Italic,
                            color = WidgetTokens.Colours.TextPrimary,
                            fontFamily = FontFamily.SansSerif
                        ),
                        maxLines = 2
                    )
                }

                Spacer(modifier = GlanceModifier.height(6.dp))

                // Date & Time Schedule Footer + Countdown
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (dateFmt.isNotBlank()) {
                        Text(
                            text = "$dateFmt • $timeFmt",
                            style = TextStyle(
                                fontSize = WidgetTokens.Typography.Micro,
                                fontWeight = FontWeight.Medium,
                                color = WidgetTokens.Colours.TextSecondary,
                                fontFamily = FontFamily.SansSerif
                            )
                        )
                    }

                    Spacer(modifier = GlanceModifier.defaultWeight())

                    Text(
                        text = if (isLive) countdownFmt else "Starts in $countdownFmt",
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Micro,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(accentColor),
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }

    /**
     * Compact Timeline Agenda Row for secondary upcoming classes.
     * Course Name maxLines = 1.
     */
    @Composable
    fun UpcomingTimelineRow(item: WidgetClass, nowMillis: Long, accentIndex: Int = 0) {
        val accentColors = listOf(
            Color(0xFF3B82F6), // Blue
            Color(0xFF10B981), // Green
            Color(0xFFF59E0B), // Amber
            Color(0xFF8B5CF6), // Purple
            Color(0xFFEF4444)  // Red
        )
        val accentColor = accentColors[accentIndex % accentColors.size]
        val relativeDateFmt = formatRelativeDate(item.startMillis, nowMillis)
        val countdownFmt = formatCountdown(item.startMillis, nowMillis)

        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.InnerBlock),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Prominent 6dp M3 Left Accent Bar
            Box(
                modifier = GlanceModifier
                    .width(6.dp)
                    .height(44.dp)
                    .background(ColorProvider(accentColor))
                    .cornerRadius(3.dp)
            ) {}

            Row(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp, vertical = 6.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = GlanceModifier.defaultWeight()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = item.courseName,
                            style = TextStyle(
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = WidgetTokens.Colours.TextPrimary,
                                fontFamily = FontFamily.SansSerif
                            ),
                            maxLines = 1,
                            modifier = GlanceModifier.defaultWeight()
                        )
                        Spacer(modifier = GlanceModifier.width(6.dp))
                        CourseTypePill(item.courseTypeLabel())
                    }
                    Text(
                        text = relativeDateFmt,
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Caption,
                            color = ColorProvider(accentColor),
                            fontWeight = FontWeight.Medium,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }

                Spacer(modifier = GlanceModifier.width(6.dp))

                Column(horizontalAlignment = Alignment.End) {
                    DynamicAttendancePill(item.attendance)
                    Spacer(modifier = GlanceModifier.height(2.dp))
                    Text(
                        text = "Starts in $countdownFmt",
                        style = TextStyle(
                            fontSize = WidgetTokens.Typography.Micro,
                            fontWeight = FontWeight.Medium,
                            color = WidgetTokens.Colours.TextSecondary,
                            fontFamily = FontFamily.SansSerif
                        )
                    )
                }
            }
        }
    }

    /**
     * Subtle Course Type Pill Classifier (Low Visual Emphasis).
     */
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

    /**
     * Dynamic Attendance Risk Pill evaluating dynamically against attendance.required threshold.
     */
    @Composable
    fun DynamicAttendancePill(attendance: AttendanceModel) {
        val percentage = attendance.percentage
        val required = attendance.required.toDouble()

        val (bgColor, textColor, label) = when {
            // Below required threshold -> Critical Risk
            percentage < required -> Triple(
                ColorProvider(Color(0xFFFFCDD2)),
                ColorProvider(Color(0xFFB3261E)),
                "${percentage.toInt()}% (Req:${attendance.required}%)"
            )
            // Within 5% buffer of required threshold -> Warning Zone / On Wire
            percentage <= (required + 5.0) -> Triple(
                ColorProvider(Color(0xFFFFF0C2)),
                ColorProvider(Color(0xFF7A5900)),
                "${percentage.toInt()}% (On Wire)"
            )
            // Well above required threshold -> Good Standing / Safe
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



    /**
     * M3 Tonal Status Chip with muted non-saturated colors.
     */
    @Composable
    fun StatusChip(status: WidgetStatus, isAbsent: Boolean = false) {
        val (label, bgColor, textColor) = when {
            isAbsent -> Triple("ABSENT", ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)))
            status == WidgetStatus.LIVE -> Triple("LIVE", ColorProvider(Color(0xFFDCFCE7)), ColorProvider(Color(0xFF166534)))
            status == WidgetStatus.UPCOMING -> Triple("UPCOMING", ColorProvider(Color(0xFFE0E7FF)), ColorProvider(Color(0xFF3730A3)))
            status == WidgetStatus.COMPLETED -> Triple("DONE", ColorProvider(Color(0xFFF3F4F6)), ColorProvider(Color(0xFF4B5563)))
            status == WidgetStatus.CANCELLED -> Triple("CANCELLED", ColorProvider(Color(0xFFFEE2E2)), ColorProvider(Color(0xFF991B1B)))
            status == WidgetStatus.HOLIDAY -> Triple("HOLIDAY", ColorProvider(Color(0xFFE0F2FE)), ColorProvider(Color(0xFF075985)))
            else -> Triple("SCHEDULED", WidgetTokens.Colours.SurfaceVariant, WidgetTokens.Colours.TextPrimary)
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

    /**
     * Adaptive Progress Bar: Switches to Error/Warning color when <= 5 min remain.
     */
    @Composable
    fun ProgressSection(progress: Double, remainingMin: Int) {
        val isEndingSoon = remainingMin <= 5
        val barColor = if (isEndingSoon) WidgetTokens.Colours.Error else WidgetTokens.Colours.Primary

        Column(modifier = GlanceModifier.fillMaxWidth()) {
            LinearProgressIndicator(
                progress = progress.toFloat(),
                modifier = GlanceModifier.fillMaxWidth().height(6.dp).cornerRadius(3.dp),
                color = barColor,
                backgroundColor = WidgetTokens.Colours.SurfaceVariant
            )
            Spacer(modifier = GlanceModifier.height(4.dp))
            Row(modifier = GlanceModifier.fillMaxWidth()) {
                Text(
                    text = "${(progress * 100).toInt()}%",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = FontWeight.Bold,
                        color = barColor,
                        fontFamily = FontFamily.SansSerif
                    )
                )
                Spacer(modifier = GlanceModifier.defaultWeight())
                Text(
                    text = if (isEndingSoon) "$remainingMin min left!" else "$remainingMin min remaining",
                    style = TextStyle(
                        fontSize = WidgetTokens.Typography.Micro,
                        fontWeight = if (isEndingSoon) FontWeight.Bold else FontWeight.Medium,
                        color = if (isEndingSoon) WidgetTokens.Colours.Error else WidgetTokens.Colours.TextPrimary,
                        fontFamily = FontFamily.SansSerif
                    )
                )
            }
        }
    }

    /**
     * Quick Attendance Action Chip (One-Tap Attendance Action from Widget) with M3 touch target.
     */
    @Composable
    fun AttendanceActionChip(classId: String, isAbsent: Boolean) {
        val label = if (isAbsent) "Mark Present" else "Mark Absent"
        val bgColor = if (isAbsent) ColorProvider(Color(0xFF24A869)) else ColorProvider(Color(0xFFFF5963))

        Box(
            modifier = GlanceModifier
                .background(bgColor)
                .cornerRadius(WidgetTokens.Radius.Chip)
                .padding(horizontal = 14.dp, vertical = 10.dp)
                .clickable(actionRunCallback<ToggleAbsenceAction>()),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = label,
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Micro,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(Color(0xFFFFFFFF)),
                    fontFamily = FontFamily.SansSerif
                )
            )
        }
    }

    @Composable
    fun StaticLoadingPlaceholder() {
        Column(
            modifier = GlanceModifier.fillMaxWidth().padding(vertical = 8.dp)
        ) {
            Box(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .height(20.dp)
                    .background(WidgetTokens.Colours.SurfaceVariant)
                    .cornerRadius(8.dp)
            ) {}
            Spacer(modifier = GlanceModifier.height(8.dp))
            Box(
                modifier = GlanceModifier
                    .width(140.dp)
                    .height(14.dp)
                    .background(WidgetTokens.Colours.SurfaceVariant)
                    .cornerRadius(6.dp)
            ) {}
            Spacer(modifier = GlanceModifier.height(12.dp))
            Box(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .height(36.dp)
                    .background(WidgetTokens.Colours.SurfaceVariant)
                    .cornerRadius(12.dp)
            ) {}
        }
    }

    @Composable
    fun ContextualEmptyStateView(reason: EmptyState) {
        val (title, description, buttonLabel) = when (reason) {
            EmptyState.NO_MESS_SELECTED -> Triple("Choose your mess", "Choose your mess in Attendrix.", "Select Mess")
            EmptyState.MESS_MISSING -> Triple("Mess unavailable", "Your selected mess couldn't be found.", "Choose Another")
            EmptyState.WEEKEND -> Triple("Enjoy your weekend", "No classes scheduled today.", null)
            EmptyState.HOLIDAY -> Triple("Holiday today", "Classes resume tomorrow.", null)
            EmptyState.NO_TIMETABLE -> Triple("No timetable", "Sync your timetable to begin.", null)
            EmptyState.SEMESTER_NOT_STARTED -> Triple("Ready for semester", "Your schedule will appear here.", null)
            EmptyState.LOGGED_OUT -> Triple("Sign in", "Sign in to Attendrix.", "Sign In")
            EmptyState.NO_CLASSES -> Triple("No classes today", "You have no classes scheduled for today.", null)
            EmptyState.NO_MENU_AVAILABLE -> Triple("No menu available", "Today's menu isn't available yet.", null)
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

    @Composable
    fun ErrorStateView() {
        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTokens.Colours.Surface)
                .cornerRadius(WidgetTokens.Radius.Card)
                .padding(WidgetTokens.Spacing.md),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Couldn't update",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Title,
                    fontWeight = FontWeight.Bold,
                    color = WidgetTokens.Colours.Error,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(4.dp))
            Text(
                text = "Open Attendrix to refresh.",
                style = TextStyle(
                    fontSize = WidgetTokens.Typography.Body,
                    color = WidgetTokens.Colours.TextSecondary,
                    textAlign = TextAlign.Center,
                    fontFamily = FontFamily.SansSerif
                )
            )
            Spacer(modifier = GlanceModifier.height(8.dp))
            Box(
                modifier = GlanceModifier
                    .background(WidgetTokens.Colours.Primary)
                    .cornerRadius(WidgetTokens.Radius.Button)
                    .height(48.dp)
                    .padding(horizontal = 20.dp)
                    .clickable(actionStartActivity<MainActivity>()),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Open App",
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

    @Composable
    fun FreshnessFooter(updatedAtMillis: Long, isOffline: Boolean = false) {
        val now = System.currentTimeMillis()
        val diffMin = ((now - updatedAtMillis) / 60000L).coerceAtLeast(0L)
        val relativeTime = when {
            diffMin <= 1 -> "Synced just now"
            diffMin < 60 -> "Last synced ${diffMin} min ago"
            diffMin < 1440 -> "Last synced ${diffMin / 60}h ago"
            else -> "Last synced yesterday"
        }

        val text = when {
            isOffline -> "Offline • $relativeTime"
            diffMin >= 60 -> "$relativeTime • May be outdated"
            else -> relativeTime
        }

        Text(
            text = text,
            style = TextStyle(
                fontSize = WidgetTokens.Typography.Caption,
                color = if (diffMin >= 60) WidgetTokens.Colours.Tertiary else WidgetTokens.Colours.TextSecondary,
                fontFamily = FontFamily.SansSerif
            ),
            modifier = GlanceModifier.clickable(actionRunCallback<RefreshWidgetAction>())
        )
    }
}

class ToggleAbsenceAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: androidx.glance.action.ActionParameters) {
        val snapshot = WidgetStateRepository.getSnapshot(context)
        val activeClass = snapshot.currentClass
        if (activeClass != null) {
            WidgetBridge.notifyAbsenceChanged(context, activeClass.classId, !activeClass.isAbsent)
        }
    }
}
