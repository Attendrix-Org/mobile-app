import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A custom, premium calendar explorer for APOD date selection.
/// Highlights today, selected date, viewed dates, and cached dates.
/// Disables future dates and dates before June 16, 1995.
class CalendarExplorer extends ConsumerWidget {
  const CalendarExplorer({
    required this.onDateSelected,
    super.key,
  });

  final void Function(DateTime date) onDateSelected;

  // The earliest date for which APOD is available
  static final DateTime _apodStartDate = DateTime(1995, 6, 16);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final monthYear = ref.watch(calendarMonthYearProvider);
    final cachedDates = ref.watch(cachedDatesProvider);
    final viewedDates = ref.watch(viewedDatesProvider);

    final surfaceColor = isDark ? const Color(0xFF201F21) : Colors.white;
    final borderColor = isDark ? const Color(0xFF353437) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF15161E);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF606A85);
    final accentColor = isDark ? const Color(0xFFC5C0FF) : const Color(0xFF6F61EF);

    final today = DateTime.now();

    // Calendar generation math
    final firstDayOfMonth = DateTime(monthYear.year, monthYear.month);
    final lastDayOfMonth = DateTime(monthYear.year, monthYear.month + 1, 0);

    // Day of week offset: 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    // DateTime.weekday returns 1 = Monday, ..., 7 = Sunday
    final startPadding = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day;

    final totalGridCells = startPadding + totalDays;
    final rowCount = (totalGridCells / 7).ceil();

    final monthName = DateFormat('MMMM').format(firstDayOfMonth);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month/Year Navigation Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildNavButton(
                    key: const Key('calendar_prev_year'),
                    icon: Icons.double_arrow_rounded,
                    isLeft: true,
                    onPressed: () {
                      ref.read(calendarMonthYearProvider.notifier).state =
                          MonthYear(monthYear.month, monthYear.year - 1);
                    },
                    color: secondaryTextColor,
                  ),
                  _buildNavButton(
                    key: const Key('calendar_prev_month'),
                    icon: Icons.chevron_left_rounded,
                    isLeft: false,
                    onPressed: () {
                      var newMonth = monthYear.month - 1;
                      var newYear = monthYear.year;
                      if (newMonth < 1) {
                        newMonth = 12;
                        newYear--;
                      }
                      ref.read(calendarMonthYearProvider.notifier).state =
                          MonthYear(newMonth, newYear);
                    },
                    color: secondaryTextColor,
                  ),
                ],
              ),
              Text(
                '$monthName ${monthYear.year}',
                style: GoogleFonts.outfit(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildNavButton(
                    key: const Key('calendar_next_month'),
                    icon: Icons.chevron_right_rounded,
                    isLeft: false,
                    onPressed: _isNextMonthValid(monthYear, today)
                        ? () {
                            var newMonth = monthYear.month + 1;
                            var newYear = monthYear.year;
                            if (newMonth > 12) {
                              newMonth = 1;
                              newYear++;
                            }
                            ref.read(calendarMonthYearProvider.notifier).state =
                                MonthYear(newMonth, newYear);
                          }
                        : null,
                    color: secondaryTextColor,
                  ),
                  _buildNavButton(
                    key: const Key('calendar_next_year'),
                    icon: Icons.double_arrow_rounded,
                    isLeft: false,
                    onPressed: monthYear.year < today.year
                        ? () {
                            ref.read(calendarMonthYearProvider.notifier).state =
                                MonthYear(monthYear.month, monthYear.year + 1);
                          }
                        : null,
                    color: secondaryTextColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days of Week Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.outfit(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Grid
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rowCount,
            itemBuilder: (context, rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (colIndex) {
                  final cellIndex = rowIndex * 7 + colIndex;
                  final dayNumber = cellIndex - startPadding + 1;

                  if (dayNumber < 1 || dayNumber > totalDays) {
                    return const Expanded(child: SizedBox(height: 40));
                  }

                  final cellDate = DateTime(monthYear.year, monthYear.month, dayNumber);
                  final isToday = cellDate.year == today.year &&
                      cellDate.month == today.month &&
                      cellDate.day == today.day;
                  final isSelected = cellDate.year == selectedDate.year &&
                      cellDate.month == selectedDate.month &&
                      cellDate.day == selectedDate.day;

                  final dateStr = _formatDateStr(cellDate);
                  final isCached = cachedDates.contains(dateStr);
                  final isViewed = viewedDates.contains(dateStr);

                  // Validate bounds
                  final isBeforeStart = cellDate.isBefore(_apodStartDate);
                  final isFuture = cellDate.isAfter(today);
                  final isValid = !isBeforeStart && !isFuture;

                  return Expanded(
                    child: Center(
                      child: _buildDayCell(
                        context,
                        day: dayNumber,
                        isValid: isValid,
                        isToday: isToday,
                        isSelected: isSelected,
                        isCached: isCached,
                        isViewed: isViewed,
                        accentColor: accentColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        onTap: () {
                          if (isValid) {
                            ref.read(calendarSelectedDateProvider.notifier).state = cellDate;
                            onDateSelected(cellDate);
                          }
                        },
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isNextMonthValid(MonthYear current, DateTime today) {
    if (current.year < today.year) return true;
    if (current.year == today.year && current.month < today.month) return true;
    return false;
  }

  String _formatDateStr(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildNavButton({
    required Key key,
    required IconData icon,
    required bool isLeft,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    Widget child = Icon(icon, size: 18, color: onPressed == null ? color.withValues(alpha: 0.3) : color);
    if (isLeft && icon == Icons.double_arrow_rounded) {
      child = Transform.rotate(angle: 3.14159, child: child);
    }

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        key: key,
        padding: EdgeInsets.zero,
        icon: child,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context, {
    required int day,
    required bool isValid,
    required bool isToday,
    required bool isSelected,
    required bool isCached,
    required bool isViewed,
    required Color accentColor,
    required Color textColor,
    required Color secondaryTextColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    BoxDecoration? decoration;
    var textStyle = GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isValid ? textColor : secondaryTextColor.withValues(alpha: 0.35),
    );

    if (isSelected) {
      decoration = BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      );
      textStyle = textStyle.copyWith(
        color: isDark ? Colors.black : Colors.white,
        fontWeight: FontWeight.bold,
      );
    } else if (isToday) {
      decoration = BoxDecoration(
        border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
        shape: BoxShape.circle,
      );
      textStyle = textStyle.copyWith(
        color: accentColor,
        fontWeight: FontWeight.bold,
      );
    } else if (isViewed) {
      // Subtly highlight viewed dates
      decoration = BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      );
      textStyle = textStyle.copyWith(
        fontWeight: FontWeight.w600,
      );
    }

    return Semantics(
      label: 'Day $day${isToday ? ", Today" : ""}${isSelected ? ", Selected" : ""}${isCached ? ", Cached" : ""}${isViewed ? ", Viewed" : ""}',
      button: isValid,
      enabled: isValid,
      child: InkWell(
        onTap: isValid ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: decoration,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '$day',
                  style: textStyle,
                ),
              ),
              // Cache dot indicator at the bottom
              if (isCached)
                Positioned(
                  bottom: 3,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? const Color(0xFF8A80FF) : const Color(0xFF6F61EF)),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
