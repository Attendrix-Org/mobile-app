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

const String _rpcGetDateCacheKey = 'get_date_cache_key';
const String _rpcGetClassesForDate = 'get_classes_for_date';
const String _paramDate = 'p_date';

const int _maxRetries = 1;
const Duration _retryDelay = Duration(milliseconds: 500);

const int _defaultUpcomingLimit = 5;
const int _maxLookaheadDays = 14;
const int _maxRangeDays = 366;
const int _maxRangeConcurrency = 8;

String _getCacheKey(DateTime date) {
  final dateStr = DateFormat('dd_MM_yyyy').format(date);
  return '$_cacheKeyPrefix$dateStr';
}

Future<T> _withRetry<T>(
  Future<T> Function() action, {
  bool Function(Object error)? shouldRetry,
}) async {
  var attempt = 0;
  while (true) {
    try {
      return await action();
    } catch (e) {
      final retryable = shouldRetry?.call(e) ?? true;
      attempt++;
      if (!retryable || attempt > _maxRetries) rethrow;
      debugPrint(
          '[ScheduleService] transient failure, retrying ($attempt/$_maxRetries): $e');
      await Future.delayed(_retryDelay);
    }
  }
}

Future<List<T>> _mapWithConcurrencyLimit<S, T>(
  List<S> items,
  int concurrency,
  Future<T> Function(S item) task,
) async {
  final results = List<T?>.filled(items.length, null);
  var nextIndex = 0;

  Future<void> worker() async {
    while (true) {
      final index = nextIndex;
      if (index >= items.length) return;
      nextIndex++;
      results[index] = await task(items[index]);
    }
  }

  final workerCount = concurrency < items.length ? concurrency : items.length;
  await Future.wait(List.generate(workerCount, (_) => worker()));
  return results.cast<T>();
}

ScheduledClassStruct _parseScheduleRow(Map<String, dynamic> data) {
  final courseTypeRaw = (data['courseType'] ??
          data['course_type'] ??
          data['courseCategory'] ??
          data['course_category'])
      ?.toString();

  final isAbsentRaw = (data['isAbsent'] ?? data['is_absent']) == true;
  final isExtraClassRaw =
      (data['isExtraClass'] ?? data['is_extra_class']) == true;

  CourseType? category;
  if (courseTypeRaw != null) {
    category = deserializeEnum<CourseType>(courseTypeRaw);
  }
  category ??= CourseType.theory;

  final startRaw =
      (data['scheduledStart'] ?? data['scheduled_start'])?.toString();
  final endRaw = (data['scheduledEnd'] ?? data['scheduled_end'])?.toString();

  if (startRaw == null || endRaw == null) {
    throw StateError('missing scheduledStart or scheduledEnd');
  }

  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  try {
    scheduledStart = DateTime.parse(startRaw).toLocal();
    scheduledEnd = DateTime.parse(endRaw).toLocal();
  } catch (e) {
    throw StateError('failed parsing timestamps ($startRaw / $endRaw): $e');
  }

  return ScheduledClassStruct(
    classId: (data['classId'] ?? data['class_id'])?.toString() ?? '',
    courseId: (data['courseId'] ?? data['course_id'])?.toString() ?? '',
    courseCode: (data['courseCode'] ?? data['course_code'])?.toString() ?? '',
    courseName: (data['courseName'] ?? data['course_name'])?.toString() ?? '',
    batchId: (data['batchId'] ?? data['batch_id'])?.toString() ?? '',
    courseCategory: category,
    scheduledStart: scheduledStart,
    scheduledEnd: scheduledEnd,
    venue: (data['venue'] as String?)?.trim() ?? '',
    labGroup: (data['labGroup'] ?? data['lab_group'])?.toString(),
    isPlusSlot: (data['isPlusSlot'] ?? data['is_plus_slot']) == true,
    isExtraClass: isExtraClassRaw,
    isAbsent: isAbsentRaw,
  );
}

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
      debugPrint(
          '[$sourceTag] failed parsing class ${data['classId'] ?? data['class_id']}: $e');
      continue;
    }
  }

  if (skippedRows > 0) {
    debugPrint(
        '[$sourceTag] $skippedRows row(s) skipped out of ${rows.length} total.');
  }

  return result;
}

final Map<String, Future<List<ScheduledClassStruct>>> _inFlightFetches = {};

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

  final inFlight = _inFlightFetches[cacheKey];
  if (inFlight != null) {
    debugPrint('[ScheduleService] Joining in-flight fetch for $cacheKey');
    return inFlight;
  }

  final fetchFuture = _fetchAndCacheScheduleForDate(
    targetDate: targetDate,
    datePrefix: datePrefix,
    cacheKey: cacheKey,
    prefs: prefs,
    forceRefresh: forceRefresh,
    existingKeyPresent: existingKey.isNotEmpty,
  );
  _inFlightFetches[cacheKey] = fetchFuture;
  try {
    return await fetchFuture;
  } finally {
    _inFlightFetches.remove(cacheKey);
  }
}

Future<List<ScheduledClassStruct>> _fetchAndCacheScheduleForDate({
  required DateTime targetDate,
  required String datePrefix,
  required String cacheKey,
  required SharedPreferences prefs,
  required bool forceRefresh,
  required bool existingKeyPresent,
}) async {
  debugPrint(
      '[ScheduleService] Network fetch triggered for $cacheKey (force=$forceRefresh, inCalendarDates=$existingKeyPresent)');

  final formattedDate = DateFormat('yyyy-MM-dd').format(targetDate);

  String? newDateKey;
  try {
    final dynamic keyResponse = await _withRetry(
      () => SupaFlow.client.rpc(_rpcGetDateCacheKey, params: {
        _paramDate: formattedDate
      }).timeout(const Duration(seconds: 5)),
    );
    if (keyResponse != null) {
      newDateKey = keyResponse.toString();
    }
  } catch (e) {
    debugPrint('[ScheduleService] get_date_cache_key skipped/failed: $e');
  }

  dynamic response;
  try {
    response = await _withRetry(
      () => SupaFlow.client.rpc(_rpcGetClassesForDate,
          params: {_paramDate: formattedDate}).timeout(_rpcTimeout),
      shouldRetry: (e) {
        try {
          final dynamic err = e;
          final code = err.code?.toString();
          return !(code == 'PT401' || code == 'PT404');
        } catch (_) {
          return true;
        }
      },
    );
  } catch (e) {
    String? code;
    String message = e.toString();
    try {
      final dynamic err = e;
      if (err.code != null) code = err.code.toString();
      if (err.message != null) message = err.message.toString();
    } catch (_) {}

    switch (code) {
      case 'PT401':
        throw ScheduleUnauthorizedException(message);
      case 'PT404':
        throw ScheduleNotOnboardedException(message);
      default:
        debugPrint(
            '[get_classes_for_date] error ($code): $message');
        throw ScheduleFetchException(message, code: code);
    }
  }

  if (response is! List) {
    throw ScheduleFetchException(
      'RPC "get_classes_for_date" returned an unexpected response type: ${response.runtimeType}.',
    );
  }

  try {
    await prefs.setString(cacheKey, jsonEncode(response));
  } catch (e) {
    debugPrint('[ScheduleService] Failed writing cache for $cacheKey: $e');
  }

  final String dateKeyToAdd =
      '$datePrefix${newDateKey ?? DateTime.now().millisecondsSinceEpoch}';

  FFAppState().update(() {
    final currentDates =
        List<String>.from(FFAppState().cacheMetaData.calendarDates);
    currentDates.removeWhere((e) => e.startsWith(datePrefix));
    currentDates.add(dateKeyToAdd);
    FFAppState().cacheMetaData.calendarDates = currentDates;
  });

  return _parseRows(response, 'get_classes_for_date');
}

Future<List<ScheduledClassStruct>> _getScheduleForRange(
  DateTime start,
  DateTime end, {
  int? limit,
}) async {
  final normalizedStart = DateTime(start.year, start.month, start.day);
  final normalizedEnd = DateTime(end.year, end.month, end.day);

  if (normalizedEnd.isBefore(normalizedStart)) {
    throw ArgumentError('endDate ($end) is before startDate ($start).');
  }

  final totalDays = normalizedEnd.difference(normalizedStart).inDays + 1;
  if (totalDays > _maxRangeDays) {
    throw ArgumentError(
        'Range spans $totalDays days, exceeding the $_maxRangeDays-day cap.');
  }

  final dateStrings = List<String>.generate(
    totalDays,
    (i) => DateFormat('yyyy-MM-dd')
        .format(normalizedStart.add(Duration(days: i))),
  );

  try {
    final dynamic response = await _withRetry(
      () => SupaFlow.client.rpc('get_classes_for_dates', params: {
        'p_dates': dateStrings,
      }).timeout(_rpcTimeout),
    );

    final dynamic rawData =
        response is String ? jsonDecode(response) : response;
    if (rawData is List) {
      final parsed = _parseRows(rawData, 'get_classes_for_dates:range');
      if (limit != null && parsed.length > limit) {
        return parsed.take(limit).toList();
      }
      return parsed;
    }
  } catch (e) {
    debugPrint(
        '[executeScheduleQuery:get_classes_for_dates] range batch call failed ($e), falling back to per-date fetch.');
  }

  final dates = List<DateTime>.generate(
    totalDays,
    (i) => normalizedStart.add(Duration(days: i)),
  );

  final results = await _mapWithConcurrencyLimit(
    dates,
    _maxRangeConcurrency,
    (date) async {
      try {
        return await getScheduleForDate(date);
      } on ScheduleUnauthorizedException {
        rethrow;
      } on ScheduleNotOnboardedException {
        rethrow;
      } catch (e) {
        debugPrint(
            '[executeScheduleQuery:range] skipping ${date.toIso8601String()}: $e');
        return <ScheduledClassStruct>[];
      }
    },
  );

  final combined = results.expand((classes) => classes).toList();
  if (limit != null && combined.length > limit) {
    return combined.take(limit).toList();
  }
  return combined;
}

Future<List<ScheduledClassStruct>> _getUpcomingClasses({
  required DateTime from,
  required int limit,
}) async {
  final now = DateTime.now();
  final result = <ScheduledClassStruct>[];
  var cursor = DateTime(from.year, from.month, from.day);
  var daysChecked = 0;

  while (result.length < limit && daysChecked < _maxLookaheadDays) {
    List<ScheduledClassStruct> dayClasses;
    try {
      dayClasses = await getScheduleForDate(cursor);
    } on ScheduleUnauthorizedException {
      rethrow;
    } on ScheduleNotOnboardedException {
      rethrow;
    } catch (e) {
      debugPrint(
          '[executeScheduleQuery:upcoming] skipping ${cursor.toIso8601String()}: $e');
      dayClasses = <ScheduledClassStruct>[];
    }

    result.addAll(dayClasses.where((c) {
      final classStart = c.scheduledStart;
      return classStart != null && classStart.isAfter(now);
    }));

    cursor = cursor.add(const Duration(days: 1));
    daysChecked++;
  }

  result.sort((a, b) {
    final aStart = a.scheduledStart;
    final bStart = b.scheduledStart;
    if (aStart == null || bStart == null) return 0;
    return aStart.compareTo(bStart);
  });

  return result.take(limit).toList();
}

Future<List<ScheduledClassStruct>> executeScheduleQuery(
  ScheduleViewType viewType,
  DateTime? selectedDate,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
) async {
  switch (viewType) {
    case ScheduleViewType.today:
      return getScheduleForDate(DateTime.now());

    case ScheduleViewType.current:
      final now = DateTime.now();
      final classes = await getScheduleForDate(now);
      return classes.where((c) {
        final classStart = c.scheduledStart;
        final classEnd = c.scheduledEnd;
        if (classStart == null || classEnd == null) return false;
        return !now.isBefore(classStart) && !now.isAfter(classEnd);
      }).toList();

    case ScheduleViewType.upcoming:
      return _getUpcomingClasses(
        from: selectedDate ?? startDate ?? DateTime.now(),
        limit: limit ?? _defaultUpcomingLimit,
      );

    case ScheduleViewType.calendarDay:
      final day = selectedDate ?? startDate;
      if (day == null) {
        throw ArgumentError(
            'ScheduleViewType.calendarDay requires selectedDate (or startDate).');
      }
      return getScheduleForDate(day);

    case ScheduleViewType.calendarRange:
      if (startDate == null || endDate == null) {
        throw ArgumentError(
            'ScheduleViewType.calendarRange requires both startDate and endDate.');
      }
      return _getScheduleForRange(startDate, endDate, limit: limit);

    default:
      throw ArgumentError('Unhandled ScheduleViewType: $viewType');
  }
}
