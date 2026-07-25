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

// Automatic FlutterFlow Imports
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> isUsernameAvailable(String username) async {
  // Edge Case 1: Immediately reject empty or whitespace-only inputs
  if (username.trim().isEmpty) {
    return false;
  }

  try {
    // Invoke the Supabase RPC function 'is_username_available'
    // pass the exact parameter key expected by your SQL function
    final response = await Supabase.instance.client.rpc(
      'is_username_available',
      params: {'p_username': username.trim()},
    );

    // Ensure the response is cast cleanly as a boolean
    if (response is bool) {
      return response;
    }

    return false;
  } catch (e) {
    print('Error checking username availability: $e');
    // Edge Case 2: On network drop or database timeout, fail safely by returning false
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
