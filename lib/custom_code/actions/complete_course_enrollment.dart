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

Future<FeedbackStruct> completeCourseEnrollment(
  List<EnrolledCourseStruct> enrolledCourses,
) async {
  try {
    final Map<String, EnrolledCourseStruct> uniqueCourses = {};
    for (var course in enrolledCourses) {
      final key = course.courseId.isNotEmpty
          ? course.courseId
          : '${course.courseCode}_${course.slot}';
      if (key.isNotEmpty) {
        if (!uniqueCourses.containsKey(key)) {
          uniqueCourses[key] = course;
        }
      } else {
        uniqueCourses[course.hashCode.toString()] = course;
      }
    }

    final payload = uniqueCourses.values.map((e) => e.toMap()).toList();

    final response = await SupaFlow.client.rpc(
      'update_enrolled_courses',
      params: {
        'p_enrolled_courses': payload,
      },
    );

    bool isSuccess = false;
    String message = 'Course enrollment updated.';

    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      isSuccess = true;
      final added = map['added'] ?? 0;
      final removed = map['removed'] ?? 0;
      final retained = map['retained'] ?? 0;
      message =
          'Enrollment updated: $added added, $removed removed, $retained retained.';
    } else if (response is bool) {
      isSuccess = response;
      message = isSuccess
          ? 'Course enrollment completed.'
          : 'Course enrollment failed.';
    }

    return FeedbackStruct(
      success: isSuccess,
      statusCode: isSuccess ? 200 : 400,
      message: message,
    );
  } catch (e) {
    String message = e.toString();
    try {
      final dynamic err = e;
      if (err.message != null) message = err.message.toString();
    } catch (_) {}

    return FeedbackStruct(
      success: false,
      statusCode: 400,
      message: message,
    );
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
