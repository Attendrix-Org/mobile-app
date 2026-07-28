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

const String _rpcGetDateCacheKey = 'get_date_cache_key';
const String _rpcGetClassesForDate = 'get_classes_for_date';
const String _paramDate = 'p_date';

const int _maxRetries = 1; // up to 1 retry (2 attempts total) per RPC call
const Duration _retryDelay = Duration(milliseconds: 500);

const int _defaultUpcomingLimit = 5;
const int _maxLookaheadDays = 14;
const int _maxRangeDays = 366;
const int _maxRangeConcurrency = 8; // bounded parallelism for range fetches

/// Helper to generate date-specific cache keys (e.g., "schedule_cache_26_07_2026")
String _getCacheKey(DateTime date) {
  final dateStr = DateFormat('dd_MM_yyyy').format(date);
  return '$_cacheKeyPrefix$dateStr';
}

/// Retries [action] up to [_maxRetries] times on failure, with a flat
/// delay between attempts. [shouldRetry] lets the caller exclude
/// deterministic failures (e.g. auth/onboarding errors) that a retry
/// can't fix -- defaults to retrying everything.
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

/// Runs [task] over [items] with at most [concurrency] tasks in flight at
/// once. Used instead of an unbounded Future.wait for range fetches, so a
/// large calendar range doesn't open dozens of simultaneous RPC calls
/// against Supabase at once.
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
    classId: data['classId'] as String? ?? '',
    courseId: data['courseId'] as String? ?? '',
    courseCode: data['courseCode'] as String? ?? '',
    courseName: data['courseName'] as String? ?? '',
    batchId: data['batchId'] as String? ?? '',
    courseCategory: category,
    scheduledStart: scheduledStart,
    scheduledEnd: scheduledEnd,
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

/// In-flight de-duplication: if two callers request the same date's
/// schedule concurrently (e.g. "today" and "calendarDay" resolving to the
/// same date, or overlapping range/upcoming fetches), only one network
/// fetch is issued and every caller shares its result.
final Map<String, Future<List<ScheduledClassStruct>>> _inFlightFetches = {};

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

  // 2. Join an in-flight fetch for this exact date if one is already
  // running, instead of issuing a duplicate RPC round-trip.
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

/// Performs the actual network fetch + cache write + calendarDates update
/// for one date. Split out from [getScheduleForDate] so its Future can be
/// shared by concurrent callers via [_inFlightFetches].
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

  // get_date_cache_key is best-effort: on failure we fall back to a
  // synthetic key below, so a retry here just improves the odds of using
  // the server's real cache key instead of the fallback.
  String? newDateKey;
  try {
    final dynamic keyResponse = await _withRetry(
      () => Supabase.instance.client.rpc(_rpcGetDateCacheKey, params: {
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
    // PT401/PT404 are deterministic auth/onboarding failures -- retrying
    // won't change the outcome, so they're excluded from the retry.
    response = await _withRetry(
      () => Supabase.instance.client.rpc(_rpcGetClassesForDate,
          params: {_paramDate: formattedDate}).timeout(_rpcTimeout),
      shouldRetry: (e) => !(e is PostgrestException &&
          (e.code == 'PT401' || e.code == 'PT404')),
    );
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

  // 4. Add/Update date key in AppState calendarDates list.
  // Always prefixed with datePrefix -- getScheduleForDate's
  // startsWith(datePrefix) lookup depends on every stored entry having
  // it, including this success path where newDateKey comes from the RPC.
  final String dateKeyToAdd =
      '$datePrefix${newDateKey ?? DateTime.now().millisecondsSinceEpoch}';

  // Read FFAppState's CURRENT calendarDates inside the update() closure,
  // not a snapshot captured before the RPC awaits above. Concurrent calls
  // for other dates may have updated app state while this call was in
  // flight; using a stale snapshot would silently overwrite their
  // entries. The closure body runs synchronously, so this read is safe
  // from interleaving.
  FFAppState().update(() {
    final currentDates =
        List<String>.from(FFAppState().cacheMetaData.calendarDates);
    currentDates.removeWhere((e) => e.startsWith(datePrefix));
    currentDates.add(dateKeyToAdd);
    FFAppState().cacheMetaData.calendarDates = currentDates;
  });

  return _parseRows(response, 'get_classes_for_date');
}

/// Fetches [start, end] inclusive, capped at _maxRangeConcurrency
/// concurrent per-day RPCs. Reuses the per-date cache and in-flight
/// de-duplication in getScheduleForDate.
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

/// Walks forward day by day from [from], collecting classes starting
/// after `now`, until [limit] is reached or the lookahead cap is hit
/// (guards against looping indefinitely over an empty semester break).
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

/// Dispatches to the right fetch strategy for each FlutterFlow view type.
Future<List<ScheduledClassStruct>> executeScheduleQuery(
  ScheduleViewType viewType,
  DateTime? selectedDate,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
) async {
  switch (viewType) {
    case ScheduleViewType.today:
      // Literal today -- ManageClasses' "today" tab. Any selectedDate the
      // caller passes is intentionally ignored; use calendarDay for that.
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
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
