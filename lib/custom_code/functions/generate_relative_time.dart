import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String generateRelativeTime(
  DateTime? targetTime,
  bool? longer,
) {
  if (targetTime == null) return '';

  final isLonger = longer ?? false;

  // Convert targetTime to the device's local timezone
  final localTarget = targetTime.toLocal();
  final now = DateTime.now();

  // Handle past dates
  if (localTarget.isBefore(now)) {
    return isLonger ? 'Already passed' : 'Passed';
  }

  final difference = localTarget.difference(now);
  final totalMinutes = difference.inMinutes;
  final totalHours = difference.inHours;
  final totalDays = difference.inDays;

  // Precise Calendar Month Calculation in Local Time
  int totalMonths =
      (localTarget.year - now.year) * 12 + (localTarget.month - now.month);
  if (localTarget.day < now.day) {
    totalMonths--; // Hasn't completed a full month cycle yet
  }
  totalMonths = math.max(0, totalMonths);

  // Helper for clean pluralization (e.g., "1 hour" vs "2 hours")
  String _p(int count, String singular, [String? plural]) {
    return '$count ${count == 1 ? singular : (plural ?? '${singular}s')}';
  }

  // ==========================================
  // SHORTER VERSION (longer == false)
  // ==========================================
  if (!isLonger) {
    // 1. More than a month (>= 1 month)
    if (totalMonths >= 1) {
      return 'in ${_p(totalMonths, 'month')}';
    }

    // 2. More than a week (>= 7 days)
    if (totalDays >= 7) {
      final weeks = totalDays ~/ 7;
      final days = totalDays % 7;

      if (days > 0) {
        return 'in ${_p(weeks, 'week')}, ${_p(days, 'day')}';
      }
      return 'in ${_p(weeks, 'week')}';
    }

    // 3. Check if target date is Tomorrow (Calendar Check in Local Time)
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final isTomorrow = localTarget.year == tomorrow.year &&
        localTarget.month == tomorrow.month &&
        localTarget.day == tomorrow.day;

    if (isTomorrow) {
      return 'Tomorrow';
    }

    // 4. More than 1 day (>= 1 day)
    if (totalDays >= 1) {
      return 'in ${_p(totalDays, 'day')}';
    }

    // 5. Less than a day
    if (totalHours >= 1) {
      return 'in ${_p(totalHours, 'hour')}';
    } else if (totalMinutes >= 1) {
      return 'in ${_p(totalMinutes, 'min')}';
    } else {
      return 'Just now';
    }
  }

  // ==========================================
  // LONGER VERSION (longer == true)
  // ==========================================

  // 1. More than a month (>= 1 month)
  if (totalMonths >= 1) {
    final approxMonthDate =
        DateTime(now.year, now.month + totalMonths, now.day);
    final remainingDays = localTarget.difference(approxMonthDate).inDays;

    if (remainingDays > 0) {
      return 'in ${_p(totalMonths, 'month')} and ${_p(remainingDays, 'day')}';
    }
    return 'in ${_p(totalMonths, 'month')}';
  }

  // 2. More than a week (>= 7 days)
  if (totalDays >= 7) {
    final weeks = totalDays ~/ 7;
    final days = totalDays % 7;

    if (days > 0) {
      return 'in ${_p(weeks, 'week')} and ${_p(days, 'day')}';
    }
    return 'in ${_p(weeks, 'week')}';
  }

  // 3. More than 1 day (>= 1 day)
  if (totalDays >= 1) {
    final hours = totalHours % 24;

    if (hours > 0) {
      return 'in ${_p(totalDays, 'day')} and ${_p(hours, 'hour')}';
    }
    return 'in ${_p(totalDays, 'day')}';
  }

  // 4. Less than a day (>= 1 hour)
  if (totalHours >= 1) {
    final minutes = totalMinutes % 60;

    if (minutes > 0) {
      return 'in ${_p(totalHours, 'hour')} and ${_p(minutes, 'minute')}';
    }
    return 'in ${_p(totalHours, 'hour')}';
  }

  // 5. Less than an hour (>= 1 minute)
  if (totalMinutes >= 1) {
    return 'in about ${_p(totalMinutes, 'minute')}';
  }

  // 6. Less than a minute (< 60 seconds)
  return 'in a few seconds';
}
