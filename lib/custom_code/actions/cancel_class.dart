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

Future<FeedbackStruct> cancelClass(
  String classId,
  String? reason,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'cancel_class',
      params: {
        'p_class_id': classId,
        'p_reason': reason,
      },
    );

    bool isSuccess = false;
    int statusCode = 500;
    String message = 'Failed to cancel class.';

    if (response is bool) {
      isSuccess = response;
      statusCode = isSuccess ? 200 : 400;
      message = isSuccess
          ? 'Class cancelled successfully.'
          : 'Class was not found or already cancelled.';
    } else if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      isSuccess = map['success'] == true;
      statusCode =
          (map['statusCode'] ?? map['status_code'] ?? (isSuccess ? 200 : 500)) as int;
      message = map['message']?.toString() ??
          (isSuccess ? 'Class cancelled successfully.' : 'Failed to cancel class.');
    }

    return FeedbackStruct(
      success: isSuccess,
      statusCode: statusCode,
      message: message,
    );
  } catch (e, stackTrace) {
    debugPrint('cancelClass failed: $e');
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
    }

    return FeedbackStruct(
      success: false,
      statusCode: statusCode,
      message: message,
    );
  }
}
