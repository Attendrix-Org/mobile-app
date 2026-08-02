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

Future<FeedbackStruct> restoreClass(
  String classId,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'restore_class',
      params: {
        'p_class_id': classId,
      },
    );

    bool isSuccess = false;
    int statusCode = 500;
    String message = 'Failed to restore class.';

    if (response is bool) {
      isSuccess = response;
      statusCode = isSuccess ? 200 : 400;
      message = isSuccess
          ? 'Class restored successfully.'
          : 'Class was not found or is not cancelled.';
    } else if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      isSuccess = map['success'] == true;
      statusCode = (map['statusCode'] ??
          map['status_code'] ??
          (isSuccess ? 200 : 500)) as int;
      message = map['message']?.toString() ??
          (isSuccess
              ? 'Class restored successfully.'
              : 'Failed to restore class.');
    }

    return FeedbackStruct(
      success: isSuccess,
      statusCode: statusCode,
      message: message,
    );
  } catch (e, stackTrace) {
    debugPrint('restoreClass failed: $e');
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

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
