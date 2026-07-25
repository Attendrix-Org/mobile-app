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

import '/app_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

const MethodChannel _widgetChannel = MethodChannel('com.attendrix.app/widget');
const int _widgetStateVersion = 3;
bool _bridgeInitialized = false;

Future<void> initializeAndroidWidgetBridge() async {
  if (kIsWeb || !Platform.isAndroid || _bridgeInitialized) {
    return;
  }
  _bridgeInitialized = true;
  _widgetChannel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'onWidgetAuthExpired':
        debugPrint('Attendrix widget reported an expired auth session.');
        break;
      case 'onWidgetSyncFailed':
        debugPrint('Attendrix widget sync failed: ${call.arguments}');
        break;
      case 'onWidgetAbsenceChanged':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final classId = args['classId']?.toString() ?? '';
        final isAbsent = args['isAbsent'] == true;
        if (classId.isNotEmpty) {
          _syncWidgetAbsenceToAppState(classId, isAbsent);
        }
        break;
    }
  });

  try {
    await _widgetChannel.invokeMethod<bool>('schedulePeriodicWorker');
  } catch (error) {
    debugPrint('schedulePeriodicWorker failed: $error');
  }
}

Future<void> updateAndroidWidgetFromAppState() async {
  if (kIsWeb || !Platform.isAndroid) {
    return;
  }
  await initializeAndroidWidgetBridge();

  final now = DateTime.now();
  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  final allClasses = FFAppState()
      .dashboardClasses
      .where((classItem) =>
          classItem.scheduledStart != null && classItem.scheduledEnd != null)
      .toList()
    ..sort((a, b) => a.scheduledStart!.compareTo(b.scheduledStart!));

  final todayClasses =
      allClasses.where((c) => isSameDay(c.scheduledStart!, now)).toList();
  final upcomingClasses =
      allClasses.where((c) => !isSameDay(c.scheduledStart!, now)).toList();

  final currentClass = todayClasses.firstWhereOrNull(
    (c) => !now.isBefore(c.scheduledStart!) && now.isBefore(c.scheduledEnd!),
  );

  final remainingToday = todayClasses
      .where((c) =>
          c.scheduledEnd!.isAfter(now) && c.classId != currentClass?.classId)
      .toList();

  final nextClass = remainingToday.isNotEmpty
      ? remainingToday.first
      : upcomingClasses.firstOrNull;
  final usingUpcomingRows = remainingToday.isEmpty;
  final rowSource = usingUpcomingRows ? upcomingClasses : remainingToday;
  final rows = rowSource.where((c) => c.classId != nextClass?.classId).toList();
  final displayedRows = rows.take(3).toList();
  final remainingCount = (rows.length - displayedRows.length).clamp(0, 1 << 31);

  final hasAnyClasses = currentClass != null ||
      nextClass != null ||
      todayClasses.isNotEmpty ||
      upcomingClasses.isNotEmpty;
  final state = hasAnyClasses ? 'Ready' : 'Empty';

  final progress = currentClass == null
      ? 0.0
      : getScheduleProgress(
          currentClass.scheduledStart!,
          currentClass.scheduledEnd!,
          now,
        );
  final remainingMinutes = () {
    if (currentClass != null) {
      return currentClass.scheduledEnd!
          .difference(now)
          .inMinutes
          .clamp(0, 1 << 31);
    }
    if (nextClass != null) {
      return nextClass.scheduledStart!
          .difference(now)
          .inMinutes
          .clamp(0, 1 << 31);
    }
    return 0;
  }();

  final snapshot = <String, dynamic>{
    'version': _widgetStateVersion,
    'state': state,
    'currentClass':
        currentClass == null ? null : _classToWidgetJson(currentClass),
    'nextClass': nextClass == null ? null : _classToWidgetJson(nextClass),
    'nextClassIsUpcomingDay':
        nextClass != null && !isSameDay(nextClass.scheduledStart!, now),
    'upcomingRows': displayedRows.map(_classToWidgetJson).toList(),
    'upcomingRowsAreFutureDays': usingUpcomingRows,
    'remainingCount': remainingCount,
    'progress': progress,
    'remainingMinutes': remainingMinutes,
    'updatedAtMillis': now.millisecondsSinceEpoch,
    'preferredTimeFormat':
        FFAppState().userPreferences.preferredTimeFormat.serialize(),
    'cacheGeneratedAt': FFAppState().cacheMetaData.generatedAt,
    'dashboardUpdatedAt': FFAppState().cacheMetaData.dashboardUpdatedAt,
  };

  try {
    await _widgetChannel.invokeMethod<bool>(
      'updateWidgetSnapshot',
      {'snapshotJson': jsonEncode(snapshot)},
    );
  } catch (error) {
    debugPrint('updateAndroidWidgetFromAppState failed: $error');
  }
}

Map<String, dynamic> _classToWidgetJson(ScheduledClassStruct classItem) => {
      'classId': classItem.classId,
      'courseName': classItem.courseName,
      'venue': classItem.venue,
      'startMillis': classItem.scheduledStart!.millisecondsSinceEpoch,
      'endMillis': classItem.scheduledEnd!.millisecondsSinceEpoch,
      'isAbsent': classItem.isAbsent,
    };

void _syncWidgetAbsenceToAppState(String classId, bool isAbsent) {
  final dashboard =
      _withAbsentUpdated(FFAppState().dashboardClasses, classId, isAbsent);
  final calendar =
      _withAbsentUpdated(FFAppState().calendarClasses, classId, isAbsent);
  final missed = _resolveMissedListUpdate(
    FFAppState().missedClasses,
    classId,
    isAbsent,
    dashboard?.firstWhereOrNull((c) => c.classId == classId) ??
        FFAppState()
            .dashboardClasses
            .firstWhereOrNull((c) => c.classId == classId) ??
        FFAppState()
            .calendarClasses
            .firstWhereOrNull((c) => c.classId == classId),
  );

  if (dashboard == null && calendar == null && missed == null) {
    return;
  }

  FFAppState().update(() {
    if (dashboard != null) {
      FFAppState().dashboardClasses = dashboard;
    }
    if (calendar != null) {
      FFAppState().calendarClasses = calendar;
    }
    if (missed != null) {
      FFAppState().missedClasses = missed;
    }
  });
}

List<ScheduledClassStruct>? _withAbsentUpdated(
  List<ScheduledClassStruct> source,
  String classId,
  bool isAbsent,
) {
  final idx = source.indexWhere((c) => c.classId == classId);
  if (idx == -1) return null;
  if (source[idx].isAbsent == isAbsent) return null;

  final updated = List<ScheduledClassStruct>.from(source);
  updated[idx] = _cloneWithAbsent(updated[idx], isAbsent);
  return updated;
}

List<ScheduledClassStruct>? _resolveMissedListUpdate(
  List<ScheduledClassStruct> missed,
  String classId,
  bool isAbsent,
  ScheduledClassStruct? classData,
) {
  final idx = missed.indexWhere((c) => c.classId == classId);

  if (!isAbsent) {
    if (idx == -1) return null;
    return List<ScheduledClassStruct>.from(missed)..removeAt(idx);
  }

  if (idx != -1) {
    if (missed[idx].isAbsent) return null;
    final updated = List<ScheduledClassStruct>.from(missed);
    updated[idx] = _cloneWithAbsent(updated[idx], true);
    return updated;
  }

  if (classData == null) return null;
  return [
    _cloneWithAbsent(classData, true, overrideClassId: classId),
    ...missed
  ];
}

ScheduledClassStruct _cloneWithAbsent(
  ScheduledClassStruct source,
  bool isAbsent, {
  String? overrideClassId,
}) =>
    ScheduledClassStruct(
      classId: overrideClassId ?? source.classId,
      courseId: source.courseId,
      courseCode: source.courseCode,
      courseName: source.courseName,
      batchId: source.batchId,
      courseCategory: source.courseCategory,
      scheduledStart: source.scheduledStart,
      scheduledEnd: source.scheduledEnd,
      venue: source.venue,
      labGroup: source.labGroup,
      isPlusSlot: source.isPlusSlot,
      isExtraClass: source.isExtraClass,
      isAbsent: isAbsent,
    );
