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

Future<FeedbackStruct> completeCourseEnrollment(
  List<EnrolledCourseStruct> enrolledCourses,
  bool debug,
) async {
  try {
    final payload = enrolledCourses.map((e) => e.toMap()).toList();

    final res = await Supabase.instance.client.rpc(
      'update_enrolled_courses',
      params: {
        'p_enrolled_courses': payload,
      },
    );

    final resMap = res is Map ? res : <String, dynamic>{};

    final added = (resMap['added'] ?? 0) as int;
    final removed = (resMap['removed'] ?? 0) as int;
    final retained = (resMap['retained'] ?? 0) as int;

    String message;

    if (debug) {
      message = 'Course enrollment updated successfully: '
          '$added added, $removed removed, $retained retained.';
    } else {
      // Fresh onboarding
      if (removed == 0 && retained == 0) {
        message = added == 1
            ? 'Your course has been added successfully.'
            : 'Your courses have been added successfully.';
      }
      // Existing enrollment updated
      else {
        message = 'Your course preferences have been updated successfully.';
      }
    }

    return FeedbackStruct(
      success: true,
      statusCode: 200,
      message: message,
    );
  } on PostgrestException catch (e) {
    return FeedbackStruct(
      success: false,
      statusCode: 400,
      message: debug
          ? e.message
          : 'We couldn\'t update your course selections. Please try again.',
    );
  } catch (e) {
    return FeedbackStruct(
      success: false,
      statusCode: 500,
      message: debug
          ? e.toString()
          : 'Something went wrong while updating your courses. Please try again.',
    );
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
