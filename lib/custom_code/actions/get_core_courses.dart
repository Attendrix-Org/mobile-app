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

Future<List<CoreCourseStruct>> getCoreCourses(String batchId) async {
  try {
    final dynamic response = await SupaFlow.client.rpc(
      'get_core_courses_for_batch',
      params: {'p_batch_id': batchId},
    );

    if (response is! List) return [];

    return response
        .whereType<Map>()
        .map((item) => CoreCourseStruct.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  } catch (e) {
    debugPrint('getCoreCourses failed: $e');
    return [];
  }
}
