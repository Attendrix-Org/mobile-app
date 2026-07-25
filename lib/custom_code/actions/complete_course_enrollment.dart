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
) async {
  try {
    final payload = enrolledCourses.map((e) => e.toMap()).toList();

    final success = await Supabase.instance.client.rpc(
      'update_enrolled_courses',
      params: {
        'p_enrolled_courses': payload,
      },
    ) as bool;

    return FeedbackStruct(
      success: success,
      statusCode: success ? 200 : 400,
      message: success
          ? 'Course enrollment completed successfully.'
          : 'Course enrollment failed.',
    );
  } on PostgrestException catch (e) {
    return FeedbackStruct(
      success: false,
      statusCode: 400,
      message: e.message,
    );
  } catch (e) {
    return FeedbackStruct(
      success: false,
      statusCode: 500,
      message: e.toString(),
    );
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
