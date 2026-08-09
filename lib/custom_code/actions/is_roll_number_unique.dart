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

Future<bool> isRollNumberUnique(
  String? rollNumber,
  String? excludeUserId,
) async {
  if (rollNumber == null || rollNumber.trim().isEmpty) {
    return false;
  }
  try {
    // Invoke Supabase RPC function 'is_roll_number_unique'
    final response = await Supabase.instance.client.rpc(
      'is_roll_number_unique',
      params: {
        'p_roll_number': rollNumber.trim(),
        if (excludeUserId != null && excludeUserId.trim().isNotEmpty)
          'p_exclude_user_id': excludeUserId.trim(),
      },
    );
    // Safely cast response to boolean
    if (response is bool) {
      return response;
    }
    return false;
  } catch (e) {
    debugPrint('Error checking roll number uniqueness: $e');
    // Fail safely on error
    return false;
  }
}
