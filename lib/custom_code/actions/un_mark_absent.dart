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

import '/app_state.dart';
import 'dart:async';
import 'dart:convert';

Future<MarkAbsentResponseStruct> unMarkAbsent(
  ScheduledClassStruct classData,
) async {
  final String classId = classData.classId;

  try {
    final response = await SupaFlow.client.rpc(
      'un_mark_absent',
      params: {
        'p_class_id': classId,
      },
    );

    if (response is! Map) {
      throw FormatException(
          'Unexpected RPC response format: expected Map, got ${response.runtimeType}');
    }

    final resMap = Map<String, dynamic>.from(response as Map);

    final result = MarkAbsentResponseStruct(
      success: resMap['success'] == true,
      isAbsent: resMap['is_absent'] == true,
      classId: resMap['class_id']?.toString() ?? '',
      userId: resMap['user_id']?.toString() ?? '',
      timestamp: resMap['timestamp']?.toString() ?? '',
    );

    AttendanceStruct? newAttendance;
    final String targetCourseId =
        resMap['course_id']?.toString() ?? classData.courseId;

    if (resMap['attendance'] is Map) {
      final attMap = Map<String, dynamic>.from(resMap['attendance'] as Map);
      newAttendance = AttendanceStruct.fromMap(attMap);
    } else if (resMap['attendance'] is String) {
      try {
        final decoded = jsonDecode(resMap['attendance'] as String);
        if (decoded is Map) {
          newAttendance = AttendanceStruct.fromMap(
              Map<String, dynamic>.from(decoded as Map));
        }
      } catch (e) {
        debugPrint('Failed to decode attendance JSON string: $e');
      }
    }

    if (newAttendance == null) {
      debugPrint(
          '⚠️ unMarkAbsent response missing/unparseable "attendance" field (type: ${resMap['attendance']?.runtimeType}). UserProfile attendance stats will NOT be updated.');
    }

    if (result.success) {
      debugPrint('unMarkAbsent succeeded for classId: ${result.classId}');
      _syncAbsentStatus(
        result.classId,
        result.isAbsent,
        classData,
        targetCourseId,
        newAttendance,
      );
    } else {
      debugPrint(
          'unMarkAbsent RPC completed but flagged success as false for classId: $classId');
    }

    return result;
  } catch (e, stackTrace) {
    debugPrint('unMarkAbsent failed for classId $classId: $e');
    debugPrint(stackTrace.toString());

    return MarkAbsentResponseStruct(
      success: false,
      isAbsent: true, // If failed, assume the class remains marked absent
      classId: classId,
      userId: '',
      timestamp: '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// AppState reconciliation after a successful unMarkAbsent call.
// ─────────────────────────────────────────────────────────────────────────
void _syncAbsentStatus(
  String classId,
  bool isAbsent,
  ScheduledClassStruct classData,
  String? courseId,
  AttendanceStruct? newAttendance,
) {
  final dashboard = FFAppState().dashboardClasses;
  final calendar = FFAppState().calendarClasses;
  final missed = FFAppState().missedClasses;
  final currentProfile = FFAppState().userProfile;

  final updatedDashboard = _withAbsentUpdated(dashboard, classId, isAbsent);
  final updatedCalendar = _withAbsentUpdated(calendar, classId, isAbsent);
  final updatedMissed =
      _resolveMissedListUpdate(missed, classId, isAbsent, classData);

  UserProfileStruct? updatedProfile;
  if (courseId != null && courseId.isNotEmpty && newAttendance != null) {
    updatedProfile = _cloneUserProfileWithAttendance(
      currentProfile,
      courseId,
      newAttendance,
    );
  }

  if (updatedDashboard == null &&
      updatedCalendar == null &&
      updatedMissed == null &&
      updatedProfile == null) {
    return;
  }

  FFAppState().update(() {
    if (updatedDashboard != null) {
      FFAppState().dashboardClasses = updatedDashboard;
    }
    if (updatedCalendar != null) {
      FFAppState().calendarClasses = updatedCalendar;
    }
    if (updatedMissed != null) {
      FFAppState().missedClasses = updatedMissed;
    }
    if (updatedProfile != null) {
      FFAppState().userProfile = updatedProfile;
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
  ScheduledClassStruct classData,
) {
  final idx = missed.indexWhere((c) => c.classId == classId);

  if (!isAbsent) {
    // Server says class is no longer absent — remove it from missedClasses
    if (idx == -1) return null;
    return List<ScheduledClassStruct>.from(missed)..removeAt(idx);
  }

  if (idx != -1) {
    if (missed[idx].isAbsent) return null;
    final updated = List<ScheduledClassStruct>.from(missed);
    updated[idx] = _cloneWithAbsent(updated[idx], true);
    return updated;
  }

  final toInsert = _cloneWithAbsent(classData, true, overrideClassId: classId);
  return [toInsert, ...missed];
}

ScheduledClassStruct _cloneWithAbsent(
  ScheduledClassStruct source,
  bool isAbsent, {
  String? overrideClassId,
}) {
  return ScheduledClassStruct(
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
}

UserProfileStruct? _cloneUserProfileWithAttendance(
  UserProfileStruct source,
  String courseId,
  AttendanceStruct newAttendance,
) {
  final currentCourses = source.enrolledCourses;
  bool courseMatched = false;
  final target = courseId.trim().toLowerCase();

  final updatedCourses = currentCourses.map((course) {
    final cId = course.courseId.trim().toLowerCase();
    final cCode = course.courseCode.trim().toLowerCase();

    if (cId == target || cCode == target || (cId.isNotEmpty && target == cId)) {
      courseMatched = true;
      debugPrint(
          '✅ Found matching course ($courseId) in UserProfile. Updating attendance: ${newAttendance.toMap()}');
      return _cloneEnrolledCourseWithAttendance(course, newAttendance);
    }
    return course;
  }).toList();

  if (!courseMatched) {
    debugPrint(
        '⚠️ Warning: Course ID "$courseId" did NOT match any course in UserProfile!');
    debugPrint(
        'Available Course IDs: ${currentCourses.map((e) => e.courseId).toList()}');
    debugPrint(
        'Available Course Codes: ${currentCourses.map((e) => e.courseCode).toList()}');
    return null;
  }

  return UserProfileStruct(
    userId: source.userId,
    username: source.username,
    email: source.email,
    role: source.role,
    departmentId: source.departmentId,
    batchId: source.batchId,
    currentSemester: source.currentSemester,
    enrolledCourses: updatedCourses,
    amplixBalance: source.amplixBalance,
    profileUpdatedAt: source.profileUpdatedAt,
    onboardingComplete: source.onboardingComplete,
    odometer: source.odometer,
  );
}

EnrolledCourseStruct _cloneEnrolledCourseWithAttendance(
  EnrolledCourseStruct source,
  AttendanceStruct newAttendance,
) {
  return EnrolledCourseStruct(
    courseId: source.courseId,
    courseCode: source.courseCode,
    courseName: source.courseName,
    courseType: source.courseType,
    slot: source.slot,
    credits: source.credits,
    isLab: source.isLab,
    isElective: source.isElective,
    electiveCategory: source.electiveCategory,
    attendance: newAttendance,
    labSubBatch: source.labSubBatch,
  );
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
