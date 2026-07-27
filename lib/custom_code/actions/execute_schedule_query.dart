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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleUnauthorizedException implements Exception {
  final String message;
  ScheduleUnauthorizedException(this.message);
  @override
  String toString() => message;
}

class ScheduleNotOnboardedException implements Exception {
  final String message;
  ScheduleNotOnboardedException(this.message);
  @override
  String toString() => message;
}

class ScheduleFetchException implements Exception {
  final String message;
  final String? code;
  ScheduleFetchException(this.message, {this.code});
  @override
  String toString() => 'ScheduleFetchException($code): $message';
}

const Duration _rpcTimeout = Duration(seconds: 10);
const String _cacheKeyPrefix = 'schedule_cache_';

/// Helper to generate date-specific cache keys (e.g., "schedule_cache_26_07_2026")
String _getCacheKey(DateTime date) {
  final dateStr = DateFormat('dd_MM_yyyy').format(date);
  return '$_cacheKeyPrefix$dateStr';
}

/// Parses a single RPC row into a [ScheduledClassStruct].
ScheduledClassStruct _parseScheduleRow(Map<String, dynamic> data) {
  final courseTypeRaw = data['courseType'] as String?;
  if (courseTypeRaw == null) {
    throw StateError('missing courseType');
  }

  final isAbsentRaw = data['isAbsent'] as bool?;
  final isExtraClassRaw = data['isExtraClass'] as bool?;
  if (isAbsentRaw == null || isExtraClassRaw == null) {
    throw StateError('missing isAbsent/isExtraClass');
  }

  final category = deserializeEnum<CourseType>(courseTypeRaw);
  if (category == null) {
    throw StateError('unrecognized courseType "$courseTypeRaw"');
  }

  final startRaw = data['scheduledStart'] as String?;
  final endRaw = data['scheduledEnd'] as String?;

  return ScheduledClassStruct(
    classId: data['classId'] as String? ?? '',
    courseId: data['courseId'] as String? ?? '',
    courseCode: data['courseCode'] as String? ?? '',
    courseName: data['courseName'] as String? ?? '',
    batchId: data['batchId'] as String? ?? '',
    courseCategory: category,
    scheduledStart:
        startRaw != null ? DateTime.parse(startRaw).toLocal() : null,
    scheduledEnd: endRaw != null ? DateTime.parse(endRaw).toLocal() : null,
    venue: (data['venue'] as String?)?.trim() ?? '',
    labGroup: data['labGroup'] as String?,
    isPlusSlot: data['isPlusSlot'] as bool? ?? false,
    isExtraClass: isExtraClassRaw,
    isAbsent: isAbsentRaw,
  );
}

/// Helper to safely iterate and parse raw JSON rows into structs
List<ScheduledClassStruct> _parseRows(List<dynamic> rows, String sourceTag) {
  final result = <ScheduledClassStruct>[];
  var skippedRows = 0;

  for (final row in rows) {
    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(row as Map);
    } catch (e) {
      skippedRows++;
      debugPrint('[$sourceTag] row is not a Map, skipping: $e | row=$row');
      continue;
    }

    try {
      result.add(_parseScheduleRow(data));
    } catch (e) {
      skippedRows++;
      debugPrint('[$sourceTag] failed parsing class ${data['classId']}: $e');
      continue;
    }
  }

  if (skippedRows > 0) {
    debugPrint(
        '[$sourceTag] $skippedRows row(s) skipped out of ${rows.length} total.');
  }

  return result;
}

/// Fetches schedule data for a specific date using date key validation in calendarDates + SharedPreferences cache.
Future<List<ScheduledClassStruct>> getScheduleForDate(
  DateTime targetDate, {
  bool forceRefresh = false,
}) async {
  final datePrefix = '${DateFormat('dd_MM_yyyy').format(targetDate)}_';
  final cacheKey = _getCacheKey(targetDate);
  final prefs = await SharedPreferences.getInstance();

  final calendarDates = FFAppState().cacheMetaData.calendarDates;
  final existingKey = calendarDates.firstWhere(
    (e) => e.startsWith(datePrefix),
    orElse: () => '',
  );

  // 1. If not forcing refresh AND date key is present in calendarDates -> Read from SharedPreferences & return instantly
  if (!forceRefresh && existingKey.isNotEmpty) {
    final cachedJsonStr = prefs.getString(cacheKey);
    if (cachedJsonStr != null && cachedJsonStr.isNotEmpty) {
      try {
        final decodedList = jsonDecode(cachedJsonStr) as List<dynamic>;
        debugPrint(
            '[ScheduleService] Cache hit (already in calendarDates: $existingKey) for $cacheKey');
        return _parseRows(decodedList, 'cache:$cacheKey');
      } catch (e) {
        debugPrint('[ScheduleService] Failed reading cache for $cacheKey: $e');
        await prefs.remove(cacheKey);
      }
    }
  }

  debugPrint(
      '[ScheduleService] Network fetch triggered for $cacheKey (force=$forceRefresh, inCalendarDates=${existingKey.isNotEmpty})');

  // 2. Fetch date cache key & fresh classes from Supabase
  final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);

  String? newDateKey;
  try {
    final dynamic keyResponse = await Supabase.instance.client.rpc(
        'get_date_cache_key',
        params: {'p_date': formattedDate}).timeout(const Duration(seconds: 5));
    if (keyResponse != null) {
      newDateKey = keyResponse.toString();
    }
  } catch (e) {
    debugPrint('[ScheduleService] get_date_cache_key skipped/failed: $e');
  }

  dynamic response;
  try {
    response = await Supabase.instance.client.rpc('get_classes_for_date',
        params: {'p_date': formattedDate}).timeout(_rpcTimeout);
  } on PostgrestException catch (e) {
    switch (e.code) {
      case 'PT401':
        throw ScheduleUnauthorizedException(e.message);
      case 'PT404':
        throw ScheduleNotOnboardedException(e.message);
      default:
        debugPrint(
            '[get_classes_for_date] PostgrestException (${e.code}): ${e.message}');
        throw ScheduleFetchException(e.message, code: e.code);
    }
  } catch (e) {
    debugPrint('[get_classes_for_date] unexpected error: $e');
    throw ScheduleFetchException(e.toString());
  }

  if (response is! List) {
    throw ScheduleFetchException(
      'RPC "get_classes_for_date" returned an unexpected response type: ${response.runtimeType}.',
    );
  }

  // 3. Save raw payload to SharedPreferences cache
  try {
    await prefs.setString(cacheKey, jsonEncode(response));
  } catch (e) {
    debugPrint('[ScheduleService] Failed writing cache for $cacheKey: $e');
  }

  // 4. Add/Update date key in AppState calendarDates list
  final String dateKeyToAdd =
      newDateKey ?? '$datePrefix${DateTime.now().millisecondsSinceEpoch}';
  final updatedDates = List<String>.from(calendarDates);
  updatedDates.removeWhere((e) => e.startsWith(datePrefix));
  updatedDates.add(dateKeyToAdd);

  FFAppState().update(() {
    FFAppState().cacheMetaData.calendarDates = updatedDates;
  });

  return _parseRows(response, 'get_classes_for_date');
}

/// Backward-compatible wrapper for FlutterFlow UI actions.
Future<List<ScheduledClassStruct>> executeScheduleQuery(
  ScheduleViewType viewType,
  DateTime? selectedDate,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
) async {
  final target = selectedDate ?? startDate ?? DateTime.now();
  return getScheduleForDate(target);
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
