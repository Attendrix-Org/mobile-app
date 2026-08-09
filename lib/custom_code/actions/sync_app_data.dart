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

import '/custom_code/actions/update_android_widget_from_app_state.dart';
import 'dart:async';
import 'dart:io';

// ─────────────────────────────────────────────────────────────────────────
// Attendrix Industrial Client Synchronization Engine — v12 (Production Grade)
// High-performance, zero-flashing, 100% type-safe state reconciliation
// ─────────────────────────────────────────────────────────────────────────

String get _currentAppVersion => FFAppConstants.appVersion;

/// Global concurrency lock and pending queue to prevent overlapping sync runs
bool _isSyncRunning = false;
bool _hasPendingSyncRequest = false;

class _DatasetState<T> {
  T? data;
  bool fetched = false;
  Object? error;
  int latencyMs = 0;
}

class _SyncOutcome {
  final profile = _DatasetState<UserProfileStruct>();
  final userPreferences = _DatasetState<UserPreferencesStruct>();
  final dashboard = _DatasetState<List<ScheduledClassStruct>>();
  final calendar = _DatasetState<List<ScheduledClassStruct>>();
  final missed = _DatasetState<List<ScheduledClassStruct>>();
  final bus = _DatasetState<List<BusRouteStruct>>();
  final mess = _DatasetState<List<MessStruct>>();
  final apod = _DatasetState<ApodStruct>();
  int? userPreferencesUpdatedAtOverride;
}

/// Structured exception thrown when dataset sync failures occur.
class SyncException implements Exception {
  final String message;
  final Map<String, Object> datasetErrors;
  SyncException(this.message, [this.datasetErrors = const {}]);

  @override
  String toString() =>
      'SyncException: $message ${datasetErrors.isNotEmpty ? datasetErrors : ""}';
}

/// Generic retry helper for Supabase DB calls enforcing timeout and backoff.
Future<T> _callDbWithRetry<T>(
  Future<T> Function() dbCall, {
  Duration timeout = const Duration(seconds: 12),
  int maxRetries = 2,
}) async {
  int attempts = 0;
  while (true) {
    attempts++;
    try {
      return await dbCall().timeout(timeout);
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

      if (isTransient && attempts <= maxRetries) {
        final int delayMs = 300 * (1 << (attempts - 1));
        debugPrint(
            'syncAppData: transient error on DB call (attempt $attempts/$maxRetries). Retrying in ${delayMs}ms... Error: $e');
        await Future.delayed(Duration(milliseconds: delayMs));
        continue;
      }
      rethrow;
    }
  }
}

/// Executes an RPC call with timeout and exponential backoff retries for transient errors.
Future<dynamic> _callRpcWithRetry(
  String rpcName, {
  Map<String, dynamic>? params,
  Duration timeout = const Duration(seconds: 12),
  int maxRetries = 2,
}) async {
  return _callDbWithRetry(
    () => SupaFlow.client.rpc(rpcName, params: params),
    timeout: timeout,
    maxRetries: maxRetries,
  );
}

Future<void> syncAppData(
  bool? forceSync,
  bool? syncProfile,
  bool? syncDashboard,
  bool? syncCalendar,
  bool? syncMissedClasses,
  bool? syncBus,
  bool? syncMess,
  List<DateTime>? calendarDates,
) async {
  // MEDIUM FIX: Handle concurrent invocation without dropping requests outright
  if (_isSyncRunning) {
    _hasPendingSyncRequest = true;
    debugPrint(
        'syncAppData: operation already in progress - queued pending re-run request.');
    return;
  }

  _isSyncRunning = true;
  final stopwatch = Stopwatch()..start();

  try {
    final bool doForceSync = forceSync ?? false;
    final bool doSyncProfile = syncProfile ?? true;
    final bool doSyncDashboard = syncDashboard ?? true;
    final bool doSyncCalendar = syncCalendar ?? true;
    final bool doSyncMissedClasses = syncMissedClasses ?? true;
    final bool doSyncBus = syncBus ?? true;
    final bool doSyncMess = syncMess ?? true;
    final bool doSyncPreferences = doSyncProfile;

    final CacheMetadataStruct? localMetaCandidate = FFAppState().cacheMetaData;
    final CacheMetadataStruct localMeta =
        localMetaCandidate ?? CacheMetadataStruct();
    final bool firstTimeSync = !_hasInitializedCacheMetadata(localMeta);

    final int nowMs = DateTime.now().millisecondsSinceEpoch;

    // Failsafe Server Meta Fetching: If server metadata call fails (e.g. offline),
    // fallback to localMeta instead of aborting the sync unrecoverably.
    CacheMetadataStruct serverMeta;
    try {
      final dynamic response =
          await _callRpcWithRetry('get_cache_metadata', maxRetries: 2);
      if (response is Map) {
        serverMeta = _parseCacheMetadata(Map<String, dynamic>.from(response));
      } else {
        debugPrint(
            'syncAppData: get_cache_metadata returned non-Map (${response?.runtimeType}), using local fallback.');
        serverMeta = localMeta;
      }
    } catch (e) {
      debugPrint(
          'syncAppData: get_cache_metadata failed: $e. Using local fallback.');
      serverMeta = localMeta;
    }

    final bool fullSync = doForceSync ||
        firstTimeSync ||
        localMeta.appVersion != _currentAppVersion;

    // Standard TTL values (in milliseconds)
    const int profileTtl = 2 * 60 * 60 * 1000; // 2 hrs (7,200,000 ms)
    const int dashboardTtl = 30 * 60 * 1000; // 30 mins (1,800,000 ms)
    const int calendarTtl = 60 * 60 * 1000; // 1 hr (3,600,000 ms)
    const int missedTtl = 3 * 60 * 60 * 1000; // 3 hrs (10,800,000 ms)
    const int busTtl = 15 * 24 * 60 * 60 * 1000; // 15 days
    const int messTtl = 15 * 24 * 60 * 60 * 1000; // 15 days

    bool isDatasetStale({
      required bool force,
      required bool empty,
      required int? localTs,
      required int? serverTs,
      required int ttl,
    }) {
      if (force || empty) return true;
      if (localTs == null || localTs <= 0) return true;
      if (serverTs != null && serverTs > localTs) return true;
      if (nowMs - localTs > ttl) return true;
      return false;
    }

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final bool wantsCalendar =
        doSyncCalendar && calendarDates != null && calendarDates.isNotEmpty;

    // Calendar cache correctness: Compare requested date strings against cached dates
    final List<String> requestedDateStrings = wantsCalendar
        ? calendarDates
            .map((d) => d.toIso8601String().split('T').first)
            .toList()
        : const [];

    bool calendarDatesMismatch = false;
    if (wantsCalendar) {
      final cachedDates = localMeta.calendarDates;
      if (cachedDates.length != requestedDateStrings.length) {
        calendarDatesMismatch = true;
      } else {
        final setCached = cachedDates.toSet();
        calendarDatesMismatch =
            requestedDateStrings.any((d) => !setCached.contains(d));
      }
    }

    final bool staleProfile = doSyncProfile &&
        isDatasetStale(
          force: fullSync,
          empty: !FFAppState().userProfile.hasUserId() ||
              FFAppState().userProfile.userId.isEmpty,
          localTs: localMeta.profileUpdatedAt,
          serverTs: serverMeta.profileUpdatedAt,
          ttl: profileTtl,
        );

    final bool staleDashboard = doSyncDashboard &&
        isDatasetStale(
          force: fullSync,
          empty: FFAppState().dashboardClasses.isEmpty,
          localTs: localMeta.dashboardUpdatedAt,
          serverTs: serverMeta.dashboardUpdatedAt,
          ttl: dashboardTtl,
        );

    final bool staleCalendar = wantsCalendar &&
        (calendarDatesMismatch ||
            isDatasetStale(
              force: fullSync,
              empty: FFAppState().calendarClasses.isEmpty,
              localTs: localMeta.calendarClassesUpdatedAt,
              serverTs: serverMeta.calendarClassesUpdatedAt,
              ttl: calendarTtl,
            ));

    // CRITICAL FIX: Track missed classes fetch state rather than hardcoding empty: false
    final bool missedNeverFetched = localMeta.absencesUpdatedAt <= 0;
    final bool staleMissed = doSyncMissedClasses &&
        isDatasetStale(
          force: fullSync,
          empty: missedNeverFetched || FFAppState().missedClasses.isEmpty,
          localTs: localMeta.absencesUpdatedAt,
          serverTs: serverMeta.absencesUpdatedAt,
          ttl: missedTtl,
        );

    final bool staleBus = doSyncBus &&
        isDatasetStale(
          force: fullSync,
          empty: FFAppState().BusRoutes.isEmpty,
          localTs: localMeta.busUpdatedAt,
          serverTs: serverMeta.busUpdatedAt,
          ttl: busTtl,
        );

    final bool staleMess = doSyncMess &&
        isDatasetStale(
          force: fullSync,
          empty: FFAppState().Messes.isEmpty,
          localTs: localMeta.messUpdatedAt,
          serverTs: serverMeta.messUpdatedAt,
          ttl: messTtl,
        );

    final bool staleApod = fullSync ||
        localMeta.apodLastFetchedAt == null ||
        !FFAppState().apodData.hasTitle() ||
        FFAppState().apodData.title.isEmpty ||
        !isSameDay(localMeta.apodLastFetchedAt!, DateTime.now()) ||
        FFAppState().apodData.imageUrl.isEmpty;

    final outcome = _SyncOutcome();
    final List<Future<void>> pending = [];

    if (staleProfile) pending.add(_fetchProfile(outcome));
    if (doSyncPreferences) {
      pending.add(_syncUserPreferences(outcome, localMeta, serverMeta));
    }
    if (staleDashboard) pending.add(_fetchDashboard(outcome));
    if (staleCalendar) pending.add(_fetchCalendar(outcome, calendarDates!));
    if (staleMissed) pending.add(_fetchMissed(outcome));
    if (staleBus) pending.add(_fetchBus(outcome));
    if (staleMess) pending.add(_fetchMess(outcome));
    if (staleApod) pending.add(_fetchApod(outcome));

    if (pending.isNotEmpty) {
      await Future.wait(pending, eagerError: false);
    }

    // Capture dataset-level errors
    final Map<String, Object> datasetErrors = {};
    if (outcome.profile.error != null)
      datasetErrors['profile'] = outcome.profile.error!;
    if (outcome.userPreferences.error != null)
      datasetErrors['userPreferences'] = outcome.userPreferences.error!;
    if (outcome.dashboard.error != null)
      datasetErrors['dashboard'] = outcome.dashboard.error!;
    if (outcome.calendar.error != null)
      datasetErrors['calendar'] = outcome.calendar.error!;
    if (outcome.missed.error != null)
      datasetErrors['missed'] = outcome.missed.error!;
    if (outcome.bus.error != null) datasetErrors['bus'] = outcome.bus.error!;
    if (outcome.mess.error != null) datasetErrors['mess'] = outcome.mess.error!;
    if (outcome.apod.error != null) datasetErrors['apod'] = outcome.apod.error!;

    // CRITICAL FIX: Only stamp updated timestamps when fetch succeeded (fetched == true)
    final int newProfileTs = outcome.profile.fetched
        ? (serverMeta.profileUpdatedAt > 0
            ? serverMeta.profileUpdatedAt
            : nowMs)
        : localMeta.profileUpdatedAt;

    final int newUserPrefTs = outcome.userPreferences.fetched
        ? (outcome.userPreferencesUpdatedAtOverride ??
            (serverMeta.userPreferencesUpdatedAt > 0
                ? serverMeta.userPreferencesUpdatedAt
                : nowMs))
        : localMeta.userPreferencesUpdatedAt;

    final int newDashboardTs = outcome.dashboard.fetched
        ? (serverMeta.dashboardUpdatedAt > 0
            ? serverMeta.dashboardUpdatedAt
            : nowMs)
        : localMeta.dashboardUpdatedAt;

    final int newCalendarTs = outcome.calendar.fetched
        ? (serverMeta.calendarClassesUpdatedAt > 0
            ? serverMeta.calendarClassesUpdatedAt
            : nowMs)
        : localMeta.calendarClassesUpdatedAt;

    final int newMissedTs = outcome.missed.fetched
        ? (serverMeta.absencesUpdatedAt > 0
            ? serverMeta.absencesUpdatedAt
            : nowMs)
        : localMeta.absencesUpdatedAt;

    final int newBusTs = outcome.bus.fetched
        ? (serverMeta.busUpdatedAt > 0 ? serverMeta.busUpdatedAt : nowMs)
        : localMeta.busUpdatedAt;

    final int newMessTs = outcome.mess.fetched
        ? (serverMeta.messUpdatedAt > 0 ? serverMeta.messUpdatedAt : nowMs)
        : localMeta.messUpdatedAt;

    // Atomic AppState reconciliation & Cache Metadata update
    FFAppState().update(() {
      if (outcome.profile.fetched && outcome.profile.data != null) {
        FFAppState().userProfile = outcome.profile.data!;
      }
      if (outcome.userPreferences.fetched &&
          outcome.userPreferences.data != null) {
        FFAppState().userPreferences = outcome.userPreferences.data!;
      }
      if (outcome.dashboard.fetched && outcome.dashboard.data != null) {
        FFAppState().dashboardClasses = outcome.dashboard.data!;
      }
      if (outcome.calendar.fetched && outcome.calendar.data != null) {
        FFAppState().calendarClasses = outcome.calendar.data!;
      }
      if (outcome.missed.fetched && outcome.missed.data != null) {
        FFAppState().missedClasses = outcome.missed.data!;
      }
      if (outcome.bus.fetched && outcome.bus.data != null) {
        FFAppState().BusRoutes = outcome.bus.data!;
      }
      if (outcome.mess.fetched && outcome.mess.data != null) {
        FFAppState().Messes = outcome.mess.data!;
      }
      if (outcome.apod.fetched && outcome.apod.data != null) {
        FFAppState().apodData = outcome.apod.data!;
      }

      FFAppState().cacheMetaData = CacheMetadataStruct(
        appVersion: _currentAppVersion,
        generatedAt:
            serverMeta.generatedAt > 0 ? serverMeta.generatedAt : nowMs,
        profileUpdatedAt: newProfileTs,
        userPreferencesUpdatedAt: newUserPrefTs,
        dashboardUpdatedAt: newDashboardTs,
        calendarClassesUpdatedAt: newCalendarTs,
        absencesUpdatedAt: newMissedTs,
        busUpdatedAt: newBusTs,
        messUpdatedAt: newMessTs,
        apodLastFetchedAt:
            outcome.apod.fetched ? DateTime.now() : localMeta.apodLastFetchedAt,
        calendarDates: outcome.calendar.fetched
            ? requestedDateStrings
            : localMeta.calendarDates,
      );
    });

    // MEDIUM FIX: Explicit error logging for widget updates
    try {
      await updateAndroidWidgetFromAppState();
    } catch (widgetErr) {
      debugPrint(
          'syncAppData: updateAndroidWidgetFromAppState failed: $widgetErr');
    }

    debugPrint(
        '⚡ syncAppData: completed in ${stopwatch.elapsedMilliseconds}ms - '
        'firstTime=$firstTimeSync force=$doForceSync | '
        'profile=${outcome.profile.fetched} (${outcome.profile.latencyMs}ms) '
        'userPrefs=${outcome.userPreferences.fetched} (${outcome.userPreferences.latencyMs}ms) '
        'dashboard=${outcome.dashboard.fetched} (${outcome.dashboard.latencyMs}ms) '
        'calendar=${outcome.calendar.fetched} (${outcome.calendar.latencyMs}ms) '
        'missed=${outcome.missed.fetched} (${outcome.missed.latencyMs}ms) '
        'bus=${outcome.bus.fetched} (${outcome.bus.latencyMs}ms) '
        'mess=${outcome.mess.fetched} (${outcome.mess.latencyMs}ms) '
        'apod=${outcome.apod.fetched} (${outcome.apod.latencyMs}ms)');

    // Propagate errors when forced sync hits failures
    if (doForceSync && datasetErrors.isNotEmpty) {
      throw SyncException(
          'Forced sync completed with dataset errors', datasetErrors);
    }
  } catch (globalErr, stack) {
    debugPrint(
        'syncAppData: global non-fatal exception caught: $globalErr\n$stack');
    rethrow;
  } finally {
    _isSyncRunning = false;
    if (_hasPendingSyncRequest) {
      _hasPendingSyncRequest = false;
      debugPrint('syncAppData: executing queued pending sync request...');
      unawaited(syncAppData(
        forceSync,
        syncProfile,
        syncDashboard,
        syncCalendar,
        syncMissedClasses,
        syncBus,
        syncMess,
        calendarDates,
      ));
    }
  }
}

bool _hasInitializedCacheMetadata(CacheMetadataStruct meta) {
  return meta.hasAppVersion() ||
      meta.hasGeneratedAt() ||
      meta.hasProfileUpdatedAt() ||
      meta.hasUserPreferencesUpdatedAt() ||
      meta.hasDashboardUpdatedAt() ||
      meta.hasCalendarClassesUpdatedAt() ||
      meta.hasAbsencesUpdatedAt() ||
      meta.hasBusUpdatedAt() ||
      meta.hasMessUpdatedAt() ||
      meta.hasApodLastFetchedAt();
}

CacheMetadataStruct _parseCacheMetadata(Map<String, dynamic> data) {
  return CacheMetadataStruct(
    appVersion: _readString(data, 'appVersion', 'app_version'),
    generatedAt: _readInt(data, 'generatedAt', 'generated_at'),
    profileUpdatedAt: _readInt(data, 'profileUpdatedAt', 'profile_updated_at'),
    userPreferencesUpdatedAt: _readInt(
      data,
      'userPreferencesUpdatedAt',
      'user_preferences_updated_at',
    ),
    dashboardUpdatedAt:
        _readInt(data, 'dashboardUpdatedAt', 'dashboard_updated_at'),
    calendarClassesUpdatedAt: _readInt(
      data,
      'calendarClassesUpdatedAt',
      'calendar_classes_updated_at',
    ),
    absencesUpdatedAt:
        _readInt(data, 'absencesUpdatedAt', 'absences_updated_at'),
    busUpdatedAt: _readInt(data, 'busUpdatedAt', 'bus_updated_at'),
    messUpdatedAt: _readInt(data, 'messUpdatedAt', 'mess_updated_at'),
    apodLastFetchedAt: _readDateTime(
      data,
      'apodLastFetchedAt',
      'apod_last_fetched_at',
    ),
  );
}

// Standardized boolean deserialization helper
bool _parseBool(dynamic val, [bool defaultVal = false]) {
  if (val == null) return defaultVal;
  if (val is bool) return val;
  if (val is num) return val != 0;
  if (val is String) {
    final str = val.trim().toLowerCase();
    if (str == 'true' || str == '1' || str == 'yes' || str == 't') return true;
    if (str == 'false' || str == '0' || str == 'no' || str == 'f') return false;
  }
  return defaultVal;
}

// Unified field-reading logic
dynamic _readAny(Map<String, dynamic> data, String camelKey, String snakeKey) {
  if (data.containsKey(camelKey) && data[camelKey] != null) {
    return data[camelKey];
  }
  if (data.containsKey(snakeKey) && data[snakeKey] != null) {
    return data[snakeKey];
  }
  return null;
}

// PostgreSQL TIME format helper ("HH:mm:ss")
String _formatTimeForSupabase(String? raw, String fallback) {
  if (raw == null || raw.trim().isEmpty) return fallback;
  final str = raw.trim();

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

bool _readBool(
  Map<String, dynamic> data,
  String camelKey,
  String snakeKey, [
  bool defaultVal = false,
]) {
  final val = _readAny(data, camelKey, snakeKey);
  return _parseBool(val, defaultVal);
}

String? _readString(
  Map<String, dynamic> data,
  String camelKey,
  String snakeKey,
) {
  final value = _readAny(data, camelKey, snakeKey) ??
      data['currentAppVersion'] ??
      data['current_app_version'];
  if (value == null) return null;
  return value.toString();
}

int? _readInt(Map<String, dynamic> data, String camelKey, String snakeKey) {
  final value = _readAny(data, camelKey, snakeKey);
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _readDateTime(
  Map<String, dynamic> data,
  String camelKey,
  String snakeKey,
) {
  final value = _readAny(data, camelKey, snakeKey);
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

DateTime? _parseDateTimeValue(dynamic val) {
  if (val == null) return null;
  if (val is DateTime) return val;
  if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
  if (val is num) return DateTime.fromMillisecondsSinceEpoch(val.toInt());
  if (val is String) {
    if (val.isEmpty) return null;
    return DateTime.tryParse(val);
  }
  return null;
}

CourseType? _parseCourseType(dynamic val) {
  if (val == null) return null;
  if (val is CourseType) return val;
  final str = val.toString().toUpperCase();
  for (final type in CourseType.values) {
    if (type.name.toUpperCase() == str) return type;
  }
  debugPrint(
      'syncAppData: unknown CourseType "$val", defaulting to CourseType.PC');
  return CourseType.PC;
}

ScheduledClassStruct _parseScheduledClass(Map<String, dynamic> raw) {
  final now = DateTime.now();
  return ScheduledClassStruct(
    classId: _readString(raw, 'classId', 'class_id') ?? '',
    courseId: _readString(raw, 'courseId', 'course_id') ?? '',
    courseCode: _readString(raw, 'courseCode', 'course_code') ?? '',
    courseName: _readString(raw, 'courseName', 'course_name') ?? '',
    batchId: _readString(raw, 'batchId', 'batch_id') ?? '',
    courseCategory: _parseCourseType(
            _readAny(raw, 'courseCategory', 'course_category') ??
                _readAny(raw, 'courseType', 'course_type')) ??
        CourseType.PC,
    scheduledStart: _parseDateTimeValue(
            _readAny(raw, 'scheduledStart', 'scheduled_start')) ??
        now,
    scheduledEnd:
        _parseDateTimeValue(_readAny(raw, 'scheduledEnd', 'scheduled_end')) ??
            now,
    venue: _readString(raw, 'venue', 'venue') ?? '',
    labGroup: _readString(raw, 'labGroup', 'lab_group') ?? '',
    isPlusSlot: _readBool(raw, 'isPlusSlot', 'is_plus_slot', false),
    isExtraClass: _readBool(raw, 'isExtraClass', 'is_extra_class', false),
    isAbsent: _readBool(raw, 'isAbsent', 'is_absent', false),
  );
}

UserProfileStruct _parseUserProfile(Map<String, dynamic> raw) {
  final now = DateTime.now();
  return UserProfileStruct(
    userId: _readString(raw, 'userId', 'user_id') ?? '',
    username: _readString(raw, 'username', 'username') ?? '',
    email: _readString(raw, 'email', 'email') ?? '',
    role: _readString(raw, 'role', 'role') ?? '',
    departmentId: _readString(raw, 'departmentId', 'department_id') ?? '',
    batchId: _readString(raw, 'batchId', 'batch_id') ?? '',
    currentSemester: _readInt(raw, 'currentSemester', 'current_semester') ?? 1,
    enrolledCourses: (raw['enrolledCourses'] ?? raw['enrolled_courses']) is List
        ? ((raw['enrolledCourses'] ?? raw['enrolled_courses']) as List)
            .map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e as Map);
              return EnrolledCourseStruct(
                courseId: _readString(map, 'courseId', 'course_id') ?? '',
                courseCode: _readString(map, 'courseCode', 'course_code') ?? '',
                courseName: _readString(map, 'courseName', 'course_name') ?? '',
                courseType: _readString(map, 'courseType', 'course_type') ?? '',
                slot: _readString(map, 'slot', 'slot') ?? '',
                credits: _readInt(map, 'credits', 'credits') ?? 0,
                isLab: _readBool(map, 'isLab', 'is_lab', false),
                isElective: _readBool(map, 'isElective', 'is_elective', false),
                electiveCategory:
                    _readString(map, 'electiveCategory', 'elective_category') ??
                        '',
                attendance: map['attendance'] is Map
                    ? AttendanceStruct(
                        attended: _readInt(
                                Map<String, dynamic>.from(
                                    map['attendance'] as Map),
                                'attended',
                                'attended') ??
                            0,
                        missed: _readInt(
                                Map<String, dynamic>.from(
                                    map['attendance'] as Map),
                                'missed',
                                'missed') ??
                            0,
                        percentage: (Map<String, dynamic>.from(
                                        map['attendance'] as Map)['percentage']
                                    as num?)
                                ?.toDouble() ??
                            0.0,
                        required: _readInt(
                                Map<String, dynamic>.from(
                                    map['attendance'] as Map),
                                'required',
                                'required') ??
                            80,
                      )
                    : AttendanceStruct(),
              );
            } else if (e is String) {
              return EnrolledCourseStruct(
                  courseId: e.toString(), courseCode: e.toString());
            }
            return EnrolledCourseStruct();
          }).toList()
        : <EnrolledCourseStruct>[],
    amplixBalance: _readInt(raw, 'amplixBalance', 'amplix_balance') ?? 0,
    profileUpdatedAt: _parseDateTimeValue(
            _readAny(raw, 'profileUpdatedAt', 'profile_updated_at')) ??
        now,
    onboardingComplete: _readBool(
            raw, 'onboardingComplete', 'onboarding_complete', false) ||
        _readBool(raw, 'onboardingCompleted', 'onboarding_completed', false),
    odometer: _readInt(raw, 'odometer', 'odometer') ??
        _readInt(raw, 'streak', 'streak') ??
        0,
  );
}

BusRouteStruct _parseBusRoute(Map<String, dynamic> raw) {
  return BusRouteStruct(
    busId: _readString(raw, 'busId', 'bus_id') ?? '',
    routeName: _readString(raw, 'routeName', 'route_name') ?? '',
    stopsSummary: _readString(raw, 'stopsSummary', 'stops_summary') ?? '',
    isActive: _readBool(raw, 'isActive', 'is_active', false),
    timings: raw['timings'] is List
        ? (raw['timings'] as List).map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e as Map);
              return BusTimingStruct(
                timingId: _readString(map, 'timingId', 'timing_id') ?? '',
                departureTime:
                    _readString(map, 'departureTime', 'departure_time') ?? '',
                isSpecial: _readBool(map, 'isSpecial', 'is_special', false),
                sortOrder: _readInt(map, 'sortOrder', 'sort_order') ?? 0,
              );
            }
            return BusTimingStruct();
          }).toList()
        : <BusTimingStruct>[],
  );
}

MessStruct _parseMess(Map<String, dynamic> raw) {
  return MessStruct(
    messId: _readString(raw, 'messId', 'mess_id') ?? '',
    name: _readString(raw, 'name', 'name') ?? '',
    menu: raw['menu'] is List
        ? (raw['menu'] as List).map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e);
              return MessMenuStruct(
                weekday: _readInt(map, 'weekday', 'weekday') ?? 0,
                meal: _readString(map, 'meal', 'meal') ?? '',
                menu: _readString(map, 'menu', 'menu') ?? '',
              );
            }
            return MessMenuStruct();
          }).toList()
        : <MessMenuStruct>[],
  );
}

ApodStruct _parseApod(Map<String, dynamic> raw) {
  return ApodStruct(
    apodDate: _readString(raw, 'apodDate', 'apod_date') ?? '',
    title: _readString(raw, 'title', 'title') ?? '',
    description: _readString(raw, 'description', 'description') ?? '',
    imageUrl: _readString(raw, 'imageUrl', 'image_url') ?? '',
    hdImageUrl: _readString(raw, 'hdImageUrl', 'hd_image_url') ?? '',
    mediaType: _readString(raw, 'mediaType', 'media_type') ?? '',
    shareUrl: _readString(raw, 'shareUrl', 'share_url') ?? '',
    copyright: _readString(raw, 'copyright', 'copyright') ?? '',
    fetchedAt: _parseDateTimeValue(_readAny(raw, 'fetchedAt', 'fetched_at')),
  );
}

Future<void> _fetchProfile(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_user_profile');
    if (response is Map) {
      outcome.profile.data =
          _parseUserProfile(Map<String, dynamic>.from(response));
      outcome.profile.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_user_profile returned non-Map (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.profile.error = e;
    debugPrint('syncAppData: profile sync failed - $e');
  } finally {
    outcome.profile.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchDashboard(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_dashboard_classes');
    if (response is List) {
      outcome.dashboard.data = response
          .whereType<Map>()
          .map((e) => _parseScheduledClass(Map<String, dynamic>.from(e)))
          .toList();
      outcome.dashboard.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_dashboard_classes returned non-List (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.dashboard.error = e;
    debugPrint('syncAppData: dashboard sync failed - $e');
  } finally {
    outcome.dashboard.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchCalendar(_SyncOutcome outcome, List<DateTime> dates) async {
  final sw = Stopwatch()..start();
  try {
    final List<String> dateParams =
        dates.map((d) => d.toIso8601String().split('T').first).toList();
    final dynamic response = await _callRpcWithRetry(
      'get_classes_for_dates',
      params: {'p_dates': dateParams},
    );
    if (response is List) {
      outcome.calendar.data = response
          .whereType<Map>()
          .map((e) => _parseScheduledClass(Map<String, dynamic>.from(e)))
          .toList();
      outcome.calendar.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_classes_for_dates returned non-List (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.calendar.error = e;
    debugPrint('syncAppData: calendar sync failed - $e');
  } finally {
    outcome.calendar.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchMissed(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_missed_classes');
    if (response is List) {
      outcome.missed.data = response
          .whereType<Map>()
          .map((e) => _parseScheduledClass(Map<String, dynamic>.from(e)))
          .toList();
      outcome.missed.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_missed_classes returned non-List (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.missed.error = e;
    debugPrint('syncAppData: missed classes sync failed - $e');
  } finally {
    outcome.missed.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchBus(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_bus_routes');
    if (response is List) {
      outcome.bus.data = response
          .whereType<Map>()
          .map((e) => _parseBusRoute(Map<String, dynamic>.from(e)))
          .toList();
      outcome.bus.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_bus_routes returned non-List (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.bus.error = e;
    debugPrint('syncAppData: bus sync failed - $e');
  } finally {
    outcome.bus.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchMess(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_mess_menu');
    if (response is List) {
      outcome.mess.data = response
          .whereType<Map>()
          .map((e) => _parseMess(Map<String, dynamic>.from(e)))
          .toList();
      outcome.mess.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_mess_menu returned non-List (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.mess.error = e;
    debugPrint('syncAppData: mess sync failed - $e');
  } finally {
    outcome.mess.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _fetchApod(_SyncOutcome outcome) async {
  final sw = Stopwatch()..start();
  try {
    final dynamic response = await _callRpcWithRetry('get_latest_apod');
    Map<String, dynamic>? data;
    if (response is List && response.isNotEmpty) {
      data = Map<String, dynamic>.from(response.first as Map);
    } else if (response is Map) {
      data = Map<String, dynamic>.from(response);
    }

    if (data != null) {
      final parsedApod = _parseApod(data);
      outcome.apod.data = parsedApod;
      outcome.apod.fetched = true;
    } else {
      debugPrint(
          'syncAppData: get_latest_apod returned unexpected format (${response?.runtimeType})');
    }
  } catch (e) {
    outcome.apod.error = e;
    debugPrint('syncAppData: apod sync failed - $e');
  } finally {
    outcome.apod.latencyMs = sw.elapsedMilliseconds;
  }
}

Future<void> _syncUserPreferences(
  _SyncOutcome outcome,
  CacheMetadataStruct localMeta,
  CacheMetadataStruct serverMeta,
) async {
  final sw = Stopwatch()..start();
  try {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      outcome.userPreferences.latencyMs = sw.elapsedMilliseconds;
      return;
    }

    final int localTs = localMeta.userPreferencesUpdatedAt;
    final int serverTs = serverMeta.userPreferencesUpdatedAt;

    // Case 1: Local writes are newer -> Push local FFAppState().userPreferences to Supabase
    if (localTs > 0 && localTs > serverTs) {
      final prefs = FFAppState().userPreferences;
      final updatePayload = {
        'user_id': userId,
        'enable_apod': prefs.enableAPOD,
        'user_mess': prefs.userMess,
        'at_a_glance_view': prefs.atAGlanceView,
        'use_scheduled_classes_for_greeting_message':
            prefs.useScheduledClassesForGreetingMessage,
        'use_action_tone_for_greeting_message':
            prefs.useActionToneForGreetingMessage,
        'time_format':
            prefs.preferredTimeFormat == TimeFormat.twelveHour ? '12h' : '24h',
        'action_tone': prefs.preferredActionTone.name,
        'attendance_threshold': prefs.attendanceThreshold,
        'theme': prefs.theme,
        'timezone': prefs.timezone,
        'language': prefs.language,
        'notifications_enabled': prefs.notificationsEnabled,
        'notif_class_reminder': prefs.notifClassReminder,
        'notif_reminder_minutes': prefs.notifReminderMinutes,
        'notif_class_cancelled': prefs.notifClassCancelled,
        'notif_class_rescheduled': prefs.notifClassRescheduled,
        'notif_task_published': prefs.notifTaskPublished,
        'notif_task_due_soon': prefs.notifTaskDueSoon,
        'notif_exam_reminder': prefs.notifExamReminder,
        'notif_daily_brief': prefs.notifDailyBrief,
        'notif_attendance_alert': prefs.notifAttendanceAlert,
        'notif_weekly_summary': prefs.notifWeeklySummary,
        'quiet_hours_enabled': prefs.quietHoursEnabled,
        'quiet_hours_start':
            _formatTimeForSupabase(prefs.quietHoursStart, '22:00:00'),
        'quiet_hours_end':
            _formatTimeForSupabase(prefs.quietHoursEnd, '07:00:00'),
        'notif_mess_reminder': prefs.notifMessReminder,
        'notif_breakfast_reminder': prefs.notifBreakfastReminder,
        'notif_lunch_reminder': prefs.notifLunchReminder,
        'notif_evening_tea_reminder': prefs.notifEveningTeaReminder,
        'notif_dinner_reminder': prefs.notifDinnerReminder,
        'notif_mess_reminder_minutes': prefs.notifMessReminderMinutes,
        'daily_brief_time':
            _formatTimeForSupabase(prefs.dailyBriefTime, '07:00:00'),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // HIGH FIX: Wrapped in _callDbWithRetry for timeout + backoff
      await _callDbWithRetry(
          () => SupaFlow.client.from('user_preferences').upsert(updatePayload));

      // CRITICAL FIX: Stamp current device timestamp override so local cache-meta is fresh
      final int pushSuccessTs = DateTime.now().millisecondsSinceEpoch;
      outcome.userPreferencesUpdatedAtOverride = pushSuccessTs;
      outcome.userPreferences.fetched = true;
      debugPrint(
          'syncAppData: Pushed local userPreferences to Supabase (${sw.elapsedMilliseconds}ms)');
      return;
    }

    // Case 2: Server is newer or initial sync -> Pull from Supabase user_preferences
    final response = await _callDbWithRetry(() => SupaFlow.client
        .from('user_preferences')
        .select('*')
        .eq('user_id', userId)
        .maybeSingle());

    if (response != null && response is Map<String, dynamic>) {
      final String? timeFormatStr =
          _readString(response, 'timeFormat', 'time_format');
      final String? actionToneStr =
          _readString(response, 'actionTone', 'action_tone');
      final int? threshold =
          _readInt(response, 'attendanceThreshold', 'attendance_threshold') ??
              _readInt(response, 'defaultRequiredAttendance',
                  'default_required_attendance');

      final TimeFormat timeFormat =
          (timeFormatStr == '24h' || timeFormatStr == 'twentyFourHour')
              ? TimeFormat.twentyFourHour
              : TimeFormat.twelveHour;

      ActionTone actionTone = ActionTone.playful;
      if (actionToneStr != null && actionToneStr.isNotEmpty) {
        try {
          final parsed = deserializeEnum<ActionTone>(actionToneStr);
          if (parsed != null) {
            actionTone = parsed;
          } else {
            debugPrint(
                'syncAppData: unknown ActionTone value "$actionToneStr", defaulting to ActionTone.playful');
          }
        } catch (e) {
          debugPrint(
              'syncAppData: failed to parse ActionTone "$actionToneStr": $e');
        }
      }

      final fetchedStruct = UserPreferencesStruct(
        enableAPOD: _readBool(response, 'enableAPOD', 'enable_apod', true),
        userMess: _readString(response, 'userMess', 'user_mess') ?? '',
        atAGlanceView:
            _readBool(response, 'atAGlanceView', 'at_a_glance_view', true),
        useScheduledClassesForGreetingMessage: _readBool(
            response,
            'useScheduledClassesForGreetingMessage',
            'use_scheduled_classes_for_greeting_message',
            true),
        useActionToneForGreetingMessage: _readBool(
            response,
            'useActionToneForGreetingMessage',
            'use_action_tone_for_greeting_message',
            true),
        preferredTimeFormat: timeFormat,
        preferredActionTone: actionTone,
        attendanceThreshold: threshold ?? 80,
        theme: _readString(response, 'theme', 'theme') ?? 'system',
        timezone:
            _readString(response, 'timezone', 'timezone') ?? 'Asia/Kolkata',
        language: _readString(response, 'language', 'language') ?? 'en',
        notificationsEnabled: _readBool(
            response, 'notificationsEnabled', 'notifications_enabled', true),
        notifClassReminder: _readBool(
            response, 'notifClassReminder', 'notif_class_reminder', true),
        notifReminderMinutes: _readInt(
                response, 'notifReminderMinutes', 'notif_reminder_minutes') ??
            10,
        notifClassCancelled: _readBool(
            response, 'notifClassCancelled', 'notif_class_cancelled', true),
        notifClassRescheduled: _readBool(
            response, 'notifClassRescheduled', 'notif_class_rescheduled', true),
        notifTaskPublished: _readBool(
            response, 'notifTaskPublished', 'notif_task_published', true),
        notifTaskDueSoon: _readBool(
            response, 'notifTaskDueSoon', 'notif_task_due_soon', true),
        notifExamReminder: _readBool(
            response, 'notifExamReminder', 'notif_exam_reminder', true),
        notifDailyBrief:
            _readBool(response, 'notifDailyBrief', 'notif_daily_brief', true),
        notifAttendanceAlert: _readBool(
            response, 'notifAttendanceAlert', 'notif_attendance_alert', true),
        notifWeeklySummary: _readBool(
            response, 'notifWeeklySummary', 'notif_weekly_summary', true),
        quietHoursEnabled: _readBool(
            response, 'quietHoursEnabled', 'quiet_hours_enabled', true),
        quietHoursStart:
            _readString(response, 'quietHoursStart', 'quiet_hours_start') ??
                '22:00:00',
        quietHoursEnd:
            _readString(response, 'quietHoursEnd', 'quiet_hours_end') ??
                '07:00:00',
        notifMessReminder: _readBool(
            response, 'notifMessReminder', 'notif_mess_reminder', true),
        notifBreakfastReminder: _readBool(response, 'notifBreakfastReminder',
            'notif_breakfast_reminder', true),
        notifLunchReminder: _readBool(
            response, 'notifLunchReminder', 'notif_lunch_reminder', true),
        notifEveningTeaReminder: _readBool(response, 'notifEveningTeaReminder',
            'notif_evening_tea_reminder', true),
        notifDinnerReminder: _readBool(
            response, 'notifDinnerReminder', 'notif_dinner_reminder', true),
        notifMessReminderMinutes: _readInt(response, 'notifMessReminderMinutes',
                'notif_mess_reminder_minutes') ??
            30,
        dailyBriefTime:
            _readString(response, 'dailyBriefTime', 'daily_brief_time') ??
                '07:00:00',
      );

      outcome.userPreferences.data = fetchedStruct;
      outcome.userPreferences.fetched = true;
    } else {
      // Initialize server row with defaults if record doesn't exist yet
      final defaultPrefs = UserPreferencesStruct();
      final initialPayload = {
        'user_id': userId,
        'enable_apod': defaultPrefs.enableAPOD,
        'user_mess': defaultPrefs.userMess,
        'at_a_glance_view': defaultPrefs.atAGlanceView,
        'use_scheduled_classes_for_greeting_message':
            defaultPrefs.useScheduledClassesForGreetingMessage,
        'use_action_tone_for_greeting_message':
            defaultPrefs.useActionToneForGreetingMessage,
        'time_format': defaultPrefs.preferredTimeFormat == TimeFormat.twelveHour
            ? '12h'
            : '24h',
        'action_tone': defaultPrefs.preferredActionTone.name,
        'attendance_threshold': defaultPrefs.attendanceThreshold,
        'theme': defaultPrefs.theme,
        'timezone': defaultPrefs.timezone,
        'language': defaultPrefs.language,
        'notifications_enabled': defaultPrefs.notificationsEnabled,
        'notif_class_reminder': defaultPrefs.notifClassReminder,
        'notif_reminder_minutes': defaultPrefs.notifReminderMinutes,
        'notif_class_cancelled': defaultPrefs.notifClassCancelled,
        'notif_class_rescheduled': defaultPrefs.notifClassRescheduled,
        'notif_task_published': defaultPrefs.notifTaskPublished,
        'notif_task_due_soon': defaultPrefs.notifTaskDueSoon,
        'notif_exam_reminder': defaultPrefs.notifExamReminder,
        'notif_daily_brief': defaultPrefs.notifDailyBrief,
        'notif_attendance_alert': defaultPrefs.notifAttendanceAlert,
        'notif_weekly_summary': defaultPrefs.notifWeeklySummary,
        'quiet_hours_enabled': defaultPrefs.quietHoursEnabled,
        'quiet_hours_start': defaultPrefs.quietHoursStart,
        'quiet_hours_end': defaultPrefs.quietHoursEnd,
        'notif_mess_reminder': defaultPrefs.notifMessReminder,
        'notif_breakfast_reminder': defaultPrefs.notifBreakfastReminder,
        'notif_lunch_reminder': defaultPrefs.notifLunchReminder,
        'notif_evening_tea_reminder': defaultPrefs.notifEveningTeaReminder,
        'notif_dinner_reminder': defaultPrefs.notifDinnerReminder,
        'notif_mess_reminder_minutes': defaultPrefs.notifMessReminderMinutes,
        'daily_brief_time': defaultPrefs.dailyBriefTime,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _callDbWithRetry(() =>
          SupaFlow.client.from('user_preferences').upsert(initialPayload));

      outcome.userPreferences.data = defaultPrefs;
      outcome.userPreferences.fetched = true;
    }
  } catch (e) {
    outcome.userPreferences.error = e;
    debugPrint('syncAppData: userPreferences sync failed - $e');
  } finally {
    outcome.userPreferences.latencyMs = sw.elapsedMilliseconds;
  }
}
