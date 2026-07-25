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

Future<FeedbackStruct> rescheduleClass(
  String classId,
  DateTime scheduledStart,
  DateTime scheduledEnd,
  String? venue,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'reschedule_class',
      params: {
        'p_class_id': classId,
        'p_start': scheduledStart.toUtc().toIso8601String(),
        'p_end': scheduledEnd.toUtc().toIso8601String(),
        'p_venue': venue,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Unexpected RPC response format.');
    }

    return FeedbackStruct(
      success: response['success'] == true,
      statusCode:
          (response['statusCode'] ?? response['status_code'] ?? 500) as int,
      message: response['message']?.toString() ?? '',
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
