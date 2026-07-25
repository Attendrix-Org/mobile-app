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

Future<List<EnrolledCourseStruct>> combineEnrolledCourses(
  List<EnrolledCourseStruct>? coreCourses,
  List<EnrolledCourseStruct>? electives,
  List<EnrolledCourseStruct>? labs,
) async {
  // Initialize an empty list to compile everything
  List<EnrolledCourseStruct> combinedList = [];

  // Add items from each list if they aren't null
  if (coreCourses != null) {
    combinedList.addAll(coreCourses);
  }
  if (electives != null) {
    combinedList.addAll(electives);
  }
  if (labs != null) {
    combinedList.addAll(labs);
  }

  return combinedList;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
