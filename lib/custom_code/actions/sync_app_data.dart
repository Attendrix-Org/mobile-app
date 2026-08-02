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
import 'package:path_provider/path_provider.dart';

// ─────────────────────────────────────────────────────────────────────────
// Attendrix Industrial Client Synchronization Engine — v11 (Bulletproof)
// High-performance, zero-flashing, 100% type-safe state reconciliation + APOD
// ─────────────────────────────────────────────────────────────────────────

String get _currentAppVersion => FFAppConstants.appVersion;

/// Global concurrency lock to prevent overlapping sync executions
bool _isSyncRunning = false;

class _DatasetState<T> {
  T? data;
  bool fetched = false;
  Object? error;
  int latencyMs = 0;
}

class _SyncOutcome {
  final profile = _DatasetState<UserProfileStruct>();
  final dashboard = _DatasetState<List<ScheduledClassStruct>>();
  final calendar = _DatasetState<List<ScheduledClassStruct>>();
  final missed = _DatasetState<List<ScheduledClassStruct>>();
  final bus = _DatasetState<List<BusRouteStruct>>();
  final mess = _DatasetState<List<MessStruct>>();
  final apod = _DatasetState<ApodStruct>();
}

/// Executes an RPC call with timeout and exponential backoff retries for transient errors.
Future<dynamic> _callRpcWithRetry(
  String rpcName, {
  Map<String, dynamic>? params,
  Duration timeout = const Duration(seconds: 12),
  int maxRetries = 2,
}) async {
  int attempts = 0;
  while (true) {
    attempts++;
    try {
      final dynamic response =
          await SupaFlow.client.rpc(rpcName, params: params).timeout(timeout);
      return response;
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
            'syncAppData: transient error on $rpcName (attempt $attempts/$maxRetries). Retrying in ${delayMs}ms... Error: $e');
        await Future.delayed(Duration(milliseconds: delayMs));
        continue;
      }
      rethrow;
    }
  }
}

Future<String?> _downloadAndSaveApodImage(String url) async {
  if (url.isEmpty || !url.startsWith('http')) return null;
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url)).timeout(const Duration(seconds: 8));
    final response = await request.close().timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final bytes = await response
          .fold<List<int>>(<int>[], (acc, element) => acc..addAll(element));
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/apod_latest.jpg');
      await file.writeAsBytes(bytes);
      return file.path;
    }
  } catch (e) {
    debugPrint('syncAppData: failed to download APOD image - $e');
  }
  return null;
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
  // Prevent duplicate concurrent sync runs unless explicitly forced
  if (_isSyncRunning && forceSync != true) {
    debugPrint('syncAppData: skipped - sync operation is already in progress.');
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
      debugPrint('syncAppData: get_cache_metadata failed: $e. Using local fallback.');
      serverMeta = localMeta;
    }

    final bool fullSync = doForceSync ||
        firstTimeSync ||
        localMeta.appVersion != _currentAppVersion;

    // Standard TTL values (in milliseconds)
    const int profileTtl = 5 * 60 * 1000;       // 5 mins
    const int dashboardTtl = 2 * 60 * 1000;     // 2 mins
    const int calendarTtl = 5 * 60 * 1000;      // 5 mins
    const int missedTtl = 2 * 60 * 1000;        // 2 mins
    const int busTtl = 60 * 60 * 1000;          // 60 mins
    const int messTtl = 60 * 60 * 1000;         // 60 mins

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
        isDatasetStale(
          force: fullSync,
          empty: FFAppState().calendarClasses.isEmpty,
          localTs: localMeta.calendarClassesUpdatedAt,
          serverTs: serverMeta.calendarClassesUpdatedAt,
          ttl: calendarTtl,
        );

    final bool staleMissed = doSyncMissedClasses &&
        isDatasetStale(
          force: fullSync,
          empty: false,
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
    if (staleDashboard) pending.add(_fetchDashboard(outcome));
    if (staleCalendar) pending.add(_fetchCalendar(outcome, calendarDates!));
    if (staleMissed) pending.add(_fetchMissed(outcome));
    if (staleBus) pending.add(_fetchBus(outcome));
    if (staleMess) pending.add(_fetchMess(outcome));
    if (staleApod) pending.add(_fetchApod(outcome));

    if (pending.isNotEmpty) {
      await Future.wait(pending, eagerError: false);
    }

    // Atomic AppState reconciliation & Cache Metadata update
    FFAppState().update(() {
      if (outcome.profile.fetched && outcome.profile.data != null) {
        FFAppState().userProfile = outcome.profile.data!;
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
        generatedAt: serverMeta.generatedAt ?? nowMs,
        profileUpdatedAt: outcome.profile.fetched
            ? (serverMeta.profileUpdatedAt ?? nowMs)
            : (localMeta.profileUpdatedAt ?? nowMs),
        dashboardUpdatedAt: outcome.dashboard.fetched
            ? (serverMeta.dashboardUpdatedAt ?? nowMs)
            : (localMeta.dashboardUpdatedAt ?? nowMs),
        calendarClassesUpdatedAt: outcome.calendar.fetched
            ? (serverMeta.calendarClassesUpdatedAt ?? nowMs)
            : (localMeta.calendarClassesUpdatedAt ?? nowMs),
        absencesUpdatedAt: outcome.missed.fetched
            ? (serverMeta.absencesUpdatedAt ?? nowMs)
            : (localMeta.absencesUpdatedAt ?? nowMs),
        busUpdatedAt: outcome.bus.fetched
            ? (serverMeta.busUpdatedAt ?? nowMs)
            : (localMeta.busUpdatedAt ?? nowMs),
        messUpdatedAt: outcome.mess.fetched
            ? (serverMeta.messUpdatedAt ?? nowMs)
            : (localMeta.messUpdatedAt ?? nowMs),
        apodLastFetchedAt:
            outcome.apod.fetched ? DateTime.now() : localMeta.apodLastFetchedAt,
      );
    });

    try {
      await updateAndroidWidgetFromAppState();
    } catch (_) {}

    try {
      await syncLocalNotificationsAction();
    } catch (e) {
      debugPrint('syncAppData: local notifications sync failed - $e');
    }

    debugPrint(
        '⚡ syncAppData: completed in ${stopwatch.elapsedMilliseconds}ms - '
        'firstTime=$firstTimeSync force=$doForceSync | '
        'profile=${outcome.profile.fetched} (${outcome.profile.latencyMs}ms) '
        'dashboard=${outcome.dashboard.fetched} (${outcome.dashboard.latencyMs}ms) '
        'calendar=${outcome.calendar.fetched} (${outcome.calendar.latencyMs}ms) '
        'missed=${outcome.missed.fetched} (${outcome.missed.latencyMs}ms) '
        'bus=${outcome.bus.fetched} (${outcome.bus.latencyMs}ms) '
        'mess=${outcome.mess.fetched} (${outcome.mess.latencyMs}ms) '
        'apod=${outcome.apod.fetched} (${outcome.apod.latencyMs}ms)');
  } catch (globalErr, stack) {
    debugPrint('syncAppData: global non-fatal exception caught: $globalErr\n$stack');
  } finally {
    _isSyncRunning = false;
  }
}

bool _hasInitializedCacheMetadata(CacheMetadataStruct meta) {
  return meta.hasAppVersion() ||
      meta.hasGeneratedAt() ||
      meta.hasProfileUpdatedAt() ||
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

dynamic _readAny(Map<String, dynamic> data, String camelKey, String snakeKey) {
  if (data.containsKey(camelKey) && data[camelKey] != null)
    return data[camelKey];
  if (data.containsKey(snakeKey) && data[snakeKey] != null)
    return data[snakeKey];
  return null;
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
  return null;
}

ScheduledClassStruct _parseScheduledClass(Map<String, dynamic> raw) {
  final now = DateTime.now();
  return ScheduledClassStruct(
    classId: (raw['classId'] ?? raw['class_id'])?.toString() ?? '',
    courseId: (raw['courseId'] ?? raw['course_id'])?.toString() ?? '',
    courseCode: (raw['courseCode'] ?? raw['course_code'])?.toString() ?? '',
    courseName: (raw['courseName'] ?? raw['course_name'])?.toString() ?? '',
    batchId: (raw['batchId'] ?? raw['batch_id'])?.toString() ?? '',
    courseCategory: _parseCourseType(raw['courseCategory'] ??
        raw['course_category'] ??
        raw['courseType'] ??
        raw['course_type']) ?? CourseType.theory,
    scheduledStart:
        _parseDateTimeValue(raw['scheduledStart'] ?? raw['scheduled_start']) ?? now,
    scheduledEnd:
        _parseDateTimeValue(raw['scheduledEnd'] ?? raw['scheduled_end']) ?? now,
    venue: (raw['venue'])?.toString() ?? '',
    labGroup: (raw['labGroup'] ?? raw['lab_group'])?.toString() ?? '',
    isPlusSlot: raw['isPlusSlot'] == true ||
        raw['is_plus_slot'] == true ||
        raw['isPlusSlot'] == 'true',
    isExtraClass: raw['isExtraClass'] == true ||
        raw['is_extra_class'] == true ||
        raw['isExtraClass'] == 'true',
    isAbsent: raw['isAbsent'] == true ||
        raw['is_absent'] == true ||
        raw['is_absent'] == 1 ||
        raw['isAbsent'] == 'true',
  );
}

UserProfileStruct _parseUserProfile(Map<String, dynamic> raw) {
  final now = DateTime.now();
  return UserProfileStruct(
    userId: (raw['userId'] ?? raw['user_id'])?.toString() ?? '',
    username: (raw['username'])?.toString() ?? '',
    email: (raw['email'])?.toString() ?? '',
    role: (raw['role'])?.toString() ?? '',
    departmentId: (raw['departmentId'] ?? raw['department_id'])?.toString() ?? '',
    batchId: (raw['batchId'] ?? raw['batch_id'])?.toString() ?? '',
    currentSemester: _readInt(raw, 'currentSemester', 'current_semester') ?? 1,
    enrolledCourses: (raw['enrolledCourses'] ?? raw['enrolled_courses']) is List
        ? ((raw['enrolledCourses'] ?? raw['enrolled_courses']) as List)
            .map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e as Map);
              return EnrolledCourseStruct(
                courseId: (map['courseId'] ?? map['course_id'])?.toString() ?? '',
                courseCode: (map['courseCode'] ?? map['course_code'])?.toString() ?? '',
                courseName: (map['courseName'] ?? map['course_name'])?.toString() ?? '',
                courseType: (map['courseType'] ?? map['course_type'])?.toString() ?? '',
                slot: (map['slot'])?.toString() ?? '',
                credits: _readInt(map, 'credits', 'credits') ?? 0,
                isLab: map['isLab'] == true || map['is_lab'] == true,
                isElective: map['isElective'] == true || map['is_elective'] == true,
                electiveCategory: (map['electiveCategory'] ?? map['elective_category'])?.toString() ?? '',
                attendance: map['attendance'] is Map
                    ? AttendanceStruct(
                        attended: _readInt(Map<String, dynamic>.from(map['attendance'] as Map), 'attended', 'attended') ?? 0,
                        missed: _readInt(Map<String, dynamic>.from(map['attendance'] as Map), 'missed', 'missed') ?? 0,
                        percentage: (Map<String, dynamic>.from(map['attendance'] as Map)['percentage'] as num?)?.toDouble() ?? 0.0,
                        required: _readInt(Map<String, dynamic>.from(map['attendance'] as Map), 'required', 'required') ?? 80,
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
        raw['profileUpdatedAt'] ?? raw['profile_updated_at']) ?? now,
    onboardingComplete: raw['onboardingComplete'] == true ||
        raw['onboarding_complete'] == true ||
        raw['onboarding_completed'] == true,
    odometer: _readInt(raw, 'odometer', 'streak') ?? 0,
  );
}

BusRouteStruct _parseBusRoute(Map<String, dynamic> raw) {
  return BusRouteStruct(
    busId: (raw['busId'] ?? raw['bus_id'])?.toString() ?? '',
    routeName: (raw['routeName'] ?? raw['route_name'])?.toString() ?? '',
    stopsSummary: (raw['stopsSummary'] ?? raw['stops_summary'])?.toString() ?? '',
    isActive: raw['isActive'] == true ||
        raw['is_active'] == true ||
        raw['isActive'] == 'true',
    timings: raw['timings'] is List
        ? (raw['timings'] as List).map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e as Map);
              return BusTimingStruct(
                timingId: (map['timingId'] ?? map['timing_id'])?.toString() ?? '',
                departureTime: (map['departureTime'] ?? map['departure_time'])?.toString() ?? '',
                isSpecial: map['isSpecial'] == true || map['is_special'] == true,
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
    messId: (raw['messId'] ?? raw['mess_id'])?.toString() ?? '',
    name: (raw['name'])?.toString() ?? '',
    menu: raw['menu'] is List
        ? (raw['menu'] as List).map((e) {
            if (e is Map) {
              final map = Map<String, dynamic>.from(e as Map);
              return MessMenuStruct(
                weekday: _readInt(map, 'weekday', 'weekday') ?? 0,
                meal: (map['meal'])?.toString() ?? '',
                menu: (map['menu'])?.toString() ?? '',
              );
            }
            return MessMenuStruct();
          }).toList()
        : <MessMenuStruct>[],
  );
}

ApodStruct _parseApod(Map<String, dynamic> raw) {
  return ApodStruct(
    apodDate: (raw['apodDate'] ?? raw['apod_date'])?.toString() ?? '',
    title: (raw['title'])?.toString() ?? '',
    description: (raw['description'])?.toString() ?? '',
    imageUrl: (raw['imageUrl'] ?? raw['image_url'])?.toString() ?? '',
    hdImageUrl: (raw['hdImageUrl'] ?? raw['hd_image_url'])?.toString() ?? '',
    mediaType: (raw['mediaType'] ?? raw['media_type'])?.toString() ?? '',
    shareUrl:
        (raw['shareUrl'] ?? raw['share_url'] ?? raw['shareurl'])?.toString() ??
            '',
    copyright: (raw['copyright'])?.toString() ?? '',
    fetchedAt: _parseDateTimeValue(raw['fetchedAt'] ?? raw['fetched_at']),
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
      final rawImageUrl = parsedApod.hdImageUrl.isNotEmpty
          ? parsedApod.hdImageUrl
          : parsedApod.imageUrl;

      if (rawImageUrl.isNotEmpty) {
        final localPath = await _downloadAndSaveApodImage(rawImageUrl);
        if (localPath != null) {
          parsedApod.imageUrl = localPath;
        }
      }
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
