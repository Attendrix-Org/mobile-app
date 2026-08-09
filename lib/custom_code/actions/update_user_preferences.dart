// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:io';

/// Formats any raw time string (e.g. "7:00 AM", "10:30 PM", "22:00", "07:00:00")
/// into a valid Supabase PostgreSQL TIME format ("HH:mm:ss").
String _formatTimeForSupabase(String? raw, String fallback) {
  if (raw == null || raw.trim().isEmpty) return fallback;
  final str = raw.trim();

  // Parse 12-hour format with AM/PM (e.g., "7:00 AM", "10:30 PM", "12:00 AM")
  final amPmMatch = RegExp(
    r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*(AM|PM)$',
    caseSensitive: false,
  ).firstMatch(str);

  if (amPmMatch != null) {
    int h = int.parse(amPmMatch.group(1)!);
    final int m = int.parse(amPmMatch.group(2)!);
    final String period = amPmMatch.group(3)!.toUpperCase();

    if (period == 'PM' && h < 12) h += 12;
    if (period == 'AM' && h == 12) h = 0;

    final hStr = h.toString().padLeft(2, '0');
    final mStr = m.toString().padLeft(2, '0');
    return '$hStr:$mStr:00';
  }

  // Parse 24-hour format (e.g., "07:00:00", "22:00:00", "7:00")
  final time24Match =
      RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(str);
  if (time24Match != null) {
    final int h = int.parse(time24Match.group(1)!);
    final int m = int.parse(time24Match.group(2)!);
    final int s =
        time24Match.group(3) != null ? int.parse(time24Match.group(3)!) : 0;

    if (h >= 0 && h <= 23 && m >= 0 && m <= 59 && s >= 0 && s <= 59) {
      final hStr = h.toString().padLeft(2, '0');
      final mStr = m.toString().padLeft(2, '0');
      final sStr = s.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
  }

  return fallback;
}

Future<bool> updateUserPreferences(
  UserPreferencesStruct? userPrefs,
) async {
  if (userPrefs == null) {
    debugPrint('updateUserPreferences: Aborted - null userPrefs provided.');
    return false;
  }

  final userId = SupaFlow.client.auth.currentUser?.id;
  if (userId == null || userId.isEmpty) {
    debugPrint(
        'updateUserPreferences: Aborted - No active authenticated user session.');
    return false;
  }

  final int nowMs = DateTime.now().millisecondsSinceEpoch;

  // 1. Immediately persist to local AppState & stamp cache metadata
  try {
    FFAppState().update(() {
      FFAppState().userPreferences = userPrefs;
      final localMeta = FFAppState().cacheMetaData ?? CacheMetadataStruct();
      FFAppState().cacheMetaData = CacheMetadataStruct(
        appVersion: localMeta.appVersion,
        generatedAt: localMeta.generatedAt,
        profileUpdatedAt: localMeta.profileUpdatedAt,
        userPreferencesUpdatedAt: nowMs,
        dashboardUpdatedAt: localMeta.dashboardUpdatedAt,
        calendarClassesUpdatedAt: localMeta.calendarClassesUpdatedAt,
        absencesUpdatedAt: localMeta.absencesUpdatedAt,
        busUpdatedAt: localMeta.busUpdatedAt,
        messUpdatedAt: localMeta.messUpdatedAt,
        apodLastFetchedAt: localMeta.apodLastFetchedAt,
        calendarDates: localMeta.calendarDates,
      );
    });
  } catch (appStateErr) {
    debugPrint('updateUserPreferences: AppState update error: $appStateErr');
    return false;
  }

  // 2. Build non-null, hardened Supabase payload with PostgreSQL TIME formatting
  final Map<String, dynamic> updatePayload = {
    'user_id': userId,
    'enable_apod': userPrefs.enableAPOD,
    'user_mess': userPrefs.userMess,
    'at_a_glance_view': userPrefs.atAGlanceView,
    'use_scheduled_classes_for_greeting_message':
        userPrefs.useScheduledClassesForGreetingMessage,
    'use_action_tone_for_greeting_message':
        userPrefs.useActionToneForGreetingMessage,
    'time_format':
        userPrefs.preferredTimeFormat == TimeFormat.twelveHour ? '12h' : '24h',
    'action_tone': userPrefs.preferredActionTone.name,
    'attendance_threshold': userPrefs.attendanceThreshold,
    'theme': userPrefs.theme.isNotEmpty ? userPrefs.theme : 'system',
    'timezone':
        userPrefs.timezone.isNotEmpty ? userPrefs.timezone : 'Asia/Kolkata',
    'language': userPrefs.language.isNotEmpty ? userPrefs.language : 'en',
    'notifications_enabled': userPrefs.notificationsEnabled,
    'notif_class_reminder': userPrefs.notifClassReminder,
    'notif_reminder_minutes': userPrefs.notifReminderMinutes,
    'notif_class_cancelled': userPrefs.notifClassCancelled,
    'notif_class_rescheduled': userPrefs.notifClassRescheduled,
    'notif_task_published': userPrefs.notifTaskPublished,
    'notif_task_due_soon': userPrefs.notifTaskDueSoon,
    'notif_exam_reminder': userPrefs.notifExamReminder,
    'notif_daily_brief': userPrefs.notifDailyBrief,
    'notif_attendance_alert': userPrefs.notifAttendanceAlert,
    'notif_weekly_summary': userPrefs.notifWeeklySummary,
    'quiet_hours_enabled': userPrefs.quietHoursEnabled,
    'quiet_hours_start':
        _formatTimeForSupabase(userPrefs.quietHoursStart, '22:00:00'),
    'quiet_hours_end':
        _formatTimeForSupabase(userPrefs.quietHoursEnd, '07:00:00'),
    'notif_mess_reminder': userPrefs.notifMessReminder,
    'notif_breakfast_reminder': userPrefs.notifBreakfastReminder,
    'notif_lunch_reminder': userPrefs.notifLunchReminder,
    'notif_evening_tea_reminder': userPrefs.notifEveningTeaReminder,
    'notif_dinner_reminder': userPrefs.notifDinnerReminder,
    'notif_mess_reminder_minutes': userPrefs.notifMessReminderMinutes,
    'daily_brief_time':
        _formatTimeForSupabase(userPrefs.dailyBriefTime, '07:00:00'),
    'updated_at': DateTime.fromMillisecondsSinceEpoch(nowMs).toIso8601String(),
  };

  // 3. Robust Supabase update with retry loop & backoff
  int attempt = 0;
  const int maxRetries = 3;
  const Duration timeout = Duration(seconds: 10);

  while (attempt < maxRetries) {
    attempt++;
    try {
      await SupaFlow.client
          .from('user_preferences')
          .upsert(updatePayload)
          .timeout(timeout);

      debugPrint(
          'updateUserPreferences: Persisted successfully on attempt $attempt.');
      return true;
    } catch (e) {
      final String errStr = e.toString().toLowerCase();
      final bool isTransient = e is TimeoutException ||
          e is SocketException ||
          errStr.contains('socketexception') ||
          errStr.contains('timeoutexception') ||
          errStr.contains('httpexception') ||
          errStr.contains('handshakeexception') ||
          errStr.contains('502') ||
          errStr.contains('503') ||
          errStr.contains('504');

      if (isTransient && attempt < maxRetries) {
        final int delayMs = 300 * (1 << (attempt - 1));
        debugPrint(
            'updateUserPreferences: Transient failure (attempt $attempt/$maxRetries). Retrying in ${delayMs}ms... Error: $e');
        await Future.delayed(Duration(milliseconds: delayMs));
        continue;
      }

      debugPrint(
          'updateUserPreferences: Database update failed ($e). Local preferences preserved offline for auto-sync.');
      return true;
    }
  }

  return true;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
