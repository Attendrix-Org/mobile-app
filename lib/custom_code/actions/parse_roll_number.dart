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

Future<RollNumberDetailsStruct> parseRollNumber(
  String rollNumber,
) async {
  final roll = rollNumber.trim().toUpperCase();

  final match = RegExp(r'^B(\d{2})\d+[A-Z]{2,4}$').firstMatch(roll);

  if (match == null) {
    throw Exception('Invalid institute roll number.');
  }

  final joiningYear = 2000 + int.parse(match.group(1)!);

  final departmentId = RegExp(r'[A-Z]{2,4}$').firstMatch(roll)!.group(0)!;

  final now = DateTime.now();

  int semesterNumber;

  if (now.month >= 7 && now.month <= 11) {
    // Odd semester (Jul-Nov)
    semesterNumber = ((now.year - joiningYear) * 2) + 1;
  } else if (now.month == 12) {
    // Even semester begins in December
    semesterNumber = ((now.year - joiningYear) * 2) + 2;
  } else if (now.month >= 1 && now.month <= 4) {
    // Continue same even semester
    semesterNumber = ((now.year - joiningYear - 1) * 2) + 2;
  } else {
    // May-June: after even semester exams, before next odd semester
    semesterNumber = ((now.year - joiningYear - 1) * 2) + 2;
  }

  semesterNumber = semesterNumber.clamp(1, 8);

  return RollNumberDetailsStruct(
    departmentId: departmentId,
    semesterNumber: semesterNumber,
  );
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
