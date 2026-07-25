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

Future<bool> completeUserOnboarding(
  String fullName,
  String rollNumber,
  String departmentId,
  String batchId,
  int currentSemester,
  String? username,
  String? bio,
) async {
  try {
    final supabase = Supabase.instance.client;

    // Invoke the secure RPC function
    final bool isSuccess = await supabase.rpc(
      'complete_user_onboarding',
      params: {
        'p_full_name': fullName,
        'p_roll_number': rollNumber,
        'p_department_id': departmentId,
        'p_batch_id': batchId,
        'p_current_semester': currentSemester,
        'p_username': (username != null && username.trim().isNotEmpty)
            ? username.trim()
            : null,
        'p_bio': (bio != null && bio.trim().isNotEmpty) ? bio.trim() : null,
      },
    );

    return isSuccess;
  } catch (e) {
    // Log or handle errors gracefully in your debug console
    print('Error completing onboarding: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
