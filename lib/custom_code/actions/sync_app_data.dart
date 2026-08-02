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
// Attendrix Industrial Client Synchronization Engine — v9
// High-performance, fault-tolerant, concurrent state reconciliation + APOD
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

/// Executes an RPC call with timeout and retries for transient errors.
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
      final bool isTransient = e is TimeoutException ||
          e is SocketException ||
          e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('502') ||
          e.toString().contains('503') ||
          e.toString().contains('504');

      if (isTransient && attempts <= maxRetries) {
        debugPrint(
            'syncAppData: transient error on $rpcName (attempt $attempts/$maxRetries). Retrying in ${attempts * 300}ms... Error: $e');
        await Future.delayed(Duration(milliseconds: attempts * 300));
        continue;
      }
      rethrow;
    }
  }
}

Future<String?> _downloadAndSaveApodImage(String url) async {
  if (url.isEmpty || !url.startsWith('http')) return null;
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
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
  } finally {
    client.close();
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

    CacheMetadataStruct serverMeta;
    try {
      final dynamic response =
          await _callRpcWithRetry('get_cache_metadata', maxRetries: 2);
      if (response is! Map) {
        debugPrint(
            'syncAppData: unrecoverable - get_cache_metadata returned non-Map (${response?.runtimeType})');
        return;
      }
      serverMeta =
          _parseCacheMetadata(Map<String, dynamic>.from(response as Map));
    } catch (e) {
      debugPrint('syncAppData: unrecoverable - get_cache_metadata failed: $e');
      return;
    }

    final bool fullSync = doForceSync ||
        firstTimeSync ||
        localMeta.appVersion != _currentAppVersion;

    bool isStale(int localTs, int serverTs) => fullSync || localTs < serverTs;
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    final bool wantsCalendar =
        doSyncCalendar && calendarDates != null && calendarDates.isNotEmpty;

    final bool staleProfile = doSyncProfile &&
        isStale(localMeta.profileUpdatedAt, serverMeta.profileUpdatedAt);
    final bool staleDashboard = doSyncDashboard &&
        (isStale(localMeta.dashboardUpdatedAt, serverMeta.dashboardUpdatedAt) ||
            FFAppState().dashboardClasses.isEmpty);
    final bool staleCalendar = wantsCalendar;
    final bool staleMissed = doSyncMissedClasses &&
        isStale(localMeta.absencesUpdatedAt, serverMeta.absencesUpdatedAt);
    final bool staleBus =
        doSyncBus && isStale(localMeta.busUpdatedAt, serverMeta.busUpdatedAt);
    final bool staleMess = doSyncMess &&
        isStale(localMeta.messUpdatedAt, serverMeta.messUpdatedAt);

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
        generatedAt: serverMeta.generatedAt,
        profileUpdatedAt: outcome.profile.fetched
            ? serverMeta.profileUpdatedAt
            : localMeta.profileUpdatedAt,
        dashboardUpdatedAt: outcome.dashboard.fetched
            ? serverMeta.dashboardUpdatedAt
            : localMeta.dashboardUpdatedAt,
        calendarClassesUpdatedAt: outcome.calendar.fetched
            ? serverMeta.calendarClassesUpdatedAt
            : localMeta.calendarClassesUpdatedAt,
        absencesUpdatedAt: outcome.missed.fetched
            ? serverMeta.absencesUpdatedAt
            : localMeta.absencesUpdatedAt,
        busUpdatedAt: outcome.bus.fetched
            ? serverMeta.busUpdatedAt
            : localMeta.busUpdatedAt,
        messUpdatedAt: outcome.mess.fetched
            ? serverMeta.messUpdatedAt
            : localMeta.messUpdatedAt,
        apodLastFetchedAt:
            outcome.apod.fetched ? DateTime.now() : localMeta.apodLastFetchedAt,
      );
    });

    try {
      await updateAndroidWidgetFromAppState();
    } catch (_) {}

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
  return ScheduledClassStruct(
    classId: (raw['classId'] ?? raw['class_id'])?.toString(),
    courseId: (raw['courseId'] ?? raw['course_id'])?.toString(),
    courseCode: (raw['courseCode'] ?? raw['course_code'])?.toString(),
    courseName: (raw['courseName'] ?? raw['course_name'])?.toString(),
    batchId: (raw['batchId'] ?? raw['batch_id'])?.toString(),
    courseCategory: _parseCourseType(raw['courseCategory'] ??
        raw['course_category'] ??
        raw['courseType'] ??
        raw['course_type']),
    scheduledStart:
        _parseDateTimeValue(raw['scheduledStart'] ?? raw['scheduled_start']),
    scheduledEnd:
        _parseDateTimeValue(raw['scheduledEnd'] ?? raw['scheduled_end']),
    venue: (raw['venue'])?.toString(),
    labGroup: (raw['labGroup'] ?? raw['lab_group'])?.toString(),
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
  return UserProfileStruct(
    userId: (raw['userId'] ?? raw['user_id'])?.toString(),
    username: (raw['username'])?.toString(),
    email: (raw['email'])?.toString(),
    role: (raw['role'])?.toString(),
    departmentId: (raw['departmentId'] ?? raw['department_id'])?.toString(),
    batchId: (raw['batchId'] ?? raw['batch_id'])?.toString(),
    currentSemester: _readInt(raw, 'currentSemester', 'current_semester'),
    enrolledCourses: (raw['enrolledCourses'] ?? raw['enrolled_courses']) is List
        ? ((raw['enrolledCourses'] ?? raw['enrolled_courses']) as List)
            .map((e) {
            if (e is Map) {
              return EnrolledCourseStruct.fromMap(
                  Map<String, dynamic>.from(e as Map));
            } else if (e is String) {
              return EnrolledCourseStruct(
                  courseId: e.toString(), courseCode: e.toString());
            }
            return EnrolledCourseStruct();
          }).toList()
        : null,
    amplixBalance: _readInt(raw, 'amplixBalance', 'amplix_balance'),
    profileUpdatedAt: _parseDateTimeValue(
        raw['profileUpdatedAt'] ?? raw['profile_updated_at']),
    onboardingComplete: raw['onboardingComplete'] == true ||
        raw['onboarding_complete'] == true ||
        raw['onboarding_completed'] == true,
    odometer: _readInt(raw, 'odometer', 'streak'),
  );
}

BusRouteStruct _parseBusRoute(Map<String, dynamic> raw) {
  return BusRouteStruct(
    busId: (raw['busId'] ?? raw['bus_id'])?.toString(),
    routeName: (raw['routeName'] ?? raw['route_name'])?.toString(),
    stopsSummary: (raw['stopsSummary'] ?? raw['stops_summary'])?.toString(),
    isActive: raw['isActive'] == true ||
        raw['is_active'] == true ||
        raw['isActive'] == 'true',
    timings: raw['timings'] is List
        ? (raw['timings'] as List)
            .map((e) =>
                BusTimingStruct.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : null,
  );
}

MessStruct _parseMess(Map<String, dynamic> raw) {
  return MessStruct(
    messId: (raw['messId'] ?? raw['mess_id'])?.toString(),
    name: (raw['name'])?.toString(),
    menu: raw['menu'] is List
        ? (raw['menu'] as List)
            .map((e) =>
                MessMenuStruct.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : null,
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

      if (rawImageUrl.isNotEmpty && rawImageUrl.startsWith('http')) {
        unawaited(_downloadAndSaveApodImage(rawImageUrl));
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
