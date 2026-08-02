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
        'p_scheduled_start': scheduledStart.toUtc().toIso8601String(),
        'p_scheduled_end': scheduledEnd.toUtc().toIso8601String(),
        'p_venue': venue,
      },
    );

    Map<String, dynamic>? rawData;
    if (response is Map<String, dynamic>) {
      rawData = response;
    } else if (response is Map) {
      rawData = Map<String, dynamic>.from(response);
    }

    if (rawData == null) {
      throw const FormatException('Unexpected RPC response format.');
    }

    final bool isSuccess = rawData['success'] == true ||
        rawData.containsKey('class_id') ||
        rawData.containsKey('classId');

    final int status = rawData['statusCode'] is int
        ? rawData['statusCode'] as int
        : (rawData['status_code'] is int
            ? rawData['status_code'] as int
            : (isSuccess ? 200 : 500));

    final String msg = rawData['message']?.toString() ??
        (isSuccess
            ? 'Class rescheduled successfully.'
            : 'Failed to reschedule class.');

    return FeedbackStruct(
      success: isSuccess,
      statusCode: status,
      message: msg,
    );
  } catch (e, stackTrace) {
    debugPrint('rescheduleClass failed: $e');
    debugPrint(stackTrace.toString());

    String? code;
    String message = e.toString();
    try {
      final dynamic err = e;
      if (err.code != null) code = err.code.toString();
      if (err.message != null) message = err.message.toString();
    } catch (_) {}

    int statusCode = 500;
    if (code == 'PT401' || code == '401') {
      statusCode = 401;
    } else if (code == 'PT404' || code == '404') {
      statusCode = 404;
    } else if (code == 'PT409' || code == '409' || code == '23505') {
      statusCode = 409;
    } else if (code == 'PT422' || code == '422') {
      statusCode = 422;
    }

    return FeedbackStruct(
      success: false,
      statusCode: statusCode,
      message: message,
    );
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
