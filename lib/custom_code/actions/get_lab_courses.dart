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

Future<List<EnrolledCourseStruct>> getLabCourses(
  String batchId,
) async {
  final supabase = Supabase.instance.client;

  final List<dynamic> response = await supabase.rpc(
    'get_lab_courses',
    params: {
      'p_batch_id': batchId,
    },
  );

  return response
      .map((item) => EnrolledCourseStruct.fromMap(
            Map<String, dynamic>.from(item as Map),
          ))
      .toList();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
