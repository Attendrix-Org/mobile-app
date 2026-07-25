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

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

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

/// Parses a single RPC row into a [ScheduledClassStruct].
/// Throws if the row is missing a field the schema guarantees as
/// NOT NULL — callers decide whether to skip-and-count or abort.
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

Future<List<ScheduledClassStruct>> executeScheduleQuery(
  ScheduleViewType viewType,
  DateTime? selectedDate,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
) async {
  String rpcName;
  Map<String, dynamic> params = {};

  switch (viewType) {
    case ScheduleViewType.today:
      rpcName = 'get_today_classes';
      break;
    case ScheduleViewType.current:
      rpcName = 'get_current_class';
      break;
    case ScheduleViewType.upcoming:
      rpcName = 'get_upcoming_classes';
      params = {'p_limit': limit ?? 10};
      break;
    case ScheduleViewType.calendarDay:
      if (selectedDate == null) {
        throw Exception('selectedDate cannot be null');
      }
      rpcName = 'get_classes_for_date';
      params = {'p_date': DateFormat('yyyy-MM-dd').format(selectedDate)};
      break;
    case ScheduleViewType.calendarRange:
      if (startDate == null || endDate == null) {
        throw Exception('startDate and endDate cannot be null');
      }
      rpcName = 'get_classes_for_date_range';
      params = {
        'p_start_date': DateFormat('yyyy-MM-dd').format(startDate),
        'p_end_date': DateFormat('yyyy-MM-dd').format(endDate),
      };
      break;
  }

  dynamic response;
  try {
    response = await Supabase.instance.client
        .rpc(rpcName, params: params)
        .timeout(_rpcTimeout);
  } on PostgrestException catch (e) {
    switch (e.code) {
      case 'PT401':
        throw ScheduleUnauthorizedException(e.message);
      case 'PT404':
        throw ScheduleNotOnboardedException(e.message);
      default:
        debugPrint('[$rpcName] PostgrestException (${e.code}): ${e.message}');
        throw ScheduleFetchException(e.message, code: e.code);
    }
  } catch (e) {
    debugPrint('[$rpcName] unexpected error: $e');
    throw ScheduleFetchException(e.toString());
  }

  if (response is! List) {
    throw ScheduleFetchException(
      'RPC "$rpcName" returned an unexpected response type: '
      '${response.runtimeType}.',
    );
  }
  final rows = response;

  final result = <ScheduledClassStruct>[];
  var skippedRows = 0;

  for (final row in rows) {
    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(row as Map);
    } catch (e) {
      skippedRows++;
      debugPrint('[$rpcName] row is not a Map, skipping: $e | row=$row');
      continue;
    }

    try {
      result.add(_parseScheduleRow(data));
    } catch (e) {
      skippedRows++;
      debugPrint(
        '[$rpcName] failed parsing class ${data['classId']}: $e',
      );
      continue;
    }
  }

  if (skippedRows > 0) {
    debugPrint(
      '[$rpcName] $skippedRows row(s) skipped out of ${rows.length} total.',
    );
    // Surface this to the caller if the UI should reflect partial data,
    // e.g. via a companion return value or a stream event, rather than
    // only a debug log the user never sees:
    // throw PartialScheduleException(result, skippedRows);
  }

  return result;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
