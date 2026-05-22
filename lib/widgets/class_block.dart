import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A reusable card widget showing a category, title, subtitle, footer, and progress bar.
class ClassBlock extends StatelessWidget {
  const ClassBlock({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.footerText,
    required this.progress,
    this.categoryColor = const Color(0xFFFF7A59),
    super.key,
  });

  final String category;
  final String title;
  final String subtitle;
  final String footerText;
  final double progress;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF15161E);
    const secondaryTextColor = Color(0xFF606A85);
    const borderColor = Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Label
          Text(
            category,
            style: GoogleFonts.plusJakartaSans(
              color: categoryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            style: GoogleFonts.outfit(
              color: primaryTextColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              color: secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: borderColor, height: 1, thickness: 1),
          const SizedBox(height: 16),
          // Footer text
          Text(
            footerText,
            style: GoogleFonts.plusJakartaSans(
              color: secondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          // Progress Section (centered inside a capsule)
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 24,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(
                      0xFFEFE6E4,
                    ), // light pinkish/beige background
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFF6C8C3),
                    ),
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A detailed view of a class scheduled for today, featuring a time label, title,
/// venue/lab group pills, and an interactive checkmark to mark attendance.
// ignore: camel_case_types
class ClassBlock_primary extends StatelessWidget {
  const ClassBlock_primary({
    required this.classId,
    required this.classRef,
    required this.courseId,
    required this.batchId,
    required this.semesterId,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.isMarked,
    this.venue,
    this.isPlusSlot = false,
    this.labGroup,
    this.isCancelled = false,
    this.cancelledAt,
    this.onAttendanceChanged,
    super.key,
  });

  final String classId;
  final String classRef;
  final String courseId;
  final String batchId;
  final String semesterId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final String? venue;
  final bool isPlusSlot;
  final String? labGroup;
  final bool isCancelled;
  final DateTime? cancelledAt;

  // Attendance state fields
  final bool isMarked;
  final ValueChanged<bool>? onAttendanceChanged;

  @override
  Widget build(BuildContext context) {
    // Exact colors from design system
    final primaryTextColor = isCancelled
        ? const Color(0xFF94A3B8)
        : const Color(0xFF15161E);
    final secondaryTextColor = isCancelled
        ? const Color(0xFF94A3B8)
        : const Color(0xFF606A85);
    const borderColor = Color(0xFFE2E8F0);
    const pillBgColor = Color(0xFFFEF9C3);
    const pillTextColor = Color(0xFF854D0E);

    final hourStr = DateFormat('h:mm').format(scheduledStart.toLocal());
    final amPmStr = DateFormat('a').format(scheduledStart.toLocal());

    return Opacity(
      opacity: isCancelled ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Left Column: Time detail stacked vertically
            SizedBox(
              width: 65,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hourStr,
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amPmStr,
                    style: GoogleFonts.plusJakartaSans(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            // Vertical Divider
            Container(
              height: 48,
              width: 1.5,
              color: borderColor,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            // Middle section: Course details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    courseId,
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Cancelled',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFD32F2F),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else ...[
                        if (venue != null && venue!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              venue!,
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (labGroup != null && labGroup!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Group $labGroup',
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (isPlusSlot)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+ Plus Slot',
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right Column: Squircle checkbox and Mark Attendance label
            if (!isCancelled)
              GestureDetector(
                onTap: () => onAttendanceChanged?.call(!isMarked),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isMarked
                              ? const Color(0xFF24A148) // Green when checked
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isMarked
                                ? const Color(0xFF24A148)
                                : const Color(0xFF15161E),
                            width: 2,
                          ),
                        ),
                        child: isMarked
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Mark Attendance',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: primaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A detailed view of an upcoming class (future scheduled date), featuring a date/time
/// display, title, venue/lab group pills, and no checkmark interaction.
// ignore: camel_case_types
class ClassBlock_upcoming extends StatelessWidget {
  const ClassBlock_upcoming({
    required this.classId,
    required this.classRef,
    required this.courseId,
    required this.batchId,
    required this.semesterId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.venue,
    this.isPlusSlot = false,
    this.labGroup,
    this.isCancelled = false,
    this.cancelledAt,
    super.key,
  });

  final String classId;
  final String classRef;
  final String courseId;
  final String batchId;
  final String semesterId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final String? venue;
  final bool isPlusSlot;
  final String? labGroup;
  final bool isCancelled;
  final DateTime? cancelledAt;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isCancelled
        ? const Color(0xFF94A3B8)
        : const Color(0xFF15161E);
    final secondaryTextColor = isCancelled
        ? const Color(0xFF94A3B8)
        : const Color(0xFF606A85);
    const borderColor = Color(0xFFE2E8F0);
    const pillBgColor = Color(0xFFFEF9C3);
    const pillTextColor = Color(0xFF854D0E);

    final dateStr = DateFormat('EEE, MMM d').format(scheduledStart.toLocal());
    final timeRangeStr =
        '${DateFormat('h:mm a').format(scheduledStart.toLocal())} - ${DateFormat('h:mm a').format(scheduledEnd.toLocal())}';

    return Opacity(
      opacity: isCancelled ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Left Column: Date & Time stack
            SizedBox(
              width: 95,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateStr,
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeRangeStr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: secondaryTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            // Vertical Divider
            Container(
              height: 48,
              width: 1.5,
              color: borderColor,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            // Middle section: Course details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    courseId,
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Cancelled',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFD32F2F),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else ...[
                        if (venue != null && venue!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              venue!,
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (labGroup != null && labGroup!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Group $labGroup',
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (isPlusSlot)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: pillBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+ Plus Slot',
                              style: GoogleFonts.plusJakartaSans(
                                color: pillTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
